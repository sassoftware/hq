package org.hyperic.hq.ui.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hyperic.util.StringUtil;
import org.hyperic.util.security.SecurityUtil;
import org.jasypt.encryption.pbe.PooledPBEStringEncryptor;

/**
 * Used to secret value encryption & decryption
 * 
 * @author scnrsd
 * 
 */
public class EncryptionUtil {
	
	private static Log log = LogFactory.getLog(EncryptionUtil.class.getName());
	
	private static final String SEC_ENCRYPTION_KEY = "server.encryption-key";

	public static String encrypt(String text) {
		String val = null;
		try {
			if (text != null && !"".equals(text.trim())) {
				val = SecurityUtil.encrypt(createEncryptor(), text);
			}
		} catch (Exception e) {
			log.error(e);
		}
		return val;
	}

	public static String decrypt(String text) {
		String val = null;
		try {
			if (text != null && !"".equals(text.trim())) {
				val = SecurityUtil.decrypt(createEncryptor(), text);
			}
		} catch (Exception e) {
			log.error(e);
		}
		return val;
	}

	/**
	 * Determine whether given string text is encrypted format
	 * 
	 * @param text
	 * @return
	 */
	public static boolean isMarkedEncryption(String text) {
		try {
			return SecurityUtil.isMarkedEncrypted(text);
		} catch (Exception e) {
			log.error(e);
			return false;
		}
	}

	private static PooledPBEStringEncryptor createEncryptor() {
		try {
			PooledPBEStringEncryptor encryptor = new PooledPBEStringEncryptor();
			encryptor.setPoolSize(1);
			encryptor.setAlgorithm(SecurityUtil.DEFAULT_ENCRYPTION_ALGORITHM);
			encryptor.setPassword(getKeyvalsPass());
			return encryptor;
		} catch (Exception e) {
			log.error(e);
			return null;
		}
	}

	/**
	 * Get encryption key server.encryption-key from HQ server configure:
	 * conf/hq-server.conf
	 * 
	 * @return
	 * @throws IOException
	 */
	private static String getKeyvalsPass() throws IOException {
		File file = new File(StringUtil.normalizePath("conf/hq-server.conf"));
		String val = null;
		if (file.exists()) {
			Properties prop = new Properties();
			FileInputStream fi = null;
			try {
				fi = new FileInputStream(file.getAbsolutePath());
				prop.load(fi);
			} catch (IOException ioe) {
				log.error(ioe);
			} finally {
				if (fi != null) {
					try {
						fi.close();
					} catch (IOException e) {
						log.error(e);
					}
				}
			}
			val = prop.getProperty(SEC_ENCRYPTION_KEY);
		}
		return val;
	}

}
