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

package org.hyperic.hq.ui.util.trans;

import java.util.Locale;
import java.util.ResourceBundle;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;


public class YesOrNoMap 
{
    private static final String BUNDLE = "ApplicationResources";
    private static final Log _log = LogFactory.getLog(YesOrNoMap.class);
    
    private YesOrNoMap() {
    }

    public static String valueFor(boolean isYes) {
    	return valueFor(isYes, Locale.getDefault());
    }
    
    public static String valueFor(boolean isYes, Locale loc) {
    	ResourceBundle bundle = ResourceBundle.getBundle(BUNDLE, loc);
    	if(bundle == null) {
    		_log.warn("Unable to find bundle in YesOrNoMap.");
    		return isYes ? "YES" : "NO";
    	}
    	String value;
    	if(isYes) {
    		value = bundle.getString("yesno.true");
    		if(value == null)
    			value = "YES";
    	}
    	else {
    		value = bundle.getString("yesno.false");
    		if(value == null)
    			value = "NO";
    	}
    	return value;
    }

    public static String valueFor(String yesOrNo) {
    	return valueFor(yesOrNo, Locale.getDefault());
    }

    public static String valueFor(String yesOrNo, Locale loc) {
        if (yesOrNo == null) {
            return valueFor(false, loc);
        }
        
        String normalizedValue = yesOrNo.trim().toLowerCase();
        
        if (normalizedValue.equals("y")) {
            return valueFor(true, loc);
        } else if (normalizedValue.equals("n")) {
            return valueFor(false, loc);
        }
        
        ResourceBundle bundle = ResourceBundle.getBundle(BUNDLE, loc);

        if (bundle == null) {
            _log.warn("Unable to find bundle in YesOrNoMap.");
        }
        else {
        	String value = bundle.getString(yesOrNo);
        	if(value != null)
        		return value;
        }
        
        return valueFor(false, loc);
    }
    
}
