<%@page import="com.company.mycart.dao.ProductDao"%>
<%@page import="com.company.mycart.dao.UserDao"%>
<%@page import="java.util.Map"%>
<%@page import="com.company.mycart.helper.Helper"%>
<%@page import="java.util.List"%>
<%@page import="com.company.mycart.helper.FactoryProvider"%>
<%@page import="com.company.mycart.dao.CategoryDao"%>
<%@page import="com.company.mycart.entities.User"%>
<%@page import="com.company.mycart.entities.Product"%>
<%@page import="com.company.mycart.entities.Category"%>
<%
    User user = (User) session.getAttribute("current-user");
    if (user == null) {
        session.setAttribute("message", "you are not logged in !! Login first");
        response.sendRedirect("login.jsp");
        return;
    } else {
        if (user.getUserType().equals("normal")) {
            session.setAttribute("message", "You are not admin ! Do not access this page");
            response.sendRedirect("login.jsp");
            return;
        }
    }
%>
<%
    CategoryDao cdao = new CategoryDao(FactoryProvider.getFactory());
    List<Category> list = cdao.getCategories();
    UserDao udao = new UserDao(FactoryProvider.getFactory());
    List<User> list1 = udao.getAllUsers();
    ProductDao pdao = new ProductDao(FactoryProvider.getFactory());
    List<Product> list2 = pdao.getAllProducts();

//getting count
    Map<String, Long> m = Helper.getCounts(FactoryProvider.getFactory());


%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Panel</title>
        <%@include file="components/common_css_js.jsp" %>
    </head>
    <body>
        <%@include file="components/navbar_login.jsp" %>
        <div class="container admin">
            <div class="container-fluid mt-3">
                <%@include file="components/message.jsp" %>
            </div>



            <div class="row mt-3">
                <!--first col-->
                <div class="col-md-4">
                    <!--first box-->
                    <div class="card" data-toggle="modal" data-target="#user-modal">
                        <div class="card-body text-center">
                            <div class="container">
                                <img style="max-width: 150px;" class="img-fluid rounded-circle" src="img/man.png" alt="user_icon"/>
                            </div>
                            <h1><%= m.get("userCount")%></h1>
                            <h1 class="text-uppercase text-muted">Users</h1>
                        </div>
                    </div>
                </div>
                <!--second col-->
                <div class="col-md-4">
                    <!--second box-->
                    <div class="card" data-toggle="modal" data-target="#show-category-modal">
                        <div class="card-body text-center">
                            <div class="container">
                                <img style="max-width: 150px;" class="img-fluid rounded-circle" src="img/options.png" alt="user_icon"/>
                            </div>
                            <h1><%= list.size()%></h1>
                            <h1 class="text-uppercase text-muted">Categories</h1>
                        </div>
                    </div>
                </div>
                <!--third col-->
                <div class="col-md-4">
                    <!--third box-->
                    <div class="card" data-toggle="modal" data-target="#show-product-modal">
                        <div class="card-body text-center">
                            <div class="container">
                                <img style="max-width: 150px;" class="img-fluid rounded-circle" src="img/product.png" alt="user_icon"/>
                            </div>
                            <h1><%= m.get("productCount")%></h1>
                            <h1 class="text-uppercase text-muted">Products</h1>
                        </div>
                    </div>
                </div>
            </div>
            <!--second row-->
            <div class="row mt-3">
                <!--second row first col-->
                <div class="col-md-6">
                    <div class="card" data-toggle="modal" data-target="#add-category-modal">
                        <div class="card-body text-center">
                            <div class="container">
                                <img style="max-width: 150px;" class="img-fluid rounded-circle" src="img/apps.png" alt="user_icon"/>
                            </div>
                            <p class="mt-2">Click here to add new category</p>
                            <h1 class="text-uppercase text-muted">Add Category</h1>
                        </div>
                    </div>
                </div>
                <!--second row second col-->
                <div class="col-md-6">
                    <div class="card" data-toggle="modal" data-target="#add-product-modal">
                        <div class="card-body text-center">
                            <div class="container">
                                <img style="max-width: 150px;" class="img-fluid rounded-circle" src="img/plus.png" alt="user_icon"/>
                            </div>
                            <p class="mt-2">Click here to add new Product</p>
                            <h1 class="text-uppercase text-muted">Add Product</h1>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--add category modal-->

        <!-- Modal -->
        <div class="modal fade" id="add-category-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header custom-bg text-white">
                        <h5 class="modal-title" id="exampleModalLabel">Fill category details</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <form action="ProductOperationServlet" method="post">
                            <input type="hidden" name="operation" value="addcategory"/>

                            <div class="form-group">
                                <input type="text" class="form-control" name="catTitle" placeholder="Enter category title" required/>
                            </div>
                            <div class="form-group">
                                <textarea style="height: 250px;" class="form-control" placeholder="Enter category description" name="catDescription" required></textarea>
                            </div>
                            <div class="container text-center">
                                <button class="btn btn-outline-success">Add Category</button>
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                            </div>
                        </form>
                    </div>

                </div>
            </div>
        </div>
        <!--end category modal-->

        <!--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-->

        <!--product modal-->

        <!-- Modal -->
        <div class="modal fade" id="add-product-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Product details</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <!--form-->
                        <form action="ProductOperationServlet" method="post" enctype="multipart/form-data">

                            <input type="hidden" name="operation" value="addproduct"/>

                            <!--product title-->
                            <div class="form-group">
                                <input type="text" class="form-control" placeholder="Enter title of product" name="pName" required/>
                            </div>
                            <!--product description-->
                            <div class="form-group">
                                <textarea style="height: 150px;" class="form-control" placeholder="Enter product description" name="pDesc"></textarea>
                            </div>
                            <!--product price-->
                            <div class="form-group">
                                <input type="number" class="form-control" placeholder="Enter price of product" name="pPrice" required/>
                            </div>
                            <!--product discount-->
                            <div class="form-group">
                                <input type="number" class="form-control" placeholder="Enter product discount" name="pDiscount" required/>
                            </div>
                            <!--product quantity-->
                            <div class="form-group">
                                <input type="number" class="form-control" placeholder="Enter product quantity" name="pQuantity" required/>
                            </div>
                            <!--product category-->


                            <div class="form-group">
                                <select name="catId" class="form-control" >
                                    <%                                        for (Category c : list) {
                                    %>
                                    <option value="<%= c.getCategoryId()%>"><%= c.getCategoryTitle()%></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                            <!--product file-->
                            <div class="form-group">
                                <label for="pPic">Select Picture of product</label>
                                <br>
                                <input type="file" id="pPic" name="pPic" required/>
                            </div>
                            <!--submit button-->
                            <div class="container text-center">
                                <button class="btn btn-outline-success">Add product</button>
                            </div>

                        </form>

                        <!--end form-->
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>

                    </div>
                </div>
            </div>
        </div>
        <!--end product modal-->
        <!--show user modal-->

        <!-- Modal -->
        <div class="modal fade" id="user-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header custom-bg text-white">
                        <h5 class="modal-title" id="exampleModalLabel">User details</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">

                        <table style="width: 100%">
                            <tr >
                                <th>Name</th>
                                <th>email</th>
                                <th>phone</th>
                                <th>address</th>
                                <th>Edit</th>
                                <th>Remove</th>
                            </tr>

                            <%
                                for (int i = 0; i < list1.size(); i++) {

                            %>

                            <tr>
                                <td><%= list1.get(i).getUserName()%></td>
                                <td><%= list1.get(i).getUserEmail()%></td>

                                <td><%= list1.get(i).getUserPhone()%></td>
                                <td><%= list1.get(i).getUserAddress()%></td>
                                <td><a class="nav-link edit-link" href="#!" data-toggle="modal" data-target="#user-edit-modal" data-userid="<%= list1.get(i).getUserId()%>">edit</a></td>
                                <td>
                                    <form action="DeleteUser" method="post">
                                        <input type="hidden" name="usrId" value="<%= list1.get(i).getUserId()%>">
                                        <button type="submit" class="remove-button">remove</button>
                                    </form>
                                </td>
                            </tr>

                            <%
                                }
                            %>

                        </table>


                    </div>

                </div>
            </div>
        </div>
        <!--end user modal-->  
        <!--show Category modal-->

        <!-- Modal -->
        <div class="modal fade" id="show-category-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header custom-bg text-white">
                        <h5 class="modal-title" id="exampleModalLabel">Category details</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">

                        <table style="width: 100%">
                            <tr>
                                <th>CategoryId</th>
                                <th>CategoryTitle</th>
                                <th>CategoryDescription</th>
                                <th>Edit</th>
                                <th>Remove</th>
                            </tr>

                            <%
                                for (int i = 0; i < list.size(); i++) {
                            %>
                            <tr>
                                <td><%= list.get(i).getCategoryId()%></td>
                                <td><%= list.get(i).getCategoryTitle()%></td>
                                <td><%= list.get(i).getCategoryDescription()%></td>
                                <td><a class="nav-link edit-link" href="#!" data-toggle="modal" data-target="#category-edit-modal" data-categoryid="<%= list.get(i).getCategoryId()%>">edit</a></td>
                                <td>
                                    <form action="DeleteCategory" method="post">
                                        <input type="hidden" name="categoryId" value="<%= list.get(i).getCategoryId()%>">
                                        <button type="submit" class="remove-button">remove</button>
                                    </form>
                                </td>

                            </tr>
                            <%
                                }
                            %>

                        </table>


                    </div>

                </div>
            </div>
        </div>
        <!--end category modal-->
        <!--show Product modal-->

        <!-- Modal -->
        <div class="modal fade" id="show-product-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" style="max-width:70%;" role="document">
                <div class="modal-content">
                    <div class="modal-header custom-bg text-white">
                        <h5 class="modal-title" id="exampleModalLabel" style="text-align: center">Product details</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        
                            <table style="width: 100%">
                                <tr>
                                    <th>ProId</th>
                                    <th>ProName</th>
                                    <th>ProPrice</th>
                                    <th>ProDiscount(%)</th>
                                    <th>ProQuantity</th>
                                    <th>ProductDesc</th>
                                    <th>ProductPic</th>
                                    <th>Edit</th>
                                    <th>Remove</th>

                                </tr>

                                <%
                                    for (int i = 0; i < list2.size(); i++) {
                                %>
                                <tr>
                                    <td><%= list2.get(i).getpId()%></td>
                                    <td><%= list2.get(i).getpName()%></td>
                                    <td><%= list2.get(i).getpPrice()%></td>
                                    <td><%= list2.get(i).getpDiscount()%></td>
                                    <td><%= list2.get(i).getpQuantity()%></td>
                                    <td><%= list2.get(i).getpDesc()%></td>
                                    <td><%= list2.get(i).getpPhoto()%></td>
                                    <td><a class="nav-link edit-link" href="#!" data-toggle="modal" data-target="#product-edit-modal" data-productid="<%= list2.get(i).getpId()%>">edit</a></td>
                                    <td>
                                    <form action="DeleteProduct" method="post">
                                        <input type="hidden" name="productId" value="<%= list2.get(i).getpId() %>">
                                        <button type="submit" class="remove-button">remove</button>
                                    </form>
                                </td>

                                </tr>
                                <%
                                    }
                                %>

                            </table>

                        
                    </div>

                </div>
            </div>
        </div>

        <!--end Product modal--> 

        <!-- Edit user details Modal -->
        <div class="modal fade" id="user-edit-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header primary-background text-white text-center">
                        <h5 class="modal-title" id="exampleModalLabel">mycart</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="container text-center">
                            <h5 class="modal-title" id="exampleModalLabel"><span id="edit-user-name"></span></h5>
                            <div id="user-details">
                                <table class="table">
                                    <tbody>
                                        <tr>
                                            <th scope="row">ID:</th>
                                            <td><span id="edit-user-id"></span></td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Email:</th>
                                            <td><span id="edit-user-email"></span></td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Phone:</th>
                                            <td><span id="edit-user-phone"></span></td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Address:</th>
                                            <td><span id="edit-user-address"></span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div id="user-edit" style="display: none">
                                <h2 class="mt-2">Please Edit Carefully</h2>
                                <form action="EditUserServlet" method="post" enctype="multipart/form-data">
                                    <table class="table">
                                        <tr>
                                            <td>ID:</td>
                                            <td><input type="text" class="form-control" name="user_id" id="edit-user-id-input" readonly></td>

                                        </tr>
                                        <tr>
                                            <td>Email:</td>
                                            <td><input type="email" class="form-control" name="user_email" id="edit-user-email-input"></td>
                                        </tr>
                                        <tr>
                                            <td>Name:</td>
                                            <td><input type="text" class="form-control" name="user_name" id="edit-user-name-input"></td>
                                        </tr>
                                        <tr>
                                            <td>Password:</td>
                                            <td><input type="password" class="form-control" name="user_password" id="edit-user-password-input"></td>
                                        </tr>
                                        <tr>
                                            <td>Phone:</td>
                                            <td><input type="text" class="form-control" name="user_phone" id="edit-user-phone-input"></td>
                                        </tr>
                                        <tr>
                                            <td>Address:</td>
                                            <td><input type="text" class="form-control" name="user_address" id="edit-user-address-input"></td>
                                        </tr>
                                    </table>
                                    <div class="container">
                                        <button type="submit" class="btn btn-outline-primary">Save</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button id="edit-user-button" type="button" class="btn btn-primary">Edit</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit Category details Modal -->
        <div class="modal fade" id="category-edit-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header primary-background text-white text-center">
                        <h5 class="modal-title" id="exampleModalLabel">mycart</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="container text-center">
                            <h5 class="modal-title" id="exampleModalLabel"><span ></span></h5>
                            <div id="category-details">
                                <table class="table">
                                    <tbody>
                                        <tr>
                                            <th scope="row">CategoryID:</th>
                                            <td><span id="edit-category-id"></span></td>
                                        </tr>
                                        <tr>
                                            <th scope="row">CategoryTitle:</th>
                                            <td><span id="edit-category-title"></span></td>
                                        </tr>
                                        <tr>
                                            <th scope="row">CategoryDescription:</th>
                                            <td><span id="edit-category-description"></span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div id="category-edit" style="display: none">
                                <h2 class="mt-2">Please Edit Carefully</h2>
                                <form action="EditCategoryServlet" method="post" enctype="multipart/form-data">
                                    <table class="table">
                                        <tr>
                                            <td>ID:</td>
                                            <td><input type="text" class="form-control" name="category_id" id="edit-category-id-input" readonly></td>
                                        </tr>
                                        <tr>
                                            <td>CategoryTitle:</td>
                                            <td><input type="text" class="form-control" name="category_title" id="edit-category-title-input"></td>
                                        </tr>
                                        <tr>
                                            <td>CategoryDescription:</td>
                                            <td><input type="text" class="form-control" name="category_description" id="edit-category-description-input"></td>
                                        </tr>
                                    </table>
                                    <div class="container">
                                        <button type="submit" class="btn btn-outline-primary">Save</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button id="edit-category-button" type="button" class="btn btn-primary">Edit</button>
                    </div>
                </div>
            </div>
        </div>


        <!-- Edit Product details Modal -->
        <div class="modal fade" id="product-edit-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header primary-background text-white text-center">
                        <h5 class="modal-title" id="exampleModalLabel">mycart</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="container text-center">
                            <h5 class="modal-title" id="exampleModalLabel"><span id="edit-user-name"></span></h5>
                            <div id="product-details">
                                <table class="table">
                                    <tbody>
                                        <tr>
                                            <th scope="row">ProductID:</th>
                                            <td><span id="edit-product-id"></span></td>
                                        </tr>
                                        <tr>
                                            <th scope="row">ProductName:</th>
                                            <td><span id="edit-product-name"></span></td>
                                        </tr>
                                        <tr>
                                            <th scope="row">ProductPrice:</th>
                                            <td><span id="edit-product-price"></span></td>
                                        </tr>
                                        <tr>
                                            <th scope="row">ProductDiscount(%):</th>
                                            <td><span id="edit-product-discount"></span></td>
                                        </tr>
                                        <tr>
                                            <th scope="row">ProductQuantity:</th>
                                            <td><span id="edit-product-quantity"></span></td>
                                        </tr>
                                        <tr>
                                            <th scope="row">ProductDesc:</th>
                                            <td><span id="edit-product-desc"></span></td>
                                        </tr>
                                        <tr>
                                            <th scope="row">ProductPic:</th>
                                            <td><span id="edit-product-pic"></span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div id="product-edit" style="display: none">
                                <h2 class="mt-2">Please Edit Carefully</h2>
                                <form action="EditProductServlet" method="post" enctype="multipart/form-data">
                                    <table class="table">
                                        <tr>
                                            <td>ID:</td>
                                            <td><input type="text" class="form-control" name="product_id" id="edit-product-id-input" readonly></td>

                                        </tr>
                                        <tr>
                                            <td>ProductName:</td>
                                            <td><input type="text" class="form-control" name="product_name" id="edit-product-name-input"></td>
                                        </tr>
                                        <tr>
                                            <td>ProductPrice:</td>
                                            <td><input type="number" class="form-control" name="product_price" id="edit-product-price-input"></td>
                                        </tr>
                                        <tr>
                                            <td>ProductDiscount(%):</td>
                                            <td><input type="number" class="form-control" name="product_discount" id="edit-product-discount-input"></td>
                                        </tr>
                                        <tr>
                                            <td>ProductQuantity:</td>
                                            <td><input type="number" class="form-control" name="product_quantity" id="edit-product-quantity-input"></td>
                                        </tr>
                                        <tr>
                                            <td>ProductDesc:</td>
                                            <td><input type="text" class="form-control" name="product_desc" id="edit-product-desc-input"></td>
                                        </tr>
                                        <tr>
                                            <td>Productpic:</td>
                                            <td><input type="file" class="form-control" name="product_pic" id="edit-product-pic-input"></td>
                                        </tr>
                                    </table>
                                    <div class="container">
                                        <button type="submit" class="btn btn-outline-primary">Save</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button id="edit-product-button" type="button" class="btn btn-primary">Edit</button>
                    </div>
                </div>
            </div>
        </div>


        <script>
//            user
            $(document).ready(function () {
                let editStatus = false;
                $("#edit-user-button").click(function () {
                    if (editStatus == false) {
                        $("#user-details").hide();
                        $("#user-edit").show();
                        editStatus = true;
                        $(this).text("Back");
                    } else {
                        $("#user-details").show();
                        $("#user-edit").hide();
                        editStatus = false;
                        $(this).text("Edit");
                    }
                });

                $("#user-modal").on("click", ".edit-link", function () {
                    var userId = $(this).data("userid");
                    var userName = $(this).closest("tr").find("td:nth-child(1)").text();
                    var userEmail = $(this).closest("tr").find("td:nth-child(2)").text();
                    var userPhone = $(this).closest("tr").find("td:nth-child(4)").text();
                    var userAddress = $(this).closest("tr").find("td:nth-child(5)").text();

                    $("#edit-user-id").text(userId);
                    $("#edit-user-id-input").val(userId);
                    $("#edit-user-name").text(userName);
                    $("#edit-user-name-input").val(userName);
                    $("#edit-user-email").text(userEmail);
                    $("#edit-user-email-input").val(userEmail);
                    $("#edit-user-phone").text(userPhone);
                    $("#edit-user-phone-input").val(userPhone);
                    $("#edit-user-address").text(userAddress);
                    $("#edit-user-address-input").val(userAddress);

                    // Set the user ID as a value in the hidden input field
                    $("#edit-user-id-input").val(userId);
                });
            });

//            category
            $(document).ready(function () {
                let editStatus = false;

                $("#edit-category-button").click(function () {
                    if (editStatus == false) {
                        $("#category-details").hide();
                        $("#category-edit").show();
                        editStatus = true;
                        $(this).text("Back");
                    } else {
                        $("#category-details").show();
                        $("#category-edit").hide();
                        editStatus = false;
                        $(this).text("Edit");
                    }
                });

                $("#show-category-modal").on("click", ".edit-link", function () {
                    var categoryId = $(this).data("categoryid");
                    var categoryTitle = $(this).closest("tr").find("td:eq(1)").text();
                    var categoryDescription = $(this).closest("tr").find("td:eq(2)").text();

                    $("#edit-category-id").text(categoryId);
                    $("#edit-category-id-input").val(categoryId);
                    $("#edit-category-title").text(categoryTitle);
                    $("#edit-category-title-input").val(categoryTitle);
                    $("#edit-category-description").text(categoryDescription);
                    $("#edit-category-description-input").val(categoryDescription);
                    // Set the category ID as a value in the hidden input field
                    $("#edit-category-id-input").val(categoryId);
                });
            });

            //product
            $(document).ready(function () {
                let editStatus = false;
                $("#edit-product-button").click(function () {
                    if (editStatus == false) {
                        $("#product-details").hide();
                        $("#product-edit").show();
                        editStatus = true;
                        $(this).text("Back");
                    } else {
                        $("#product-details").show();
                        $("#product-edit").hide();
                        editStatus = false;
                        $(this).text("Edit");
                    }
                });

                $("#show-product-modal").on("click", ".edit-link", function () {
                    var productId = $(this).data("productid");
                    var productName = $(this).closest("tr").find("td:eq(1)").text();
                    var productPrice = $(this).closest("tr").find("td:eq(2)").text();
                    var productDiscount = $(this).closest("tr").find("td:eq(3)").text();
                    var productQuantity = $(this).closest("tr").find("td:eq(4)").text();
                    var productDesc = $(this).closest("tr").find("td:eq(5)").text();
                    var productPic = $(this).closest("tr").find("td:eq(6)").text();

                    $("#edit-product-id").text(productId);
                    $("#edit-product-id-input").val(productId);
                    $("#edit-product-name").text(productName);
                    $("#edit-product-name-input").val(productName);
                    $("#edit-product-price").text(productPrice);
                    $("#edit-product-price-input").val(productPrice);
                    $("#edit-product-discount").text(productDiscount);
                    $("#edit-product-discount-input").val(productDiscount);
                    $("#edit-product-quantity").text(productQuantity);
                    $("#edit-product-quantity-input").val(productQuantity);
                    $("#edit-product-desc").text(productDesc);
                    $("#edit-product-desc-input").val(productDesc);
                    $("#edit-product-pic").text(productPic);
                    $("#edit-product-pic-input").val(productPic);

                    // Set the product ID as a value in the hidden input field
                    $("#edit-product-id-input").val(productId);
                });
            });



        </script>









        <%@include file="components/common_modals.jsp" %>
    </body>
</html>
