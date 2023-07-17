<%@ page import="com.company.mycart.entities.User" %>
<%
    User user = (User) session.getAttribute("current-user");
    if (user == null) {
        session.setAttribute("message", "You are not logged in! Please login first to access the checkout page.");
        response.sendRedirect("login.jsp");
    }
%>
<%
//    HttpSession session1 = request.getSession();
//    User currentUser = (User) session1.getAttribute("current-user");
    int usid = user.getUserId();

    AddToCartDao adaom = new AddToCartDao(FactoryProvider.getFactory());
    List<AddToCart> cartItemsm = adaom.getCartItemsByUserId(usid);
    List<Product> productsm = new ArrayList<>();
    if (cartItemsm != null && !cartItemsm.isEmpty()) {
        List<Integer> productIdsm = new ArrayList<>();
        for (AddToCart cartItem : cartItemsm) {
            Product product = cartItem.getProductid();
            Integer pid = product.getpId();
            productIdsm.add(pid);

        }

        productsm = new ProductDao(FactoryProvider.getFactory()).getProductsByIds(productIdsm);

    }


%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Checkout</title>
        <%@include file="components/common_css_js.jsp" %>
    </head>
    <body>
        <%@include file="components/navbar_checkout.jsp" %>
        <div class="container">
            <div class="row mt-5">
                <div class="col-md-6">
                    <!--card-->
                    <div class="card">
                        <div class="card-body">
                            <h3 class="text-center mb-3">Your selected items</h3>
<!--                            <div class="cart-body">-->
                                <form>
                                    <table style="width:100%">
                                        <tr>
                                            <th>Item Name</th>
                                            <th>ProductQuantity</th>
                                            <th>Price</th>
                                            
                                        </tr>
                                        <%     if (productsm != null && !productsm.isEmpty()) {
                                                    double totalPrice=0.0;
                                                for (Product product : productsm) {
                                                    int quantity = 0;
                                                    for (AddToCart cartItem : cartItemsm) {
                                                        if (cartItem.getProductid().getpId() == product.getpId()) {
                                                            quantity = cartItem.getQuantity();
                                                            break;
                                                        }
                                                    }
                                                    double itemPrice=product.getPriceAfterApplyingDiscount()*quantity;
                                                    totalPrice+=itemPrice;

                                        %>
                                        <tr>
                                            <td><%=  product.getpName()%></td>
                                            <td><%= quantity%></td>
                                            <td><%=  product.getPriceAfterApplyingDiscount() * quantity%></td>
                                        </tr>
                                        <%
                                            }%>
                                            <tr>
                                                <td colspan="3" class="text-right">Total Price:</td>
                                                <td><%= totalPrice %> </td>
                                            </tr>
                                       <% } else {%>
                                        <tr>
                                            <td colspan="2">Your Cart is Empty</td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </table>
                                </form>



                            <!--</div>-->
                        </div>
                    </div>

                </div>
                <div class="col-md-6">
                    <!--form details-->
                    <!--card-->
                    <div class="card">
                        <div class="card-body">
                            <h3 class="text-center mb-3">Your details for order</h3>
                            <form action="#!">
                                <div class="form-group">
                                    <label for="exampleInputEmail1">Email address</label>
                                    <input value="<%= user.getUserEmail()%>" type="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" placeholder="Enter email">

                                </div> 
                                <div class="form-group">
                                    <label for="name">Your name</label>
                                    <input value="<%= user.getUserName()%>" type="text" class="form-control" id="name" aria-describedby="emailHelp" placeholder="Enter name">

                                </div>
                                <div class="form-group">
                                    <label for="phone">Your contact</label>
                                    <input value="<%= user.getUserPhone()%>" type="number" class="form-control" id="phone" aria-describedby="emailHelp" placeholder="Enter contact number">

                                </div>
                                <div class="form-group">
                                    <label for="exampleFormControlTextarea1">Your shipping address</label>
                                    <textarea value="<%= user.getUserAddress() %>" class="form-control" id="exampleFormControlTextarea1" placeholder="Enter your address" rows="3"></textarea>
                                </div>
                                <div class="form-group">
                                    <label >Payment Mode :</label>
                                    <select class="form-control">
                                        <option>Cash on delivery</option>
                                        <option>UPI</option>
                                        <option>Credit card</option>

                                    </select>



                                </div>
                                <div class="container text-center">
                                    <button class="btn btn-outline-success" onclick="orderPlaced()">Order Now</button>
                                    <a class="btn btn-outline-primary" href="index.jsp">Continue Shopping</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>


        </div>
        <%@include file="components/common_modals.jsp" %>
    </body>
</html>
