/*
 * NOTE: This copyright does *not* cover user programs that use Hyperic
 * program services by normal system calls through the application
 * program interfaces provided as part of the Hyperic Plug-in Development
 * Kit or the Hyperic Client Development Kit - this is merely considered
 * normal use of the program, and does *not* fall under the heading of
 * "derived work".
 * 
 * Copyright (C) [2004-2011], VMware, Inc.
 * This file is part of Hyperic.
 * 
 * Hyperic is free software; you can redistribute it and/or modify
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
package org.hyperic.hq.plugin.cloudfoundry.product;

import java.util.Properties;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hyperic.hq.authz.shared.AuthzConstants;
import org.hyperic.hq.product.GenericPlugin;
import org.hyperic.hq.product.PluginException;
import org.hyperic.hq.product.PluginManager;
import org.hyperic.hq.product.ProductPlugin;
import org.hyperic.hq.product.TypeInfo;

public class CloudFoundryProductPlugin extends ProductPlugin {
    private static final Log logger = LogFactory.getLog(CloudFoundryProductPlugin.class);

    /*
	public GenericPlugin getPlugin(String type, TypeInfo entity)
    {  
        if (type.equals(ProductPlugin.TYPE_AUTOINVENTORY) &&
            entity.getName().equals("Cloud Foundry")) {
            return new CloudFoundryDetector();
        }
        return super.getPlugin(type, entity);
    }
    */
    public void init(PluginManager manager) throws PluginException {
        super.init(manager);
        Properties props = manager.getProperties();
        logger.debug("manager.getProperties [" + props +"]");
    }
}