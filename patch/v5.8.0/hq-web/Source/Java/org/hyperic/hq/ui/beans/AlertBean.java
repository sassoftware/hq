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

package org.hyperic.hq.ui.beans;

import java.io.Serializable;
import java.util.Locale;

/**
 * Bean to hold alert values from AlertValue and AlertDefinitionValue.
 * 
 */
public class AlertBean implements Serializable {
	// alert fields
	private Integer _id;
	private long _ctime;

	// alert def fields
	private Integer _alertDefId;
	private String _name;
	private int _priority;
	private String _conditionName;
	private String _comparator;
	private String _threshold;
	private String _value;
	private boolean _multiCondition;
	private boolean _fixed;
	private boolean _acknowledgeable;
	private boolean viewable;
	private boolean canTakeAction;

	// escalation fields
	private long _maxPauseTime;

	// resource fields
	private Integer _rid;
	private Integer _type;

	private Locale locale;
	
	//private String locale_str ;

	public AlertBean() {
	}

	public AlertBean(Integer id, long ctime, Integer alertDefId, String name,
			int priority, Integer rid, Integer type, boolean fixed,
			boolean acknowledgeable) {
		this(id, ctime, alertDefId, name, priority, rid, type, fixed,
				acknowledgeable, false);
	}

	public AlertBean(Integer id, long ctime, Integer alertDefId, String name,
			int priority, Integer rid, Integer type, boolean fixed,
			boolean acknowledgeable, boolean canTakeAction) {
		_id = id;
		_ctime = ctime;
		_alertDefId = alertDefId;
		_name = name;
		_priority = priority;
		_rid = rid;
		_type = type;
		_fixed = fixed;
		_acknowledgeable = acknowledgeable;
		this.canTakeAction = canTakeAction;
	}

	public Integer getId() {
		return _id;
	}

	public void setId(Integer id) {
		_id = id;
	}

	public long getCtime() {
		return _ctime;
	}

	public void setCtime(long ctime) {
		_ctime = ctime;
	}

	public Integer getAlertDefId() {
		return _alertDefId;
	}

	public void setAlertDefId(Integer alertDefId) {
		_alertDefId = alertDefId;
	}

	public String getName() {
		return _name;
	}

	public void setName(String name) {
		_name = name;
	}

	public int getPriority() {
		return _priority;
	}

	public void setPriority(int priority) {
		_priority = priority;
	}

	public String getConditionName() {
		return _comparator;
	}

	public void setConditionName(String conditionName) {
		_conditionName = conditionName;
	}

	public String getComparator() {
		return _comparator;
	}

	public void setComparator(String comparator) {
		_comparator = comparator;
	}

	public String getThreshold() {
		return _threshold;
	}

	public void setThreshold(String threshold) {
		_threshold = threshold;
	}

	public String getValue() {
		return _value;
	}

	public void setValue(String value) {
		_value = value;
	}

	public boolean isMultiCondition() {
		return _multiCondition;
	}

	public void setMultiCondition(boolean multiCondition) {
		_multiCondition = multiCondition;
	}

	public Integer getRid() {
		return _rid;
	}

	public void setRid(Integer rid) {
		_rid = rid;
	}

	public Integer getType() {
		return _type;
	}

	public void setType(Integer type) {
		_type = type;
	}

	/**
	 * Return the formatted alert condition.
	 */
	public String getConditionFmt() {
		if (_multiCondition) {
			return _conditionName;
		} else {
			return _conditionName.trim() + " " + _comparator.trim() + " "
					+ _threshold;
		}
	}

	public String getConditionFmtOnLocale() {
		if (locale == null) {
			return getConditionFmt();
		}
		//Locale locale = new Locale(locale_str);
		java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle(
				"ApplicationResources", locale);

		if (this.getThreshold() != null
				&& this.getThreshold().trim().length() > 0) {
			String lstr = getConditionFmt();
			String lthrishold = null;
			if ("ANY".equals(this.getThreshold())) {
				lthrishold = rb.getString("Alert.action.status.threshold.any");
				lstr = lstr.replaceAll("ANY", lthrishold);
				return lstr ;
			}else if ("ERR".equals(this.getThreshold())) {
				lthrishold = rb.getString("Alert.action.status.threshold.err");
				lstr = lstr.replaceAll("ERR", lthrishold);
				return lstr ;
			}else if ("WRN".equals(this.getThreshold())) {
				lthrishold = rb.getString("Alert.action.status.threshold.wrn");
				lstr = lstr.replaceAll("WRN", lthrishold);
				return lstr ;
			}else if ("INF".equals(this.getThreshold())) {
				lthrishold = rb.getString("Alert.action.status.threshold.inf");
				lstr = lstr.replaceAll("INF", lthrishold);
				return lstr ;
			}else if ("DBG".equals(this.getThreshold())) {
				lthrishold = rb.getString("Alert.action.status.threshold.dbg");
				lstr = lstr.replaceAll("DBG", lthrishold);
				return lstr ;
			}
			
		}
		
		if ("restart  completed".equalsIgnoreCase(getConditionFmt())) {
			return rb.getString("Alert.action.status.restart.completed");
		}
		if ("restart  in progress".equalsIgnoreCase(getConditionFmt())) {
			return rb.getString("Alert.action.status.restart.inprogress");
		}
		if ("restart  failed".equalsIgnoreCase(getConditionFmt())) {
			return rb.getString("Alert.action.status.restart.failed");
		}
		if ("start  completed".equalsIgnoreCase(getConditionFmt())) {
			return rb.getString("Alert.action.status.start.completed");
		}
		if ("start  in progress".equalsIgnoreCase(getConditionFmt())) {
			return rb.getString("Alert.action.status.start.inprogress");
		}
		if ("start  failed".equalsIgnoreCase(getConditionFmt())) {
			return rb.getString("Alert.action.status.start.failed");
		}
		if ("stop  completed".equalsIgnoreCase(getConditionFmt())) {
			return rb.getString("Alert.action.status.stop.completed");
		}
		if ("stop  in progress".equalsIgnoreCase(getConditionFmt())) {
			return rb.getString("Alert.action.status.stop.inprogress");
		}
		if ("stop  failed".equalsIgnoreCase(getConditionFmt())) {
			return rb.getString("Alert.action.status.stop.failed");
		}
		if ("pause  completed".equalsIgnoreCase(getConditionFmt())) {
			return rb.getString("Alert.action.status.pause.completed");
		}
		if ("pause  in progress".equalsIgnoreCase(getConditionFmt())) {
			return rb.getString("Alert.action.status.pause.inprogress");
		}
		if ("pause  failed".equalsIgnoreCase(getConditionFmt())) {
			return rb.getString("Alert.action.status.pause.failed");
		}
		if ("resume  completed".equalsIgnoreCase(getConditionFmt())) {
			return rb.getString("Alert.action.status.resume.completed");
		}
		if ("resume  in progress".equalsIgnoreCase(getConditionFmt())) {
			return rb.getString("Alert.action.status.resume.inprogress");
		}
		if ("resume  failed".equalsIgnoreCase(getConditionFmt())) {
			return rb.getString("Alert.action.status.resume.failed");
		}
		if ("run  failed".equalsIgnoreCase(getConditionFmt())) {
			return rb.getString("Alert.action.status.run.failed");
		}
		return getConditionFmt();
	}

    public void setLocale(Locale locale){
    	this.locale = locale ;
    }
	
	public boolean isFixed() {
		return _fixed;
	}

	public void setFixed(boolean fixed) {
		_fixed = fixed;
	}

	public boolean isAcknowledgeableAndCanTakeAction() {
		return isAcknowledgeable() && isCanTakeAction();
	}

	public boolean isAcknowledgeable() {
		return _acknowledgeable;
	}

	public void setAcknowledgeable(boolean acknowledgeable) {
		this._acknowledgeable = acknowledgeable;
	}

	public long getMaxPauseTime() {
		return _maxPauseTime;
	}

	public void setMaxPauseTime(long maxPauseTime) {
		_maxPauseTime = maxPauseTime;
	}

	public boolean isViewable() {
		return viewable;
	}

	public void setViewable(boolean viewable) {
		this.viewable = viewable;
	}

	public boolean isCanTakeAction() {
		return canTakeAction;
	}

	public void setCanTakeAction(boolean canTakeAction) {
		this.canTakeAction = canTakeAction;
	}


	public String toString() {
		StringBuffer str = new StringBuffer();
		str.append("{id=").append(getId()).append(" ctime=").append(getCtime())
				.append(" alertDefId=").append(getAlertDefId())
				.append(" name=").append(getName()).append(" priority=")
				.append(getPriority()).append(" conditionFmt=")
				.append(getConditionFmt()).append(" value=").append(getValue())
				.append(" rid=").append(getRid()).append(" type=")
				.append(getType()).append(" fixed=").append(isFixed())
				.append(" acknowledgeable=").append(isAcknowledgeable())
				.append(" maxPauseTime=").append(getMaxPauseTime()).append('}');

		return str.toString();
	}
}

// EOF
