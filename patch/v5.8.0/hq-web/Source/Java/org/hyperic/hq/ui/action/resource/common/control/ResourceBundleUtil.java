package org.hyperic.hq.ui.action.resource.common.control;

import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

public class ResourceBundleUtil {
	private static Properties caProperties = null;

	public static String getLocalStr(HttpServletRequest request, String ctrlStr) {

		java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle(
				"ApplicationResources", request.getLocale());
		try {
			String messageKey = getFromCAProp(ctrlStr);
			if(messageKey!=null){
				return rb.getString(messageKey) ;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ctrlStr;
	}

	public static String getFromCAProp(String key)  {
		if (caProperties == null) {
			caProperties = new Properties();
			InputStream is = null;
			try {
				is = ResourceBundleUtil.class
						.getResourceAsStream("/controlAction.properties");
				caProperties.load(is);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				caProperties = null ;
				e.printStackTrace();
				return null ;
			} finally {
				if (is != null)
					try {
						is.close();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
			}
		}
		Enumeration enu = caProperties.keys();
		
		while(enu.hasMoreElements()){
			String thekey = (String)enu.nextElement();
			if(thekey.equalsIgnoreCase("ca-" + key)){
				return caProperties.getProperty(thekey);
			}
		}
		
            return null;
		}

}
