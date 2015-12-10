<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>

<c:if test="${useroperations['viewSubject'] || useroperations['createSubject'] || useroperations['modifySubject'] || useroperations['removeSubject'] || useroperations['viewRole'] || useroperations['createRole'] || useroperations['modifyRole'] || useroperations['removeRole']}">

<tiles:insert definition=".header.tab">
  <tiles:put name="tabKey" value="admin.home.AuthAuthZTab"/>
  <tiles:put name="icon"><html:img page="/images/group_key.gif" altKey="admin.home.AuthAuthZTab"/></tiles:put>
</tiles:insert>

<script type="text/javascript">
	function syncUsers(){ 
		if(confirm("<fmt:message key='admin.home.SyncUsers.confirm'/>")){ 
			hqDojo.xhrGet({
                url: '/admin/user/SyncUsers.do' ,
                load: function (status){
                        var json = eval("(" +status+")" );
                        var succ = json['success'];
                        var fail = json['failure'];
                        if (json['state' ] == 1){
                        	var info = "<fmt:message key='admin.home.SyncUsers.success'/>";
                        	info = info.replace("\{0}",succ).replace("\{1}",fail);
                            alert(info);
                        }else if(json['state' ] == 0){ 
                        	alert("<fmt:message key='admin.home.SyncUsers.failure'/>");
                        }else if(json['state' ] == 2){
                        	alert("<fmt:message key='admin.home.SyncUsers.nodata'/>");
                        }
                        window.location.href = "/admin/user/UserAdmin.do?mode=list" ;
                },
               	error: function (data){
                        alert( '<fmt:message key="admin.home.SyncUsers.failure"/>');
                		console.debug( "An error occurred updating control status... "); 
         		}
         	});
		}
	}
	 
</script>

<!--  GENERAL PROPERTIES CONTENTS -->
<table width="100%" cellpadding="0" cellspacing="0" border="0" class="TableBottomLine" style="margin-bottom: 24px;">
  <tr>
<c:choose>
    <c:when test="${useroperations['viewSubject'] || useroperations['createSubject'] || useroperations['modifySubject'] || useroperations['removeSubject']}">
    <td width="20%" class="BlockLabel"><fmt:message key="admin.home.Users"/></td>
    <td width="30%" class="BlockContent">
    	<html:link action="/admin/user/UserAdmin">
    		<html:param name="mode" value="list"/>
    		<fmt:message key="admin.home.ListUsers"/>
    	</html:link>
    </td>
    </c:when>
    <c:otherwise>
    <td colspan="2" class="BlockContent">&nbsp;</td>
    </c:otherwise>
</c:choose>
<c:choose>
    <c:when test="${useroperations['viewRole'] || useroperations['createRole'] || useroperations['modifyRole'] || useroperations['removeRole']}">

    <td width="20%" class="BlockLabel"><fmt:message key="admin.home.Roles"/></td>
    <td width="30%" class="BlockContent">
    	<html:link action="/admin/role/RoleAdmin">
    		<html:param name="mode" value="list"/>
    		<fmt:message key="admin.home.ListRoles"/>
    	</html:link>
    </td>
   </c:when>
    <c:otherwise>
    <td colspan="2" class="BlockContent">&nbsp;</td>
    </c:otherwise>
</c:choose>

  </tr>
  <tr>
    <td width="20%" class="BlockLabel">&nbsp;</td>
    <c:choose>
    <c:when test="${useroperations['createSubject']}">
    <td width="30%" class="BlockContent">
    	<a href="###" id="syncUsers" onclick="syncUsers();"><fmt:message key="admin.home.SyncUsers"/></a>
    	<!-- <html:link action="/admin/user/SyncUsers"> 
    		<fmt:message key="admin.home.SyncUsers"/>
    	</html:link> -->
    </td>
    </c:when>
    <c:otherwise>
    <td width="30%" class="BlockContent">&nbsp;</td>
    </c:otherwise>
    </c:choose>
    <td width="20%" class="BlockLabel">&nbsp;</td>
    <c:choose>
    <c:when test="${useroperations['createRole']}">
    <td width="30%" class="BlockContent">
    	<html:link action="/admin/role/RoleAdmin">
    		<html:param name="mode" value="new"/>
    		<fmt:message key="admin.home.NewRole"/>
    	</html:link>
    </td>
    </c:when>
    <c:otherwise>
    <td width="30%" class="BlockContent">&nbsp;</td>
    </c:otherwise>
    </c:choose>
  </tr>
</table>
<!--  /  -->
</c:if>

