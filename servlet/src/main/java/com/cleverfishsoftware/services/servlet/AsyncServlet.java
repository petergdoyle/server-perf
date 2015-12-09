/*
 */
package com.cleverfishsoftware.services.servlet;

import static com.cleverfishsoftware.services.common.CommonUtils.isNumeric;
import static com.cleverfishsoftware.services.common.CommonUtils.isSpecified;
import com.cleverfishsoftware.services.common.GeneratedContent;
import java.io.IOException;
import java.util.Queue;
import java.util.concurrent.Executors;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import javax.servlet.AsyncContext;
import javax.servlet.AsyncEvent;
import javax.servlet.AsyncListener;
import javax.servlet.ReadListener;
import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.ServletOutputStream;
import javax.servlet.ServletRequest;
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
        ServletRequest r = asyncContext.getRequest();

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
            }
        }

        executor.schedule(asyncContext::complete, sleep, TimeUnit.MILLISECONDS);

        long endTime = System.currentTimeMillis();
        System.out.println(servletName + " End::Name="
                + Thread.currentThread().getName() + "::ID="
                + Thread.currentThread().getId() + "::Time Taken="
                + (endTime - startTime) + " ms.");
    }

//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        AsyncContext asyncContext = request.startAsync();
//
//        int count = COUNTER.incrementAndGet();
//        String servletName = getServletName();
//        long startTime = System.currentTimeMillis();
//        System.out.println(servletName + " Start::Name="
//                + Thread.currentThread().getName() + "::ID="
//                + Thread.currentThread().getId());
//
//        // introduce latency
//        int sleep = 0;
//        String sleepParam = request.getParameter("sleep");
//        if (isSpecified(sleepParam) && isNumeric(sleepParam)) {
//            sleep = Integer.valueOf(sleepParam);
//            // max 10 seconds
//            if (sleep > 10000) {
//                sleep = 10000;
//            }
//        }
//
//        executor.schedule(asyncContext::complete, sleep, TimeUnit.MILLISECONDS);
//
//        long endTime = System.currentTimeMillis();
//        System.out.println(servletName + " End::Name="
//                + Thread.currentThread().getName() + "::ID="
//                + Thread.currentThread().getId() + "::Time Taken="
//                + (endTime - startTime) + " ms.");
//    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
        ReadListener readListener = new CustomReadListener(context, is, response);
        is.setReadListener(readListener);

    }

    @Override
    public String getServletInfo() {
        return "Asynchronous Servlet for testing various performance test patterns.";
    }

    class CustomWriteListener implements WriteListener {

        private final ServletOutputStream sos;
        private final Queue queue;
        private final AsyncContext context;

        public CustomWriteListener(ServletOutputStream sos, Queue queue, AsyncContext context) {
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

    class CustomReadListener implements ReadListener {

        private final AsyncContext context;
        private final ServletInputStream is;
        private final HttpServletResponse res;
        private final Queue queue;

        public CustomReadListener(AsyncContext context, ServletInputStream is, HttpServletResponse res) {
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
            WriteListener writeListener = new CustomWriteListener(output, queue, context);
            output.setWriteListener(writeListener);
        }

        @Override
        public void onError(Throwable t) {
            System.err.println(t);
            context.complete();
        }

    }
}
