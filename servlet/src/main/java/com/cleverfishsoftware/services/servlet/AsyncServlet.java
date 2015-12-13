/*
 */
package com.cleverfishsoftware.services.servlet;

import static com.cleverfishsoftware.services.common.CommonUtils.isNumeric;
import static com.cleverfishsoftware.services.common.CommonUtils.isSpecified;
import com.cleverfishsoftware.services.common.GeneratedContent;
import java.io.IOException;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import javax.servlet.AsyncContext;
import javax.servlet.ReadListener;
import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.ServletOutputStream;
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

    private ScheduledExecutorService executor;
    private ScheduledThreadPoolExecutor scheduler;

    private final static AtomicInteger COUNTER = new AtomicInteger();

    private final static GeneratedContent CONTENT = GeneratedContent.getInstance();

    @Override
    public void init() {
        this.executor = Executors.newSingleThreadScheduledExecutor();
        this.scheduler = new ScheduledThreadPoolExecutor(Runtime.getRuntime().availableProcessors());
    }

    @Override
    public void destroy() {
        executor.shutdown();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AsyncContext asyncContext = request.startAsync();
        String servletName = getServletName();
        long startTime = System.currentTimeMillis();
        ThreadInfo ti = new ThreadInfo(getServletName(), Thread.currentThread(), System.currentTimeMillis());

        int count = COUNTER.incrementAndGet();

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
        System.out.println("sleep is set to " + sleep);

        // simple sleep and call complete on asyncContext 
        ServletOutputStream os = response.getOutputStream();

        // determine how to respond
        int size;
        String sizeParam = request.getParameter("size");
        if (isSpecified(sizeParam) && isNumeric(sizeParam)) {
            size = Integer.valueOf(sizeParam);
            if (sleep > 0) {
                System.out.println("here i am. going to process with sleep");
                os.setWriteListener(new GeneratedContentWriteListenerAndSleep(os, CONTENT, size, asyncContext, sleep, scheduler, ti));
            } else {
                os.setWriteListener(new GeneratedContentWriteListener(os, CONTENT, size, asyncContext, ti));
            }
        } else {
            executor.schedule(asyncContext::complete, sleep, TimeUnit.MILLISECONDS);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        AsyncContext context = request.startAsync();
        ServletInputStream is = request.getInputStream();
        ReadListener readListener = new EchoReadListenerUsingStrings(context, is, response);
        is.setReadListener(readListener);
    }

    @Override
    public String getServletInfo() {
        return "Asynchronous Servlet for testing various performance test patterns.";
    }

}
