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
 * 
 * This is Open Source Hyperic extension for SAS product.
 * Modified by: Bing Cai
 * 
 */

package org.hyperic.hq.ui.taglib.display;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;
import java.util.TimeZone;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.PageContext;

import org.hyperic.hq.ui.util.RequestUtils;


public class EventDateTimeDecorator extends BaseDecorator {
	public static final String defaultKey = "common.value.notavail";

	private static Log log = LogFactory.getLog(DateDecorator.class.getName());

	private PageContext context;

	protected String bundle = org.apache.struts.Globals.MESSAGES_KEY;
	
	@Override
	public String decorate(Object obj) {
		String tempVal = getName();
		Long newDate = null;

		if (tempVal != null) {
			try {
				newDate = Long.valueOf(tempVal);
			} catch (NumberFormatException nfe) {
				log.debug("number format exception parsing long for: " + tempVal);
				
				return "";
			}
		} else {
			newDate = (Long) obj;
		}

		HttpServletRequest request = (HttpServletRequest) getPageContext().getRequest();

		if (newDate != null && newDate.equals(new Long(0))) {
			String resString;
			
			resString = RequestUtils.message(request, "resource.common.monitor.visibility.config.NONE");
			
			return resString;
		}

		if (obj == null) {
			// there may be cases where we have no date set when rendering a
			// table, so just show n/a (see PR 8443)
			return RequestUtils.message(request, bundle, request.getLocale().toString(), EventDateTimeDecorator.defaultKey);
		}

		TimeZone hostTimeZone = TimeZone.getDefault();
		Locale outLocale = getPageContext().getRequest().getLocale();
		SimpleDateFormat df = (SimpleDateFormat) SimpleDateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.SHORT, outLocale);
		df.setCalendar(Calendar.getInstance(hostTimeZone, outLocale));
		if(outLocale.equals(new Locale("en", "US")) || outLocale.equals(new Locale("en"))) {
			df.applyPattern("MM/dd/yyyy hh:mm aa");
		}
		return df.format(newDate);
	}

	public PageContext getContext() {
		return context;
	}

	public void setContext(PageContext context) {
		this.context = context;
	}
	
}
