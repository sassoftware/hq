<%@ page language="java" %>
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
  		<title><fmt:message key="about.Title"/></title>
		<link rel=stylesheet href="<html:rewrite page="/css/win.css"/>" type="text/css">
		<jsu:importScript path="/js/functions.js" />
		<jsu:script>
			var help = "<hq:help/>";
		</jsu:script>
	</head>

<body>
<div align="center">
<table cellpadding="0" cellspacing="0" border="0" width="305">
  <tr>
    <td rowspan="6"><html:img page="/images/spacer.gif" width="15" height="215" border="0"/></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td rowspan="6"><html:img page="/images/spacer.gif" width="15" height="215" border="0"/></td>
  </tr>
  <tr>
    <td width="1%" class="PageTitle"><html:img page="/images/spacer.gif" width="1" height="32" alt="" border="0"/></td>
    <td width="66%" class="PageTitle"><fmt:message key="about.Title"/></td>
    <td class="PageTitle" align="right"><html:link href="" onclick="window.open(help + 'About+Hyperic+HQ','SASDoc','width=800,height=650,scrollbars=yes,left=80,top=80,resizable=yes'); return false;"><html:img page="/images/title_pagehelp.gif" width="20" height="20" alt="" border="0" hspace="10"/></html:link></td>
  </tr>
  <tr>
    <td class="DisplayLabel" rowspan="3">&nbsp;</td>
    <td valign="top" class="DisplaySubhead" colspan="2"><html:img page="/images/spacer.gif" width="1" height="5" border="0"/><br>
    <fmt:message key="footer.version"/><br>&nbsp;</td>
  </tr>
  <tr>
    <td valign="top" class="DisplayContent" colspan="2"><span class="DisplayLabel"><fmt:message key="footer.Copyright"/></span><fmt:message key="about.Copyright.Content"/><br>
    <br>&nbsp;<br></td>
  </tr>
  <tr>
    <td colspan="3">&nbsp;</td>
  </td>
</table>
</div>
</body>
</html>
