<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>
<link rel="stylesheet" href="<html:rewrite page="/css/HQ_40.css"/>" type="text/css"/>
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


<%-- @param okAssignOnly a flag indicating to only display the okAssign, 
            and no ok button --%>

<tiles:importAttribute name="cancelOnly" ignore="true"/>
<tiles:importAttribute name="okAssignBtn" ignore="true"/>
<tiles:importAttribute name="okAssignOnly" ignore="true"/>
<jsu:script>
  	var isButtonClicked = false;

  	function checkSubmit() {
    	if (isButtonClicked) {
      		alert('<fmt:message key="error.PreviousRequestEtc"/>');
      		return false;
    	}
  	}  
  	
  	function triggerClick(name){
  	 var ppp_button = null ;
  	 if (document.createEventObject){
      ppp_button = document.getElementById(name);
	 }	else{
	  ppp_button = document.all[name];
	 }
	 ppp_button.click();
  	}
</jsu:script>
<!-- FORM BUTTONS -->
<table width="100%" cellpadding="0" cellspacing="0" border="0" class="buttonTable">
  <tr>
    <td colspan="2"><html:img page="/images/spacer.gif" width="1" height="10" border="0"/></td>
  </tr>
  <tr>
    <td colspan="2" class="ToolbarLine"><html:img page="/images/spacer.gif" width="1" height="1" border="0"/></td>
  </tr>
  <tr>
    <td colspan="2"><html:img page="/images/spacer.gif" width="1" height="10" border="0"/></td>
  </tr>
  <tr align=left valign=bottom>
    <td width="20%">&nbsp;</td>
    <td width="80%">
    
      <table width="100%" cellpadding="0" cellspacing="7" border="0">
        <tr>
<c:if test="${empty cancelOnly}">
 <c:if test="${empty okAssignOnly}">
          <td>
              <div style="display:none;">
                <html:image page="/images/fb_ok.gif" border="0" titleKey="FormButtons.ClickToOk" property="ok" onmouseover="imageSwap(this, imagePath + 'fb_ok', '_over');" onmouseout="imageSwap(this, imagePath +  'fb_ok', '');" onmousedown="imageSwap(this, imagePath +  'fb_ok', '_down')" onclick="checkSubmit(); isButtonClicked=true;" tabindex="11"/>
              </div>
              <input type="button" class="button42" value="<fmt:message key='button.ok'/>" onclick="triggerClick('ok')"/>
          </td>
          <td><html:img page="/images/spacer.gif" width="10" height="1" border="0"/></td>
 </c:if>
 <c:choose>
  <c:when test="${not empty okAssignBtn}">
        <td>
                <div style="display:none;">
                <html:image page="/images/${okAssignBtn}.gif" border="0" titleKey="FormButtons.ClickToAssignToRoles" 
                property="okassign" onmouseover="imageSwap(this, imagePath + '${okAssignBtn}', '_over');" 
                onmouseout="imageSwap(this, imagePath + '${okAssignBtn}', '');" 
                onmousedown="imageSwap(this, imagePath + '${okAssignBtn}', '_down')" onclick="checkSubmit(); isButtonClicked=true;" tabindex="11"/>
                </div>
                <input type="button" class="button42" value="<fmt:message key='button.ok'/>" onclick="triggerClick('okassign')"/>
        </td>
  </c:when>
  <c:otherwise>
        <td>
                <div style="display:none;">
                <html:image page="/images/fb_okassign.gif" border="0" titleKey="FormButtons.ClickToAssignToRoles" 
                property="okassign" onmouseover="imageSwap(this, imagePath + 'fb_okassign', '_over');" 
                onmouseout="imageSwap(this, imagePath + 'fb_okassign', '');" 
                onmousedown="imageSwap(this, imagePath + 'fb_okassign', '_down')" onclick="checkSubmit(); isButtonClicked=true;" tabindex="11"/>
                </div>
                <input type="button" class="button42" value="<fmt:message key='button.ok'/>" onclick="triggerClick('okassign')"/>
        </td>
  </c:otherwise>
 </c:choose>
		  <td>
		        <div style="display:none;">
		        
		        <html:image page="/images/fb_reset.gif" border="0" titleKey="FormButtons.ClickToReset" property="reset" 
                onmouseover="imageSwap(this, imagePath + 'fb_reset', '_over');" 
                onmouseout="imageSwap(this, imagePath + 'fb_reset', '');" 
                onmousedown="imageSwap(this, imagePath + 'fb_reset', '_down')" tabindex="12"/>
                </div>
                <input type="button" class="button42" value="<fmt:message key='button.reset'/>" onclick="triggerClick('reset')"/>   
                </td>
</c:if>
          <td>
          <div style="display:none;">
                <html:image page="/images/fb_cancel.gif" border="0" 
                property="cancel" />
          </div>
          <input type="button" class="button42" value="<fmt:message key='button.cancel'/>" onclick="triggerClick('cancel')"/>
          </td>
		  <td width="100%"><html:img page="/images/spacer.gif" width="1" height="1" border="0"/></td>
        </tr>
      </table>
      
    </td>
  </tr>
</table>
<!-- /  -->
