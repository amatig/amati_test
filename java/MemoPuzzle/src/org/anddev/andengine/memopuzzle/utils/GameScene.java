package org.anddev.andengine.memopuzzle.utils;

import org.anddev.andengine.engine.handler.timer.ITimerCallback;
import org.anddev.andengine.engine.handler.timer.TimerHandler;
import org.anddev.andengine.entity.layer.Layer;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.memopuzzle.MemoPuzzle;

public class GameScene extends Scene {
	protected MemoPuzzle mGame;
	
	public GameScene() {
		super(0);
		
		attachChild(new Layer());
		attachChild(new Layer());
		attachChild(Enviroment.instance().getScoreLayer());
		
		this.mGame = Enviroment.instance().getGame();
		
		registerUpdateHandler(new TimerHandler(1f, true, new ITimerCallback() {
			public void onTimePassed(TimerHandler pTimerHandler) {
				GameScene.this.getScoreLayer().increaseTime(1);
			}
		}));
	}
	
	public Layer getBackgroundLayer() {
		return (Layer) this.getChild(0);
	}
	
	public Layer getGameLayer() {
		return (Layer) this.getChild(1);
	}
	
	public ScoreLayer getScoreLayer() {
		return (ScoreLayer) this.getChild(2);
	}
	
	public void manageTouch(ITouchArea pTouchArea) {
		
	}

}
