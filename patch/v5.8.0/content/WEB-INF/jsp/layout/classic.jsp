<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ page import="java.util.Locale" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
		<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
		<title>
			<fmt:message>
				<tiles:insertAttribute name="title"/>
			</fmt:message>
		</title>
		<link rel="icon" href="<spring:url value="/static/images/favicon.ico" />" />
		<link rel="stylesheet" href="<spring:url value="/static/js/dojo/1.5/dojo/resources/dojo.css" />" type="text/css">
		<!--link rel="stylesheet" href="<spring:url value="/static/js/dojo/1.5/dijit/themes/tundra/tundra.css" />" type="text/css">
		<link rel="stylesheet" href="<spring:url value="/static/css/blueprint/screen.css" />" type="text/css" media="screen, projection" -->
		<link rel="stylesheet" href="<spring:url value="/static/css/blueprint/print.css" />" type="text/css" media="print">	
		<link rel="stylesheet" type="text/css" href="<spring:url value="/static/css/core/layout.css" />">
		<link rel="stylesheet" type="text/css" href="<spring:url value="/static/css/core/type.css" />">
		<link rel="stylesheet" type="text/css" href="<spring:url value="/static/css/core/theme.css" />">
		<link rel="stylesheet" type="text/css" href="<spring:url value="/static/css/xstyle/overrides.css" />">
		<link rel="stylesheet" href="<spring:url value="/css/HQ_40.css" />" type="text/css" />
		<link rel="stylesheet" href="<spring:url value="/css/win.css" />" type="text/css" />
<%
	String djLocaleString="";
	{
		Locale locale = request.getLocale();
		String reqLocaleString = locale.toString();
		
		if(reqLocaleString.equalsIgnoreCase("zh_HANS_CN")){
			locale = new Locale("zh", "CN");
		}else if(reqLocaleString.equalsIgnoreCase("zh_HANT_TW")){
			locale = new Locale("zh", "TW");
		}else if(reqLocaleString.equalsIgnoreCase("zh_HANT_HK")){
			locale = new Locale("zh", "HK");
		}else if(reqLocaleString.equalsIgnoreCase("zh_HANS")){
			locale = new Locale("zh", "CN");
		}else if(reqLocaleString.equalsIgnoreCase("zh_HANT")){
			locale = new Locale("zh", "TW");
		}
		//dojo locale must use lower case string.
		djLocaleString = locale.toString().replaceAll("_","-").toLowerCase();
	}
%>

		<script type="text/javascript">
			var djConfig = {};
			djConfig.parseOnLoad = true;
			djConfig.baseUrl = '/static/js/dojo/1.5/dojo/';
			djConfig.scopeMap = [ [ "dojo", "hqDojo" ], [ "dijit", "hqDijit" ], [ "dojox", "hqDojox" ] ];
			djConfig.locale='<%=djLocaleString%>';
		</script>
		<!--[if IE]>
		<script type="text/javascript">
			// since dojo has trouble when it comes to using relative urls + ssl, we
			// use this workaorund to provide absolute urls.
			function qualifyURL(url) {
				var a = document.createElement('img');
			    a.src = url;
			    return a.src;
			}
			
			djConfig.modulePaths = {
			    "dojo": qualifyURL("/static/js/dojo/1.5/dojo"),
			    "dijit":  qualifyURL("/static/js/dojo/1.5/dijit"),
			    "dojox":  qualifyURL("/static/js/dojo/1.5/dojox")
		  	};
		</script>
		<![endif]-->
		<script src="<spring:url value="/static/js/dojo/1.5/dojo/dojo.js" />" type="text/javascript" djConfig="parseOnLoad: true"></script>
		<script src="<spring:url value="/static/js/html5.js" />" type="text/javascript"></script>
	</head>
	<body class="tundra">
   		<div id="header">
   			<tiles:insertAttribute name="header" />
   		</div>
   		<div id="content">
			<tiles:insertAttribute name="content" />
		</div>
		<sec:authorize access="hasRole('ROLE_HQ_USER')">
			<div id="footer">
				<tiles:insertAttribute name="footer" />
			</div>
		</sec:authorize>
	</body>
</html>