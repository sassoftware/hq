/*
 * NOTE: This copyright does *not* cover user programs that use HQ
 * program services by normal system calls through the application
 * program interfaces provided as part of the Hyperic Plug-in Development
 * Kit or the Hyperic Client Development Kit - this is merely considered
 * normal use of the program, and does *not* fall under the heading of
 * "derived work".
 * 
 * Copyright (C) [2004, 2005, 2006, 2007], Hyperic, Inc.
 * This file is part of HQ.
 * 
 * HQ is free software; you can redistribute it and/or modify
 * it under the terms version 2 of the GNU General Public License as
 * published by the Free Software Foundation. This program is distributed
 * in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
 * even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 * USA.
 */

package org.hyperic.hq.ui.action.portlet.addresource;

import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.hyperic.hq.ui.Constants;
import org.hyperic.hq.ui.StringConstants;
import org.hyperic.hq.ui.WebUser;
import org.hyperic.hq.ui.action.BaseAction;
import org.hyperic.hq.ui.action.BaseValidatorForm;
import org.hyperic.hq.ui.util.ConfigurationProxy;
import org.hyperic.hq.ui.util.RequestUtils;
import org.hyperic.hq.ui.util.SessionUtils;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * An Action that adds resources to a dashboard widget
 * 
 * Heavily based on:
 * org.hyperic.hq.ui.action.admin.role.AddUserFormPrepareAction
 */
public class AddResourcesAction
    extends BaseAction {

    private final Log log = LogFactory.getLog(AddResourcesAction.class.getName());
    private ConfigurationProxy configurationProxy;

    @Autowired
    public AddResourcesAction(ConfigurationProxy configurationProxy) {
        super();
        this.configurationProxy = configurationProxy;
    }

    /**
     * Add resources to the user specified in the given
     * <code>AddResourcesForm</code>.
     */
    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request,
                                 HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        WebUser user = SessionUtils.getWebUser(session);

        AddResourcesForm addForm = (AddResourcesForm) form;

        ActionForward forward = checkSubmit(request, mapping, form, Constants.USER_PARAM, user.getId());
        if (forward != null) {
            BaseValidatorForm spiderForm = (BaseValidatorForm) form;
            
            if (spiderForm.isCancelClicked() || spiderForm.isResetClicked() || forward.getName().equalsIgnoreCase("reset")) {
                log.trace("removing pending resources list");
                SessionUtils.removeList(session, Constants.PENDING_RESOURCES_SES_ATTR);
            } else if (spiderForm.isAddClicked()) {
                log.trace("adding to pending resources list");

                SessionUtils.addToList(session, Constants.PENDING_RESOURCES_SES_ATTR, addForm.getAvailableResources());

            } else if (spiderForm.isRemoveClicked()) {
                log.trace("removing from pending resources list");

                SessionUtils.removeFromList(session, Constants.PENDING_RESOURCES_SES_ATTR, addForm
                    .getPendingResources());
            }
            return forward;
        }

        log.trace("getting pending resources list");
        List<String> pendingResourceIds = SessionUtils.getListAsListStr(request.getSession(),
            Constants.PENDING_RESOURCES_SES_ATTR);

        StringBuffer resourcesAsString = new StringBuffer();

        for (Iterator<String> i = pendingResourceIds.iterator(); i.hasNext();) {
            resourcesAsString.append(StringConstants.DASHBOARD_DELIMITER);
            resourcesAsString.append(i.next());
        }

        SessionUtils.removeList(session, Constants.PENDING_RESOURCES_SES_ATTR);

        RequestUtils.setConfirmation(request, "admin.user.confirm.AddResource");

        configurationProxy.setPreference(session, user, addForm.getKey(), resourcesAsString.toString());

        return returnSuccess(request, mapping);

    }
}
