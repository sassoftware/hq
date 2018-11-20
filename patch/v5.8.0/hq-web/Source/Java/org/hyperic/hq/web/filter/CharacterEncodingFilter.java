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

package org.hyperic.hq.web.filter;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hyperic.hq.ui.action.resource.common.control.ResourceControlController;

public class CharacterEncodingFilter
	extends org.springframework.web.filter.CharacterEncodingFilter {
    
	private final Log log = LogFactory.getLog(CharacterEncodingFilter.class.getName());
	
	private URIMatcher uriMatcher = new URIMatcher();

	/**
	 * This is a comma-separated list of paths, which can use
	 * asterisk for wildcard support, to exclude from the filter. 
	 * There is no limit to how many items can be specified. 
	 * However, for performance reasons it is best to specify as 
	 * few as possible since each requested path is matched via regex.
	 */
	public void setExcludePaths(String excludePaths) {
		uriMatcher.setPatterns(excludePaths);
	}
	
	/**
	 * Custom filtering control, returning true to avoid filtering of the given request
	 */
	protected boolean shouldNotFilter(HttpServletRequest request)
		throws ServletException {
		String requestURI = request.getRequestURI();
		
		if(requestURI!=null&& requestURI.startsWith("/static/js/dojo/1.5/dijit/nls")&& requestURI.endsWith("/common.js")){
			if (System.getProperties().getProperty("os.name").toUpperCase().indexOf("WINDOWS") != -1){
				log.info("OS is "+System.getProperties().getProperty("os.name"));
				return true ;
			}
		}
		return uriMatcher.matches(request.getRequestURI());
	}

	  protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			    throws ServletException, java.io.IOException {
			    /*if ((this.encoding != null) && ((this.forceEncoding) || (request.getCharacterEncoding() == null))) {
			      request.setCharacterEncoding(this.encoding);
			      if (this.forceEncoding) {
			        response.setCharacterEncoding(this.encoding);
			      }
			    }
			    filterChain.doFilter(request, response);*/
		        //super.doFilter(request, response, filterChain);
		        super.doFilterInternal(request, response, filterChain);
		        String characterEncoding = response.getCharacterEncoding();
		        log.info("characterEncoding is "+characterEncoding+" request path is "+request.getRequestURI());
			  }	  
	  
	static class URIMatcher {
		private List<Pattern> patterns = null;
		
		public URIMatcher() {
			patterns = new ArrayList<Pattern>();
		}

		public boolean matches(String uri) {
			boolean found = false;
			for (Pattern p : patterns) {
				Matcher m = p.matcher(uri);
				if (m.matches()) {
					found = true;
			        break;
				}
			}
			return found;
		}
		
		public List<Pattern> getPatterns() {
			return patterns;
		}
		
		public void setPatterns(String pathsStr) {
			if (pathsStr != null) {
				patterns.clear();
				String[] paths = pathsStr.split(",");
				for (int i=0; i<paths.length; i++) {
					// ignore empty strings
					if (paths[i].trim().length() > 0) {
						// We need to replace any wildcard characters with a suitable regex.
						String path = paths[i].trim().replace("*", ".*");
						Pattern p  = Pattern.compile(path, Pattern.CASE_INSENSITIVE);
						patterns.add(p);
					}
				}
			}
		}
	}

}

