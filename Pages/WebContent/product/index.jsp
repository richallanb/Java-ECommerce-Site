<%@ page import="Action.*"%>
<%@ page import="XML.*" %>
<%@ page import="XML.XMLParser.DisplayType" %>
<%@ page import="XML.XMLParser.XMLType" %>
<%@ page import="Action.ProductAction"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="org.jdom2.Document"%>
<%@ page import="org.jdom2.Element"%>
<%@ page import="org.jdom2.Attribute"%>
<%
	/*
Modified layout. I like this look. Leave it.
 
*/
	/// Important , get product id in url  /product?id=343 , if not specified, redirect to homepage
	String product_id = request.getParameter("id");
	String category_id = Integer.toString(ProductAction.getCategoryID(Integer.parseInt(product_id)));
	String category_name = CategoryAction.getCategoryName(Integer.parseInt(category_id));
	String product_name = ProductAction.getProductName(Integer.parseInt(product_id));
	String product_price = ProductAction.toPrice(ProductAction.getProductPrice(Integer.parseInt(product_id)));
	String product_price_full = ProductAction.getProductPrice(Integer.parseInt(product_id));
	Map<String, String> user = UserAction.getCurrentUser(request);
	if(product_id==null || product_id.length()==0 || product_name==null){
		response.sendRedirect("/");  
		// Will redirect user to home page if product id is not specified.
	}
	
	/// Adding reviews
	if(request.getMethod().equals("POST")){
		
		
		if(user!=null){
			String comment = request.getParameter("comment");
			String rating = request.getParameter("rating");
	
			if(product_id!=null && comment!=null && rating!=null && user != null){
				ReviewAction.addReview(user.get("ID"), product_id, comment, rating);
			}
		}
	}
	
	//// Displaying reviews
	Map<String, List<String>> product_reviews = ReviewAction.getByProductId(product_id);

	//// Get product images
	Map<String, List<String>> product_images = ImageAction.getImages(product_id);
	
	// Get Product XML Description
	Document prodInfo_XML = ProductAction.getXMLDocumentByID(Integer.parseInt(product_id));
	
	
	//System.out.println(prodInfo_XML);
	// Get Category XML Description (contains properties & types)
	Document catInfo_XML = CategoryAction.getXMLDocumentByID(Integer.parseInt(category_id));
	Map<XMLType, List<String>> XMLMap = XMLParser.ParseXMLDocumentToHTML(prodInfo_XML, catInfo_XML, DisplayType.all);
	//System.out.println(catInfo_XML);
	
%>

<jsp:include page="/layout/header.jsp" flush="true" />
<script type="text/javascript" src="/js/product.js"></script>
<link href="/css/product.css" rel="stylesheet" type="text/css">

<div class='row-fluid'>
	<!--  <div class='span3' style="width: 180px"> -->
	<div class='span8 offset2 well'>
		<h3><% if (product_name != null)
					out.print(product_name);
				else
					out.print("Invalid Product!");
			%></h3>
		<div class='row-fluid'>
		
			<div class='span6'>
			
			<div id="slider" class="flexslider" style="width:100%">
				<ul class="slides">
					<%
						if(product_images!=null) {
							if (product_images.get("ID").size()>0) {
						
							for (int i = 0; i < product_images.get("ID").size(); ++i) {
								String url = product_images.get("Image").get(i);
					
								out.print("<li><img src=\""+ url + "\" alt=\"thumb-nail\" height=\"380\"></li>");
					
							}
						
					
							}else{
					%>
					
						<li><img src="http://placehold.it/380x380" alt="thumb-nail"></li>
						<li><img src="http://placehold.it/380x380" alt="thumb-nail"></li>
						<li><img src="http://placehold.it/380x380" alt="thumb-nail"></li>
					
					<%
							}
						}
					
					%>
					</ul>
				</div>

					<%
					if(product_images!=null) {
						if (product_images.get("ID").size()>1) {
					%>
					<div id="carousel" class="flexslider">
						<ul class="slides">
						<%
							for (int i = 0; i < product_images.get("ID").size()+1; ++i) {
								String url = product_images.get("Image").get(0);
						
								out.print("<li><img src=\""+ url + "\" alt=\"thumb-nail\"></li>");
						
							}
						%>
						</ul>
					</div>
					<%
						}else if (product_images.get("ID").size()!=1){
					%>
					<div id="carousel" class="flexslider">
						<ul class="slides">
						<li><img src="http://placehold.it/70x70" alt="thumb-nail"></li>
						<li><img src="http://placehold.it/70x70" alt="thumb-nail"></li>
						<li><img src="http://placehold.it/70x70" alt="thumb-nail"></li>
						</ul>
					</div>
					<%
						}
					}
					%>
					
					<div>Tags: 
					<%
					for (int x=0; x < XMLMap.get(XMLType.tag).size(); x++ ){
						out.print("<a href=\"#\"><span class=\"label\">");
						out.print(XMLMap.get(XMLType.tag).get(x));
						out.print("</span></a>");
					}
					%>
					</div>
				</div>
				<div class="span6">
							 
					
			
			
			
					<h5>Category: <% if (category_name != null)
										out.print(category_name.trim());
									else
										out.print("Invalid Category!");
									%></h5>
					<h5>Price: $<% if (product_price != null)
										out.print(product_price.trim());
									else
										out.print("Invalid Product!");
									%></h5>
					<div class="alert alert-info"><h5><%=XMLMap.get(XMLType.description).get(0)%></h5>
					<p><%=XMLMap.get(XMLType.description).get(1) %>
					</div>
					
					
					
						<div>
						<form class="" action="/cart/index.jsp" method="post">
						<div class="control-group">
							<label for="quantity" class="control-label"><strong>Quantity: </strong></label>
							<div class="controls">
								<input type="number"
									name="quantity" min="1" max="100" value="1" class="input-small"> <input
									type="hidden" name="product_id" value="<%=product_id %>" /> <input type="hidden"
									name="title" value="<%=product_name %>" /> <input
									type="hidden" name="price" value="<%=product_price_full %>" /> <input type="hidden"
									name="image" value="/img/avatar.png" />
							</div>
							</div>
							<div>
							<div class="control-group">
							<div class="controls">
							<button type="submit" class="btn">
								Add to cart <i class='icon-shopping-cart'></i>
							</button>
							</div>
							</div>
						</form>
						
						<form action="/wishlist/index.jsp" method="post" >
								<input type="hidden" name="wishlist_product_id" value="<%=product_id %>" />
								<div class="control-group">
							<div class="controls">
								<button type="submit" class="btn">
									Add to wishlist <i class='icon-star'></i>
								</button>
								</div>
							</div>
						</form>
						
						</div>
					</div>
				</div>
	   </div>
	   <p><p>
	   <div class='row-fluid'>
	   <div>
	   		<div class="tabbable"> <!-- Only required for left/right tabs -->
		 		 <ul class="nav nav-tabs">
		   			<li class="active"><a href="#tab-info" data-toggle="tab">Product Info</a></li>
		   			<%
		   				XMLType xmltypes[] = XMLType.values();
						
	   					for (int x=0; x < xmltypes.length; x++) {
	   						if (xmltypes[x] != XMLType.text && xmltypes[x] != XMLType.description 
	   								&& xmltypes[x] != XMLType.tag) {
	   							if (XMLMap.get(xmltypes[x]).size() > 0)
	   				      				out.print("<li><a href=\"#tab-"+ XMLMap.get(xmltypes[x]).get(0) +"\" data-toggle=\"tab\">" + XMLMap.get(xmltypes[x]).get(0) + "</a></li>");
	   							
	   						}
	   					}
		   			
		   			%>
	
				  </ul>
				  <div class="tab-content">
		    		<div class="tab-pane active" id="tab-info">
		      		<p>
		      		<%
		      		for (int x=0; x < XMLMap.get(XMLType.text).size(); x++) {
		      			if ((x+1)%2==1)
		      				out.print("<h5>" + XMLMap.get(XMLType.text).get(x) + "</h5>");
		      			else {
		      				out.print("<p>");
		      				out.print(XMLMap.get(XMLType.text).get(x));
		      				out.print("</p>");
		      			}
		      		}
		      		%>
		      		</p>
		    		</div>
		    		<%
		   			
	   					for (int x=0; x < xmltypes.length; x++) {
	   						if (xmltypes[x] != XMLType.text && xmltypes[x] != XMLType.description 
	   								&& xmltypes[x] != XMLType.tag) {
	   							if (XMLMap.get(xmltypes[x]).size() > 0){
	   								out.print("<div class=\"tab-pane\" id=\"tab-"+ XMLMap.get(xmltypes[x]).get(0) +"\">");
	   								if (xmltypes[x]== XMLType.list)
	   									out.println("<ul>");
	   								else if (xmltypes[x]== XMLType.list_numbered)
	   									out.println("<ol>");
	   								
	   								for (int y = 1; y < XMLMap.get(xmltypes[x]).size(); y++) {
	   								if (xmltypes[x]== XMLType.list)
	   				      					out.print("<li>" + XMLMap.get(xmltypes[x]).get(y) + "</li>");
	   								else if (xmltypes[x]== XMLType.list_numbered)
	   									out.print("<li>" + XMLMap.get(xmltypes[x]).get(y) + "</li>");
	   								}
	   								
	   								if (xmltypes[x]== XMLType.list)
	   									out.println("</ul>");
	   								if (xmltypes[x]== XMLType.list)
	   									out.println("</ol>");
	   								out.print("</div>");
	   							}
	   						}
	   					}
		   			
		   			%>
		    		</div>
	  			</div>
			</div>
		</div>
		
		<hr style='margin: 5px 0;'>
		<div class='row-fluid'>
			<div class='span12'>
				<h4>Reviews</h4>
				<%
					if(product_reviews!=null) {
						if (product_reviews.get("ID").size()>0) {
				%>
				
				<ul id="content_pagination" class="clearfix">
					<%
						for (int i = 0; i < product_reviews.get("ID").size(); ++i) {
																			String rating = product_reviews.get("Rating").get(i);
																			String comment = product_reviews.get("Comment").get(i);
																			String username = UserAction.getUsernameById(product_reviews.get("User_ID").get(i));
																			String user_id = product_reviews.get("User_ID").get(i);
																			String date = product_reviews.get("Review_date").get(i);
																			
																			//SimpleDateFormat sdf =  new SimpleDateFormat("MM/dd/yyyy");
																			//String time = sdf.format (date );
					%>
					<li>
						<div>
							<a href="/user?id=<%=user_id%>"><%=username%></a>&nbsp; rated
							&nbsp;
							<div class="rateit" data-rateit-value="<%=rating%>"
								data-rateit-ispreset="true" data-rateit-readonly="true"></div>
							&nbsp;on&nbsp; <span><%=date%></span>
						</div>
						<p class="product-review"><%=comment%></p>
					</li>
					<%
						}
					%>
				</ul>
				
				<div class="pagination pagination-centered">
					<ul id='page_navigation'>
					
					</ul>
				</div>
				
    			<input type='hidden' id='current_page' />
    			<input type='hidden' id='show_per_page' />
    			
				<%
					}else{
				%>

				<p>There is no reviews for this product</p>

				<%
					}
					}else{
						%>
						<p>There is no reviews for this product</p>
						<%
						
					}
				%>


			</div>
		</div>
		<hr style='margin: 5px 0;'>

		<div class='row-fluid'>
			<div class='span12'>
				<%
					
													if(user!=null) {
				%>
				<h4>Your review</h4>
				<form class="form-horizontal" method="post">
					<div class="control-group">
						<label class="control-label" for="inputRate">Rate</label> <input
							type="hidden" name="rating" id="rating_hidden">
						<div class="controls">
							<div id="rating-setter" class="rateit"></div>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label" for="inputReview">Review</label>
						<div class="controls">
							<textarea id="comment" name="comment" class="span5" rows="4" cols="30" style="width: 100%;"></textarea>
						</div>
					</div>

					<div class="control-group">
						<div class="controls">
							<button id="submit_review_btn" type="submit"
								class="btn btn-primary">Submit</button>
						</div>
					</div>

				</form>

				<%
					} else {
				%>
				<p>You need to login before comment</p>
				<%
					}
				%>

			</div>

		</div>

	</div>
</div>

<style type="text/css">
#carousel {
	overflow: hidden;
	margin-bottom: 20px;
}

#carousel li {
	margin-right: 5px;
}

#slider {
	margin-bottom: 10px;
	overflow: hidden;
}
</style>

<script type="text/javascript">
	$(function() {
		$('#carousel').flexslider({
			animation : "slide",
			controlNav : false,
			animationLoop : false,
			slideshow : false,
			itemWidth : 70,
			itemMargin : 1,
			asNavFor : '#slider'
		});

		$('#slider').flexslider({
			animation : "slide",
			controlNav : false,
			animationLoop : false,
			slideshow : false,
			sync : "#carousel"
		});
	});

	if ($('#rating-setter').children()) {
		$('#rating-setter').rateit({
			max : 5,
			step : 1,
			backingfld : '#rating_hidden'
		});
	}
</script>

<jsp:include page="/layout/footer.jsp" flush="true" />