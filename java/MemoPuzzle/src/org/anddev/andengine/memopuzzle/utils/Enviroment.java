package org.anddev.andengine.memopuzzle.utils;

import org.anddev.andengine.entity.layer.Layer;
import org.anddev.andengine.memopuzzle.MemoPuzzle;
import org.anddev.andengine.memopuzzle.ScoreLayer;

public class Enviroment {
	private static Enviroment mInstance = null;
	
	private int mDifficult = 1;  // 0 Easy 1 Normal 2 Hard
	private MemoPuzzle mGame = null;
	private Layer mScore = null;
	
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
	
	public void setDifficult(int value) {
		this.mDifficult = value;
	}
	
	public int getDifficult() {
		return this.mDifficult;
	}
	
	public void setGame(MemoPuzzle game) {
		this.mGame = game;
		this.mScore = new ScoreLayer();
	}
	
	public MemoPuzzle getGame() {
        return this.mGame;
	}
	
	public Layer getScoreLayer() {
        return this.mScore;
	}
}
