package org.anddev.andengine.memopuzzle.utils;

import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.memopuzzle.MemoPuzzle;

public class MyGameScene extends Scene {
	protected MemoPuzzle mGame;
	
	public MyGameScene() {
		super(1);
		this.attachChild(Enviroment.instance().getScoreLayer());
		this.mGame = Enviroment.instance().getGame();
	}

	public void manageTouch(ITouchArea pTouchArea) {
		
	}

}
