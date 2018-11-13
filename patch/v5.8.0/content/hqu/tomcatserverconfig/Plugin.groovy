// Copyright (c) 2009-2010 VMware, Inc.  All rights reserved.

import java.io.File; 
import org.hyperic.hq.authz.server.session.AuthzSubject; 
import org.hyperic.hq.authz.server.session.Resource; 
import org.hyperic.hq.hqu.rendit.HQUPlugin 
import org.hyperic.hq.hqu.server.session.Attachment; 

class Plugin extends HQUPlugin {    
    void initialize(File pluginDir) {        
        super.initialize(pluginDir)        
        /**         
         * The following can be un-commented to have the plugin's view rendered in HQ.         
         * description:  The brief name of the view (e.g.: "Fast Executor")         
         * attachType:   one of ['masthead', 'admin', 'resource']         
         * controller:   The controller to invoke when the view is to be generated        
         * action:       The method within 'controller' to invoke         
         * category:     (optional)  If set, specifies either 'tracker' or 'resource' menu         
         * resourceType: The type of resource this should appear on.         
         * showAttachmentIf: (optional) This will allow to limit when to show the attachement.         
         */         
        addView(description:  'Server Configuration',                
                attachType:   'resource',                
                controller:   TomcatserverconfigController,                
                action:       'index',                
                resourceType: ['SpringSource tc Runtime 6.0','SpringSource tc Runtime 7.0','SASWebApplicationServer 9.45'],                
                showAttachmentIf: {a, r, u -> attachmentIsShown(a, r, u)})
    }
    
    private boolean attachmentIsShown(Attachment a, Resource r, AuthzSubject u){        
        // Do not show group view        
        if (r.isGroup()) {            
            return false
        }        
        true
    }
}
