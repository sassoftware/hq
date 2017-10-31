package org.hyperic.hq.measurement.server.session;

import java.util.HashMap;
import java.util.Map;

import org.hyperic.hq.appdef.shared.AppdefEntityID;

public class GlobalTime {
 private static Map<AppdefEntityID,Long> hm = new HashMap();
 public static void put(AppdefEntityID aeid, Long time){
	 hm.put(aeid, time);
 }
 public static Long get(AppdefEntityID aeid){
	 return hm.get(aeid);
 }
}
