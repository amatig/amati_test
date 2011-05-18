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
import org.anddev.andengine.entity.modifier.MoveXModifier;
import org.anddev.andengine.entity.modifier.ScaleModifier;
import org.anddev.andengine.entity.modifier.SequenceEntityModifier;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.entity.scene.Scene.IOnSceneTouchListener;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.entity.text.Text;
import org.anddev.andengine.input.touch.TouchEvent;

public class End extends Scene implements IOnSceneTouchListener {
	
	public End() {
		super(1);
		Sprite back = new Sprite(0, 0, Resource.instance().texBack2);
		attachChild(back);
		Sprite ptitle = new Sprite(17, 62, Resource.instance().texTitleFinish);
    	attachChild(ptitle);
    	
		Sprite lav = new Sprite(0, 300, Resource.instance().texLavagna);
		Sprite prof = new Sprite(0, 300, Resource.instance().texLavagnaProf);
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
    	
    	int p1 = -115;
		int p2 = 115;
		int adjust1 = 0;
		int adjust2 = 0;
		
    	if (Enviroment.instance().getNumPlayers() == 2) {
    		int win = p1;
    		int lose = p2;
        	
    		if (Enviroment.instance().getTimeP1() > Enviroment.instance().getTimeP2()) {
    			adjust1 = -10;
    			adjust2 = -7;
    			win = p2 - 15;
    			lose = p1;
    		} else if (Enviroment.instance().getTimeP1() == Enviroment.instance().getTimeP2()) {
    			if (Enviroment.instance().getErrorP1() > Enviroment.instance().getErrorP2()) {
    				adjust1 = -10;
        			adjust2 = -7;
    				win = p2 - 15;
        			lose = p1;
    			}
    		}
    		prof.setPosition(prof.getX(), prof.getY() + win);
    		eyes.setPosition(eyes.getX(), eyes.getY() + win);
    		
    		lav.setPosition(lav.getX(), lav.getY() + lose);
    		
    		attachChild(prof);
        	attachChild(eyes);
        	attachChild(lav);
    	} else {
    		adjust1 = 115;
    		attachChild(prof);
        	attachChild(eyes);
    	}
    	
    	Enviroment.instance().addScore(Enviroment.instance().getTimeP1());
    	String time1 = Enviroment.toTime(Enviroment.instance().getTimeP1());
    	Text timeP1 = new Text(60, 254 + adjust1, Resource.instance().fontTimeP1, time1);
    	Text errorP1 = new Text(60, 324 + adjust1, Resource.instance().fontErrorP1, Integer.toString(Enviroment.instance().getErrorP1()) + " Err");
    	
    	attachChild(timeP1);
    	attachChild(errorP1);
    	Text lp1 = new Text(40, 180 + adjust1, Resource.instance().fontPlayer2, "P1");
    	if (adjust1 >= 0) {
    		lp1.registerEntityModifier(
    				new LoopEntityModifier(
    						null, 
    						-1, 
    						null,
    						new SequenceEntityModifier(
    								new ScaleModifier(0.3f, 1f, 1.08f),
    								new ScaleModifier(0.3f, 1.08f, 1f)
    						)
    				)
    		);
    	}
		lp1.setColor(1f, 0.7f, 0.7f);
		attachChild(lp1);
    	
    	if (Enviroment.instance().getNumPlayers() == 2) {
    		Enviroment.instance().addScore(Enviroment.instance().getTimeP2());
    		String time2 = Enviroment.toTime(Enviroment.instance().getTimeP2());
        	Text timeP2 = new Text(60, 475 + adjust2, Resource.instance().fontTimeP2, time2);
        	Text errorP2 = new Text(60, 545 + adjust2, Resource.instance().fontErrorP2, Integer.toString(Enviroment.instance().getErrorP2()) + " Err");
        	
    		attachChild(timeP2);
    		attachChild(errorP2);
    		Text lp2 = new Text(40, 401 + adjust2, Resource.instance().fontPlayer2, "P2");
    		if (adjust1 < 0) {
        		lp2.registerEntityModifier(
        				new LoopEntityModifier(
        						null, 
        						-1, 
        						null,
        						new SequenceEntityModifier(
        								new ScaleModifier(0.3f, 1f, 1.08f),
        								new ScaleModifier(0.3f, 1.08f, 1f)
        						)
        				)
        		);
        	}
    		lp2.setColor(1f, 0.7f, 0.7f);
    		attachChild(lp2);
    	}
    	
    	setOnSceneTouchListener(this);
	}

	@Override
	public boolean onSceneTouchEvent(Scene pScene, TouchEvent pSceneTouchEvent) {
		if (pSceneTouchEvent.isActionDown()) {
			registerUpdateHandler(new TimerHandler(3f, false, new ITimerCallback() {
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
