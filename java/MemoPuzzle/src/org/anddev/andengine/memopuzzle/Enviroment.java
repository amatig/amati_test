package org.anddev.andengine.memopuzzle;

public class Enviroment {
	private static Enviroment mInstance = null;
	
	private Enviroment() {
		
	}
	
	public static synchronized Enviroment instance() {
		if (mInstance == null) 
			mInstance = new Enviroment();
		return mInstance;
	}
	
}
