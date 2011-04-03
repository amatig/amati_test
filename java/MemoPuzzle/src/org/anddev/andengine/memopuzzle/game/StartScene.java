package org.anddev.andengine.memopuzzle.game;

import org.anddev.andengine.engine.handler.timer.ITimerCallback;
import org.anddev.andengine.engine.handler.timer.TimerHandler;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.entity.scene.background.ColorBackground;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.memopuzzle.utils.Enviroment;

public class StartScene extends Scene {
	
	public StartScene() {
		super(1);
		Enviroment.instance().createScoreLayer();
		
		setBackground(new ColorBackground(1f, 1f, 1f));
		
    	Sprite back = new Sprite(0, 0, Enviroment.instance().texBack2);
    	back.setScale(0.95f);
    	attachChild(back);
    	
    	registerUpdateHandler(new TimerHandler(3f, true, new ITimerCallback() {
			public void onTimePassed(TimerHandler pTimerHandler) {
				Enviroment.instance().getGame().nextScene();
			}
		}));
	}
	
}
