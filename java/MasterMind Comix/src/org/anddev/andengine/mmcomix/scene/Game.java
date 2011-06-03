package org.anddev.andengine.mmcomix.scene;

import java.util.LinkedList;

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
import org.anddev.andengine.util.MathUtils;
import org.anddev.andengine.util.modifier.IModifier;

public class Game extends ExtraScene {
	
	private LinkedList<Integer> mListValue;
	private float mColor[][];
	private int mCount;
	
	private TextureRegion mHole;
	private TextureRegion mHoleFront;
	private TextureRegion mWorm;
	private TextureRegion mBird1;
	private TextureRegion mBird2;
	private TextureRegion mShadow;
	private TextureRegion mClickColor;
	
	private Sprite mSpriteBird1;
	private Sprite mSpriteBird2;
	
	@Override
	public void createScene() {
		setBackground(new ColorBackground(0.603921569f, 0.909803922f, 0.337254902f));
    	
		this.mClickColor = Resource.getTexture(64, 64, "color");
		this.mShadow = Resource.getTexture(64, 32, "shadow");
		this.mBird1 = Resource.getTexture(64, 64, "bird1");
		this.mBird2 = Resource.getTexture(64, 64, "bird2");
		this.mWorm = Resource.getTexture(64, 64, "worm");
		this.mHole = Resource.getTexture(128, 128, "hole_back");
		this.mHoleFront = Resource.getTexture(128, 128, "hole");
		
		this.mSpriteBird1 = new Sprite(0, -21, this.mBird1);
		this.mSpriteBird2 = new Sprite(0, -21, this.mBird2);
		
		this.mColor = new float[6][3];
    	this.mColor[0][0] = 1.0f; this.mColor[0][1] = 0.3f; this.mColor[0][2] = 0.3f;
    	this.mColor[1][0] = 0.2f; this.mColor[1][1] = 1.0f; this.mColor[1][2] = 0.2f;
    	this.mColor[2][0] = 0.3f; this.mColor[2][1] = 0.3f; this.mColor[2][2] = 1.0f;
    	this.mColor[3][0] = 1.0f; this.mColor[3][1] = 1.0f; this.mColor[3][2] = 0.0f;
    	this.mColor[4][0] = 1.0f; this.mColor[4][1] = 1.0f; this.mColor[4][2] = 1.0f;
    	this.mColor[5][0] = 0.3f; this.mColor[5][1] = 0.3f; this.mColor[5][2] = 0.3f;
    	
    	// generate sequence
    	this.mListValue = new LinkedList<Integer>();
    	//for (int i = 0; i < 4; i++)
    	//	this.mListValue.add(new Integer(MathUtils.random(0, 5)));
    	this.mListValue.add(new Integer(4));
    	this.mListValue.add(new Integer(1));
    	this.mListValue.add(new Integer(2));
    	this.mListValue.add(new Integer(4));
    	
    	// create scene
		int space_x = 25;
		int space_y = 50;
		
		for (int i = 0; i < 40; i++) {
			int x = i % 4;
			int y = (int)(i / 4);
			Sprite h = new Sprite(space_x + x * 80, space_y + y * 64, this.mHole);
			h.attachChild(new Entity());
			Sprite hf = new Sprite(0, 0, this.mHoleFront);
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
			}
			
			registerUpdateHandler(new TimerHandler(5f, false, new ITimerCallback() {
				@Override
				public void onTimePassed(TimerHandler pTimerHandler) {
					
				}
			}));
		}
		
		int adjust = 28;
		int space = 73; 
		int pos_y = 677;
		
		Sprite color1 = new Sprite(adjust + 0 * space, pos_y, this.mClickColor);
		color1.setColor(this.mColor[0][0], this.mColor[0][1], this.mColor[0][2]);
		registerTouchArea(color1);
		Sprite color2 = new Sprite(adjust + 1 * space, pos_y, this.mClickColor);
		color2.setColor(this.mColor[1][0], this.mColor[1][1], this.mColor[1][2]);
		registerTouchArea(color2);
		Sprite color3 = new Sprite(adjust + 2 * space, pos_y, this.mClickColor);
		color3.setColor(this.mColor[2][0], this.mColor[2][1], this.mColor[2][2]);
		registerTouchArea(color3);
		Sprite color4 = new Sprite(adjust + 3 * space, pos_y, this.mClickColor);
		color4.setColor(this.mColor[3][0], this.mColor[3][1], this.mColor[3][2]);
		registerTouchArea(color4);
		Sprite color5 = new Sprite(adjust + 4 * space, pos_y, this.mClickColor);
		color5.setColor(this.mColor[4][0], this.mColor[4][1], this.mColor[4][2]);
		registerTouchArea(color5);
		Sprite color6 = new Sprite(adjust + 5 * space, pos_y, this.mClickColor);
		color6.setColor(this.mColor[5][0], this.mColor[5][1], this.mColor[5][2]);
		registerTouchArea(color6);
		
		getChild(ExtraScene.GAME_LAYER).attachChild(color1);
		getChild(ExtraScene.GAME_LAYER).attachChild(color2);
		getChild(ExtraScene.GAME_LAYER).attachChild(color3);
		getChild(ExtraScene.GAME_LAYER).attachChild(color4);
		getChild(ExtraScene.GAME_LAYER).attachChild(color5);
		getChild(ExtraScene.GAME_LAYER).attachChild(color6);
		
		this.mCount = 45;
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
		if (this.mCount == 4) {
			return;
		}
		
		if ((this.mCount + 1) % 5 == 0)
			this.mCount -= 9;
		
		IEntity color = (IEntity) pTouchArea;
		IEntity h = getChild(ExtraScene.GAME_LAYER).getChild(this.mCount);
		
		Sprite w = new Sprite(27, 10, this.mWorm);
		w.setColor(color.getRed(), color.getGreen(), color.getBlue());
		h.getFirstChild().attachChild(w);
		w.registerEntityModifier(new MoveYModifier(0.3f, w.getY(), w.getY() - 46f));
		
		this.mCount += 1;
		checkRow(this.mCount);
	}
	
	private void checkRow(int num) {
		if ((num + 1) % 5 == 0) {
			IEntity pos = getChild(ExtraScene.GAME_LAYER).getChild(num);
			
			// check di quelli inseriti per non ripetere ricerca colori
			boolean check[] = new boolean[4];
			check[0] = false;
			check[1] = false;
			check[2] = false;
			check[3] = false;
			
			LinkedList<Sprite> slotPos = new LinkedList<Sprite>();
			
			for (int i = 0; i < 4; i++) {
				float r = this.mColor[this.mListValue.get(i).intValue()][0];
				float g = this.mColor[this.mListValue.get(i).intValue()][1];
				float b = this.mColor[this.mListValue.get(i).intValue()][2];
				IEntity w = getChild(ExtraScene.GAME_LAYER).getChild(num - 4 + i).getFirstChild().getFirstChild();
				if (w.getRed() == r && w.getGreen() == g && w.getBlue() == b) {
					slotPos.add(0, this.mSpriteBird2);
					check[i] = true;
				}
			}
			for (int i = 0; i < 4; i++) {
				if (check[i] == true) continue;
				float r = this.mColor[this.mListValue.get(i).intValue()][0];
				float g = this.mColor[this.mListValue.get(i).intValue()][1];
				float b = this.mColor[this.mListValue.get(i).intValue()][2];
				for (int j = 0; j < 4; j++) {
					IEntity w = getChild(ExtraScene.GAME_LAYER).getChild(num - 4 + j).getFirstChild().getFirstChild();
					if ((w.getRed() == r && w.getGreen() == g && w.getBlue() == b) && (check[i] == false)) {
						slotPos.add(this.mSpriteBird1);
						check[i] = true;
					}
				}
			}
			
			for (int i = 0; i < 4; i++)
				pos.getChild(i).attachChild(slotPos.get(i));
		}
	}
	
	@Override
	public void manageSceneTouch(TouchEvent pSceneTouchEvent) {
		// TODO Auto-generated method stub
		
	}

}
