package org.prova;

import org.anddev.andengine.engine.handler.timer.ITimerCallback;
import org.anddev.andengine.engine.handler.timer.TimerHandler;
import org.anddev.andengine.entity.primitive.Rectangle;
import org.anddev.andengine.extra.Enviroment;
import org.anddev.andengine.extra.ExtScene;
import org.anddev.andengine.input.touch.TouchEvent;

public class Scene1 extends ExtScene {

	@Override
	public void createScene() {
		Rectangle rec = new Rectangle(0, 0, Enviroment.getInstance().getScreenWidth(), Enviroment.getInstance().getScreenHeight());
		rec.setColor(1f, 0f, 0f);
		getFirstChild().attachChild(rec);
	}

	@Override
	public void endScene() {
		Enviroment.getInstance().setScene(new Scene2());
	}

	@Override
	public void manageAreaTouch(ITouchArea pTouchArea) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void manageSceneTouch(TouchEvent pSceneTouchEvent) {
		
	}

	@Override
	public void startScene() {
		registerUpdateHandler(new TimerHandler(4f, false, new ITimerCallback() {
			@Override
			public void onTimePassed(TimerHandler pTimerHandler) {
				Enviroment.getInstance().nextScene();
			}
		}));		
	}

}
