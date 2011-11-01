package org.anddev.andengine.mmcomix.scene;

import java.util.LinkedList;

import org.amatidev.scene.AdScene;
import org.amatidev.util.AdEnviroment;
import org.amatidev.util.AdResourceLoader;
import org.anddev.andengine.engine.handler.timer.ITimerCallback;
import org.anddev.andengine.engine.handler.timer.TimerHandler;
import org.anddev.andengine.entity.Entity;
import org.anddev.andengine.entity.IEntity;
import org.anddev.andengine.entity.modifier.MoveYModifier;
import org.anddev.andengine.entity.modifier.ScaleModifier;
import org.anddev.andengine.entity.modifier.IEntityModifier.IEntityModifierListener;
import org.anddev.andengine.entity.scene.background.ColorBackground;
import org.anddev.andengine.entity.scene.menu.MenuScene;
import org.anddev.andengine.entity.sprite.AnimatedSprite;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.entity.text.ChangeableText;
import org.anddev.andengine.entity.text.Text;
import org.anddev.andengine.input.touch.TouchEvent;
import org.anddev.andengine.opengl.font.Font;
import org.anddev.andengine.opengl.texture.region.TextureRegion;
import org.anddev.andengine.opengl.texture.region.TiledTextureRegion;
import org.anddev.andengine.util.MathUtils;
import org.anddev.andengine.util.TimeUtils;
import org.anddev.andengine.util.modifier.IModifier;

import com.openfeint.api.resource.Leaderboard;
import com.openfeint.api.resource.Score;

import android.app.Activity;
import android.graphics.Color;

public class Game extends AdScene {
	
	private LinkedList<Integer> mListValue;
	private float mColor[][];
	private int mCount = 40;
	
	private TextureRegion mHole;
	private TextureRegion mHoleFront;
	private TextureRegion mShadow;
	private TextureRegion mDialog;
	private TextureRegion mBall;
	private TiledTextureRegion mWorm1;
	private TiledTextureRegion mWorm2;
	private TiledTextureRegion mWorm3;
	private TiledTextureRegion mWorm4;
	private TiledTextureRegion mWorm5;
	private TiledTextureRegion mWorm6;
	private TiledTextureRegion mBird1;
	private TiledTextureRegion mBird2;
	
	private AnimatedSprite mSpriteBird1;
	private AnimatedSprite mSpriteBird2;
	
	private Font mFont1;
	private Font mFont2;
	private Font mFont3;
	
	private Text mYouWin;
	private Text mYouLose;
	
	private GameMenu mMenu = null;
	
	private int mTime = 0;
	
	@Override
	public void createScene() {
		setBackground(new ColorBackground(0.603921569f, 0.909803922f, 0.337254902f));
		
		this.mFont1 = AdResourceLoader.getFont(512, 512, "akaDylan Plain", 21, 2, Color.WHITE, Color.BLACK);
		this.mFont2 = AdResourceLoader.getFont(512, 512, "akaDylan Plain", 58, 4, Color.WHITE, Color.BLACK);
		this.mFont3 = AdResourceLoader.getFont(512, 512, "akaDylan Plain", 25, 2, Color.WHITE, Color.BLACK);
		
		final ChangeableText time = new ChangeableText(54, 38, this.mFont3, TimeUtils.formatSeconds(this.mTime), 5);
		time.setColor(1.0f, 0.7f, 0.7f);
		time.setScale(1.1f);
		getChild(GUI_LAYER).attachChild(time);
		
		registerUpdateHandler(new TimerHandler(1f, true, new ITimerCallback() {
			@Override
			public void onTimePassed(TimerHandler pTimerHandler) {
				Game.this.mTime++;
				time.setText(TimeUtils.formatSeconds(Game.this.mTime));
			}
		}));
		
		this.mYouWin = new Text(0, 0, this.mFont2, "You Win!");
		this.mYouWin.setColor(1.0f, 1.0f, 0.7f);
		this.mYouLose = new Text(0, 0, this.mFont2, "You Lose!");
		this.mYouLose.setColor(1.0f, 1.0f, 0.7f);
		this.mDialog = AdResourceLoader.getTexture(512, 256, "dialog");
		this.mBall = AdResourceLoader.getTexture(64, 64, "ball");
		
		this.mWorm1 = AdResourceLoader.getTexture(128, 64, "worm1", 2, 1);
		this.mWorm2 = AdResourceLoader.getTexture(128, 64, "worm2", 2, 1);
		this.mWorm3 = AdResourceLoader.getTexture(128, 64, "worm3", 2, 1);
		this.mWorm4 = AdResourceLoader.getTexture(128, 64, "worm4", 2, 1);
		this.mWorm5 = AdResourceLoader.getTexture(128, 64, "worm5", 2, 1);
		this.mWorm6 = AdResourceLoader.getTexture(128, 64, "worm6", 2, 1);
		
		this.mShadow = AdResourceLoader.getTexture(128, 128, "nest");
		this.mBird1 = AdResourceLoader.getTexture(128, 64, "bird1", 2, 1);
		this.mBird2 = AdResourceLoader.getTexture(128, 64, "bird2", 2, 1);
		this.mHole = AdResourceLoader.getTexture(128, 128, "hole_back");
		this.mHoleFront = AdResourceLoader.getTexture(128, 128, "hole");
		
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
    	this.mListValue.add(new Integer(4));
    	*/
    	// create scene
		int space_x = 33;
		int space_y = 108;
		
		for (int i = 0; i < 36; i++) {
			int x = i % 4;
			int y = (int)(i / 4);
			Sprite h = new Sprite(space_x + x * 80, space_y + y * 64, this.mHole);
			h.attachChild(new Entity());
			Sprite hf = new Sprite(0, 0, this.mHoleFront);
			h.attachChild(hf);
			getChild(GAME_LAYER).attachChild(h);
			
			if (x == 0) {
				Text num = new Text(h.getX() - 23, h.getY() - 11, this.mFont1, Integer.toString(9 - y));
				getChild(EXTRA_GAME_LAYER).attachChild(num);
			} else if (x == 3) {
				Sprite pos = new Sprite(0, 0, this.mShadow);
				pos.setPosition(h.getX() + 109, h.getY() - 30);
				Entity p1 = new Entity();
				Entity p2 = new Entity();
				Entity p3 = new Entity();
				Entity p4 = new Entity();
				p1.setPosition(12, 15);
				p2.setPosition(48, 15);
				p3.setPosition(12, 35);
				p4.setPosition(48, 35);
				pos.attachChild(p1);
				pos.attachChild(p2);
				pos.attachChild(p3);
				pos.attachChild(p4);
				getChild(EXTRA_GAME_LAYER).attachChild(pos);
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
			
			AnimatedSprite color = null;
			if (i == 0)
				color = new AnimatedSprite(27, -34, this.mWorm1);
			else if (i == 1)
				color = new AnimatedSprite(27, -34, this.mWorm2);
			else if (i == 2)
				color = new AnimatedSprite(27, -34, this.mWorm3);
			else if (i == 3)
				color = new AnimatedSprite(27, -34, this.mWorm4);
			else if (i == 5)
				color = new AnimatedSprite(27, -34, this.mWorm6);
			else
				color = new AnimatedSprite(27, -34, this.mWorm5);
			color.animate(3000);
			color.setColor(this.mColor[i][0], this.mColor[i][1], this.mColor[i][2]);
			registerTouchArea(color);
			
			h.getFirstChild().attachChild(color);
			getChild(GAME_LAYER).attachChild(h);
		}
	}
	
	@Override
	public void startScene() {
		this.mMenu = new GameMenu();
	}
	
	@Override
	public void endScene() {
		AdEnviroment.getInstance().setScene(new Game());
	}
	
	@Override
	public void manageAreaTouch(ITouchArea pTouchArea) {
		setOnAreaTouchListener(null);
		unregisterTouchArea(pTouchArea);
		
		if (this.mCount % 4 == 0)
			this.mCount -= 8;
		
		final IEntity color = (IEntity) pTouchArea;
		
		color.registerEntityModifier(
				new MoveYModifier(0.1f, color.getY(), color.getY() + 44f, new IEntityModifierListener() {
					@Override
					public void onModifierFinished(IModifier<IEntity> pModifier, IEntity pItem) {
						Game.this.pop(color);
					}

					@Override
					public void onModifierStarted(IModifier<IEntity> pModifier, IEntity pItem) {
						
					}
				})
		);
	}
	
	private void pop(final IEntity color){
		registerUpdateHandler(new TimerHandler(0.3f, false, new ITimerCallback() {
			@Override
			public void onTimePassed(TimerHandler pTimerHandler) {
				IEntity h = getChild(GAME_LAYER).getChild(Game.this.mCount);
				
				AnimatedSprite w = new AnimatedSprite(27, 10, ((AnimatedSprite) color).getTextureRegion());
				w.animate(3000);
				w.setColor(color.getRed(), color.getGreen(), color.getBlue());
				h.getFirstChild().attachChild(w);
				
				Game.this.mCount += 1;
				final boolean result = checkRow(Game.this.mCount);
				
				w.registerEntityModifier(new MoveYModifier(0.1f, w.getY(), w.getY() - 44f, new IEntityModifierListener() {
					@Override
					public void onModifierFinished(IModifier<IEntity> pModifier, IEntity pItem) {
						if (!result)
							if (Game.this.mCount != 4)
								Game.this.setOnAreaTouchListener(Game.this);
							else
								Game.this.dialog("love");
						else
							Game.this.dialog("win");
						
						Game.this.unpop(color);
					}

					@Override
					public void onModifierStarted(IModifier<IEntity> pModifier, IEntity pItem) {
						
					}
				}));
			}
		}));
	}
	
	private void unpop(final IEntity color) {
		registerUpdateHandler(new TimerHandler(0.1f, false, new ITimerCallback() {
			@Override
			public void onTimePassed(TimerHandler pTimerHandler) {
				color.registerEntityModifier(new MoveYModifier(0.3f, color.getY(), color.getY() - 44f, new IEntityModifierListener() {
					@Override
					public void onModifierFinished(IModifier<IEntity> pModifier, IEntity pItem) {
						Game.this.registerTouchArea((ITouchArea) color);
					}

					@Override
					public void onModifierStarted(IModifier<IEntity> pModifier, IEntity pItem) {
						
					}
				}));	
			}
		}));
	}
	
	private void dialog(final String result) {
		Sprite dialog = new Sprite(0, 0, this.mDialog);
		dialog.setAlpha(0.9f);
		dialog.setPosition(AdEnviroment.getInstance().getScreenWidth() / 2 - dialog.getWidthScaled() / 2, AdEnviroment.getInstance().getScreenHeight() / 2 - dialog.getHeightScaled() / 2);
		getChild(GUI_LAYER).attachChild(dialog);
		
		Text time = new Text(0, 0, this.mFont3, TimeUtils.formatSeconds(this.mTime));
		time.setColor(1.0f, 0.7f, 0.7f);
		time.registerEntityModifier(new ScaleModifier(0.3f, 0f, 1.0f));
		time.setPosition(dialog.getWidthScaled() / 2 - time.getWidthScaled() / 2, 107);
		dialog.attachChild(time);
		
		if (result.equals("win")) {
			this.mYouWin.registerEntityModifier(new ScaleModifier(0.3f, 0f, 1.0f));
			this.mYouWin.setPosition(dialog.getWidthScaled() / 2 - this.mYouWin.getWidthScaled() / 2, 25);
			dialog.attachChild(this.mYouWin);
			
			try {
				Score s = new Score((long)this.mTime, TimeUtils.formatSeconds(this.mTime ));
				Leaderboard l = new Leaderboard("771276");
				s.submitTo(l, new Score.SubmitToCB() {
					@Override public void onSuccess(boolean newHighScore) {
						((Activity) AdEnviroment.getInstance().getContext()).setResult(Activity.RESULT_OK);
					}
					
					@Override public void onFailure(String exceptionMessage) {
						((Activity) AdEnviroment.getInstance().getContext()).setResult(Activity.RESULT_CANCELED);
					}
				});
			} catch (Exception e) {
				
			}
		} else {
			this.mYouLose.registerEntityModifier(new ScaleModifier(0.3f, 0f, 1.0f));
			this.mYouLose.setPosition(dialog.getWidthScaled() / 2 - this.mYouLose.getWidthScaled() / 2, 25);
			dialog.attachChild(this.mYouLose);
		}
		
		for (int i = 0; i < 4; i++) {
			float r = this.mColor[this.mListValue.get(i).intValue()][0];
			float g = this.mColor[this.mListValue.get(i).intValue()][1];
			float b = this.mColor[this.mListValue.get(i).intValue()][2];
			Sprite ball = new Sprite(85 + i * 80, 150, this.mBall);
			ball.setColor(r, g, b);
			ball.registerEntityModifier(new ScaleModifier(0.3f, 0f, 1.0f));
			dialog.attachChild(ball);
		}
	}
	
	private boolean checkRow(int num) {
		boolean result = false;
		if (num % 4 == 0) {
			IEntity pos = getChild(EXTRA_GAME_LAYER).getChild(num / 2 - 1);
			
			// check delle soluzioni
			boolean check1[] = new boolean[4];
			check1[0] = false;
			check1[1] = false;
			check1[2] = false;
			check1[3] = false;
			
			LinkedList<IEntity> slotPos = new LinkedList<IEntity>();
			
			int finish = 0;
			for (int i = 0; i < 4; i++) {
				IEntity w = getChild(GAME_LAYER).getChild(num - 4 + i).getFirstChild().getFirstChild();
				float r = this.mColor[this.mListValue.get(i).intValue()][0];
				float g = this.mColor[this.mListValue.get(i).intValue()][1];
				float b = this.mColor[this.mListValue.get(i).intValue()][2];
				
				if (w.getRed() == r && w.getGreen() == g && w.getBlue() == b) {
					slotPos.add(0, this.mSpriteBird2);
					check1[i] = true;
					finish++;
				}
			}
			if (finish >= 4)
				result = true;
			else {
				// check delle soluzioni
				boolean check2[] = new boolean[4];
				check2[0] = check1[0];
				check2[1] = check1[1];
				check2[2] = check1[2];
				check2[3] = check1[3];
				
				for (int i = 0; i < 4; i++) {
					if (check1[i] == true) continue;
					IEntity w = getChild(GAME_LAYER).getChild(num - 4 + i).getFirstChild().getFirstChild();
					
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
			}
			
			for (int i = 0; i < 4; i++) {
				try {
					pos.getChild(i).attachChild(slotPos.get(i));
				} catch (Exception e) {
					
				}
			}
		}
		return result;
	}
	
	@Override
	public MenuScene createMenu() {
		return this.mMenu;
	}

	@Override
	public void downSceneTouch(TouchEvent pSceneTouchEvent) {
		// TODO Auto-generated method stub
		
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
