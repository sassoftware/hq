                
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="org.springframework.security.cas.authentication.CasAuthenticationToken,
            org.springframework.security.core.context.SecurityContextHolder,
            org.springframework.security.core.Authentication,
            org.jasig.cas.client.validation.Assertion
           "
%>

<%
	// help link should bring up the selectedTopic=evfolderview.hlp/folder.htm
	request.setAttribute("camTitle", "folder");
	request.setAttribute("selectedTopic", "evfolderview.hlp");
%>

<html>
	<head>
		<script type="text/javascript">
			/** Set style for the Header, as style do not take effect on this page on IE**/
			function setHeaderStyle(){ 
				if(document.all){ 
					var logo = hqDojo.byId("headerLogoZ"); 
					if(logo){
						logo.className = "headerlogoZ";
					}
				}
			}
			setHeaderStyle();
		</script>
		<meta http-equiv="X-UA-Compatible" content="IE=Edge">
		<meta charset="UTF-8">
		<tiles:insert page="/common/Head.jsp"/>
		<title><fmt:message key="evm.Title"/></title>	
	    
	</head>
	<body class="tundra">
		<tiles:insert definition=".main.header"/>
		
		<script type="text/javascript">
		    	var onloads = new Array();
		    	
		    	hqDojo.ready(function() {
		      		for ( var i = 0 ; i < onloads.length ; i++ )
		        		onloads[i]();
		    	});
		    	
		    	init_reporting();
		</script>

		<script type="text/javascript">
			function handleMessage(e){
				if (e.data.id == "admappmid") {
					if (e.data.active) {
						var ping_url = hqDojo.moduleUrl("dojo", "resources/blank.gif");
						hqDojo.xhrGet({url: ping_url.toString(),preventCache: "true"});
					}
				}
			};

			if (window.addEventListener) {
				window.addEventListener("message",handleMessage,false); 
			} else if (window.attachEvent)  {
				window.attachEvent("message",handleMessage,false);
			}
		</script>
	      
	      <%
                  String url = application.getInitParameter("ModuleFrameworkURL");
              %>
                 <iframe id="VisualAnalyticsViewerLogon_iframe" src="<%=url%>" width="100%" height="100%" style="z-index:-1000"></iframe>
	  
		<tiles:insert definition=".licensing.footer"/>
		<tiles:insert page="/sas/Footer.jsp"/>
		<script type="text/javascript">			
			window.onresize = resizeCurrentFrame; //Bind function to event, so whenever the window is resized, resize the current frame accordingly

			function resizeCurrentFrame() {
				var height = window.innerHeight || document.body.clientHeight || document.documentElement.clientHeight;
				height -= 150;   // account for header and footer
				height = (height < 0) ? 0 : height;
				hqDojo.query('body table')[0].style.height="35px";
				hqDojo.query('iframe')[0].style.height=height+'px';
			}
		
			resizeCurrentFrame();
		</script>
	</body>
</html>
