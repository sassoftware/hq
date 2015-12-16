/*
 * NOTE: This copyright does *not* cover user programs that use HQ
 * program services by normal system calls through the application
 * program interfaces provided as part of the Hyperic Plug-in Development
 * Kit or the Hyperic Client Development Kit - this is merely considered
 * normal use of the program, and does *not* fall under the heading of
 * "derived work".
 * 
 * Copyright (C) [2004, 2005, 2006], Hyperic, Inc.
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

package org.hyperic.hq.ui.action.resource.common.control;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.hyperic.hq.appdef.shared.AppdefEntityID;
import org.hyperic.hq.bizapp.shared.ControlBoss;
import org.hyperic.hq.control.server.session.ControlHistory;
import org.hyperic.hq.ui.Constants;
import org.hyperic.hq.ui.action.BaseAction;
import org.hyperic.hq.ui.exception.ParameterNotFoundException;
import org.hyperic.hq.ui.util.RequestUtils;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * An Action that the current status of actions on a resource.
 */
public class UpdateStatusAction
    extends BaseAction {

    private final Log log = LogFactory.getLog(UpdateStatusAction.class.getName());
    private ControlBoss controlBoss;

    @Autowired
    public UpdateStatusAction(ControlBoss controlBoss) {
        super();
        this.controlBoss = controlBoss;
    }

    /**
     * Displays state of current actions of a resource.
     */
    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request,
                                 HttpServletResponse response) throws Exception {

        log.trace("determining current status.");
        int sessionId = RequestUtils.getSessionId(request).intValue();

        AppdefEntityID appId = RequestUtils.getEntityId(request);

        Integer batchId = null;
        try {
            batchId = RequestUtils.getIntParameter(request, Constants.CONTROL_BATCH_ID_PARAM);
        }
        /* failed to get that param, that's ok, use current */
        catch (NullPointerException npe) {
        } catch (ParameterNotFoundException pnfe) {
        } catch (NumberFormatException nfe) {
        }

        ControlHistory cValue = null;
        if (null == batchId) {
            cValue = controlBoss.getCurrentJob(sessionId, appId);
        } else {
            cValue = controlBoss.getJobByJobId(sessionId, batchId);
        }

        if (cValue == null /* no current job */) {
            cValue = controlBoss.getLastJob(sessionId, appId);
        }
        JSONObject obj = new JSONObject();
        //cValue.setLocale(request.getLocale());
        obj.put("ctrlAction", ResourceBundleUtil.getLocalStr(request,cValue.getAction()));
        obj.put("ctrlDesc", cValue.getDescription());
        obj.put("ctrlStatus", cValue.getStatus());
        obj.put("ctrlStart", cValue.getStartTime());
        obj.put("ctrlMessage", cValue.getMessage());
        obj.put("ctrlSched", cValue.getDateScheduled());
        obj.put("ctrlDuration", cValue.getDuration());
        request.setAttribute(Constants.AJAX_JSON, obj);

        return returnSuccess(request, mapping);
    }
    

}
