/*
 */
package com.cleverfishsoftware.services.servlets;

import com.cleverfishsoftware.services.common.CannedResponses;
import com.cleverfishsoftware.services.common.CommonUtils;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import static com.cleverfishsoftware.services.common.CommonUtils.*;
import java.io.ByteArrayInputStream;

/**
 *
 * @author peter
 */
@WebServlet(name = "CannedResponse", urlPatterns = {"/CannedResponse "})
public class CannedResponse extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private static final CannedResponses DB = CannedResponses.getInstance();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String servletName = getServletName();
        long startTime = System.currentTimeMillis();
        System.out.println(servletName + " Start::Name="
                + Thread.currentThread().getName() + "::ID="
                + Thread.currentThread().getId());
        
        String hintParam = request.getParameter("hint");

        byte[] data;
        if (isSpecified(hintParam) && isNumeric(hintParam)) {
            data = DB.get(Integer.parseInt(hintParam));
        } else {
            data = DB.any();
        }

        response.setContentType("text/html;charset=UTF-8");
        CommonUtils.copy(new ByteArrayInputStream(data), response.getOutputStream());
        
        
        long endTime = System.currentTimeMillis();
        System.out.println(servletName + " End::Name="
                + Thread.currentThread().getName() + "::ID="
                + Thread.currentThread().getId() + "::Time Taken="
                + (endTime - startTime) + " ms.");
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
