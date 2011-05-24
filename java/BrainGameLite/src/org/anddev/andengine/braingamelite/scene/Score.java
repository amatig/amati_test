/***
=== BrainGame ===

Copyright (C) 2011 Giovanni Amati

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
***/

package org.anddev.andengine.braingamelite.scene;

import org.anddev.andengine.braingamelite.singleton.Enviroment;
import org.anddev.andengine.braingamelite.singleton.Resource;
import org.anddev.andengine.engine.handler.timer.ITimerCallback;
import org.anddev.andengine.engine.handler.timer.TimerHandler;
import org.anddev.andengine.entity.modifier.LoopEntityModifier;
import org.anddev.andengine.entity.modifier.ScaleModifier;
import org.anddev.andengine.entity.modifier.SequenceEntityModifier;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.entity.scene.Scene.IOnSceneTouchListener;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.entity.text.Text;
import org.anddev.andengine.input.touch.TouchEvent;

public class Score extends Scene implements IOnSceneTouchListener {
	
	public Score() {
		super(1);
		Sprite back = new Sprite(0, 0, Resource.instance().texBack2);
		getLastChild().attachChild(back);
		Sprite ptitle = new Sprite(17, 62, Resource.instance().texScore);
		getLastChild().attachChild(ptitle);
    	
    	int y = 184;
    	for (int i = 0; i < 10; i++) {
    		Text num = new Text(20, y + i * 51, Resource.instance().fontScore, Integer.toString(i + 1) + ".");
    		getLastChild().attachChild(num);
    		String text = Enviroment.toTime(Enviroment.instance().getDBValue(Integer.toString(i)));
    		Text elem = new Text(100, y + i * 51, Resource.instance().fontScore, text);
    		elem.setColor(1.0f, 1.0f, 0.6f);
    		getLastChild().attachChild(elem);
    	}
    	
    	Sprite info = new Sprite(280, 400, Resource.instance().texInfo);
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
    	
    	setOnSceneTouchListener(this);
	}
	
	@Override
	public boolean onSceneTouchEvent(Scene pScene, TouchEvent pSceneTouchEvent) {
		if (pSceneTouchEvent.isActionDown()) {
			registerUpdateHandler(new TimerHandler(0.5f, false, new ITimerCallback() {
				@Override
				public void onTimePassed(TimerHandler pTimerHandler) {
					Enviroment.instance().setScene(new MainMenu());
				}
			}));
			return true;
		}
		return false;
	}
	
}
