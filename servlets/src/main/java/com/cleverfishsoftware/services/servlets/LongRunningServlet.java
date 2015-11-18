/*
 */
package com.cleverfishsoftware.services.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author peter
 */
@WebServlet(name = "LongRunningServlet", urlPatterns = {"/LongRunningServlet"})
public class LongRunningServlet extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {

            String servletName = getServletName();
            long startTime = System.currentTimeMillis();
            System.out.println(servletName + " Start::Name="
                    + Thread.currentThread().getName() + "::ID="
                    + Thread.currentThread().getId());

            int secs;
            String sleep = request.getParameter("sleep");
            if (sleep != null && !sleep.isEmpty() && sleep.matches("\\d+")) {
                secs = Integer.valueOf(sleep);
                // max 10 seconds
                if (secs > 10000) {
                    secs = 10000;
                }
                Thread.sleep(secs);
            }

            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LongRunningServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LongRunningServlet at " + request.getContextPath() + "</h1>");
            out.println("<h3>sleep time: " + sleep+ " seconds</h3>");
            out.println("</body>");
            out.println("</html>");

            long endTime = System.currentTimeMillis();
            System.out.println(servletName + " End::Name="
                    + Thread.currentThread().getName() + "::ID="
                    + Thread.currentThread().getId() + "::Time Taken="
                    + (endTime - startTime) + " ms.");

        } catch (InterruptedException ex) {
            System.out.println(ex);
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
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
