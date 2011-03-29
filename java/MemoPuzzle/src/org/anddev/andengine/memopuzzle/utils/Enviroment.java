package org.anddev.andengine.memopuzzle.utils;

public class Enviroment {
	private static Enviroment mInstance = null;
	
	private Enviroment() {
		
	}
	
	public static synchronized Enviroment instance() {
		if (mInstance == null) 
			mInstance = new Enviroment();
		return mInstance;
	}
	
	public static int random(int min, int max) {
		int range = max - min + 1;
    	int value = (int)(range * Math.random()) + min;
    	return value;
	}
	
}
