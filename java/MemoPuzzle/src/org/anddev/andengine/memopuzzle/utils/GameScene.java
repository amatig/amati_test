package org.anddev.andengine.memopuzzle.utils;

import org.anddev.andengine.entity.layer.Layer;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.memopuzzle.MemoPuzzle;

public class GameScene extends Scene {
	protected MemoPuzzle mGame;
	
	public GameScene() {
		super(1);
		this.attachChild(Enviroment.instance().getScoreLayer());
		this.mGame = Enviroment.instance().getGame();
	}
	
	public Layer getGameLayer() {
		return (Layer) getFirstChild();
	}
	
	public ScoreLayer getScoreLayer() {
		return (ScoreLayer) getLastChild();
	}
	
	public void manageTouch(ITouchArea pTouchArea) {
		
	}

}
