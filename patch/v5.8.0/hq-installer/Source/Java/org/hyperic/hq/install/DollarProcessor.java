package org.hyperic.hq.install;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;

import org.hyperic.util.config.EarlyExitException;

public class DollarProcessor {

	public static String escapeDollar(String dolstr) {
		StringBuffer sb = new StringBuffer();
		char[] chars = dolstr.toCharArray();

		for (int i = 0; i < chars.length; i++) {
			sb.append(chars[i]);
			if (chars[i] == '$') {
				sb.append('$');
			}
		}
		return sb.toString();
	}

	
	public static String unEscapeDollar(String dolstr) {
		StringBuffer sb = new StringBuffer();
		char[] chars = dolstr.toCharArray();
		boolean isPreviousDollar = false ;

		for (int i = 0; i < chars.length; i++) {
			if(isPreviousDollar){
				isPreviousDollar = false;
				if(chars[i] != '$'){
					throw new EarlyExitException("The dollar-escaped password is not valid. The $ must appear in pair.");
				}
			}else{
				sb.append(chars[i]);
				if (chars[i] == '$') {
					isPreviousDollar = true;
				}

			}
			
		}
		if(isPreviousDollar){
			throw new EarlyExitException("The dollar-escaped password is not valid. The $ must appear in pair.");
		}
		return sb.toString();
	}

	public static void main(String[] args) {
		String setupPath = null;
		if (args.length == 0) {
			setupPath = "./out.properties";
		} else {
			setupPath = args[0];
		}

		Properties p = new Properties();
		try {
			p.load(new FileInputStream(setupPath));
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		System.out.println(p.get("server.database-password"));

		String x = (String) p.get("server.database-password");
		
		if(x==null)
			return ;
		
		String escapedPass = escapeDollar(x);
		
		p.setProperty("server.database-password", escapedPass);
		
		try {
			p.store(new FileOutputStream(setupPath), null);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}
