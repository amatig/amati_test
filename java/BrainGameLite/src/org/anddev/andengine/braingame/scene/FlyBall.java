/***
=== BrainGame ===

Copyright (C) 2011 Giovanni Amati

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
***/

package org.anddev.andengine.braingame.scene;

import java.util.Collections;
import java.util.LinkedList;

import org.anddev.andengine.braingame.singleton.Enviroment;
import org.anddev.andengine.braingame.singleton.Resource;
import org.anddev.andengine.braingame.util.MyScene;
import org.anddev.andengine.braingame.util.MySound;
import org.anddev.andengine.engine.handler.timer.ITimerCallback;
import org.anddev.andengine.engine.handler.timer.TimerHandler;
import org.anddev.andengine.entity.IEntity;
import org.anddev.andengine.entity.modifier.LoopEntityModifier;
import org.anddev.andengine.entity.modifier.PathModifier;
import org.anddev.andengine.entity.modifier.ScaleModifier;
import org.anddev.andengine.entity.modifier.SequenceEntityModifier;
import org.anddev.andengine.entity.modifier.PathModifier.IPathModifierListener;
import org.anddev.andengine.entity.modifier.PathModifier.Path;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.entity.text.Text;
import org.anddev.andengine.extension.physics.box2d.PhysicsConnector;
import org.anddev.andengine.extension.physics.box2d.PhysicsFactory;
import org.anddev.andengine.extension.physics.box2d.PhysicsWorld;
import org.anddev.andengine.extension.physics.box2d.util.Vector2Pool;
import org.anddev.andengine.util.modifier.ease.EaseSineInOut;

import android.hardware.SensorManager;

import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.physics.box2d.Body;
import com.badlogic.gdx.physics.box2d.FixtureDef;
import com.badlogic.gdx.physics.box2d.BodyDef.BodyType;

public class FlyBall extends MyScene {
	private int mNum;
	private PhysicsWorld mPhysicsWorld;
	private MySound mLaunch;
	private Sprite mTubo1;
	private Sprite mTubo2;
	
	private LinkedList<Integer> mListValue;
	private int mDiff;
	
	public FlyBall(LinkedList<Integer> aListValue, int aDiff) {
		super();
		getBackgroundLayer().getLastChild().setColor(1f, 0.8f, 0.8f);
		
		this.mLaunch = Resource.instance().getSound("launch");
		
		// difficult
		this.mNum = 0;
    	switch (Enviroment.instance().getDifficult()) {
    		case 0: this.mNum = 8; break;
    		case 1: this.mNum = 10; break;
    		case 2: this.mNum = 12; break;
    	}
    	
    	// fisica
    	this.mPhysicsWorld = new PhysicsWorld(new Vector2(0, SensorManager.GRAVITY_EARTH), false);
    	
		// dati
    	if (aListValue == null) {
    		this.mListValue = new LinkedList<Integer>();
    		int red = this.mNum / 2;
    		int blue = red;
    		
    		this.mDiff = Enviroment.random(0, 2);
    		if (this.mDiff != 0) {
    			int move = 1;
    			if (Enviroment.instance().getDifficult() != 0)
        			move = Enviroment.random(1, 2);
    			if (this.mDiff == 1) {
    				red += move;
    	    		blue -= move;
    			} else {
    				red -= move;
    	    		blue += move;
    			}
    		}
    		for (int i = 0; i < red; i++) {
    			this.mListValue.add(new Integer(0));
    			if (Enviroment.instance().getDifficult() != 0 && Enviroment.random(0, 2) == 1)
    				this.mListValue.add(new Integer(2));
    		}
    		for (int i = 0; i < blue; i++) {
    			this.mListValue.add(new Integer(1));
    			if (Enviroment.instance().getDifficult() != 0 && Enviroment.random(0, 2) == 1)
    				this.mListValue.add(new Integer(2));
    		}
    		Collections.shuffle(this.mListValue);
    	} else {
    		this.mDiff = aDiff;
    		this.mListValue = aListValue;
    	}
    	
    	// label
    	Sprite quad = new Sprite(21, 133, Resource.instance().texQuad);
    	Text look = new Text(29, 27, Resource.instance().fontBall, "Which are more?");
		quad.attachChild(look);
		getGameLayer().attachChild(quad);
		
        // physics
        registerUpdateHandler(this.mPhysicsWorld);
        
        this.mTubo1 = new Sprite(25, 650, Resource.instance().texTubo2);
		Sprite tuboFront1 = new Sprite(0, 0, Resource.instance().texTubo);
		this.mTubo1.attachChild(tuboFront1);
		this.mTubo1.setScale(0.7f, 0.9f);
		this.mTubo1.getFirstChild().setColor(0.8f, 0.8f, 0.8f);
		this.mTubo1.setRotation(9f);
		
		this.mTubo2 = new Sprite(350, 650, Resource.instance().texTubo2);
		Sprite tuboFront2 = new Sprite(0, 0, Resource.instance().texTubo);
		this.mTubo2.attachChild(tuboFront2);
		this.mTubo2.setScale(0.7f, 0.9f);
		this.mTubo2.getFirstChild().setColor(0.8f, 0.8f, 0.8f);
		this.mTubo2.setRotation(-9f);
		
		getGameLayer().attachChild(this.mTubo1);
		getGameLayer().attachChild(this.mTubo2);
		
		if (Enviroment.instance().getDifficult() == 2) {
			Sprite cloud1 = new Sprite(0, 0, Resource.instance().texCloud);
			Sprite cloud2 = new Sprite(0, 0, Resource.instance().texCloud);
			Path path1 = new Path(3).to(15, 360).to(Enviroment.CAMERA_WIDTH - 260, 360).to(10, 360);
			Path path2 = new Path(3).to(Enviroment.CAMERA_WIDTH - 260, 500).to(15, 500).to(Enviroment.CAMERA_WIDTH - 260, 500);
			cloud1.registerEntityModifier(new LoopEntityModifier(new PathModifier(10, path1, null, new IPathModifierListener() {
				@Override
				public void onWaypointPassed(final PathModifier pPathModifier, final IEntity pEntity, final int pWaypointIndex) {
				}
			}, EaseSineInOut.getInstance())));
			cloud2.registerEntityModifier(new LoopEntityModifier(new PathModifier(5, path2, null, new IPathModifierListener() {
				@Override
				public void onWaypointPassed(final PathModifier pPathModifier, final IEntity pEntity, final int pWaypointIndex) {
				}
			}, EaseSineInOut.getInstance())));
			cloud1.setScale(0.9f);
			cloud2.setScale(0.9f);
			getExtraGameLayer().attachChild(cloud1);
			getExtraGameLayer().attachChild(cloud2);
		}
	}
	
	public void start() {
		// add ball
		for (int i = 0; i < this.mListValue.size(); i++)
			registerUpdateHandler(new TimerHandler(1f + i * 0.85f, false, new ITimerCallback() {
				@Override
				public void onTimePassed(TimerHandler pTimerHandler) {
					int i = (int) (pTimerHandler.getTimerSeconds() / 0.85f) - 1;
					addBall(FlyBall.this.mListValue.get(i).intValue(), i);
				}
				
			}));
		
		registerUpdateHandler(new TimerHandler(0.5f + this.mListValue.size(), false, new ITimerCallback() {
			@Override
			public void onTimePassed(TimerHandler pTimerHandler) {
				FlyBall.this.showSolutions();
			}
		}));
	}
	
	private void showSolutions() {
		int x = 89;
		int y = 122;
		int space = 101;
		float size = 1.1f;
		Sprite ball1 = new Sprite(x, y, Resource.instance().texStep);
		ball1.setColor(1f, 0.2f, 0.2f);
		Text equal = new Text(x + 17 + 1 * space, y + 3, Resource.instance().fontBall, "=");
		Sprite ball2 = new Sprite(x + 2 * space, y, Resource.instance().texStep);
		ball2.setColor(0.2f, 0.2f, 1f);
		
		ball1.registerEntityModifier(
				new ScaleModifier(0.3f, 0f, size)
		);
		ball2.registerEntityModifier(
				new ScaleModifier(0.3f, 0f, size)
		);
		equal.registerEntityModifier(
				new ScaleModifier(0.3f, 0f, size + 0.7f)
		);
		registerTouchArea(ball1);
		registerTouchArea(ball2);
		registerTouchArea(equal);
		getGameLayer().getFirstChild().attachChild(ball1);
		getGameLayer().getFirstChild().attachChild(equal);
		getGameLayer().getFirstChild().attachChild(ball2);
	}
	
	private void addBall(int value, int pos) {
		final Sprite ball = new Sprite(0, 0, Resource.instance().texStep);
		
		int x = 54;
		int angle = 2;
		int lato = -1;
		
		if (value == 2)
			lato =  Enviroment.random(0, 1);
		else
			lato = value;
		
		if (lato == 0) {
			this.mTubo1.registerEntityModifier(
					new SequenceEntityModifier(
							new ScaleModifier(0.2f, 0.7f, 0.8f, 0.9f, 1f),
							new ScaleModifier(0.2f, 0.8f, 0.7f, 1f, 0.9f)
					));
			if (value == 0)
				ball.setColor(1f, 0.2f, 0.2f);
			else
				ball.setColor(0.2f, 1f, 0.2f);
		} else {
			this.mTubo2.registerEntityModifier(
					new SequenceEntityModifier(
							new ScaleModifier(0.2f, 0.7f, 0.8f, 0.9f, 1f),
							new ScaleModifier(0.2f, 0.8f, 0.7f, 1f, 0.9f)
					));
			angle *= -1;
			x = 372;
			if (value == 1)
				ball.setColor(0.2f, 0.2f, 1f);
			else
				ball.setColor(0.2f, 1f, 0.2f);
		}
		ball.setPosition(x, 633);
		
    	FixtureDef objectFixtureDef = PhysicsFactory.createFixtureDef(1, 1f, 0f, false, (short)(pos + 1), (short)0, (short)0);
    	Body bodyBox = PhysicsFactory.createCircleBody(this.mPhysicsWorld, ball, BodyType.DynamicBody, objectFixtureDef); 	
    	this.mPhysicsWorld.registerPhysicsConnector(new PhysicsConnector(ball, bodyBox, true, false)); // false update la rotazione
    	
    	getGameLayer().attachChild(ball);
    	
    	Vector2 velocity = Vector2Pool.obtain(angle, -15);
    	bodyBox.setLinearVelocity(velocity);
		Vector2Pool.recycle(velocity);
		
		this.mLaunch.play();
	}
	
	@Override
	public void manageTouch(ITouchArea pTouchArea) {
		IEntity click = (IEntity) pTouchArea;
		
		boolean cond = false;
		if (click.getRed() == 1f && click.getBlue() == 0.2f && this.mDiff == 1)
			cond = true;
		else if (click.getRed() == 0.2f && click.getBlue() == 1f && this.mDiff == 2)
			cond = true;
		else if (click.getRed() == 1f && click.getBlue() == 1f && this.mDiff == 0)
			cond = true;
		
    	if (cond == false)
    		Resource.instance().fail(new FlyBall(this.mListValue, this.mDiff));
    	else
    		Resource.instance().done();
	}
	
}
