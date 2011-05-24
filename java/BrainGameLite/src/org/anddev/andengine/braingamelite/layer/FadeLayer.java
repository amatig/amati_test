/***
=== BrainGame ===

Copyright (C) 2011 Giovanni Amati

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
***/

package org.anddev.andengine.braingamelite.layer;

import org.anddev.andengine.braingamelite.singleton.Enviroment;
import org.anddev.andengine.braingamelite.util.MyScene;
import org.anddev.andengine.engine.handler.timer.ITimerCallback;
import org.anddev.andengine.engine.handler.timer.TimerHandler;
import org.anddev.andengine.entity.IEntity;
import org.anddev.andengine.entity.layer.Layer;
import org.anddev.andengine.entity.modifier.AlphaModifier;
import org.anddev.andengine.entity.modifier.IEntityModifier.IEntityModifierListener;
import org.anddev.andengine.entity.primitive.Rectangle;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.util.modifier.IModifier;

public class FadeLayer extends Layer {
	private Rectangle mScreenBlack;
	
	public FadeLayer() {
		this.mScreenBlack = new Rectangle(0, 0, Enviroment.CAMERA_WIDTH, Enviroment.CAMERA_HEIGHT);
		this.mScreenBlack.setColor(0f, 0f, 0f);
		attachChild(this.mScreenBlack);
		FadeOut();
	}
	
	public void show() {
		this.mScreenBlack.setAlpha(1f);
	}
	
	public void hide() {
		this.mScreenBlack.setAlpha(0f);
	}
	
	public void FadeOut() {
		registerUpdateHandler(new TimerHandler(0.1f, false, new ITimerCallback() {
			@Override
			public void onTimePassed(TimerHandler pTimerHandler) {
				FadeLayer.this.mScreenBlack.registerEntityModifier(
						new AlphaModifier(0.3f, 1f, 0f, new IEntityModifierListener() {
							@Override
							public void onModifierFinished(IModifier<IEntity> pModifier, IEntity pItem) {
								FadeLayer.this.hide();
								((MyScene)Enviroment.instance().getScene()).start();
							}
						})
				);
			}
		}));
	}
	
	public void FadeIn(final Scene scene) {
		registerUpdateHandler(new TimerHandler(0.1f, false, new ITimerCallback() {
			@Override
			public void onTimePassed(TimerHandler pTimerHandler) {
				FadeLayer.this.mScreenBlack.registerEntityModifier(
						new AlphaModifier(0.3f, 0f, 1f, new IEntityModifierListener() {
							@Override
							public void onModifierFinished(IModifier<IEntity> pModifier, IEntity pItem) {
								FadeLayer.this.show();
								if (scene != null)
									Enviroment.instance().setScene(scene);
								else
									Enviroment.instance().nextScene();
							}
						})
				);
			}
		}));
	}
}