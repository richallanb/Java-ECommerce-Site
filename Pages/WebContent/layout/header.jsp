<%@ page import="Action.*"%>
<%@ page import="java.util.*"%>


<%
	/*
	 Updates
	 - Matias added session for login
	 - Trung display number of products in cart , next to cart icon
	 -  logo, site name loaded from database
	 */

	/// Login is moved to /user/login.jsp

	//// Loading site settings: get logo, brand name
	Map<String, List<String>> site = SiteAction.getSettings();
	String template_url = "/bootstrap/css/bootstrap.min1.css";
	
	if (site != null) {
		int template_int = Integer
				.parseInt(site.get("Template").get(0));
		switch (template_int) {
		case 2:
			template_url = "/bootstrap/css/bootstrap.min2.css";
			break;
		case 3:
			template_url = "/bootstrap/css/bootstrap.min3.css";
			break;
		case 4:
			template_url = "/bootstrap/css/bootstrap.min4.css";
			break;
		case 5:
			template_url = "/bootstrap/css/bootstrap.min5.css";
			break;
		case 6:
			template_url = "/bootstrap/css/bootstrap.min6.css";
			break;
		default:
			template_url = "/bootstrap/css/bootstrap.min1.css";
		}
	}
	
	//// Get cookie of remember
	String cookieName = "Remember";
	Cookie cookies[] = request.getCookies();
	Cookie myCookie = null;
	
	if (cookies != null) {
		for (int i = 0; i < cookies.length; i++) {
			if (cookies[i].getName().equals(cookieName)) {
				myCookie = cookies[i];
				break;
			}
		}
	}
	
	boolean remember_me_check = false;
	String user_name = "";
	
	if(myCookie!=null && myCookie.getValue().equals("true")){
		remember_me_check = true;
		
		Cookie name_cookie = null;
		for (int i = 0; i < cookies.length; i++) {
			if (cookies[i].getName().equals("Username")) {
				name_cookie = cookies[i];
				break;
			}
		}
		
		if(name_cookie!=null){
			user_name = name_cookie.getValue();
		}
	}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>SOL</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="icon" href="/favicon.ico" type="image/x-icon">
<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
<script
	src="//ajax.googleapis.com/ajax/libs/jqueryui/1.9.2/jquery-ui.min.js"></script>
<script src="/bootstrap/js/bootstrap.js"></script>
<script src="/js/layout.js"></script>
<link href="<%=template_url%>" rel="stylesheet">
<link href="/css/layout.css" rel="stylesheet">
<link rel="stylesheet" href="/font/font-awesome.css">
<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
		<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
		<![endif]-->

<!-- Jquery plugins -->
<script src="/libs/flexslider/jquery.flexslider.js"></script>
<link href="/libs/flexslider/flexslider.css" rel="stylesheet">

<script src="/libs/rateit/jquery.rateit.js" type="text/javascript"></script>
<link href="/libs/rateit/rateit.css" rel="stylesheet" type="text/css">

<!-- Add fancyBox -->
<link rel="stylesheet" href="/libs/fancybox/jquery.fancybox.css?v=2.1.3"
	type="text/css" media="screen" />
<script type="text/javascript"
	src="/libs/fancybox/jquery.fancybox.pack.js?v=2.1.3"></script>

<!-- Optionally add helpers - button, thumbnail and/or media -->
<link rel="stylesheet"
	href="/libs/fancybox/helpers/jquery.fancybox-buttons.css?v=1.0.5"
	type="text/css" media="screen" />
<script type="text/javascript"
	src="/libs/fancybox/helpers/jquery.fancybox-buttons.js?v=1.0.5"></script>
<script type="text/javascript"
	src="/libs/fancybox/helpers/jquery.fancybox-media.js?v=1.0.5"></script>

<link rel="stylesheet"
	href="/libs/fancybox/helpers/jquery.fancybox-thumbs.css?v=1.0.7"
	type="text/css" media="screen" />
<script type="text/javascript"
	src="/libs/fancybox/helpers/jquery.fancybox-thumbs.js?v=1.0.7"></script>

<!-- Add Jquery validator for Boostrap -->
<script type="text/javascript"
	src="/libs/bootstrap_validator/jquery.validate.js"></script>

</head>
<body>
	<!-- Modal -->
	<div id="login-modal" class="modal hide fade" tabindex="-1">
		<div class="modal-header">
			<h3 id="myModalLabel">Login</h3>
		</div>
		<div class="modal-body">
			<div id="login-error" class="alert alert-error hide">You have
				entered an incorrect username or password!</div>
			<form id="login-form" class="form-horizontal">
				<div class="control-group">
					<label class="control-label" for="inputUsernameLogin">Username</label>
					<div class="controls">
						<input type="text" id="inputUsernameLogin"
							name="inputUsernameLogin" placeholder="Username" value="<%= user_name %>" >
					</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="inputPasswordLogin">Password</label>
					<div class="controls">
						<input type="password" id="inputPasswordLogin"
							name="inputPasswordLogin" placeholder="Password">
					</div>
				</div>
				<div class="control-group">
					<div class="controls">
						<label class="checkbox"> 
						<input type="checkbox" id="inputRemember" <% if(remember_me_check){ out.print("checked='checked'");} %>>
							Remember me
						</label>
						<button id="login-button" class="btn btn-inverse">Sign in</button>
					</div>
				</div>
			</form>
		</div>

		<div class="modal-footer"></div>
		<!-- 
			<a href='/user/recoverpasssword.jsp'>Forgot your password?</a>
		 -->
	</div>

	<div class="container-fluid">
	
		<div class="navbar" style="margin-top:1.5%">
			<div class="navbar-inner">
				<div class="container" style="width: auto">
					<a class="btn btn-navbar" data-toggle="collapse"
						data-target=".nav-collapse"> <span class="icon-bar"></span> <span
						class="icon-bar"></span> <span class="icon-bar"></span>
					</a>
					<%
						if (site != null) {
					%>

					<a class="brand" href="/"> <%=""/*site.get("Site_name").get(0)*/%>
						<img alt="Logo" src="<%=site.get("Logo_image").get(0)%>"
						style ="max-height: 25px; width: auto;height: 25px;"/>
					</a>
					<%
						}
					%>
					<div class="nav-collapse">
						<ul class="nav">
							<li class="dropdown"><a href="#" class="dropdown-toggle"
								data-toggle="dropdown"> Category <b class="caret"></b>
							</a>
								<ul class="dropdown-menu">
									<li><a href="/product/list.jsp">All</a></li>
									<%
									Map<String, List<String>> categories = CategoryAction.getCategoryMap();
									List<String> categoryNames = categories.get("Name");
									List<String> categoryIDs = categories.get("ID");
									for(int i=0;i<categoryNames.size();i++){
										out.write("<li><a href=\"/product/list.jsp?cat="+categoryIDs.get(i)+"\">"+categoryNames.get(i)+"</a></li>");
									}
									%>
								</ul></li>
							<!--<li><a href="/home/about.jsp">About Us</a></li>
							<li><a href="/home/contact.jsp">Contact</a></li>-->
							<li>
								<form method="get" action="/product/search.jsp" id="search">
									<input name="q" size="40" type="text">
								</form>
							</li>
							<!--
							<form class="navbar-search" action="/product/search.jsp">
								<div class="input-append">
									<input class="span2 search-query " placeholder="Search"
										type="text"> <span class="add-on"
										style="font-size: 16px; color: white"><i
										class="icon-search"> </i></span>
								</div>
							</form>
							-->
						</ul>
						<ul class="nav pull-right">
							<%
								//// Get current user (ID , username)
								Map<String, String> user = null;
								//// Logout
								user = UserAction.getCurrentUser(request);
								
								if (user == null) {
							%>
							<!--<li><a href="/management/login.jsp">Management</a>-->
							<li><a href="#login-modal" role="button" data-toggle="modal"
								style="outline: 0;">Login</a></li>
							<li><a href="/user/sign_up.jsp">Sign up</a></li>
							<%
								} else {

									//// Get products in cart and display # of products
									Map<String, List<String>> products = CartAction
											.getCart(session);
									int total_in_cart = 0;
									
									if (products != null) {
										total_in_cart = products.get("product_id").size();
									}
							%>
							<li>
							
							<a href="#" id="cart_link" rel="popover" data-content="
								<%if (products != null && total_in_cart > 0) {%>
								<table class='table' style='margin:1px;'><tbody>
								<%for (int i = 0; i < products.get("product_id").size(); ++i) {
								String product_id = products.get("product_id").get(i);
								String name = ProductAction.getProductName(Integer.parseInt(product_id));
								String image = "http://placehold.it/42x42";
								Map<String, List<String>> product_images = ImageAction.getImages(product_id);
								
								if(product_images!=null) {
									if(product_images.get("ID").size()>0){
										image = product_images.get("Image").get(0);
									}
								}
								
								%>
								<tr><th style='width:42px'><a href='/product?id=<%=product_id%>'><img src='<%=image%>' width='42' height='42' /></a>
								</th><th><a href='/product?id=<%=product_id%>' style='font-size:12px'><%=name%></a></th></tr>
								<%}%>
								</tbody></table>
								<%} else {%>
									<p>Your cart is empty.</p>
								<%}%>
								"
								data-original-title="<a class='btn btn-info' href='/cart'>View Details</a>"
								data-placement="bottom"><i
									class="icon-shopping-cart icon-large cart_navbar"></i><span
									class="badge badge-info cart_navbar"> <%=total_in_cart%>
								</span></a>
								
							</li>
								
								
							<li class="dropdown"><a href="#" class="dropdown-toggle"
								data-toggle="dropdown"><%=user.get("Username")%> <b
									class="caret"></b></a>
								<ul class="dropdown-menu">
									<li><a href="/user/settings.jsp">Settings</a></li>
									<li><a href="/order/list.jsp">Orders</a></li>
									<li><a href="/wishlist">Wishlist</a></li>
									<li><a href="/address">Address</a></li>
									<li><a href="/user/payment.jsp">Payment</a></li>
									<li class="divider"></li>
									<li><a href="/user/logout.jsp"> Logout</a></li>
								</ul></li>
							<%
								}
							%>


						</ul>
					</div>
					<!-- /.nav-collapse -->
				</div>
				<!-- /.container -->
			</div>
			<!-- /navbar-inner -->
		</div>
		<div class="container-fluid" style="width: 100%">