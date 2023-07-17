/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.company.mycart.servlets;

import com.company.mycart.dao.AddToCartDao;
import com.company.mycart.dao.ProductDao;
import com.company.mycart.dao.UserDao;
import com.company.mycart.entities.AddToCart;
import com.company.mycart.entities.Product;
import com.company.mycart.entities.User;
import com.company.mycart.helper.FactoryProvider;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author atulk
 */
public class AddToCartAction extends HttpServlet {

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
        
        
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddToCartAction</title>");            
            out.println("</head>");
            out.println("<body>");
            
            int productId=Integer.parseInt(request.getParameter("productId"));
            int userId=Integer.parseInt(request.getParameter("userId"));
//            
            ProductDao pdao=new ProductDao(FactoryProvider.getFactory());
            Product product=pdao.getProductById(productId);
////           
            UserDao udao=new UserDao(FactoryProvider.getFactory());
            User user=udao.getUserById(userId);
//           
//            AddToCart a=new AddToCart(user, product);
            AddToCartDao adao=new AddToCartDao(FactoryProvider.getFactory());
//            adao.saveATD(a);
            List<AddToCart> cartItems=adao.getCartItemsByUserId(userId);
            boolean isProductExistsInCart=false;
            for(AddToCart item:cartItems){
                if(item.getProductid().getpId()==productId){
                    int quantity=item.getQuantity()+1;
                    item.setQuantity(quantity);
                    adao.saveATD(item);
                    isProductExistsInCart=true;
                    break;
                }
            }
            if(!isProductExistsInCart){
                AddToCart newCartItem=new AddToCart(user, product);
                newCartItem.setQuantity(1);
                adao.saveATD(newCartItem);
            }
            response.sendRedirect("index.jsp");
            
            
            
            out.println("</body>");
            out.println("</html>");
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
