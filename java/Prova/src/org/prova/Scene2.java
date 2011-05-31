package org.prova;

import org.anddev.andengine.entity.primitive.Rectangle;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.extra.Enviroment;
import org.anddev.andengine.extra.ExtScene;
import org.anddev.andengine.extra.ExtSound;
import org.anddev.andengine.extra.ExtVibration;
import org.anddev.andengine.extra.Resource;
import org.anddev.andengine.input.touch.TouchEvent;
import org.anddev.andengine.opengl.texture.region.TextureRegion;

public class Scene2 extends ExtScene {

	private ExtSound s;

	@Override
	public void createScene() {
		Rectangle rec = new Rectangle(0, 0, Enviroment.getInstance().getScreenWidth(), Enviroment.getInstance().getScreenHeight());
		rec.setColor(0.6f, 0.6f, 1f);
		getFirstChild().attachChild(rec);
		
		TextureRegion box = Resource.getTexture(128, 128, "box");
		Sprite sprite = new Sprite(100, 100, box);
		getFirstChild().attachChild(sprite);
		
		this.s = Resource.getSound("done");
	}

	@Override
	public void endScene() {
		
	}

	@Override
	public void manageAreaTouch(ITouchArea pTouchArea) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void manageSceneTouch(TouchEvent pSceneTouchEvent) {
		ExtVibration.duration(200);
		this.s.play();
	}

	@Override
	public void startScene() {
		// TODO Auto-generated method stub
		
	}

}
