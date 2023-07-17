<%@page import="com.company.mycart.entities.User"%>
<%@page import="com.company.mycart.dao.UserDao"%>
<%@page import="com.company.mycart.helper.Helper"%>
<%@page import="com.company.mycart.dao.CategoryDao"%>
<%@page import="java.util.List"%>
<%@page import="com.company.mycart.dao.ProductDao"%>
<%@page import="com.company.mycart.entities.Product"%>
<%@page import="com.company.mycart.entities.Category"%>
<%@page import="com.company.mycart.helper.FactoryProvider"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MyCart - Home</title>
        <%@include file="components/common_css_js.jsp" %>

    </head>
    <body>
        <%@include file="components/navbar_login.jsp" %>
        <div class="container-fluid">
            <div class="row mt-3 mx-2">

                <%  String cat = request.getParameter("category");
//                    out.println(cat);

                    ProductDao dao = new ProductDao(FactoryProvider.getFactory());
                    List<Product> list = null;
                    if (cat == null || cat.trim().equals("all")) {
                        list = dao.getAllProducts();
                    } else {
                        int cid = Integer.parseInt(cat.trim());
                        list = dao.getAllProductsById(cid);
                    }

                    CategoryDao cdao = new CategoryDao(FactoryProvider.getFactory());
                    List<Category> clist = cdao.getCategories();
                    HttpSession httpsession = request.getSession();
                    User u = (User) httpsession.getAttribute("current-user");

                %>

                

                <!--show categories-->
                <div class="col-md-2">
                    <div class="list-group mt-4">
                        <a href="index.jsp?category=all" class="list-group-item list-group-item-action active">
                            All Products
                        </a>

                        <%                            for (Category c : clist) {
                        %>
                        <a href="index.jsp?category=<%= c.getCategoryId()%>" class="list-group-item list-group-item-action"><%= c.getCategoryTitle()%></a>
                        <%
                            }
                        %>
                    </div>
                </div>
                <!--show products-->
                <div class="col-md-10">
                    <!--row-->
                    <div class="row mt-4">

                        <!--col:12-->
                        <div class="col-md-12">
                            <div class="card-columns">
                                
                                <!--traversing products-->
                                <%
                                    for (Product p : list) {
                                %>
                                <!--product card-->
                                <div class="card product-card">
                                    <div class="container text-center">
                                        <img class="card-img-top m-2" src="img/products/<%= p.getpPhoto()%>" style="max-height: 200px; max-width: 100%; width: auto;" alt="Card image cap">
                                    </div>
                                    <div class="card-body">
                                        <h5 class="card-title"><%= p.getpName()%></h5>
                                        <p class="card-text"><%= Helper.get10Words(p.getpDesc())%></p>
                                    </div>
                                    <div class="card-footer text-center">
                                        <!-- ...previous code... -->

                                        <%
                                            // Check if the 'u' object is not null before accessing its methods
                                        if (u != null) {
                                        %>
                                        <form action="AddToCartAction">
                                            <input type="hidden" name="productId" value="<%= p.getpId() %>"/>
                                            <input type="hidden" name="userId" value="<%= u.getUserId() %>"/>
                                            <input class="btn custom-bg text-white" type="submit" value="Add To Cart"/>
                                        </form>
                                        <%
                                        } else {
                                        %>
                                        <!-- Handle the case when 'u' is null -->
                                        <button class="btn custom-bg text-white">Add to Cart</button>
                                        <%
                                            }
                                        %>

                                        <!-- ...remaining code... -->



                                        <button class="btn btn-outline-success"> &#8377; <%= p.getPriceAfterApplyingDiscount()%>/- <span class="text-secondary discount-label">&#8377; <%= p.getpPrice()%> , <%= p.getpDiscount()%>% off</span></button>
                                    </div>
                                </div>


                                <%
                                    }

                                    if (list.size() == 0) {
                                        out.println("<h3>No item in this category</h3>");
                                    }

                                %>





                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <%@include file="components/common_modals.jsp" %>
    </body>
</html>
