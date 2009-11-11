/*
 * Generated by XDoclet - Do not edit!
 */
package org.hyperic.hq.bizapp.shared;

import java.util.Collection;
import java.util.List;
import java.util.Map;

import javax.ejb.CreateException;
import javax.ejb.FinderException;
import javax.ejb.RemoveException;
import javax.security.auth.login.LoginException;

import org.hyperic.hq.appdef.shared.AppdefEntityID;
import org.hyperic.hq.auth.shared.SessionException;
import org.hyperic.hq.auth.shared.SessionNotFoundException;
import org.hyperic.hq.auth.shared.SessionTimeoutException;
import org.hyperic.hq.authz.server.session.AuthzSubject;
import org.hyperic.hq.authz.server.session.Operation;
import org.hyperic.hq.authz.server.session.Resource;
import org.hyperic.hq.authz.server.session.ResourceType;
import org.hyperic.hq.authz.shared.AuthzSubjectValue;
import org.hyperic.hq.authz.shared.PermissionException;
import org.hyperic.hq.authz.shared.ResourceGroupValue;
import org.hyperic.hq.common.ApplicationException;
import org.hyperic.util.ConfigPropertyException;
import org.hyperic.util.config.ConfigResponse;
import org.hyperic.util.pager.PageControl;
import org.hyperic.util.pager.PageList;

/**
 * Local interface for AuthzBoss.
 */
public interface AuthzBoss {
    /**
     * Check if the current logged in user can administer CAM
     * @return true - if user has adminsterCAM op false otherwise
     */
    public boolean hasAdminPermission(int sessionId) throws FinderException, SessionTimeoutException,
        SessionNotFoundException;

    /**
     * Return a sorted, paged <code>List</code> of <code>ResourceType</code>
     * objects representing every resource type in the system that the user is
     * allowed to view.
     */
    public List<ResourceType> getAllResourceTypes(Integer sessionId, PageControl pc) throws CreateException,
        FinderException, PermissionException, SessionTimeoutException, SessionNotFoundException;

    /**
     * Return the full <code>List</code> of <code>ResourceType</code> objects
     * representing every resource type in the system that the user is allowed
     * to view.
     */
    public List<ResourceType> getAllResourceTypes(Integer sessionId) throws CreateException, FinderException,
        PermissionException, SessionTimeoutException, SessionNotFoundException;

    /**
     * Return a sorted, paged <code>List</code> of <code>Operation</code>
     * objects representing every resource type in the system that the user is
     * allowed to view.
     */
    public List<Operation> getAllOperations(Integer sessionId, PageControl pc) throws FinderException,
        PermissionException, SessionTimeoutException, SessionNotFoundException;

    /**
     * Return the full <code>List</code> of <code>Operation</code> objects
     * representing every resource type in the system that the user is allowed
     * to view.
     */
    public List<Operation> getAllOperations(Integer sessionId) throws FinderException, PermissionException,
        SessionTimeoutException, SessionNotFoundException;

    /**
     * Return a sorted, paged <code>List</code> of
     * <code>AuthzSubjectValue</code> objects representing every resource type
     * in the system that the user is allowed to view.
     */
    public PageList<AuthzSubjectValue> getAllSubjects(Integer sessionId, Collection<Integer> excludes, PageControl pc)
        throws FinderException, SessionTimeoutException, SessionNotFoundException, PermissionException;

    /**
     * Return a sorted, paged <code>List</code> of
     * <code>AuthzSubjectValue</code> objects corresponding to the specified id
     * values.
     */
    public PageList<AuthzSubjectValue> getSubjectsById(Integer sessionId, Integer[] ids, PageControl pc)
        throws PermissionException, SessionTimeoutException, SessionNotFoundException;

    /**
     * Return a sorted, paged <code>List</code> of
     * <code>AuthzSubjectValue</code> objects matching name as substring
     */
    public PageList<AuthzSubjectValue> getSubjectsByName(Integer sessionId, String name, PageControl pc)
        throws PermissionException, SessionTimeoutException, SessionNotFoundException;

    /**
     * Return a sorted, paged <code>List</code> of
     * <code>ResourceGroupValue</code> objects representing every resource type
     * in the system that the user is allowed to view.
     */
    public List<ResourceGroupValue> getAllResourceGroups(Integer sessionId, PageControl pc) throws FinderException,
        PermissionException, SessionTimeoutException, SessionNotFoundException;

    /**
     * Return a sorted, paged <code>List</code> of
     * <code>ResourceGroupValue</code> objects corresponding to the specified id
     * values.
     */
    public PageList<ResourceGroupValue> getResourceGroupsById(Integer sessionId, Integer[] ids, PageControl pc)
        throws FinderException, PermissionException, SessionTimeoutException, SessionNotFoundException;

    public Map<AppdefEntityID, Resource> findResourcesByIds(Integer sessionId, AppdefEntityID[] entities)
        throws SessionNotFoundException, SessionTimeoutException;

    /**
     * Remove the user identified by the given ids from the subject as well as
     * principal tables.
     */
    public void removeSubject(Integer sessionId, Integer[] ids) throws FinderException, RemoveException,
        PermissionException, SessionTimeoutException, SessionNotFoundException;

    /**
     * Update a subject
     */
    public void updateSubject(Integer sessionId, AuthzSubject target, Boolean active, String dsn, String dept,
                              String email, String first, String last, String phone, String sms, Boolean useHtml)
        throws PermissionException, SessionException;

    /**
     * Create the user identified by the given ids from the subject as well as
     * principal tables.
     */
    public AuthzSubject createSubject(Integer sessionId, String name, boolean active, String dsn, String dept,
                                      String email, String first, String last, String phone, String sms, boolean useHtml)
        throws PermissionException, CreateException, SessionException;

    public AuthzSubject getCurrentSubject(int sessionid) throws SessionException;

    public AuthzSubject getCurrentSubject(String name) throws SessionException, ApplicationException;

    /**
     * Return the <code>AuthzSubject</code> object identified by the given
     * subject id.
     * @throws SessionTimeoutException
     * @throws SessionNotFoundException
     * @throws PermissionException
     */
    public AuthzSubject findSubjectById(Integer sessionId, Integer subjectId) throws SessionNotFoundException,
        SessionTimeoutException, PermissionException;

    /**
     * Return the <code>AuthzSubject</code> object identified by the given
     * username.
     */
    public AuthzSubject findSubjectByName(Integer sessionId, String subjectName) throws FinderException,
        SessionTimeoutException, SessionNotFoundException, PermissionException;

    /**
     * Return the <code>AuthzSubject</code> object identified by the given
     * username. This method should only be used in cases where displaying the
     * user does not require an Authz check. An example of this is when the
     * owner and last modifier need to be displayed, and the user viewing the
     * resource does not have permissions to view other users. See bug #5452 for
     * more information
     */
    public AuthzSubject findSubjectByNameNoAuthz(Integer sessionId, String subjectName) throws FinderException,
        SessionTimeoutException, SessionNotFoundException, PermissionException;

    /**
     * Return a ConfigResponse matching the UserPreferences
     * @throws ApplicationException
     * @throws ConfigPropertyException
     * @throws LoginException
     */
    public ConfigResponse getUserPrefs(String username) throws SessionNotFoundException, ApplicationException,
        ConfigPropertyException;

    /**
     * Return a ConfigResponse matching the UserPreferences
     */
    public ConfigResponse getUserPrefs(Integer sessionId, Integer subjectId);

    /**
     * Set the UserPreferences
     */
    public void setUserPrefs(Integer sessionId, Integer subjectId, ConfigResponse prefs) throws ApplicationException,
        SessionTimeoutException, SessionNotFoundException;

    /**
     * Get the current user's dashboard
     */
    public ConfigResponse getUserDashboardConfig(Integer sessionId) throws SessionNotFoundException,
        SessionTimeoutException, PermissionException;

    /**
     * Get the email of a user by name
     */
    public String getEmailByName(Integer sessionId, String userName) throws FinderException, SessionTimeoutException,
        SessionNotFoundException;

    /**
     * Get the email of a user by id
     */
    public String getEmailById(Integer sessionId, Integer userId) throws FinderException, SessionTimeoutException,
        SessionNotFoundException;

}
