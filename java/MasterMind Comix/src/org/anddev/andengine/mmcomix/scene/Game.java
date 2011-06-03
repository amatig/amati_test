package org.anddev.andengine.mmcomix.scene;

import org.anddev.andengine.engine.handler.timer.ITimerCallback;
import org.anddev.andengine.engine.handler.timer.TimerHandler;
import org.anddev.andengine.entity.Entity;
import org.anddev.andengine.entity.IEntity;
import org.anddev.andengine.entity.modifier.MoveYModifier;
import org.anddev.andengine.entity.modifier.IEntityModifier.IEntityModifierListener;
import org.anddev.andengine.entity.scene.background.ColorBackground;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.extra.ExtraScene;
import org.anddev.andengine.extra.Resource;
import org.anddev.andengine.input.touch.TouchEvent;
import org.anddev.andengine.opengl.texture.region.TextureRegion;
import org.anddev.andengine.util.modifier.IModifier;

public class Game extends ExtraScene {

	private TextureRegion mHole;
	private TextureRegion mHoleFront;
	private TextureRegion mWorm;
	private TextureRegion mBird1;
	private TextureRegion mBird2;
	private TextureRegion mShadow;
	private TextureRegion mColor;

	@Override
	public void createScene() {
		setBackground(new ColorBackground(0.603921569f, 0.909803922f, 0.337254902f));
		
		this.mColor = Resource.getTexture(64, 64, "color");
		this.mShadow = Resource.getTexture(64, 32, "shadow");
		this.mBird1 = Resource.getTexture(64, 64, "bird1");
		this.mBird2 = Resource.getTexture(64, 64, "bird2");
		this.mWorm = Resource.getTexture(64, 64, "worm");
		this.mHole = Resource.getTexture(128, 128, "hole_back");
		this.mHoleFront = Resource.getTexture(128, 128, "hole");
		int space_x = 25;
		int space_y = 50;
		
		Sprite bird1 = new Sprite(0, -21, this.mBird1);
		Sprite bird2 = new Sprite(0, -21, this.mBird2);
		
		for (int i = 0; i < 40; i++) {
			int x = i % 4;
			int y = (int)(i / 4);
			Sprite h = new Sprite(space_x + x * 80, space_y + y * 64, this.mHole);
			Sprite hf = new Sprite(0, 0, this.mHoleFront);
			h.attachChild(new Entity());
			h.attachChild(hf);
			getChild(ExtraScene.GAME_LAYER).attachChild(h);
			
			if (x == 3) {
				Entity pos = new Entity();
				pos.setPosition(h.getX() + 120, h.getY() - 8);
				pos.attachChild(new Sprite(0, 0, this.mShadow));
				pos.attachChild(new Sprite(40, 0, this.mShadow));
				pos.attachChild(new Sprite(0, 20, this.mShadow));
				pos.attachChild(new Sprite(40, 20, this.mShadow));
				getChild(ExtraScene.GAME_LAYER).attachChild(pos);
				
				/*pos.getChild(0).attachChild(bird2);
				pos.getChild(1).attachChild(bird2);
				pos.getChild(2).attachChild(bird2);
				pos.getChild(3).attachChild(bird2);*/
			}
			
			final Sprite w = new Sprite(27, 10, this.mWorm);
			w.setColor(1f, 0.8f, 0.8f);
			h.getFirstChild().attachChild(w);
			
			/*registerUpdateHandler(new TimerHandler(5f, false, new ITimerCallback() {
				@Override
				public void onTimePassed(TimerHandler pTimerHandler) {
					w.registerEntityModifier(
							new MoveYModifier(0.3f, w.getY(), w.getY() - 46f, new IEntityModifierListener() {
								@Override
								public void onModifierFinished(IModifier<IEntity> pModifier, IEntity pItem) {
									
								}
							})
					);
				}
			}));*/
			
			int adjust = 28;
			int space = 73; 
			int pos_y = 677;
			Sprite color1 = new Sprite(adjust + 0 * space, pos_y, this.mColor);
			color1.setColor(1f, 0f, 0f);
			Sprite color2 = new Sprite(adjust + 1 * space, pos_y, this.mColor);
			color2.setColor(0f, 1f, 0f);
			Sprite color3 = new Sprite(adjust + 2 * space, pos_y, this.mColor);
			color3.setColor(0f, 0f, 1f);
			Sprite color4 = new Sprite(adjust + 3 * space, pos_y, this.mColor);
			color4.setColor(1f, 0f, 0f);
			Sprite color5 = new Sprite(adjust + 4 * space, pos_y, this.mColor);
			color5.setColor(1f, 0f, 0f);
			Sprite color6 = new Sprite(adjust + 5 * space, pos_y, this.mColor);
			color6.setColor(1f, 0f, 0f);
			
			getChild(ExtraScene.GAME_LAYER).attachChild(color1);
			getChild(ExtraScene.GAME_LAYER).attachChild(color2);
			getChild(ExtraScene.GAME_LAYER).attachChild(color3);
			getChild(ExtraScene.GAME_LAYER).attachChild(color4);
			getChild(ExtraScene.GAME_LAYER).attachChild(color5);
			getChild(ExtraScene.GAME_LAYER).attachChild(color6);
		}
	}

	@Override
	public void startScene() {
		// TODO Auto-generated method stub
		
	}
	
	@Override
	public void endScene() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void manageAreaTouch(ITouchArea pTouchArea) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void manageSceneTouch(TouchEvent pSceneTouchEvent) {
		// TODO Auto-generated method stub
		
	}

}
