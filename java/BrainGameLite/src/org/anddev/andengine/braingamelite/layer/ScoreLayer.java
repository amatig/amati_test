/***
=== BrainGame ===

Copyright (C) 2011 Giovanni Amati

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
***/

package org.anddev.andengine.braingamelite.layer;

import org.anddev.andengine.braingamelite.singleton.Enviroment;
import org.anddev.andengine.braingamelite.singleton.Resource;
import org.anddev.andengine.braingamelite.util.MyChangeableText;
import org.anddev.andengine.entity.Entity;
import org.anddev.andengine.entity.IEntity;
import org.anddev.andengine.entity.modifier.ScaleModifier;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.util.TimeUtils;

public class ScoreLayer extends Entity {
	private static int SPACE = 45;
	private int mStep = 0;
	
	private MyChangeableText mTimeText;
	private int mTime;
	
	public ScoreLayer() {
		for (int i = 0; i < Enviroment.NUMMINIGAME; i++) {
			Sprite step = new Sprite(10 + i * SPACE, 10, Resource.instance().texStep);
			step.setColor(1.0f, 1.0f, 0.5f);
			step.setScale(0.7f);
			attachChild(step);
		}
		
		this.mTimeText = new MyChangeableText(20, 75, Resource.instance().fontTime, "00:00", 5);
		this.mTimeText.setColor(1.0f, 1.0f, 1.0f);
		attachChild(this.mTimeText);
	}
	
	public void nextStep() {
		this.mStep += 1;
		
		IEntity step = getChild(this.mStep - 1);
		step.setColor(0.5f, 0.9f, 0.2f);
		step.registerEntityModifier(
				new ScaleModifier(0.2f, 0.5f, 0.9f)
		);
	}
	
	public int getTime() {
		return this.mTime;
	}
	
	public void updateTime() {
		this.mTime += 1;
		this.mTimeText.setText(TimeUtils.formatSeconds(this.mTime));
	}
	
}