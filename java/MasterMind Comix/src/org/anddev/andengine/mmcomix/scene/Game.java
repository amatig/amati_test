package org.anddev.andengine.mmcomix.scene;

import java.util.LinkedList;

import org.anddev.andengine.engine.handler.timer.ITimerCallback;
import org.anddev.andengine.engine.handler.timer.TimerHandler;
import org.anddev.andengine.entity.Entity;
import org.anddev.andengine.entity.IEntity;
import org.anddev.andengine.entity.modifier.MoveYModifier;
import org.anddev.andengine.entity.modifier.IEntityModifier.IEntityModifierListener;
import org.anddev.andengine.entity.scene.background.ColorBackground;
import org.anddev.andengine.entity.scene.menu.MenuScene;
import org.anddev.andengine.entity.sprite.AnimatedSprite;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.entity.text.Text;
import org.anddev.andengine.extra.Enviroment;
import org.anddev.andengine.extra.ExtraScene;
import org.anddev.andengine.extra.Resource;
import org.anddev.andengine.input.touch.TouchEvent;
import org.anddev.andengine.opengl.font.Font;
import org.anddev.andengine.opengl.texture.region.TextureRegion;
import org.anddev.andengine.opengl.texture.region.TiledTextureRegion;
import org.anddev.andengine.util.MathUtils;
import org.anddev.andengine.util.modifier.IModifier;

import android.graphics.Color;

public class Game extends ExtraScene {
	
	private LinkedList<Integer> mListValue;
	private float mColor[][];
	private int mCount;
	
	private TextureRegion mHole;
	private TextureRegion mHoleFront;
	private TiledTextureRegion mWorm1;
	private TiledTextureRegion mBird1;
	private TiledTextureRegion mBird2;
	private TextureRegion mShadow;
	
	private AnimatedSprite mSpriteBird1;
	private AnimatedSprite mSpriteBird2;
	
	private Font mFont1;
	
	private GameMenu mMenu;
	
	@Override
	public void createScene() {
		setBackground(new ColorBackground(0.603921569f, 0.909803922f, 0.337254902f));
    	
		this.mMenu = new GameMenu();
		
		this.mFont1 = Resource.getFont(512, 512, "akaDylan Plain", 20, 2, Color.WHITE, Color.BLACK);
		
		this.mShadow = Resource.getTexture(64, 32, "shadow");
		this.mBird1 = Resource.getTexture(128, 64, "bird1", 2, 1);
		this.mBird2 = Resource.getTexture(128, 64, "bird2", 2, 1);
		this.mWorm1 = Resource.getTexture(128, 64, "worm1", 2, 1);
		this.mHole = Resource.getTexture(128, 128, "hole_back");
		this.mHoleFront = Resource.getTexture(128, 128, "hole");
		
		this.mSpriteBird1 = new AnimatedSprite(0, -21, this.mBird1);
		this.mSpriteBird2 = new AnimatedSprite(0, -21, this.mBird2);
		this.mSpriteBird1.animate(6000);
		this.mSpriteBird2.animate(6000);
		
		this.mColor = new float[6][3];
    	this.mColor[0][0] = 1.0f; this.mColor[0][1] = 0.3f; this.mColor[0][2] = 0.3f;
    	this.mColor[1][0] = 0.2f; this.mColor[1][1] = 1.0f; this.mColor[1][2] = 0.2f;
    	this.mColor[2][0] = 0.3f; this.mColor[2][1] = 0.3f; this.mColor[2][2] = 1.0f;
    	this.mColor[3][0] = 1.0f; this.mColor[3][1] = 1.0f; this.mColor[3][2] = 0.0f;
    	this.mColor[4][0] = 1.0f; this.mColor[4][1] = 1.0f; this.mColor[4][2] = 1.0f;
    	this.mColor[5][0] = 0.3f; this.mColor[5][1] = 0.3f; this.mColor[5][2] = 0.3f;
    	
    	// generate sequence
    	this.mListValue = new LinkedList<Integer>();
    	for (int i = 0; i < 4; i++)
    		this.mListValue.add(new Integer(MathUtils.random(0, 5)));
    	/*this.mListValue.add(new Integer(4));
    	this.mListValue.add(new Integer(1));
    	this.mListValue.add(new Integer(2));
    	this.mListValue.add(new Integer(4));*/
    	
    	// create scene
		int space_x = 33;
		int space_y = 43;
		
		for (int i = 0; i < 40; i++) {
			int x = i % 4;
			int y = (int)(i / 4);
			Sprite h = new Sprite(space_x + x * 80, space_y + y * 64, this.mHole);
			h.attachChild(new Entity());
			Sprite hf = new Sprite(0, 0, this.mHoleFront);
			h.attachChild(hf);
			getChild(ExtraScene.GAME_LAYER).attachChild(h);
			
			if (x == 0) {
				Text num = new Text(h.getX() - 23, h.getY() - 11, this.mFont1, Integer.toString(10 - y));
				getChild(ExtraScene.EXTRA_GAME_LAYER).attachChild(num);
			} else if (x == 3) {
				Entity pos = new Entity();
				pos.setPosition(h.getX() + 109, h.getY() - 8);
				pos.attachChild(new Sprite(0, 0, this.mShadow));
				pos.attachChild(new Sprite(40, 0, this.mShadow));
				pos.attachChild(new Sprite(0, 20, this.mShadow));
				pos.attachChild(new Sprite(40, 20, this.mShadow));
				getChild(ExtraScene.EXTRA_GAME_LAYER).attachChild(pos);
			}
		}
		
		int adjust = -15;
		int space = 81; 
		int pos_y = 695;
		
		for (int i = 0; i < 6; i++) {
			Sprite h = new Sprite(adjust + i * space, pos_y, this.mHole);
			h.attachChild(new Entity());
			Sprite hf = new Sprite(0, 0, this.mHoleFront);
			h.attachChild(hf);
			
			AnimatedSprite color = new AnimatedSprite(27, -34, this.mWorm1);
			color.animate(3000);
			color.setColor(this.mColor[i][0], this.mColor[i][1], this.mColor[i][2]);
			registerTouchArea(color);
			
			h.getFirstChild().attachChild(color);
			getChild(ExtraScene.GAME_LAYER).attachChild(h);
		}
		
		this.mCount = 44;
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
		setOnAreaTouchListener(null);
		unregisterTouchArea(pTouchArea);
		
		if (this.mCount == 4) {
			Enviroment.getInstance().setScene(new Game());
		}
		
		if (this.mCount % 4 == 0)
			this.mCount -= 8;
		
		final IEntity color = (IEntity) pTouchArea;
		
		color.registerEntityModifier(
				new MoveYModifier(0.3f, color.getY(), color.getY() + 44f, new IEntityModifierListener() {
					@Override
					public void onModifierFinished(IModifier<IEntity> pModifier, IEntity pItem) {
						Game.this.pop(color);
					}
				})
		);
	}
	
	private void pop(final IEntity color){
		registerUpdateHandler(new TimerHandler(0.3f, false, new ITimerCallback() {
			@Override
			public void onTimePassed(TimerHandler pTimerHandler) {
				IEntity h = getChild(ExtraScene.GAME_LAYER).getChild(Game.this.mCount);
				
				AnimatedSprite w = new AnimatedSprite(27, 10, Game.this.mWorm1);
				w.animate(3000);
				w.setColor(color.getRed(), color.getGreen(), color.getBlue());
				h.getFirstChild().attachChild(w);
				
				Game.this.mCount += 1;
				checkRow(Game.this.mCount);
				
				w.registerEntityModifier(new MoveYModifier(0.3f, w.getY(), w.getY() - 44f, new IEntityModifierListener() {
					@Override
					public void onModifierFinished(IModifier<IEntity> pModifier, IEntity pItem) {
						Game.this.setOnAreaTouchListener(Game.this);
						Game.this.pop2(color);
					}
				}));
			}
		}));
	}
	
	private void pop2(final IEntity color) {
		registerUpdateHandler(new TimerHandler(0.3f, false, new ITimerCallback() {
			@Override
			public void onTimePassed(TimerHandler pTimerHandler) {
				color.registerEntityModifier(new MoveYModifier(0.3f, color.getY(), color.getY() - 44f, new IEntityModifierListener() {
					@Override
					public void onModifierFinished(IModifier<IEntity> pModifier, IEntity pItem) {
						Game.this.registerTouchArea((ITouchArea) color);
					}
				}));	
			}
		}));
	}

	private void checkRow(int num) {
		if (num % 4 == 0) {
			IEntity pos = getChild(ExtraScene.EXTRA_GAME_LAYER).getChild(num / 2 - 1);
			
			// check delle soluzioni
			boolean check1[] = new boolean[4];
			check1[0] = false;
			check1[1] = false;
			check1[2] = false;
			check1[3] = false;
			
			LinkedList<IEntity> slotPos = new LinkedList<IEntity>();
			
			for (int i = 0; i < 4; i++) {
				IEntity w = getChild(ExtraScene.GAME_LAYER).getChild(num - 4 + i).getFirstChild().getFirstChild();
				float r = this.mColor[this.mListValue.get(i).intValue()][0];
				float g = this.mColor[this.mListValue.get(i).intValue()][1];
				float b = this.mColor[this.mListValue.get(i).intValue()][2];
				
				if (w.getRed() == r && w.getGreen() == g && w.getBlue() == b) {
					slotPos.add(0, this.mSpriteBird2);
					check1[i] = true;
				}
			}
			
			// check delle soluzioni
			boolean check2[] = new boolean[4];
			check2[0] = check1[0];
			check2[1] = check1[1];
			check2[2] = check1[2];
			check2[3] = check1[3];
			
			for (int i = 0; i < 4; i++) {
				if (check1[i] == true) continue;
				IEntity w = getChild(ExtraScene.GAME_LAYER).getChild(num - 4 + i).getFirstChild().getFirstChild();
				
				for (int j = 0; j < 4; j++) {
					if (check2[j] == true) continue;
					
					float r = this.mColor[this.mListValue.get(j).intValue()][0];
					float g = this.mColor[this.mListValue.get(j).intValue()][1];
					float b = this.mColor[this.mListValue.get(j).intValue()][2];
					if ((w.getRed() == r && w.getGreen() == g && w.getBlue() == b) && (check2[j] == false)) {
						slotPos.add(this.mSpriteBird1);
						check2[j] = true;
						break;
					}
				}
			}
			
			for (int i = 0; i < 4; i++) {
				try {
					pos.getChild(i).attachChild(slotPos.get(i));
				} catch (Exception e) {
					
				}
			}
		}
	}
	
	@Override
	public void manageSceneTouch(TouchEvent pSceneTouchEvent) {
		// TODO Auto-generated method stub
		
	}
	
	@Override
	public MenuScene createMenu() {
		return this.mMenu;
	}
	
}
