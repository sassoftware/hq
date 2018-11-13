// Copyright (c) 2009-2010 VMware, Inc.  All rights reserved.

import org.hyperic.hq.hqu.rendit.HQUPlugin

class Plugin extends HQUPlugin {
    Plugin() {
        /**
         * The following can be un-commented to have the plugin's view rendered in HQ.
         *
         * description:  The brief name of the view (e.g.: "Fast Executor")
         * attachType:   one of ['masthead', 'admin']
         * controller:   The controller to invoke when the view is to be generated
         * action:       The method within 'controller' to invoke
         * category:     (optional)  If set, specifies either 'tracker' or 'resource' menu
         */

        addView(description:  'Application Management',
                attachType:   'resource',
                controller:   TomcatappmgmtController,
                action:       'manageApplications',
                resourceType: ['SpringSource tc Runtime 6.0','SpringSource tc Runtime 7.0','SASWebApplicationServer 9.45'])

		
    }
}

