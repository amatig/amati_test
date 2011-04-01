package org.anddev.andengine.memopuzzle.utils;

import org.anddev.andengine.engine.handler.timer.ITimerCallback;
import org.anddev.andengine.engine.handler.timer.TimerHandler;
import org.anddev.andengine.entity.layer.Layer;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.memopuzzle.MemoPuzzle;

public class GameScene extends Scene {
	protected MemoPuzzle mGame;
	
	public GameScene() {
		super(1);
		this.attachChild(Enviroment.instance().getScoreLayer());
		this.mGame = Enviroment.instance().getGame();
		
		registerUpdateHandler(new TimerHandler(1f, true, new ITimerCallback() {
			public void onTimePassed(TimerHandler pTimerHandler) {
				Enviroment.instance().getScoreLayer().increaseTime(1);
			}
		}));
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
