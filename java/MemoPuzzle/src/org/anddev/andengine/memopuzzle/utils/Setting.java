package org.anddev.andengine.memopuzzle.utils;

public class Setting {
	private static Setting mInstance = null;
	
	// setting game sum box
	private int mSumBoxSetting1[];
	private int mSumBoxSetting2[];
	
	private Setting() {
		
	}
	
	public static synchronized Setting instance() {
		if (mInstance == null) 
			mInstance = new Setting();
		return mInstance;
	}

	public void setSumBoxSetting1(int setting1[]) {
		this.mSumBoxSetting1 = setting1;
	}

	public int[] getSumBoxSetting1() {
		return this.mSumBoxSetting1;
	}

	public void setSumBoxSetting2(int setting2[]) {
		this.mSumBoxSetting2 = setting2;
	}

	public int[] getSumBoxSetting2() {
		return this.mSumBoxSetting2;
	}
	
}
