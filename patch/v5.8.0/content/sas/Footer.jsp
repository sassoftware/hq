<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="FooterBold" nowrap="nowrap" style="padding-left: 30px;" width="20%"><tiles:insert definition=".footer.current.time" /></td>
		<td class="FooterRegular" nowrap="nowrap" align="center" width="60%">
			<div id="aboutAnchor">
			  <a name="aboutLink" href="javascript:showProperDialog();"><fmt:message key="footer.HQ" /></a>
			</div>
		</td>
	</tr>
</table>

<div id="about" class="dialog" style="display: none;">
  <table cellpadding="2" cellspacing="0" border="0" width="305" id="aboutContentTable">
  	<tr>
  		<td class="DisplayLabel" rowspan="4">&nbsp;</td>
  		<td valign="top" class="DisplaySubhead" colspan="2" style="padding-top:5px;">
  			<br />
  			<fmt:message key="footer.version" /> 2.1
  		</td>
  	</tr>
  	<tr>
  		<td valign="top" class="DisplaySubhead" colspan="2" style="padding-top:5px;">
  			<br />
  			<fmt:message key="footer.builddate" /> Wednesday, November 6, 2013 22:32 PM
  			<br />&nbsp;
  		</td>
  	</tr>
  	<tr>
  		<td valign="top" class="DisplayContent" colspan="2"><span
  			class="DisplayLabel"><fmt:message key="footer.Copyright" /></span>&nbsp;<fmt:message
  			key="about.Copyright.Content" /><br />
  		<br />
  		&nbsp;<br />
  		</td>
  	</tr>
  	<tr>
  		<td valign="top" class="DisplayContent" colspan="2"><fmt:message
  			key="about.MoreInfo.Label" /><br />
  		<fmt:message key="about.MoreInfo.LinkSupport" />(
  		<html:link href="http://www.vmware.com/go/patents" target="about">
  			http://www.vmware.com/go/patents
  		</html:link>)<br />
  		&nbsp;</td>
  	</tr>
  </table>
</div>

<jsu:importScript path="/js/effects.js" />
<jsu:importScript path="/js/footer.js" />
<jsu:script>
	hqDojo.require("dijit.dijit");
  	hqDojo.require("dijit.Dialog");

  	var aboutDia = null;
	
	function showProperDialog(){
		if(document.all && navigator.userAgent.indexOf('Opera') === -1){
			var closeButton = hqDojo.query(".dijitDialogCloseIcon")[0];
			
			closeButton.attachEvent("onclick", closeDialog);
			var aboutPopupDialog = hqDojo.byId('about_popup');
			aboutPopupDialog.style.position = "absolute";
			aboutPopupDialog.style.opacity = 1;
			aboutPopupDialog.style.left = "40%";
			aboutPopupDialog.style.top = "20%";
			aboutPopupDialog.style.zIndex = 951;		
			
			hqDojo.addClass(aboutPopupDialog, "dijitDialogFocused");	
			hqDojo.addClass(aboutPopupDialog, "dijitFocused");
			hqDojo.addClass(hqDojo.byId("about_popup_title"),"dijitDialogTitle");
			var tds = hqDojo.query("td",hqDojo.byId("aboutContentTable"));
			for(var i=0; i<tds.length; i++){
				var contentTd = tds[i];
				contentTd.style.backgroundColor = "#EBEBEB";
			}
			aboutPopupDialog.show();		
		}else{
			aboutDia.show();
		}
	}

	function closeDialog(){
		hqDojo.byId('about_popup').style.display = 'none';
	}
</jsu:script>
<jsu:script onLoad="true">	
	aboutDia = new hqDijit.Dialog({
	    id: 'about_popup',
        refocus: true,
        autofocus: false,
        opacity: 0,
        title: "<fmt:message key="about.Title" />"
    }, hqDojo.byId('about'));	
  	setFoot();
</jsu:script>
<jsu:writeJs />