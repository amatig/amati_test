package org.amatidev.myworld;

import org.amatidev.scene.AdScene;
import org.anddev.andengine.entity.primitive.Line;
import org.anddev.andengine.entity.scene.menu.MenuScene;
import org.anddev.andengine.input.touch.TouchEvent;
import org.anddev.andengine.util.MathUtils;

import android.util.Log;

public class Game extends AdScene {
	private float mOldX;
	private float mOldY;

	@Override
	public MenuScene createMenu() {
		return null;
	}

	@Override
	public void createScene() {
        setOnSceneTouchListener(this);
        //setTouchAreaBindingEnabled(true);
	}

	@Override
	public void endScene() {
		
	}

	@Override
	public void manageAreaTouch(ITouchArea pTouchArea) {
			
	}

	@Override
	public void upSceneTouch(TouchEvent pSceneTouchEvent) {
		this.mOldX = 0;
		this.mOldY = 0;
	}

	@Override
	public void downSceneTouch(TouchEvent pSceneTouchEvent) {
		
	}

	@Override
	public void moveSceneTouch(TouchEvent pSceneTouchEvent) {
		if (this.mOldX != 0 && this.mOldY != 0) {
			if (MathUtils.distance(this.mOldX, this.mOldY, pSceneTouchEvent.getX(), pSceneTouchEvent.getY()) > 5.0f) {
				Log.i("Game", this.mOldX + "," + this.mOldY + " - " + pSceneTouchEvent.getX() + "," + pSceneTouchEvent.getY());
				
				Line line = new Line(this.mOldX, this.mOldY, pSceneTouchEvent.getX(), pSceneTouchEvent.getY(), 3);
				line.setColor(1f, 1f, 1f);
				getChild(GAME_LAYER).attachChild(line);
			}
		}
		this.mOldX = pSceneTouchEvent.getX();
		this.mOldY = pSceneTouchEvent.getY();
	}

	@Override
	public void startScene() {
				
	}

}
