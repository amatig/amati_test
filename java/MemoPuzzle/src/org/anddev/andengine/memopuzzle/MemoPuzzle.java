package org.anddev.andengine.memopuzzle;

import org.anddev.andengine.engine.Engine;
import org.anddev.andengine.engine.camera.Camera;
import org.anddev.andengine.engine.options.EngineOptions;
import org.anddev.andengine.engine.options.EngineOptions.ScreenOrientation;
import org.anddev.andengine.engine.options.resolutionpolicy.RatioResolutionPolicy;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.entity.scene.Scene.IOnAreaTouchListener;
import org.anddev.andengine.entity.scene.Scene.ITouchArea;
import org.anddev.andengine.input.touch.TouchEvent;
import org.anddev.andengine.memopuzzle.game.SumBox;
import org.anddev.andengine.ui.activity.BaseGameActivity;
import org.anddev.andengine.memopuzzle.utils.Enviroment;
import org.anddev.andengine.memopuzzle.utils.MyGameScene;

public class MemoPuzzle extends BaseGameActivity implements IOnAreaTouchListener {
    public static final int CAMERA_WIDTH = 480;
    public static final int CAMERA_HEIGHT = 720;
	
	public void onLoadComplete() {
		
	}
	
	public Engine onLoadEngine() {
		final Camera camera = new Camera(0, 0, CAMERA_WIDTH, CAMERA_HEIGHT);
		final EngineOptions engineOptions = new EngineOptions(true, ScreenOrientation.PORTRAIT, new RatioResolutionPolicy(CAMERA_WIDTH, CAMERA_HEIGHT), camera);
		// engineOptions.getTouchOptions().setRunOnUpdateThread(true);
		return new Engine(engineOptions);
	}
	
	public void onLoadResources() {
		Enviroment.instance().loadResource(this); // setta tutto per iniziare
	}
	
	public Scene onLoadScene() {
		// getEngine().registerUpdateHandler(new FPSLogger());
		return new SumBox();
	}
	
	public void nextScene() {
		getEngine().setScene(new SumBox());
	}
	
	public boolean onAreaTouched(TouchEvent pSceneTouchEvent, ITouchArea pTouchArea, float pTouchAreaLocalX, float pTouchAreaLocalY) {
		if (pSceneTouchEvent.isActionDown()) {
			((MyGameScene) getEngine().getScene()).manageTouch(pTouchArea);
			return true;
		}
		return false;
	}
	
}
