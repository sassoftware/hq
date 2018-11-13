<%@ page pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>
<%--
  NOTE: This copyright does *not* cover user programs that use HQ
  program services by normal system calls through the application
  program interfaces provided as part of the Hyperic Plug-in Development
  Kit or the Hyperic Client Development Kit - this is merely considered
  normal use of the program, and does *not* fall under the heading of
  "derived work".
  
  Copyright (C) [2004, 2005, 2006], Hyperic, Inc.
  This file is part of HQ.
  
  HQ is free software; you can redistribute it and/or modify
  it under the terms version 2 of the GNU General Public License as
  published by the Free Software Foundation. This program is distributed
  in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
  even the implied warranty of MERCHANTABILITY or FITNESS FOR A
  PARTICULAR PURPOSE. See the GNU General Public License for more
  details.
  
  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  USA.
 --%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<style type="text/css">
			.exception table {
				border: 1px solid #c6c6c6;
				background-color: #efefef;
			}
			.blockcontent {
				padding: 3px;
				background-color: #ebebeb;
			}
			.blockbottomline {
				height: 1px;
				padding: 0;
			}
			.blocktitle {
				/* border-top: 1px solid #c6c6c6;
				border-bottom: 1px solid #c6c6c6;
				*/
				background-color: #dadada; 
				background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#fafafa), to(#cacaca));
				background-image: -webkit-linear-gradient(top, #fafafa, #cacaca); 
				background-image:    -moz-linear-gradient(top, #fafafa, #cacaca);
				background-image:     -ms-linear-gradient(top, #fafafa, #cacaca);
				background-image:      -o-linear-gradient(top, #fafafa, #cacaca);
			}
		</style>
		<title><fmt:message key="securityAlert.SecurityAlert.Title"/></title>
		<link rel=stylesheet href="<html:rewrite page="/css/win.css"/>" type="text/css" />
		<jsu:importScript path="/js/functions.js" />
		<jsu:script>
			var help = "<hq:help/>";	
		</jsu:script>
		
		<script type="text/javascript">
			function logout(){
				window.parent.location.href="/j_spring_security_logout";
			}
		</script>
	</head>
<body class="exception">
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<div align="center">
<table border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td class="blocktitle" width="100%" align="left">&nbsp;<fmt:message key="securityAlert.LogonError.Title" /></td>
        </tr>
      </table>	
    </td>
  </tr>
	<tr>
	  <td class="blockcontent" colspan="2" align="left">
		<p>
		<fmt:message key="securityAlert.LogonError.Head" />
		<br/>
		<br/>-&nbsp;<fmt:message key="securityAlert.LogonError.noGroups" />
		<br/>-&nbsp;<fmt:message key="securityAlert.LogonError.faultURL" />
		<br/>-&nbsp;<fmt:message key="securityAlert.LogonError.initialData" />
		<br/>-&nbsp;<fmt:message key="securityAlert.LogonError.sslSpecify" />
		<br/><br/>
		<fmt:message key="securityAlert.LogonError.requireSupport" />
		</p>
		
		<p align="left">
		<fmt:message key="securityAlert.ReturnToLogout"/>
		</p>
	  </td>
	</tr>
      <tr>
        <td class="blockcontent" colspan="2"><html:img page="/images/spacer.gif" width="1" height="5" alt="" border="0"/></td>
      </tr>
      <tr>
        <td class="blockbottomline" colspan="2"><html:img page="/images/spacer.gif" width="1" height="1" alt="" border="0"/></td>
      </tr>
    </table>
    </td>
   </tr>
  </table>
</div>
</body>
</html>
