package org.anddev.andengine.memopuzzle.game;

import org.anddev.andengine.engine.handler.timer.ITimerCallback;
import org.anddev.andengine.engine.handler.timer.TimerHandler;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.entity.scene.background.ColorBackground;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.entity.text.Text;
import org.anddev.andengine.memopuzzle.utils.Enviroment;
import org.anddev.andengine.memopuzzle.utils.MyChangeableText;

public class StartScene extends Scene {
	private int timeRemaining;
	private MyChangeableText mText;
	
	public StartScene() {
		super(1);
		Enviroment.instance().createScoreLayer();
		
		setBackground(new ColorBackground(0.9f, 0.5f, 0.5f));
		
    	Sprite back = new Sprite(0, 0, Enviroment.instance().texBack);
    	back.setScale(0.95f);
    	attachChild(back);
    	
    	Text playerText = new Text(100, 195, Enviroment.instance().fontPlayer, "Player 1");
		playerText.setColor(0.6f, 0.7f, 1.0f);
		attachChild(playerText);
		
    	this.timeRemaining = 3;
    	
    	this.mText = new MyChangeableText(145, 305, Enviroment.instance().fontCountDown, Integer.toString(this.timeRemaining), 1);
    	this.mText.setColor(1.0f, 1.0f, 0.5f);
		attachChild(this.mText);
    	
    	registerUpdateHandler(new TimerHandler(1.5f, true, new ITimerCallback() {
			public void onTimePassed(TimerHandler pTimerHandler) {
				StartScene.this.timeRemaining--;
				if (StartScene.this.timeRemaining == 0)
					Enviroment.instance().getGame().nextScene();
				else
			    	StartScene.this.mText.setText(Integer.toString(StartScene.this.timeRemaining));
			}
		}));
	}
	
}
