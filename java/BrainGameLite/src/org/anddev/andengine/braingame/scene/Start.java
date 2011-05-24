/***
=== BrainGame ===

Copyright (C) 2011 Giovanni Amati

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
***/

package org.anddev.andengine.braingame.scene;

import org.anddev.andengine.braingame.singleton.Enviroment;
import org.anddev.andengine.braingame.singleton.Resource;
import org.anddev.andengine.braingame.util.MyChangeableText;
import org.anddev.andengine.braingame.util.MySound;
import org.anddev.andengine.engine.handler.timer.ITimerCallback;
import org.anddev.andengine.engine.handler.timer.TimerHandler;
import org.anddev.andengine.entity.IEntity;
import org.anddev.andengine.entity.modifier.LoopEntityModifier;
import org.anddev.andengine.entity.modifier.MoveXModifier;
import org.anddev.andengine.entity.modifier.ScaleModifier;
import org.anddev.andengine.entity.modifier.SequenceEntityModifier;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.entity.scene.Scene.IOnAreaTouchListener;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.entity.text.Text;
import org.anddev.andengine.input.touch.TouchEvent;

public class Start extends Scene implements IOnAreaTouchListener {
	private int mTimeRemaining;
	private MyChangeableText mText;
	private MySound mBeep;
	
	public Start() {
		super(1);
		Enviroment.instance().createScoreLayer(); // create new score
		
		this.mBeep = Resource.instance().getSound("beep");
		
    	Sprite back = new Sprite(0, 0, Resource.instance().texBack2);
    	getLastChild().attachChild(back);
    	
    	Sprite ptitle = new Sprite(15, 62, Resource.instance().texTitlePlayer);
    	getLastChild().attachChild(ptitle);
    	
    	int player = Enviroment.instance().getCurrentPlayer();
    	Text playerText = new Text(320, 97, Resource.instance().fontPlayer, Integer.toString(player));
		playerText.setColor(1f, 0.7f, 0.7f);
		getLastChild().attachChild(playerText);
		
		Sprite prof = new Sprite(0, 300, Resource.instance().texLavagnaProf);
		getLastChild().attachChild(prof);
    	
    	Sprite eyes = new Sprite(364, 423, Resource.instance().texEyes);
    	eyes.registerEntityModifier(
				new LoopEntityModifier(
						null, 
						-1, 
						null,
						new SequenceEntityModifier(
								new MoveXModifier(0.5f, eyes.getX(), eyes.getX() - 2f),
								new MoveXModifier(1f, eyes.getX(), eyes.getX() + 2f)
						)
				)
		);
    	getLastChild().attachChild(eyes);
    	
    	Sprite info = new Sprite(180, 555, Resource.instance().texInfo);
    	info.registerEntityModifier(
				new LoopEntityModifier(
						null, 
						-1, 
						null,
						new SequenceEntityModifier(
								new ScaleModifier(0.5f, 1.1f, 1.2f),
								new ScaleModifier(0.5f, 1.2f, 1.1f)
						)
				)
		);
    	getLastChild().attachChild(info);
    	
		Text startText = new Text(49, 375, Resource.instance().fontStart, "Go");
		/*startText.registerEntityModifier(
				new LoopEntityModifier(
						null, 
						-1, 
						null,
						new SequenceEntityModifier(
								new ScaleModifier(0.3f, 1f, 1.3f),
								new ScaleModifier(0.3f, 1.3f, 1f)
						)
				)
		);*/
		getLastChild().attachChild(startText);
		registerTouchArea(startText); // reg touch
		
		setOnAreaTouchListener(this);
	}
	
	@Override
	public boolean onAreaTouched(TouchEvent pSceneTouchEvent, ITouchArea pTouchArea, float pTouchAreaLocalX, float pTouchAreaLocalY) {
		if (pSceneTouchEvent.isActionDown()) {
			manageTouch(pTouchArea);
			return true;
		}
		return false;
	}
	
	public void manageTouch(ITouchArea pTouchArea) {
		IEntity startText = (IEntity)pTouchArea;
		unregisterTouchArea(pTouchArea);
		getLastChild().detachChild(startText);
		
		Start.this.mBeep.play();
    	this.mTimeRemaining = 3;
    	
    	this.mText = new MyChangeableText(65, 350, Resource.instance().fontCountDown, Integer.toString(Start.this.mTimeRemaining), 1);
    	this.mText.registerEntityModifier(
				new ScaleModifier(0.3f, 0f, 1f)
		);
    	getLastChild().attachChild(this.mText);
    	
    	registerUpdateHandler(new TimerHandler(1f, true, new ITimerCallback() {
    		@Override
			public void onTimePassed(TimerHandler pTimerHandler) {
				Start.this.mTimeRemaining--;
				if (Start.this.mTimeRemaining == 0)
					Enviroment.instance().nextScene();
				else {
					Start.this.mBeep.play();
					Start.this.mText.setText(Integer.toString(Start.this.mTimeRemaining));
					if (Start.this.mTimeRemaining == 1)
						Start.this.mText.setPosition(Start.this.mText.getX() + 30, Start.this.mText.getY() + 10); // fix num 1
					Start.this.mText.registerEntityModifier(
							new ScaleModifier(0.3f, 0f, 1f)
					);
				}
			}
		}));
	}
	
}
