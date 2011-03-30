package org.anddev.andengine.memopuzzle.utils;

import org.anddev.andengine.entity.layer.Layer;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.memopuzzle.MemoPuzzle;

public class MyGameScene extends Scene {
	protected MemoPuzzle mGame;
	
	public MyGameScene(MemoPuzzle game, Layer score) {
		super(1);
		this.mGame = game;
		this.attachChild(score);
	}

	public void manageTouch(ITouchArea pTouchArea) {
		
	}

}
