<%@page import="java.util.ArrayList"%>
<%@page import="com.company.mycart.dao.ProductDao"%>
<%@page import="java.util.List"%>
<%@page import="com.company.mycart.helper.FactoryProvider"%>
<%@page import="com.company.mycart.dao.AddToCartDao"%>
<%@page import="com.company.mycart.dao.UserDao"%>
<%@page import="com.company.mycart.entities.User"%>
<%@page import="com.company.mycart.entities.Product"%>
<%@page import="com.company.mycart.entities.AddToCart"%>
<!-- Button trigger modal -->
<%
    HttpSession session1 = request.getSession();
    User currentUser = (User) session1.getAttribute("current-user");
    int uid = currentUser.getUserId();

    AddToCartDao adao = new AddToCartDao(FactoryProvider.getFactory());
    List<AddToCart> cartItems = adao.getCartItemsByUserId(uid);
    List<Product> products = new ArrayList<>();
    if (cartItems != null && !cartItems.isEmpty()) {
        List<Integer> productIds = new ArrayList<>();
        for (AddToCart cartItem : cartItems) {
            Product product = cartItem.getProductid();
            Integer pid = product.getpId();
            productIds.add(pid);

        }

        products = new ProductDao(FactoryProvider.getFactory()).getProductsByIds(productIds);

    }


%>


<!-- Modal -->
<div class="modal fade" id="cart" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header custom-bg text-white">
                <h5 class="modal-title" id="exampleModalLabel">Your Cart</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" >
                <form action="DeleteProductAddToCart" method="post">
                    <table style="width: 100%">
                        <tr>
                            <th>Item Name</th>
                            <th>ProductQuantity</th>
                            <th>Price</th>
                            <th>Remove</th>
                        </tr>
                        <%     if (products != null && !products.isEmpty()) {
                                    double totalPrice=0.0;
                                for (Product product : products) {
                                    int quantity = 0;
                                    for (AddToCart cartItem : cartItems) {
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
                            <td><%= quantity %></td>
                            <td><%=  product.getPriceAfterApplyingDiscount() * quantity%></td>
                            <td>
                                
                                    <input type="hidden" name="productId" value="<%= product.getpId()%>"/>
                                    <input type="hidden" name="userId" value="<%= uid %>"/>
                                    <button type="submit" class="btn btn-danger" >Remove</button>
                               
                            </td>

                        </tr>
                        <%
                            }%>
                            <tr>
                                <td colspan="5" class="text-right">Total Price:</td>
                                <td><%= totalPrice %></td>
                            </tr>
                        <%} else {%>
                        <tr>
                            <td colspan="2">Your Cart is Empty</td>
                        </tr>
                        <%
                            }
                        %>
                    </table>
                </form>

            </div>
            <div class="modal-footer">
<!--                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>-->
                <a href="checkout.jsp" type="button" class="btn btn-primary ">Buy-now</a>
                <a href="index.jsp" type="button" class="btn btn-primary ">Checkout</a>
            </div>
        </div>
    </div>
</div>

<div id="toast"></div>