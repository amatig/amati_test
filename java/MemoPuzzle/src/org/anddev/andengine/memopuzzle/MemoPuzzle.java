package org.anddev.andengine.memopuzzle;

import org.anddev.andengine.engine.Engine;
import org.anddev.andengine.engine.camera.Camera;
import org.anddev.andengine.engine.options.EngineOptions;
import org.anddev.andengine.engine.options.EngineOptions.ScreenOrientation;
import org.anddev.andengine.engine.options.resolutionpolicy.RatioResolutionPolicy;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.entity.scene.Scene.IOnAreaTouchListener;
import org.anddev.andengine.entity.scene.Scene.ITouchArea;
import org.anddev.andengine.entity.scene.menu.MenuScene;
import org.anddev.andengine.entity.scene.menu.MenuScene.IOnMenuItemClickListener;
import org.anddev.andengine.entity.scene.menu.item.IMenuItem;
import org.anddev.andengine.input.touch.TouchEvent;
import org.anddev.andengine.memopuzzle.game.EndScene;
import org.anddev.andengine.memopuzzle.game.MainMenu;
import org.anddev.andengine.memopuzzle.game.StartScene;
import org.anddev.andengine.memopuzzle.game.SumBox;
import org.anddev.andengine.ui.activity.BaseGameActivity;
import org.anddev.andengine.memopuzzle.utils.Enviroment;
import org.anddev.andengine.memopuzzle.utils.GameMenu;
import org.anddev.andengine.memopuzzle.utils.GameScene;
import android.view.KeyEvent;

public class MemoPuzzle extends BaseGameActivity implements IOnAreaTouchListener, IOnMenuItemClickListener {
    public static final int CAMERA_WIDTH = 480;
    public static final int CAMERA_HEIGHT = 720;
    
    public static final int MENU_AUDIO = 0;
	public static final int MENU_EXIT = 1;
	public static final int MENU_EASY = 2;
	public static final int MENU_NORMAL = 3;
	public static final int MENU_HARD = 4;
	
	public void onLoadComplete() {
		
	}
	
	public Engine onLoadEngine() {
		Camera camera = new Camera(0, 0, CAMERA_WIDTH, CAMERA_HEIGHT);
		EngineOptions engineOptions = new EngineOptions(true, ScreenOrientation.PORTRAIT, new RatioResolutionPolicy(CAMERA_WIDTH, CAMERA_HEIGHT), camera);
		engineOptions.getTouchOptions().setRunOnUpdateThread(true);
		return new Engine(engineOptions);
	}
	
	public void onLoadResources() {
		Enviroment.instance().loadResource(this); // setta tutto per iniziare
	}
	
	public Scene onLoadScene() {
		// getEngine().registerUpdateHandler(new FPSLogger());
		return new MainMenu();
	}
	
	public void setScene(Scene scene) {
		getEngine().setScene(scene);
	}
	
	public void nextScene() {
		Scene scene = null;
		switch (Enviroment.instance().nextMiniGame()) {
		case 0: scene = new EndScene(); break;
		case 1: scene = new SumBox(null, null); break;
		}
		getEngine().setScene(scene);
	}
	
	public boolean onAreaTouched(TouchEvent pSceneTouchEvent, ITouchArea pTouchArea, float pTouchAreaLocalX, float pTouchAreaLocalY) {
		if (pSceneTouchEvent.isActionDown()) {
			((GameScene) getEngine().getScene()).manageTouch(pTouchArea);
			return true;
		}
		return false;
	}
	
	public boolean onKeyDown(final int pKeyCode, final KeyEvent pEvent) {	
		if (pKeyCode == KeyEvent.KEYCODE_MENU && pEvent.getAction() == KeyEvent.ACTION_DOWN) {
			if (this.mEngine.getScene().hasChildScene()) {
				if (!(this.mEngine.getScene() instanceof MainMenu)) {
					this.mEngine.getScene().back();
				}
			} else {
				this.mEngine.getScene().setChildScene(new GameMenu(), false, true, true);
			}
			return true;
		} else {
			return super.onKeyDown(pKeyCode, pEvent);
		}
	}
	
	public boolean onMenuItemClicked(MenuScene pMenuScene, IMenuItem pMenuItem, float pMenuItemLocalX, float pMenuItemLocalY) {
		this.getEngine().getScene().clearChildScene();
		pMenuScene.reset();
		switch(pMenuItem.getID()) {
		case MENU_EASY:
			Enviroment.instance().setDifficult(0);
			setScene(new StartScene());
			return true;
		case MENU_NORMAL:
			Enviroment.instance().setDifficult(1);
			setScene(new StartScene());
			return true;
		case MENU_HARD:
			Enviroment.instance().setDifficult(2);
			setScene(new StartScene());
			return true;
		case MENU_AUDIO:
			Enviroment.instance().toggleAudio();
			return true;
		case MENU_EXIT:
			/* End Activity. */
			setScene(new MainMenu());
			return true;
		default:
			return false;
		}
	}
	
}
