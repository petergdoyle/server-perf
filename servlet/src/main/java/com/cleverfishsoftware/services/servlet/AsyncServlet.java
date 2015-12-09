/*
 */
package com.cleverfishsoftware.services.servlet;

import static com.cleverfishsoftware.services.common.CommonUtils.isNumeric;
import static com.cleverfishsoftware.services.common.CommonUtils.isSpecified;
import com.cleverfishsoftware.services.common.GeneratedContent;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.WritableByteChannel;
import java.util.Queue;
import java.util.concurrent.Executors;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.atomic.AtomicInteger;
import javax.servlet.AsyncContext;
import javax.servlet.AsyncEvent;
import javax.servlet.AsyncListener;
import javax.servlet.ReadListener;
import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.ServletOutputStream;
import javax.servlet.WriteListener;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author peter
 */
@WebServlet(name = "AsyncServlet", urlPatterns = {"/perf/async"}, asyncSupported = true)
public class AsyncServlet extends HttpServlet {

    private final ScheduledExecutorService executor;

    private final static AtomicInteger COUNTER = new AtomicInteger();

    private final static GeneratedContent CONTENT = GeneratedContent.getInstance();

    public AsyncServlet() {
        this.executor = Executors.newSingleThreadScheduledExecutor();
    }

    @Override
    public void destroy() {
        executor.shutdown();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AsyncContext asyncContext = request.startAsync();

        int count = COUNTER.incrementAndGet();
        String servletName = getServletName();
        long startTime = System.currentTimeMillis();
        System.out.println(servletName + " Start::Name="
                + Thread.currentThread().getName() + "::ID="
                + Thread.currentThread().getId());

        // introduce latency
        int sleep = 0;
        String sleepParam = request.getParameter("sleep");
        if (isSpecified(sleepParam) && isNumeric(sleepParam)) {
            sleep = Integer.valueOf(sleepParam);
            // max 10 seconds
            if (sleep > 10000) {
                sleep = 10000;
            } else if (sleep < 0) {
                sleep = 0;
            }
        }

        // simple sleep and call complete on asyncContext 
//        executor.schedule(asyncContext::complete, sleep, TimeUnit.MILLISECONDS);
        ServletOutputStream os = response.getOutputStream();

        // determine how to respond
        int size = 0;
        String sizeParam = request.getParameter("size");
        if (isSpecified(sizeParam) && isNumeric(sizeParam)) {
            size = Integer.valueOf(sizeParam);
            ByteBuffer content = CONTENT.getAsBuffer(size);
            os.setWriteListener(new GeneratedOutputStreamWriteListener(os, content, asyncContext));
        } else {
            asyncContext.complete();
        }

        long endTime = System.currentTimeMillis();
        System.out.println(servletName + " End::Name="
                + Thread.currentThread().getName() + "::ID="
                + Thread.currentThread().getId() + "::Time Taken="
                + (endTime - startTime) + " ms.");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        AsyncContext context = request.startAsync();
        context.addListener(new AsyncListener() {
            @Override
            public void onComplete(AsyncEvent event) throws IOException {
                event.getSuppliedResponse().getOutputStream().print("Complete");
            }

            @Override
            public void onError(AsyncEvent event) {
                System.out.println(event.getThrowable());
            }

            @Override
            public void onStartAsync(AsyncEvent event) {
            }

            @Override
            public void onTimeout(AsyncEvent event) {
                System.out.println("my asyncListener.onTimeout");
            }
        });
        ServletInputStream is = request.getInputStream();
        ReadListener readListener = new ServletInputStreamListener(context, is, response);
        is.setReadListener(readListener);

    }

    @Override
    public String getServletInfo() {
        return "Asynchronous Servlet for testing various performance test patterns.";
    }

    class GeneratedOutputStreamWriteListener implements WriteListener {

        private final ServletOutputStream sos;
        ByteBuffer content;
        private final AsyncContext context;

        public GeneratedOutputStreamWriteListener(ServletOutputStream sos, ByteBuffer content, AsyncContext context) {
            this.sos = sos;
            this.content = content;
            this.context = context;
        }

        @Override
        public void onWritePossible() throws IOException {
            WritableByteChannel oc = Channels.newChannel(sos);
            content.rewind();
            while (content.hasRemaining()) {
//                System.out.println("writing content"); 
                oc.write(content);
            }
            if (!content.hasRemaining()) {
//                System.out.println("writing content complete"); 
                context.complete();
            }
        }

        @Override
        public void onError(Throwable t) {
            System.err.println(t);
            context.complete();
        }

    }

    class ServletOutputStreamListener implements WriteListener {

        private final ServletOutputStream sos;
        private final Queue queue;
        private final AsyncContext context;

        public ServletOutputStreamListener(ServletOutputStream sos, Queue queue, AsyncContext context) {
            this.sos = sos;
            this.queue = queue;
            this.context = context;
        }

        @Override
        public void onWritePossible() throws IOException {
            while (queue.peek() != null && sos.isReady()) {
                String data = (String) queue.poll();
                sos.print(data);
            }
            if (queue.peek() == null) {
                context.complete();
            }
        }

        @Override
        public void onError(Throwable t) {
            System.err.println(t);
            context.complete();
        }

    }

    class ServletInputStreamListener implements ReadListener {

        private final AsyncContext context;
        private final ServletInputStream is;
        private final HttpServletResponse res;
        private final Queue queue;

        public ServletInputStreamListener(AsyncContext context, ServletInputStream is, HttpServletResponse res) {
            this.queue = new LinkedBlockingQueue();
            this.context = context;
            this.is = is;
            this.res = res;
        }

        @Override
        public void onDataAvailable() throws IOException {
            StringBuilder sb = new StringBuilder();
            int len = -1;
            byte b[] = new byte[1024];
            while (is.isReady() && (len = is.read(b)) != -1) {
                String data = new String(b, 0, len);
                sb.append(data);
            }
            queue.add(sb.toString());
        }

        @Override
        public void onAllDataRead() throws IOException {
            ServletOutputStream output = res.getOutputStream();
            WriteListener writeListener = new ServletOutputStreamListener(output, queue, context);
            output.setWriteListener(writeListener);
        }

        @Override
        public void onError(Throwable t) {
            System.err.println(t);
            context.complete();
        }

    }
}
