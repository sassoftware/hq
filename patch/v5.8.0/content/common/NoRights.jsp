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
		<title><fmt:message key="securityAlert.SecurityAlert.Title"/></title>
		<link rel=stylesheet href="<html:rewrite page="/css/win.css"/>" type="text/css">
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
<table width="400" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td class="BlockTitle" width="100%" align="left">&nbsp;<fmt:message key="securityAlert.SecurityAlert.Tab"/></td>
        </tr>
      </table>	
    </td>
  </tr>
    <tr>
      <td class="BlockContent" colspan="2" align="left">
        <p>
        <fmt:message key="securityAlert.AccessibleGroups"/> 
        <br/>
        <br/>*&nbsp;<fmt:message key="securityAlert.EVSuperUserGroup"/>
        <br/>*&nbsp;<fmt:message key="securityAlert.EVGuestGroup"/>
        <br/>*&nbsp;<fmt:message key="securityAlert.EVAppServerTierGroup"/>
        <br/><br/>
        <fmt:message key="securityAlert.GroupManagedGuide"/>         
        </p>
        
        <p align="left">
        <fmt:message key="securityAlert.ReturnToLogout"/>
        </p>
      </td>
    </tr>
      <tr>
        <td class="BlockContent" colspan="2"><html:img page="/images/spacer.gif" width="1" height="5" alt="" border="0"/></td>
      </tr>
      <tr>
        <td class="BlockBottomLine" colspan="2"><html:img page="/images/spacer.gif" width="1" height="1" alt="" border="0"/></td>
      </tr>
    </table>
    </td>
   </tr>
  </table>
</div>
</body>
</html>
