package org.anddev.andengine.mmcomix.scene;

import org.amatidev.scene.AdScene;
import org.amatidev.util.AdEnviroment;
import org.amatidev.util.AdResourceLoader;
import org.anddev.andengine.entity.scene.menu.MenuScene;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.input.touch.TouchEvent;
import org.anddev.andengine.opengl.texture.region.TextureRegion;

public class HowToPlay extends AdScene {

	private TextureRegion mBack;

	@Override
	public MenuScene createMenu() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void createScene() {
		this.mBack = AdResourceLoader.getTexture(512, 1024, "back2");
		Sprite back = new Sprite(0, 0, this.mBack);
		getChild(AdScene.GAME_LAYER).attachChild(back);
		
		setOnSceneTouchListener(this);
	}

	@Override
	public void endScene() {
		AdEnviroment.getInstance().setScene(new Game());
	}

	@Override
	public void manageAreaTouch(ITouchArea pTouchArea) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void startScene() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void downSceneTouch(TouchEvent pSceneTouchEvent) {
		AdEnviroment.getInstance().nextScene();
	}

	@Override
	public void moveSceneTouch(TouchEvent pSceneTouchEvent) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void upSceneTouch(TouchEvent pSceneTouchEvent) {
		// TODO Auto-generated method stub
		
	}

}
