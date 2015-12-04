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

package org.hyperic.hq.ui.taglib.display;

import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.TagSupport;

import org.hyperic.hq.ui.util.trans.YesOrNoMap;

/**
 * Lookup in the context messages for common boolean items for
 * textual display or HTML tag building i.e.
 * "Yes" - "No"
 *
 * Modified from class BooleanDecorator and tag display:booleandecorator.
 * Use it as: <display:booleandecorator />  
 * 
*/
public class YesNoBooleanDecorator extends BaseDecorator implements Cloneable {

    // our ColumnDecorator

    /* (non-Javadoc)
     * @see org.apache.taglibs.display.ColumnDecorator#decorate(java.lang.Object)
     */
    public String decorate(Object columnValue) {
        Boolean b = Boolean.FALSE;
        b = (Boolean)columnValue;
        return YesOrNoMap.valueFor(b, getPageContext().getRequest().getLocale());
    }
 
    public int doStartTag() throws JspTagException {
        ColumnTag ancestorTag =
            (ColumnTag)TagSupport.findAncestorWithClass(this, ColumnTag.class);

        if (ancestorTag == null) {
            throw new JspTagException(
                "A YesNoBooleanDecorator must be used within a ColumnTag.");
        }
        
        // You have to make a clone, otherwise, if there are more than one
        // boolean decorator in this table, then we'll end up with only one
        // boolean decorator object
        YesNoBooleanDecorator clone;
        try {
            clone = (YesNoBooleanDecorator) this.clone();
        } catch (CloneNotSupportedException e) {
            // Then just use this
            clone = this;
        }

        ancestorTag.setDecorator(clone);
        return SKIP_BODY;
    }

    /* (non-Javadoc)
     * @see javax.servlet.jsp.tagext.Tag#release()
     */
    public void release() {
        super.release();
    }
}
