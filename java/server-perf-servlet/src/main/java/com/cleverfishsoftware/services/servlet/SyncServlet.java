/*
 */
package com.cleverfishsoftware.services.servlet;

import com.cleverfishsoftware.services.common.CommonUtils;
import static com.cleverfishsoftware.services.common.CommonUtils.isNumeric;
import static com.cleverfishsoftware.services.common.CommonUtils.isSpecified;
import com.cleverfishsoftware.services.common.ContentGeneratorStatic;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.concurrent.atomic.AtomicInteger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author peter
 */
@WebServlet(name = "SyncServlet", urlPatterns = {"/perf"})
public class SyncServlet extends HttpServlet {

    private final static AtomicInteger COUNTER = new AtomicInteger();
    private final static ContentGeneratorStatic CONTENT = ContentGeneratorStatic.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain;charset=UTF-8");

        int count = COUNTER.incrementAndGet();

        String servletName = getServletName();
        long startTime = System.currentTimeMillis();
        //System.out.println(servletName + " Start::Name="
//                + Thread.currentThread().getName() + "::ID="
//                + Thread.currentThread().getId());

        //System.out.println("YOU ARE CALLING THE SYNC SERVLET");
        // introduce latency
        int sleep;
        String sleepParam = request.getParameter("sleep");
        if (isSpecified(sleepParam) && isNumeric(sleepParam)) {
            sleep = Integer.valueOf(sleepParam);
            // max 10 seconds
            if (sleep > 10000) {
                sleep = 10000;
            } else if (sleep < 0) {
                sleep = 0;
            }
            try {
                Thread.sleep(sleep);
            } catch (InterruptedException ex) {
                System.err.println(ex);
            }
        }

        // determine how to respond
        int size;
        String sizeParam = request.getParameter("size");
        if (isSpecified(sizeParam) && isNumeric(sizeParam)) {
            size = Integer.valueOf(sizeParam);
            sendGeneratedResponse(response, request, size);
        } else {
            sendDefaultResponse(response, request);
        }

        long endTime = System.currentTimeMillis();
        //System.out.println(servletName + " End::Name="
//                + Thread.currentThread().getName() + "::ID="
//                + Thread.currentThread().getId() + "::Time Taken="
//                + (endTime - startTime) + " ms.");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int count = COUNTER.incrementAndGet();
        String servletName = getServletName();
        long startTime = System.currentTimeMillis();
        //System.out.println(servletName + " Start::Name="
//                + Thread.currentThread().getName() + "::ID="
//                + Thread.currentThread().getId());

        //any request that uses a POST will just echo back what is sent (using OIO in this case
        response.setContentType(request.getContentType());
        CommonUtils.copy(request.getInputStream(), response.getOutputStream());

        long endTime = System.currentTimeMillis();
        //System.out.println(servletName + " End::Name="
//                + Thread.currentThread().getName() + "::ID="
//                + Thread.currentThread().getId() + "::Time Taken="
//                + (endTime - startTime) + " ms.");
    }

    private void sendGeneratedResponse(HttpServletResponse response, HttpServletRequest request, int size) throws IOException {
        CONTENT.writeChannel(response.getOutputStream(), size);
    }

    private void sendDefaultResponse(HttpServletResponse response, HttpServletRequest request) throws IOException {
        try (PrintWriter out = response.getWriter()) {
            out.println("Servlet: " + getServletName());
            out.println("Path: " + request.getContextPath());
            out.println("Requests Processed: " + COUNTER.get());
            out.println("Msg: server is running");
        }
    }

    @Override
    public String getServletInfo() {
        return "Synchronous Servlet for testing various performance test patterns.";
    }

}
