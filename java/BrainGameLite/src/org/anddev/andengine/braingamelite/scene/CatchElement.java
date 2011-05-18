/***
=== BrainGame ===

Copyright (C) 2011 Giovanni Amati

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
***/

package org.anddev.andengine.braingamelite.scene;

import java.util.Collections;
import java.util.LinkedList;

import org.anddev.andengine.braingamelite.singleton.Enviroment;
import org.anddev.andengine.braingamelite.singleton.Resource;
import org.anddev.andengine.braingamelite.utils.MyScene;
import org.anddev.andengine.braingamelite.utils.MySound;
import org.anddev.andengine.engine.handler.timer.ITimerCallback;
import org.anddev.andengine.engine.handler.timer.TimerHandler;
import org.anddev.andengine.entity.IEntity;
import org.anddev.andengine.entity.modifier.MoveYModifier;
import org.anddev.andengine.entity.modifier.RotationModifier;
import org.anddev.andengine.entity.modifier.ScaleModifier;
import org.anddev.andengine.entity.modifier.SequenceEntityModifier;
import org.anddev.andengine.entity.modifier.IEntityModifier.IEntityModifierListener;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.entity.text.Text;
import org.anddev.andengine.util.modifier.IModifier;

public class CatchElement extends MyScene {
	private int mNum;
	private LinkedList<Integer> mSeqValue;
	private MySound mOk;
	
	private LinkedList<Integer> mListValue;
	
	public CatchElement(LinkedList<Integer> aListValue) {
		super();
		getBackgroundLayer().getLastChild().setColor(1f, 1f, 0.6f);
		
		this.mOk = Resource.instance().getSound("ok");
		
		// difficult
    	this.mNum = 0;
    	switch (Enviroment.instance().getDifficult()) {
    		case 0: this.mNum = 3; break;
    		case 1: this.mNum = 4; break;
    		case 2: this.mNum = 5; break;
    	}
		
		// dati
		this.mSeqValue = new LinkedList<Integer>();
		
		if (aListValue == null) {
			this.mListValue = new LinkedList<Integer>();
			while (this.mListValue.size() < this.mNum - 1) {
				int index = Enviroment.random(0, 7); // angolazioni
				if (!this.mListValue.contains(new Integer(index * 45))) {
					this.mListValue.add(new Integer(index * 45));
					this.mSeqValue.add(new Integer(index * 45));
				}
			}
		} else {
			this.mListValue = aListValue;
			for (int i = 0; i < aListValue.size(); i++)
    			this.mSeqValue.add(aListValue.get(i));
		}
		
		Sprite quad = new Sprite(21, 133, Resource.instance().texQuad);
    	Text look = new Text(59, 23, Resource.instance().fontCatch, "Catch these");
		quad.attachChild(look);
		getGameLayer().attachChild(quad);
		
    	// add tube
		for (int i = 0; i < this.mNum; i++) {
			int n = (this.mNum - (int)(this.mNum / 2));
			int x = i % n;
			int y = (int)(i / n);
			
			int adjust = 0;
			if (Enviroment.instance().getDifficult() == 0) { 
				if (y == 0)
					adjust = 56;
				else
					adjust = 120;
			} else if (Enviroment.instance().getDifficult() == 1) {
				adjust = 56;
			} else if (Enviroment.instance().getDifficult() == 2) { 
				if (y == 0)
					adjust = -10;
				else
					adjust = 56;
			}
			
			Sprite tubo = new Sprite(61 + x * 135 + adjust, 450 + y * 135, Resource.instance().texTubo2);
			Sprite tuboFront = new Sprite(0, 0, Resource.instance().texTubo);
			tuboFront.setColor(1f, 0.4f, 0.4f);
			Sprite paletta = new Sprite(4, 3, Resource.instance().texPaletta);
			tubo.attachChild(paletta);
			tubo.attachChild(tuboFront);
			tubo.setScale(1.2f);
			getGameLayer().attachChild(tubo);
		}
    	
	}
	
	public void start() {
		// add sequence
    	for (int i = 0; i < this.mListValue.size(); i++) {
			registerUpdateHandler(new TimerHandler(0.1f + i, false, new ITimerCallback() {
				@Override
				public void onTimePassed(TimerHandler pTimerHandler) {
					int i = (int)pTimerHandler.getTimerSeconds();
					int angle = CatchElement.this.mListValue.get(i).intValue();
					CatchElement.this.addSequence(angle, i);
				}
			}));
		}
    	
    	// show solutions
    	registerUpdateHandler(new TimerHandler(3.5f, true, new ITimerCallback() {
			@Override
			public void onTimePassed(TimerHandler pTimerHandler) {
				CatchElement.this.showElemsToClick();
			}
    	}));
	}
	
	private void addSequence(int angle, int i) {
		int adjust = 0;
		if (Enviroment.instance().getDifficult() == 1) {
			adjust = -50;
		} else if (Enviroment.instance().getDifficult() == 2) { 
			adjust = -97;
		}
		final Sprite elem = new Sprite(147 + i * 100 + adjust, 244, Resource.instance().texArrow);
		elem.setRotation(angle);
		
		float[][] color = Resource.instance().getColor();
		int index = (int)(angle / 45);
		elem.setColor(color[index][0], color[index][1], color[index][2]);
		elem.registerEntityModifier(
				new ScaleModifier(0.3f, 0f, 1f)
		);
		
		getGameLayer().attachChild(elem);
	}
	
	private void showElemsToClick() {
		LinkedList<Integer> temp = new LinkedList<Integer>();
		while (temp.size() < this.mNum) {
			Integer angle = null;
			if (temp.size() == 0)
				angle = this.mSeqValue.get(Enviroment.random(0, this.mSeqValue.size() - 1)); // almeno uno della soluzione
			else
				angle = new Integer(Enviroment.random(0, 7) * 45);
			
			if (!temp.contains(angle))
				temp.add(angle); // per non far ripetere un random
		}
		Collections.shuffle(temp);
		
		for (int i = 0; i < temp.size(); i++) {
			final IEntity paletta = getGameLayer().getChild(getGameLayer().getChildCount() - this.mListValue.size() - i - 1).getFirstChild();
			
			final Sprite elem = new Sprite(9, 8, Resource.instance().texArrow);
			elem.setRotation(temp.get(i).intValue());
			
			float[][] color = Resource.instance().getColor();			
			int index = 0;
			if (Enviroment.instance().getDifficult() == 2)
				index = Enviroment.random(0, 8);
			else
				index = (int)(temp.get(i).intValue() / 45);
			elem.setColor(color[index][0], color[index][1], color[index][2]);
			
			registerTouchArea(elem); // reg touch
			paletta.attachChild(elem);
			
			paletta.registerEntityModifier(
					new MoveYModifier(0.3f, paletta.getY(), paletta.getY() - 77f)
			);
			
			registerUpdateHandler(new TimerHandler(1.2f, false, new ITimerCallback() {
				@Override
				public void onTimePassed(TimerHandler pTimerHandler) {
					CatchElement.this.unregisterTouchArea(elem);
					paletta.registerEntityModifier(
							new MoveYModifier(0.3f, paletta.getY(), paletta.getY() + 77f, new IEntityModifierListener() {
								@Override
								public void onModifierFinished(IModifier<IEntity> pModifier, IEntity pItem) {
									CatchElement.this.removeElemsToClick(paletta);
								}
							})
					);
				}
			}));
		}
	}
	
	private void removeElemsToClick(final IEntity paletta) {
		registerUpdateHandler(new TimerHandler(0.2f, false, new ITimerCallback() {
			@Override
			public void onTimePassed(TimerHandler pTimerHandler) {
				paletta.detachChild(paletta.getFirstChild());
			}	
		}));
	}
	
	@Override
	public void manageTouch(ITouchArea pTouchArea) {
		Sprite click = (Sprite)pTouchArea;
		unregisterTouchArea(pTouchArea);
		
		boolean fail = true;		
		for (int i = this.mNum + 1; i <= this.mNum * 2 - 1; i++) {
			Sprite seq = (Sprite)getGameLayer().getChild(i);
			if (click.getRotation() == seq.getRotation()) {
				seq.registerEntityModifier(
						new SequenceEntityModifier(
								new RotationModifier(0.01f, seq.getRotation(), seq.getRotation() + 1),
								new ScaleModifier(0.2f, 1f, 1.6f),
								new ScaleModifier(0.2f, 1.6f, 1f),
								new ScaleModifier(0.2f, 1f, 1.6f),
								new ScaleModifier(0.3f, 1.6f, 0f)
						)
				);
				this.mSeqValue.remove(new Integer((int) click.getRotation()));
				fail = false;
				break;
			}
		}
		
		if (fail)
			Resource.instance().fail(new CatchElement(this.mListValue));
		else if (this.mSeqValue.size() <= 0)
			Resource.instance().done();
		else
			this.mOk.play();
	}
	
}
