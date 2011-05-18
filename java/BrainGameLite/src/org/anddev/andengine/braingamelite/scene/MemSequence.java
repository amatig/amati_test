/***
=== BrainGame ===

Copyright (C) 2011 Giovanni Amati

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
***/

package org.anddev.andengine.braingamelite.scene;

import java.util.LinkedList;

import org.anddev.andengine.braingamelite.singleton.Enviroment;
import org.anddev.andengine.braingamelite.singleton.Resource;
import org.anddev.andengine.braingamelite.utils.MyChangeableText;
import org.anddev.andengine.braingamelite.utils.MyScene;
import org.anddev.andengine.braingamelite.utils.MySound;
import org.anddev.andengine.engine.handler.timer.ITimerCallback;
import org.anddev.andengine.engine.handler.timer.TimerHandler;
import org.anddev.andengine.entity.Entity;
import org.anddev.andengine.entity.IEntity;
import org.anddev.andengine.entity.modifier.ScaleModifier;
import org.anddev.andengine.entity.modifier.IEntityModifier.IEntityModifierListener;
import org.anddev.andengine.entity.shape.Shape;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.entity.text.Text;
import org.anddev.andengine.util.modifier.IModifier;

public class MemSequence extends MyScene {
	private int mNum; // num seq
	private int mRemain;
	private int mMaxNum; // elementi cliccabili
	private String[] elem; // note
	private MySound mOk;
	
	private LinkedList<Integer> mListValue;
	
	public MemSequence(LinkedList<Integer> aListValue) {
		super();
		getBackgroundLayer().getLastChild().setColor(1f, 0.8f, 8f);
		
		this.mOk = Resource.instance().getSound("ok");
		
		// difficult
    	this.mNum = 0;
    	switch (Enviroment.instance().getDifficult()) {
    		case 0: 
    			this.mNum = 4;
    			this.mMaxNum = 9;
    			break;
    		case 1: 
    			this.mNum = 4;
    			this.mMaxNum = 7;
    			this.elem = new String[this.mMaxNum];
    	    	this.elem[0] = "Do"; this.elem[1] = "Re"; this.elem[2] = "Mi"; this.elem[3] = "Fa";
    	    	this.elem[4] = "Sol"; this.elem[5] = "La"; this.elem[6] = "Si";
    			break;
    		case 2: 
    			this.mNum = 4;
    			this.mMaxNum = 7;
    			break;
    	}
    	
		this.mRemain = this.mNum; // riferimento per disegnare sui cubetti
		
		// dati
		if (aListValue == null) {
			this.mListValue = new LinkedList<Integer>();
			for (int i = 0; i < this.mNum; i++) {
				int index = Enviroment.random(0, this.mMaxNum - 1);
				this.mListValue.add(new Integer(index));
			}
		} else
			this.mListValue = aListValue;
		
    	Sprite quad = new Sprite(21, 133, Resource.instance().texQuad);
    	Text look = new Text(34, 23, Resource.instance().fontLook, "Reverse these");
		quad.attachChild(look);
		getGameLayer().attachChild(quad);
    	
		// aggiunta cubetti
		for (int i = 0; i < this.mNum; i++) {
			IEntity slot_cube = new Entity();
			slot_cube.setPosition(87 + i * 91, 269);
			Sprite cubeto = new Sprite(0, 0, Resource.instance().texPos);
			cubeto.setColor(1.0f, 1.0f, 0.5f);
			slot_cube.attachChild(cubeto);
			getGameLayer().attachChild(slot_cube);
		}
		
		// slot
		for (int i = 0; i < this.mMaxNum; i++) {
			int x = i % 3;
			int y = (int)(i / 3);
			
			Sprite slot = new Sprite(67 + x * 118, 363 + y * 118, Resource.instance().texSlot);
			getGameLayer().attachChild(slot);
		}
	}
	
	public void start() {
		// add sequence
    	for (int i = 0; i < this.mNum; i++) {
			registerUpdateHandler(new TimerHandler(0.1f + i, false, new ITimerCallback() {
				@Override
				public void onTimePassed(TimerHandler pTimerHandler) {
					int i = (int)pTimerHandler.getTimerSeconds();
					int index = MemSequence.this.mListValue.get(i).intValue();
					MemSequence.this.addSequence(index, i);
				}
			}));
		}
    	
    	registerUpdateHandler(new TimerHandler(0.1f + this.mNum, false, new ITimerCallback() {
			@Override
			public void onTimePassed(TimerHandler pTimerHandler) {
				// fa sparire ultimo elem seq all'aggiunta degli elem cliccabili
				final IEntity slot = getGameLayer().getChild(MemSequence.this.mNum);
				
				slot.getLastChild().registerEntityModifier(
						new ScaleModifier(0.3f, 1f, 0f, new IEntityModifierListener() {
							@Override
							public void onModifierFinished(IModifier<IEntity> pModifier, IEntity pItem) {
								IEntity cubetto = slot.getFirstChild();
								cubetto.setVisible(true);
								cubetto.setColor(0.5f, 0.9f, 0.2f);
								cubetto.setScale(1.3f);
							}
						})
				);
				// aggiunge soluzioni, elem cliccabili
				MemSequence.this.addElemsToClick();
			}
    	}));
	}
	
	private void addSequence(int index, int i) {
		IEntity slot = getGameLayer().getChild(i + 1);
		Sprite cub = (Sprite) slot.getFirstChild();
		cub.setVisible(false); // cubetto
		
		Shape label = null;
		float size = 1.0f;
		if (Enviroment.instance().getDifficult() == 0) {
			// number
			label = new MyChangeableText(0, 0, Resource.instance().fontSeqNum1, Integer.toString(index + 1), 1);
		} else if (Enviroment.instance().getDifficult() == 2) {
			// arrow
			label = new Sprite(0, 0, Resource.instance().texArrow);
			label.setRotation(index * 45);
		} else {
			// note
			if (this.elem[index].equals("Sol"))
				size -= 0.1f;
			label = new MyChangeableText(0, 0, Resource.instance().fontSeqNote1, this.elem[index], this.elem[index].length());
		}
		label.setPosition(cub.getWidthScaled() / 2 - label.getWidthScaled() / 2, cub.getHeightScaled() / 2 - label.getHeightScaled() / 2);
		float[][] color = Resource.instance().getColor();
		label.setColor(color[index][0], color[index][1], color[index][2]);
		label.registerEntityModifier(
				new ScaleModifier(0.3f, 0f, size)
		);
		
		// sparisce il precedente elemento della seq
		if (i > 0) {
			final IEntity temp2 = getGameLayer().getChild(i);
			
			temp2.getLastChild().registerEntityModifier(
					new ScaleModifier(0.3f, 1f, 0f, new IEntityModifierListener() {
						@Override
						public void onModifierFinished(IModifier<IEntity> pModifier, IEntity pItem) {
							temp2.getFirstChild().setVisible(true);
						}
					})
			);
		}
		slot.attachChild(label);
	}
	
	private void addElemsToClick() {
		for (int i = 0; i < this.mMaxNum; i++) {
			Shape label = null;
			float size = 1.0f;
			if (Enviroment.instance().getDifficult() == 0) {
				// number
				label = new MyChangeableText(0, 0, Resource.instance().fontSeqNum2, Integer.toString(i + 1), 1);
			} else if (Enviroment.instance().getDifficult() == 2) {
				// arrow
				label = new Sprite(0, 0, Resource.instance().texArrow);
				size += 0.1f;
				label.setRotation(i * 45);
			} else {
				// note
				if (this.elem[i].equals("Sol"))
					size -= 0.1f;
				label = new MyChangeableText(0, 0, Resource.instance().fontSeqNote2, this.elem[i], this.elem[i].length());
			}
			Sprite slot = (Sprite) getGameLayer().getChild(getGameLayer().getChildCount() - (this.mMaxNum - i));
			label.setPosition(slot.getWidthScaled() / 2 - label.getWidthScaled() / 2, slot.getHeightScaled() / 2 - label.getHeightScaled() / 2);
			float[][] color = Resource.instance().getColor();
			label.setColor(color[i][0], color[i][1], color[i][2]);
			label.registerEntityModifier(
					new ScaleModifier(0.3f, 0f, size)
			);
			registerTouchArea((ITouchArea) label); // reg touch
			slot.attachChild(label);
		}
	}
	
	@Override
	public void manageTouch(ITouchArea pTouchArea) {
		IEntity click = (IEntity) pTouchArea;
		IEntity slot = getGameLayer().getChild(this.mRemain);
		
		boolean cond = false;
		if (Enviroment.instance().getDifficult() == 2)
			cond = click.getRotation() == slot.getLastChild().getRotation();
		else
			cond = ((MyChangeableText) click).getText() == ((MyChangeableText)slot.getLastChild()).getText();
		
		if (cond) {
			slot.getFirstChild().setVisible(false);
			slot.getLastChild().registerEntityModifier(
					new ScaleModifier(0.3f, 0f, 1f)
			);
			
			this.mRemain--;
			
			if (this.mRemain == 0) // finita sequenza
				Resource.instance().done();
			else {
				this.mOk.play();
				IEntity temp2 = getGameLayer().getChild(this.mRemain).getFirstChild(); // next cubetto
				temp2.setColor(0.5f, 0.9f, 0.2f);
				temp2.setScale(1.3f);
			}
		} else
			Resource.instance().fail(new MemSequence(this.mListValue));
	}
	
}
