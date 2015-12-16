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

package org.hyperic.image.chart;

import java.text.DateFormat;
import java.text.DateFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

public class ScaleFormatter
{
    private static final int    MINUTE = 60000;
    private static final int    HOUR   = 60 * MINUTE;
    private static final int    DAY    = 24 * HOUR;
    
    private static final String DATE_FORMAT               = "M/d";
    private static final String TIME_FORMAT               = "h:mma";
    private static final String DATETIME_FORMAT           = "M/d/yyyy h:mma";
    private static final String MULTILINE_DATETIME_FORMAT = TIME_FORMAT + '\n' +
                                                            DATE_FORMAT;
    
    private static final String[] AM_PM         = {"a", "p"};
     
    private static final SimpleDateFormat m_fmt = new SimpleDateFormat();
    
    public static String formatTime(long time) {
        m_fmt.applyPattern(DATETIME_FORMAT);
        return m_fmt.format( new Date(time) );
    }
    
    public static String formatTimeNLS(long time, Locale l) {
    	if(l.equals(new Locale("en", "US")) || l.equals(new Locale("en"))) {
    		return formatTime(time);
    	}
    	SimpleDateFormat df = (SimpleDateFormat) SimpleDateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.SHORT, l);
    	df.setCalendar(Calendar.getInstance(TimeZone.getDefault(), l));
    	return df.format(time);
    }
    
    public static String formatTime(long time, long scale, long units) {
        DateFormatSymbols symMod  = m_fmt.getDateFormatSymbols();
        symMod.setAmPmStrings(AM_PM);
        m_fmt.setDateFormatSymbols(symMod);
            
//        long tmp = (scale / units );            
//        if( tmp > DAY)
//            m_fmt.applyLocalizedPattern(DATE_FORMAT);
//        else
//            m_fmt.applyLocalizedPattern(TIME_FORMAT);

        m_fmt.applyPattern(MULTILINE_DATETIME_FORMAT);
        
        return m_fmt.format( new Date(time) );
    }
    
    public static String formatTimeNLS(long time, long scale, long units, Locale l) {
    	if(l.equals(new Locale("en", "US")) || l.equals(new Locale("en"))) {
    		return formatTime(time, scale, units); 
    	}
    	SimpleDateFormat df = (SimpleDateFormat) SimpleDateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.SHORT, l);
    	df.setCalendar(Calendar.getInstance(TimeZone.getDefault(), l));
    	df.applyPattern("HH:mm" + '\n' + "MMMd");
    	return df.format(time);
    }
}
