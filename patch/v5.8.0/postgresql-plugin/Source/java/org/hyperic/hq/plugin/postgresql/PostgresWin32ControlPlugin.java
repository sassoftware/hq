package org.hyperic.hq.plugin.postgresql;

import org.hyperic.hq.product.PluginException;
import org.hyperic.hq.product.Win32ControlPlugin;
import org.hyperic.sigar.win32.Win32Exception;

public class PostgresWin32ControlPlugin extends Win32ControlPlugin {
    public void doAction(String action)
            throws PluginException
        {
            try {
                if (action.equals("start")) {
                    super.doAction(action);
                    return;
                }
                if (action.equals("stop")) {
                	super.doAction(action);
                	return;
                }
                if (action.equals("restart")) {
                	log.info("enter restart");
                    if (isRunning()){
                    	log.info("enter isRunning");
                        svc.stop();
                    }
                    while(isRunning()){
                    	try {
                    		log.info("service is still running");
							Thread.sleep(3000);
						} catch (InterruptedException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
                    }
                    log.info("after stop");
                    svc.start();
                    
                    log.info("after restart");
                    setResult(RESULT_SUCCESS);
                    log.info("after set result");
                    
                    try {
						Thread.sleep(60000);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
                    return;
                }
            } catch (Win32Exception e) {
                setResult(RESULT_FAILURE);
                throw new PluginException(action + " " + getServiceName() +
                                          " failed: " + e.getMessage());
            }
            throw new PluginException("Action '" + action +
                                      "' not supported");
        }

}
