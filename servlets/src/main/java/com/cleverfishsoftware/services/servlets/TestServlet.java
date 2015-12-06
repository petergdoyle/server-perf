/*
 */
package com.cleverfishsoftware.services.servlets;

import com.cleverfishsoftware.services.common.CommonUtils;
import static com.cleverfishsoftware.services.common.CommonUtils.isNumeric;
import static com.cleverfishsoftware.services.common.CommonUtils.isSpecified;
import com.cleverfishsoftware.services.common.GeneratedContent;
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
@WebServlet(name = "TestServlet", urlPatterns = {"/TestServlet"})
public class TestServlet extends HttpServlet {

    private final static AtomicInteger COUNTER = new AtomicInteger();

    private final static GeneratedContent CONTENT = GeneratedContent.getInstance();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain;charset=UTF-8");

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
//            System.out.println("sleeping " + sleep + " ms...");
            try {
                Thread.sleep(sleep);
            } catch (InterruptedException ex) {
                System.err.println(ex);
            }
        }

        // determine how to respond
        int size = 0;
        String sizeParam = request.getParameter("size");
        if (isSpecified(sizeParam) && isNumeric(sizeParam)) {
            size = Integer.valueOf(sizeParam);
            sendGeneratedResponse(response, request, size);
//            System.out.println("prepared response size " + size + " bytes");

        } else {
            sendDefaultResponse(response, request);
        }

        long endTime = System.currentTimeMillis();
        System.out.println(servletName + " End::Name="
                + Thread.currentThread().getName() + "::ID="
                + Thread.currentThread().getId() + "::Time Taken="
                + (endTime - startTime) + " ms.");
    }

    private void sendGeneratedResponse(HttpServletResponse response, HttpServletRequest request, int size) throws IOException {
        try (PrintWriter out = response.getWriter()) {
            out.write(CONTENT.get(size));
        }
    }

    private void sendDefaultResponse(HttpServletResponse response, HttpServletRequest request) throws IOException {
        try (PrintWriter out = response.getWriter()) {
            out.println("Servlet: " + getServletName());
            out.println("Path: " + request.getContextPath());
            out.println("Requests Processed: " + COUNTER.get());
            out.println("Msg: server is running");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int count = COUNTER.incrementAndGet();
        String servletName = getServletName();
        long startTime = System.currentTimeMillis();
        System.out.println(servletName + " Start::Name="
                + Thread.currentThread().getName() + "::ID="
                + Thread.currentThread().getId());

        //any request that uses a POST will just echo back what is sent
        response.setContentType(request.getContentType());
        CommonUtils.copy(request.getInputStream(), response.getOutputStream());

        long endTime = System.currentTimeMillis();
        System.out.println(servletName + " End::Name="
                + Thread.currentThread().getName() + "::ID="
                + Thread.currentThread().getId() + "::Time Taken="
                + (endTime - startTime) + " ms.");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet for testing various performance test patterns.";
    }// </editor-fold>

}
