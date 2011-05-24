/***
=== BrainGame ===

Copyright (C) 2011 Giovanni Amati

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
***/

package org.anddev.andengine.braingamelite.util;

import org.anddev.andengine.braingamelite.BrainGameLite;
import org.anddev.andengine.braingamelite.layer.FadeLayer;
import org.anddev.andengine.braingamelite.layer.ScoreLayer;
import org.anddev.andengine.braingamelite.singleton.Enviroment;
import org.anddev.andengine.braingamelite.singleton.Resource;
import org.anddev.andengine.engine.handler.timer.ITimerCallback;
import org.anddev.andengine.engine.handler.timer.TimerHandler;
import org.anddev.andengine.entity.layer.Layer;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.entity.scene.Scene.IOnAreaTouchListener;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.input.touch.TouchEvent;

public class MyScene extends Scene implements IOnAreaTouchListener  {
	protected BrainGameLite mGame;
	
	public MyScene() {
		super(0);
		
		this.mGame = Enviroment.instance().getGame();
		
		attachChild(new Layer());
		attachChild(new Layer());
		attachChild(new Layer());
		attachChild(Enviroment.instance().getScoreLayer());
		attachChild(new FadeLayer());
		
		registerUpdateHandler(new TimerHandler(1f, true, new ITimerCallback() {
			@Override
			public void onTimePassed(TimerHandler pTimerHandler) {
				MyScene.this.getScoreLayer().updateTime();
			}
		}));
		
        setOnAreaTouchListener(this);
        
        // background
        Sprite back = new Sprite(0, 0, Resource.instance().texBack2);
		//back.setAlpha(0.8f);
		getBackgroundLayer().attachChild(back);
	}
	
	public void start() {
		
	}
	
	public Layer getBackgroundLayer() {
		return (Layer) this.getChild(0);
	}
	
	public Layer getGameLayer() {
		return (Layer) this.getChild(1);
	}
	
	public Layer getExtraGameLayer() {
		return (Layer) this.getChild(2);
	}
	
	public ScoreLayer getScoreLayer() {
		return (ScoreLayer) this.getChild(3);
	}
	
	public FadeLayer getFadeLayer() {
		return (FadeLayer) this.getChild(4);
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
		
	}

}
