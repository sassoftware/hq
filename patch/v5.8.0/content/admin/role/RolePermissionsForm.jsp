<%@ page language="java"%>
<%@ page errorPage="/common/Error.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>

<tiles:importAttribute name="mode" ignore="true" />

<tiles:insert definition=".header.tab">
  <tiles:put name="tabKey" value="admin.role.perms.PermissionsTab"/>
</tiles:insert>

<table class="BlockBg" width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr class="ListHeader">
		<td class="resourceTypeColumn">
			<fmt:message key="admin.role.perms.ResourceTypeTH" />
		</td>
		<td class="permissionColumn">
			<fmt:message key="admin.role.permissions.header" />
		</td>
		<td class="capabilitiesColumn" colspan="2">
			<fmt:message key="admin.role.capabilities.header" />
		</td>
	</tr>
	<tr>
		<td class="resourceTypeColumn bottomBorder">
			<fmt:message key="admin.role.perms.type.users" />
		</td>
		<td class="permissionColumn bottomBorder">
			<c:choose>
				<c:when test="${mode eq 'view'}">
					<span><fmt:message key="${RoleForm.userPermission.permissionLabel}" /></span>				
				</c:when>
				<c:otherwise>
					<html:select styleId="userPermissionSelect" property="userPermission.permissionCode">
						<c:forEach var="selectOption" items="${RoleForm.availablePermissions}">
							<html:option key="${selectOption.label}" value="${selectOption.value}" />
						</c:forEach>
					</html:select>
				</c:otherwise>
			</c:choose>
		</td>
		<td class="capabilitiesColumn bottomBorder" colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td class="resourceTypeColumn bottomBorder">
			<fmt:message key="admin.role.perms.type.roles" />
		</td>
		<td class="permissionColumn bottomBorder">
			<c:choose>
				<c:when test="${mode eq 'view'}">
					<span><fmt:message key="${RoleForm.rolePermission.permissionLabel}" /></span>				
				</c:when>
				<c:otherwise>
					<html:select styleId="rolePermissionSelect" property="rolePermission.permissionCode">
						<c:forEach var="selectOption" items="${RoleForm.availablePermissions}">
							<html:option key="${selectOption.label}" value="${selectOption.value}" />
						</c:forEach>
					</html:select>
				</c:otherwise>
			</c:choose>
		</td>
		<td class="capabilitiesColumn bottomBorder" colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td class="resourceTypeColumn bottomBorder">
			<fmt:message key="admin.role.perms.type.groups" />			
		</td>
		<td class="permissionColumn bottomBorder">
			<c:choose>
				<c:when test="${mode eq 'view'}">
					<span><fmt:message key="${RoleForm.groupPermission.permissionLabel}" /></span>				
				</c:when>
				<c:otherwise>
					<html:select styleId="groupPermissionSelect" property="groupPermission.permissionCode">
						<c:forEach var="selectOption" items="${RoleForm.availablePermissions}">
							<html:option key="${selectOption.label}" value="${selectOption.value}" />
						</c:forEach>
					</html:select>
				</c:otherwise>
			</c:choose>
		</td>
		<td class="capabilitiesColumn bottomBorder" colspan="2">
			<fmt:message key="admin.role.capabilities.alert" />
			<c:choose>
				<c:when test="${mode eq 'view'}">
					<c:choose>
						<c:when test="${RoleForm.groupPermission.alertCapabilityValue}">
							<html:img src="/images/permission_enabled.gif" />
						</c:when>
						<c:otherwise>
							<html:img src="/images/permission_disabled.gif" />
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<html:multibox styleId="groupAlertCheckbox" property="groupPermission.alertCapabilityValue" value="true" />
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
	<tr>
		<td class="resourceTypeColumn bottomBorder">
			<fmt:message key="admin.role.perms.type.platforms" />
		</td>
		<td class="permissionColumn bottomBorder">
			<c:choose>
				<c:when test="${mode eq 'view'}">
					<span><fmt:message key="${RoleForm.platformPermission.permissionLabel}" /></span>				
				</c:when>
				<c:otherwise>
					<html:select styleId="platformPermissionSelect" property="platformPermission.permissionCode">
						<c:forEach var="selectOption" items="${RoleForm.availablePermissions}">
							<html:option key="${selectOption.label}" value="${selectOption.value}" />
						</c:forEach>
					</html:select>
				</c:otherwise>
			</c:choose>
		</td>
		<td class="capabilitiesColumn alertCapability bottomBorder">
			<fmt:message key="admin.role.capabilities.alert" />
			<c:choose>
				<c:when test="${mode eq 'view'}">
					<c:choose>
						<c:when test="${RoleForm.platformPermission.alertCapabilityValue}">
							<html:img src="/images/permission_enabled.gif" />
						</c:when>
						<c:otherwise>
							<html:img src="/images/permission_disabled.gif" />
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<html:multibox styleId="platformAlertCheckbox" property="platformPermission.alertCapabilityValue" value="true" />
				</c:otherwise>
			</c:choose>
		</td>
		<td class="capabilitiesColumn controlCapability bottomBorder">
			<fmt:message key="admin.role.capabilities.control" />
			<c:choose>
				<c:when test="${mode eq 'view'}">
					<c:choose>
						<c:when test="${RoleForm.platformPermission.controlCapabilityValue}">
							<html:img src="/images/permission_enabled.gif" />
						</c:when>
						<c:otherwise>
							<html:img src="/images/permission_disabled.gif" />
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<html:multibox styleId="platformControlCheckbox" property="platformPermission.controlCapabilityValue" value="true" />
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
	<tr>
		<td class="resourceTypeColumn bottomBorder">
			<fmt:message key="admin.role.perms.type.servers" />
		</td>
		<td class="permissionColumn bottomBorder">
			<c:choose>
				<c:when test="${mode eq 'view'}">
					<span><fmt:message key="${RoleForm.serverPermission.permissionLabel}" /></span>				
				</c:when>
				<c:otherwise>
					<html:select styleId="serverPermissionSelect" property="serverPermission.permissionCode">
						<c:forEach var="selectOption" items="${RoleForm.availablePermissions}">
							<html:option key="${selectOption.label}" value="${selectOption.value}" />
						</c:forEach>
					</html:select>
				</c:otherwise>
			</c:choose>
		</td>
		<td class="capabilitiesColumn alertCapability bottomBorder">
			<fmt:message key="admin.role.capabilities.alert" />
			<c:choose>
				<c:when test="${mode eq 'view'}">
					<c:choose>
						<c:when test="${RoleForm.serverPermission.alertCapabilityValue}">
							<html:img src="/images/permission_enabled.gif" />
						</c:when>
						<c:otherwise>
							<html:img src="/images/permission_disabled.gif" />
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<html:multibox styleId="serverAlertCheckbox" property="serverPermission.alertCapabilityValue" value="true" />
				</c:otherwise>
			</c:choose>
		</td>
		<td  class="capabilitiesColumn controlCapability bottomBorder">
			<fmt:message key="admin.role.capabilities.control" />
			<c:choose>
				<c:when test="${mode eq 'view'}">
					<c:choose>
						<c:when test="${RoleForm.serverPermission.controlCapabilityValue}">
							<html:img src="/images/permission_enabled.gif" />
						</c:when>
						<c:otherwise>
							<html:img src="/images/permission_disabled.gif" />
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<html:multibox styleId="serverControlCheckbox" property="serverPermission.controlCapabilityValue" value="true" />
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
	<tr>
		<td class="resourceTypeColumn bottomBorder">
			<fmt:message key="admin.role.perms.type.services" />
		</td>
		<td class="permissionColumn bottomBorder">
			<c:choose>
				<c:when test="${mode eq 'view'}">
					<span><fmt:message key="${RoleForm.servicePermission.permissionLabel}" /></span>				
				</c:when>
				<c:otherwise>
					<html:select styleId="servicePermissionSelect" property="servicePermission.permissionCode">
						<c:forEach var="selectOption" items="${RoleForm.availablePermissions}">
							<html:option key="${selectOption.label}" value="${selectOption.value}" />
						</c:forEach>
					</html:select>
				</c:otherwise>
			</c:choose>
		</td>
		<td class="capabilitiesColumn alertCapability bottomBorder">
			<fmt:message key="admin.role.capabilities.alert" />
			<c:choose>
				<c:when test="${mode eq 'view'}">
					<c:choose>
						<c:when test="${RoleForm.servicePermission.alertCapabilityValue}">
							<html:img src="/images/permission_enabled.gif" />
						</c:when>
						<c:otherwise>
							<html:img src="/images/permission_disabled.gif" />
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<html:multibox styleId="serviceAlertCheckbox" property="servicePermission.alertCapabilityValue" value="true" />
				</c:otherwise>
			</c:choose>
		</td>
		<td class="capabilitiesColumn controlCapability bottomBorder">
			<fmt:message key="admin.role.capabilities.control" />
			<c:choose>
				<c:when test="${mode eq 'view'}">
					<c:choose>
						<c:when test="${RoleForm.servicePermission.controlCapabilityValue}">
							<html:img src="/images/permission_enabled.gif" />
						</c:when>
						<c:otherwise>
							<html:img src="/images/permission_disabled.gif" />
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<html:multibox styleId="serviceControlCheckbox" property="servicePermission.controlCapabilityValue" value="true" />
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
	<tr>
		<td class="resourceTypeColumn bottomBorder">
			<fmt:message key="admin.role.perms.type.applications" />
		</td>
		<td class="permissionColumn bottomBorder">
			<c:choose>
				<c:when test="${mode eq 'view'}">
					<span><fmt:message key="${RoleForm.applicationPermission.permissionLabel}" /></span>				
				</c:when>
				<c:otherwise>
					<html:select styleId="applicationPermissionSelect" property="applicationPermission.permissionCode">
						<c:forEach var="selectOption" items="${RoleForm.availablePermissions}">
							<html:option key="${selectOption.label}" value="${selectOption.value}" />
						</c:forEach>
					</html:select>
				</c:otherwise>
			</c:choose>
		</td>
		<td class="capabilitiesColumn bottomBorder" colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td class="resourceTypeColumn bottomBorder">
			<fmt:message key="admin.role.perms.type.escalations" />
		</td>
		<td class="permissionColumn bottomBorder">
			<c:choose>
				<c:when test="${mode eq 'view'}">
					<span><fmt:message key="${RoleForm.escalationPermission.permissionLabel}" /></span>				
				</c:when>
				<c:otherwise>
					<html:select styleId="escalationPermissionSelect" property="escalationPermission.permissionCode">
						<c:forEach var="selectOption" items="${RoleForm.availablePermissions}">
							<c:if test="${selectOption.value > 0}">
								<html:option key="${selectOption.label}" value="${selectOption.value}" />							
							</c:if>
						</c:forEach>
					</html:select>
				</c:otherwise>
			</c:choose>
		</td>
		<td class="capabilitiesColumn bottomBorder" colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td class="resourceTypeColumn bottomBorder">
			<fmt:message key="admin.role.perms.type.policies" />
        </td>
        <td class="permissionColumn bottomBorder">
            <c:choose>
               	<c:when test="${mode eq 'view'}">
        	       <span><fmt:message key="${RoleForm.policyPermission.permissionLabel}" /></span>
               	</c:when>
               	<c:otherwise>
                   	<html:select styleId="policyPermissionSelect" property="policyPermission.permissionCode">
                       	<c:forEach var="selectOption" items="${RoleForm.availablePermissions}">
                           	<html:option key="${selectOption.label}" value="${selectOption.value}" />
                       	</c:forEach>
                   	</html:select>
               	</c:otherwise>
           </c:choose>
        </td>
        <td class="capabilitiesColumn bottomBorder" colspan="2">&nbsp;</td>
   </tr>
	<tr>
		<td colspan="4" class="resourceTypeColumn" style="padding-bottom:8px;">
			<span><fmt:message key="admin.role.perms.type.groups.note" /></span>
		</td>
	</tr>
</table>
<c:if test="${mode ne 'view'}">
	<hq:constant classname="org.hyperic.hq.authz.shared.ResourceOperationsHelper" 
	             symbol="NO_PERMISSIONS" var="noPermissionCode"/>
	<hq:constant classname="org.hyperic.hq.authz.shared.ResourceOperationsHelper" 
	             symbol="READ_ONLY_PERMISSION" var="readOnlyPermissionCode"/>
	<hq:constant classname="org.hyperic.hq.authz.shared.ResourceOperationsHelper" 
	             symbol="READ_WRITE_PERMISSIONS" var="readWritePermissionCode"/>
	<hq:constant classname="org.hyperic.hq.authz.shared.ResourceOperationsHelper" 
	             symbol="FULL_PERMISSIONS" var="fullPermissionCode"/>

<jsu:script>
		var lookup = {
			'<c:out value="${noPermissionCode}" />' : 0,
			'<c:out value="${readOnlyPermissionCode}" />' : 1,
			'<c:out value="${readWritePermissionCode}" />' : 2,
			'<c:out value="${fullPermissionCode}" />' : 3
		};

		function applyPermissionRules(selectInputId) {
			var platformSelect = hqDojo.byId("platformPermissionSelect");
			var serverSelect = hqDojo.byId("serverPermissionSelect");
			var serviceSelect = hqDojo.byId("servicePermissionSelect");
			var userSelect = hqDojo.byId("userPermissionSelect");
			var roleSelect = hqDojo.byId("rolePermissionSelect");
			var groupSelect = hqDojo.byId("groupPermissionSelect");
			
			if (selectInputId == "platformPermissionSelect") { 
				if (platformSelect.options[platformSelect.selectedIndex].value == <c:out value="${fullPermissionCode}" />) {
					serverSelect.options[lookup['<c:out value="${fullPermissionCode}" />']].selected = true;
					updateCapabilities("serverPermissionSelect", [ "serverAlertCheckbox", "serverControlCheckbox" ]);
				} else if ((platformSelect.options[platformSelect.selectedIndex].value == <c:out value="${noPermissionCode}" />) && 
						     (serverSelect.options[serverSelect.selectedIndex].value == <c:out value="${fullPermissionCode}" />)) {
					serverSelect.options[lookup['<c:out value="${readWritePermissionCode}" />']].selected = true;
					updateCapabilities("serverPermissionSelect", [ "serverAlertCheckbox", "serverControlCheckbox" ]);					
				}
				
				applyPermissionRules("serverPermissionSelect");
		   } else if (selectInputId == "serverPermissionSelect") { 
				if (serverSelect.options[serverSelect.selectedIndex].value == <c:out value="${fullPermissionCode}" />) {
					serviceSelect.options[lookup['<c:out value="${fullPermissionCode}" />']].selected = true;
				
					if (platformSelect.options[platformSelect.selectedIndex].value == <c:out value="${noPermissionCode}" />) {
						platformSelect.options[lookup['<c:out value="${readOnlyPermissionCode}" />']].selected = true;
						updateCapabilities("platformPermissionSelect", [ "platformAlertCheckbox", "platformControlCheckbox" ]);
					}

					updateCapabilities("servicePermissionSelect", [ "serviceAlertCheckbox", "serviceControlCheckbox" ]);
				} else if (((platformSelect.options[platformSelect.selectedIndex].value == <c:out value="${noPermissionCode}" />) ||
						      (serverSelect.options[serverSelect.selectedIndex].value == <c:out value="${noPermissionCode}" />)) &&
							  (serviceSelect.options[serviceSelect.selectedIndex].value == <c:out value="${fullPermissionCode}" />)) {
					serviceSelect.options[lookup['<c:out value="${readWritePermissionCode}" />']].selected = true;
					updateCapabilities("servicePermissionSelect", [ "serviceAlertCheckbox", "serviceControlCheckbox" ]);
				}

				if ((serverSelect.options[serverSelect.selectedIndex].value != <c:out value="${fullPermissionCode}" />) && 
					 (platformSelect.options[platformSelect.selectedIndex].value == <c:out value="${fullPermissionCode}" />)) {
					platformSelect.options[lookup['<c:out value="${readWritePermissionCode}" />']].selected = true;
					updateCapabilities("platformPermissionSelect", [ "platformAlertCheckbox", "platformControlCheckbox" ]);
				}

				applyPermissionRules("servicePermissionSelect");
			} else if (selectInputId == "servicePermissionSelect") {
				if (serviceSelect.options[serviceSelect.selectedIndex].value == <c:out value="${fullPermissionCode}" />) {
					if (serverSelect.options[serverSelect.selectedIndex].value == <c:out value="${noPermissionCode}" />) {
						serverSelect.options[lookup['<c:out value="${readOnlyPermissionCode}" />']].selected = true;
						updateCapabilities("serverPermissionSelect", [ "serverAlertCheckbox", "serverControlCheckbox" ]);
					}

					if (platformSelect.options[platformSelect.selectedIndex].value == <c:out value="${noPermissionCode}" />) {
						platformSelect.options[lookup['<c:out value="${readOnlyPermissionCode}" />']].selected = true;
						updateCapabilities("platformPermissionSelect", [ "platformAlertCheckbox", "platformControlCheckbox" ]);
					}
				} else if (serviceSelect.options[serviceSelect.selectedIndex].value != <c:out value="${fullPermissionCode}" />) {
					if (serverSelect.options[serverSelect.selectedIndex].value == <c:out value="${fullPermissionCode}" />) {
						serverSelect.options[lookup['<c:out value="${readWritePermissionCode}" />']].selected = true;
						updateCapabilities("serverPermissionSelect", [ "serverAlertCheckbox", "serverControlCheckbox" ]);
					}

					if (platformSelect.options[platformSelect.selectedIndex].value == <c:out value="${fullPermissionCode}" />) {
						platformSelect.options[lookup['<c:out value="${readWritePermissionCode}" />']].selected = true;
						updateCapabilities("platformPermissionSelect", [ "platformAlertCheckbox", "platformControlCheckbox" ]);
					}
				}
			} else if (selectInputId == "userPermissionSelect") {
				if (userSelect.options[userSelect.selectedIndex].value == <c:out value="${fullPermissionCode}" /> || 
					 userSelect.options[userSelect.selectedIndex].value == <c:out value="${readWritePermissionCode}" />) {
					if (roleSelect.options[roleSelect.selectedIndex].value == <c:out value="${noPermissionCode}" />) {
						roleSelect.options[lookup['<c:out value="${readOnlyPermissionCode}" />']].selected = true;
					}
				} else if (userSelect.options[userSelect.selectedIndex].value == <c:out value="${noPermissionCode}" />) {
					if (roleSelect.options[roleSelect.selectedIndex].value == <c:out value="${fullPermissionCode}" />) {
						roleSelect.options[lookup['<c:out value="${readWritePermissionCode}" />']].selected = true;
					}
				}
			} else if (selectInputId == "rolePermissionSelect") {
				if (roleSelect.options[roleSelect.selectedIndex].value == <c:out value="${fullPermissionCode}" /> ||
					 roleSelect.options[roleSelect.selectedIndex].value == <c:out value="${readWritePermissionCode}" />) {
					if (userSelect.options[userSelect.selectedIndex].value == <c:out value="${noPermissionCode}" />) {
						userSelect.options[lookup['<c:out value="${readOnlyPermissionCode}" />']].selected = true;
					}
					
					if (groupSelect.options[groupSelect.selectedIndex].value == <c:out value="${noPermissionCode}" />) {
						groupSelect.options[lookup['<c:out value="${readOnlyPermissionCode}" />']].selected = true;
					}
				} else if (roleSelect.options[roleSelect.selectedIndex].value == <c:out value="${noPermissionCode}" />) {
					if (userSelect.options[userSelect.selectedIndex].value == <c:out value="${fullPermissionCode}" />) {
						userSelect.options[lookup['<c:out value="${readWritePermissionCode}" />']].selected = true;
					}
				}
			} else if (selectInputId == "groupPermissionSelect") {
				if (groupSelect.options[groupSelect.selectedIndex].value == <c:out value="${noPermissionCode}" />) {
					if (roleSelect.options[roleSelect.selectedIndex].value == <c:out value="${fullPermissionCode}" />) {
						roleSelect.options[lookup['<c:out value="${readWritePermissionCode}" />']].selected = true;
					}
				}
			}
		}
		
		function updateCapabilities(selectInputId, checkboxIds) {
			var selectInput = hqDojo.byId(selectInputId);
			
			switch (selectInput.options[selectInput.selectedIndex].value) {
				case '<c:out value="${fullPermissionCode}" />':
				case '<c:out value="${readWritePermissionCode}" />':
					for (var x = 0; x < checkboxIds.length; x++) {
						var checkbox = hqDojo.byId(checkboxIds[x]);

						checkbox.disabled = true;
						checkbox.checked = true;
					}
				
					break;
				case '<c:out value="${readOnlyPermissionCode}" />':
					for (var x = 0; x < checkboxIds.length; x++) {
						var checkbox = hqDojo.byId(checkboxIds[x]);

						checkbox.disabled = false;
					}
				
					break;
				default:
					for (var x = 0; x < checkboxIds.length; x++) {
						var checkbox = hqDojo.byId(checkboxIds[x]);

						checkbox.disabled = true;
						checkbox.checked = false;
					}				
			}
		}
	</jsu:script>
	<jsu:script onLoad="true">
		updateCapabilities("groupPermissionSelect", [ "groupAlertCheckbox" ]);
		updateCapabilities("platformPermissionSelect", [ "platformAlertCheckbox", "platformControlCheckbox" ]);
		applyPermissionRules("platformPermissionSelect");
		updateCapabilities("serverPermissionSelect", [ "serverAlertCheckbox", "serverControlCheckbox" ]);
		updateCapabilities("servicePermissionSelect", [ "serviceAlertCheckbox", "serviceControlCheckbox" ]);

		hqDojo.connect(hqDojo.byId("userPermissionSelect"), "onchange", function() {
			applyPermissionRules("userPermissionSelect");
		});
		hqDojo.connect(hqDojo.byId("rolePermissionSelect"), "onchange", function() {
			applyPermissionRules("rolePermissionSelect");
		});
		hqDojo.connect(hqDojo.byId("groupPermissionSelect"), "onchange", function() {
			updateCapabilities("groupPermissionSelect", [ "groupAlertCheckbox" ]);
			applyPermissionRules("groupPermissionSelect");
		});
		hqDojo.connect(hqDojo.byId("platformPermissionSelect"), "onchange", function() {
			updateCapabilities("platformPermissionSelect", [ "platformAlertCheckbox", "platformControlCheckbox" ]);
			applyPermissionRules("platformPermissionSelect");
		});
		hqDojo.connect(hqDojo.byId("serverPermissionSelect"), "onchange", function() {
			updateCapabilities("serverPermissionSelect", [ "serverAlertCheckbox", "serverControlCheckbox" ]);
			applyPermissionRules("serverPermissionSelect");
		});
		hqDojo.connect(hqDojo.byId("servicePermissionSelect"), "onchange", function() {
			updateCapabilities("servicePermissionSelect", [ "serviceAlertCheckbox", "serviceControlCheckbox" ]);
			applyPermissionRules("servicePermissionSelect");
		});
	</jsu:script>
</c:if>
