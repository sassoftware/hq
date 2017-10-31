/**
 * NOTE: This copyright does *not* cover user programs that use HQ
 * program services by normal system calls through the application
 * program interfaces provided as part of the Hyperic Plug-in Development
 * Kit or the Hyperic Client Development Kit - this is merely considered
 * normal use of the program, and does *not* fall under the heading of
 *  "derived work".
 *
 *  Copyright (C) [2009-2010], VMware, Inc.
 *  This file is part of HQ.
 *
 *  HQ is free software; you can redistribute it and/or modify
 *  it under the terms version 2 of the GNU General Public License as
 *  published by the Free Software Foundation. This program is distributed
 *  in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
 *  even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 *  PARTICULAR PURPOSE. See the GNU General Public License for more
 *  details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 *  USA.
 *
 */

package org.hyperic.hq.ui.security;

import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hyperic.hq.auth.server.session.UserAuditFactory;
import org.hyperic.hq.auth.shared.SessionException;
import org.hyperic.hq.auth.shared.SessionManager;
import org.hyperic.hq.auth.shared.SessionNotFoundException;
import org.hyperic.hq.auth.shared.SessionTimeoutException;
import org.hyperic.hq.authz.server.session.AuthzSubject;
import org.hyperic.hq.authz.server.session.Operation;
import org.hyperic.hq.authz.server.session.Role;
import org.hyperic.hq.authz.shared.AuthzSubjectManager;
import org.hyperic.hq.authz.shared.AuthzSubjectValue;
import org.hyperic.hq.authz.shared.PermissionException;
import org.hyperic.hq.authz.shared.RoleManager;
import org.hyperic.hq.authz.shared.RoleValue;
import org.hyperic.hq.bizapp.shared.AuthBoss;
import org.hyperic.hq.bizapp.shared.AuthzBoss;
import org.hyperic.hq.common.ApplicationException;
import org.hyperic.hq.common.shared.HQConstants;
import org.hyperic.hq.security.HQAuthenticationDetails;
import org.hyperic.hq.ui.AttrConstants;
import org.hyperic.hq.ui.Constants;
import org.hyperic.hq.ui.WebUser;
import org.hyperic.util.config.ConfigResponse;
import org.hyperic.util.pager.PageControl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.session.SessionAuthenticationException;
import org.springframework.security.web.authentication.session.SessionAuthenticationStrategy;
import org.springframework.stereotype.Component;
import org.springframework.security.web.authentication.session.SessionFixationProtectionStrategy;

@Component
public class BaseSessionInitializationStrategy extends SessionFixationProtectionStrategy implements SessionAuthenticationStrategy {
	private static Log log = LogFactory.getLog(BaseSessionInitializationStrategy.class.getName());
    private SessionManager sessionManager;
    private AuthzSubjectManager authzSubjectManager;
    private AuthzBoss authzBoss;
    private AuthBoss authBoss;
	private UserAuditFactory userAuditFactory;
	private RoleManager roleManager;
    
    @Autowired
    public BaseSessionInitializationStrategy(AuthBoss authBoss, AuthzBoss authzBoss,
    		                                 AuthzSubjectManager authzSubjectManager,
    		                                 UserAuditFactory userAuditFactory,
    		                                 SessionManager sessionManager, RoleManager roleManager) {
    	this.authBoss = authBoss;
    	this.authzBoss = authzBoss;
    	this.authzSubjectManager = authzSubjectManager;
    	this.sessionManager = sessionManager;    	
    	this.userAuditFactory = userAuditFactory;
    	this.roleManager = roleManager;
    }
    
    public void onAuthentication(Authentication authentication, HttpServletRequest request,
    		                     HttpServletResponse response)
    throws SessionAuthenticationException {
    	//Call Spring session fixation ahead in super class.
    	super.onAuthentication(authentication, request, response);
    	
        final boolean debug = log.isDebugEnabled();

        if (debug) log.debug("Initializing UI session parameters...");
        boolean updateRoles = false;
        String username = authentication.getName();
		if (debug) {
        	log.debug("Authenticated username is:" + username);
        }
        //If this is an organization authentication (ldap\kerberos) we will add a 'org\' prefix to the
        //user name so we will know it's an organization user
        if (null != authentication.getDetails() && (authentication.getDetails() instanceof HQAuthenticationDetails)) {
        	HQAuthenticationDetails authDetails = (HQAuthenticationDetails) authentication.getDetails();
        	if (authDetails.isUsingExternalAuth()) {
        		username = HQConstants.ORG_AUTH_PREFIX + username;
        		//If this is a Ldap user we will update his roles
        		 if (null != authentication.getPrincipal() && 
        	        		authentication.getPrincipal().getClass().getName().contains("Ldap")) {
        	        	updateRoles = true;
        		 }
        	}
        }
        try {
        	// The following is logic taken from the old HQ Authentication Filter
            int sessionId = sessionManager.put(authzSubjectManager.findSubjectByName(username));
            HttpSession session = request.getSession();
            ServletContext ctx = session.getServletContext();
            
            // look up the subject record
            AuthzSubject subj = authzBoss.getCurrentSubject(sessionId);
            boolean needsRegistration = false;
            if (subj == null || updateRoles) {
                try {
                    //For LDAP users we first want to remove all the existing 'LDAP' roles and then add the current roles he belongs to.
                    //We are doing that because for LDAP users we do an automatic mapping of the roles according to the group the
                    //user belongs to, and if the user has been removed or added from some group we want this to be reflected in his roles.
                    if (updateRoles) {
                    	log.info("ldap Update role.");
                    	Collection<RoleValue> roles = roleManager.getRoles(subj, PageControl.PAGE_ALL);
                    	for (RoleValue role : roles) {
                    		String roleName = role.getName().toLowerCase();
							if (roleName.startsWith(HQConstants.ORG_AUTH_PREFIX)) {
                    			roleManager.removeSubjects(authzSubjectManager.getOverlordPojo(), role.getId(), 
                    					new Integer[] {subj.getId()});
                    		}
                    	}
                    }
                    //every user has ROLE_HQ_USER.  If other roles assigned, automatically assign them to new user
                    if(authentication.getAuthorities().size() > 1) {
                    	log.info("ldap have new roles.");
                        Collection<Role> roles = roleManager.getAllRoles();
                        for(GrantedAuthority authority: authentication.getAuthorities()) {
                            if(authority.getAuthority().equals("ROLE_HQ_USER")) {
                                continue;
                            }
                            for(Role role: roles) {
                            	String roleName = role.getName().toLowerCase();
								String ldapRoleName = "";
								if (roleName.startsWith(HQConstants.ORG_AUTH_PREFIX)) {
                            		ldapRoleName = roleName.substring(roleName.indexOf(HQConstants.ORG_AUTH_PREFIX) + 
                            				HQConstants.ORG_AUTH_PREFIX.length()).trim();
                            	}
                                if((("ROLE_" + role.getName()).equalsIgnoreCase(authority.getAuthority())) || 
                                		(("ROLE_" + ldapRoleName).equalsIgnoreCase(authority.getAuthority()))) {
                                    roleManager.addSubjects(authzSubjectManager.getOverlordPojo(), role.getId(), 
                                        new Integer[] {subj.getId()});
                                }
                            }
                        }
                    }
                } catch (ApplicationException e) {
                    throw new SessionAuthenticationException(
                        "Unable to add user to authorization system");
                }
                
                sessionId = sessionManager.put(subj);
            } 
            
            if(subj == null){
            	log.info("User subject is null, don't auto-create user, program will return without executing afterward logic.");
            	return;
            }
            
            userAuditFactory.loginAudit(subj);
            AuthzSubjectValue subject = subj.getAuthzSubjectValue();
            
            // figure out if the user has a principal
            boolean hasPrincipal = authBoss.isUser(sessionId, subject.getName());
            ConfigResponse preferences = needsRegistration ?
                new ConfigResponse() : getUserPreferences(ctx, sessionId, subject.getId(), authzBoss);
            WebUser webUser = new WebUser(subject, sessionId, preferences, hasPrincipal);
            
            // Add WebUser to Session
            session.setAttribute(Constants.WEBUSER_SES_ATTR, webUser);

            if (debug) log.debug("WebUser object created and stashed in the session");
            
            // TODO - We should use Spring Security for handling user
            // permissions...
            Map<String, Boolean> userOperationsMap = new HashMap<String, Boolean>();
             
            if (webUser.getPreferences().getKeys().size() > 0) {
            	log.debug("load permission");
                userOperationsMap = loadUserPermissions(webUser.getSessionId(), authzBoss);
            }
            
            session.setAttribute(Constants.USER_OPERATIONS_ATTR, userOperationsMap);
             
            if (debug) log.debug("Stashing user operations in the session");

            if (debug && needsRegistration) {
            	log.debug("Authentic user but no HQ entity, must have authenticated outside of " +
                          "HQ...needs registration");
            }
            
            //Save to session whether it's super user
            boolean isSuperUser = isSuperUser(subj);
			if (log.isDebugEnabled()) {
				log.debug("Current user is assigned super user role? " + isSuperUser);
			}
            session.setAttribute(Constants.IS_SUPER_USER, isSuperUser);
             
        } catch (SessionException e) {
            if (debug) {
                log.debug("Authentication of user {" + username + "} failed due to an session error.");
            }
            
            throw new SessionAuthenticationException("login.error.application");
        } catch (PermissionException e) {
            if (debug) {
                log.debug("Authentication of user {" + username + "} failed due to an permissions error.");
            }
            
            throw new SessionAuthenticationException("login.error.application");
        }
    }

	protected static Map<String, Boolean> loadUserPermissions(Integer sessionId, AuthzBoss authzBoss) 
    throws SessionTimeoutException, SessionNotFoundException, PermissionException {
        // look up the user's permissions
        Map<String, Boolean> userOperationsMap = new HashMap<String, Boolean>();
        List<Operation> userOperations = authzBoss.getAllOperations(sessionId);
        for (Iterator<Operation> it = userOperations.iterator(); it.hasNext();) {
            Operation operation = it.next();
            
            userOperationsMap.put(operation.getName(), Boolean.TRUE);
        }
        
        return userOperationsMap;
    }   

    protected static ConfigResponse getUserPreferences(ServletContext ctx, Integer sessionId,
    		                                           Integer subjectId, AuthzBoss authzBoss) {
        // look up the user's preferences
        ConfigResponse defaultPreferences = (ConfigResponse) ctx.getAttribute(Constants.DEF_USER_PREFS);
        ConfigResponse preferences = authzBoss.getUserPrefs(sessionId, subjectId);
        
        preferences.merge(defaultPreferences, false);
        
        return preferences;
    }
    
    private boolean isSuperUser(AuthzSubject user){
    	boolean superUser = false; 
    	Collection<Role> roles = user.getRoles(); 
		if (roles == null || roles.size() == 0) {
			return superUser;
		}
    	for(Role role : roles){
    		if(AttrConstants.SUPER_USER_ROLE.equals(role.getName())){
    			superUser = true;
    			break;
    		}
    	}
    	return superUser;
    }
}