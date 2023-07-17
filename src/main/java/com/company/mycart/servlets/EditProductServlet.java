package com.company.mycart.servlets;

import com.company.mycart.dao.ProductDao;
import com.company.mycart.entities.Product;
import com.company.mycart.helper.FactoryProvider;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

@WebServlet
@MultipartConfig
public class EditProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("product_id"));
        String productName = request.getParameter("product_name");
        int productPrice = Integer.parseInt(request.getParameter("product_price"));
        int productDiscount = Integer.parseInt(request.getParameter("product_discount"));
        int productQuantity = Integer.parseInt(request.getParameter("product_quantity"));
        String productDesc = request.getParameter("product_desc");
        Part productPic = request.getPart("product_pic");

        // Get the existing product from the database
        ProductDao productDao = new ProductDao(FactoryProvider.getFactory());
        Product existingProduct = productDao.getProductById(productId);

        // Update the product properties
        existingProduct.setpName(productName);
        existingProduct.setpPrice(productPrice);
        existingProduct.setpDiscount(productDiscount);
        existingProduct.setpQuantity(productQuantity);
        existingProduct.setpDesc(productDesc);

        // Handle the uploaded picture
        if (productPic != null && productPic.getSize() > 0) {
            String fileName = extractFileName(productPic);
            String filePath = getServletContext().getRealPath("") + "img" + File.separator + "products" + File.separator + fileName;

            // Delete the old picture if it exists
            deleteExistingPicture(existingProduct.getpPhoto());

            // Save the new picture
            try (FileOutputStream fos = new FileOutputStream(filePath);
                 InputStream is = productPic.getInputStream()) {
                byte[] data = new byte[is.available()];
                is.read(data);
                fos.write(data);
                existingProduct.setpPhoto(fileName);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        // Update the product in the database
        productDao.updateProduct(existingProduct);

        response.sendRedirect("admin.jsp");
    }

    private String extractFileName(Part part) {
        String submittedFileName = part.getSubmittedFileName();
        return submittedFileName != null ? submittedFileName.substring(submittedFileName.lastIndexOf(File.separator) + 1) : null;
    }

    private void deleteExistingPicture(String fileName) {
        if (fileName != null && !fileName.isEmpty()) {
            String filePath = getServletContext().getRealPath("") + "img" + File.separator + "products" + File.separator + fileName;
            File file = new File(filePath);
            if (file.exists()) {
                file.delete();
            }
        }
    }
}
