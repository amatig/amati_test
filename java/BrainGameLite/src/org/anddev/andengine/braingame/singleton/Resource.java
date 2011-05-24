/***
=== BrainGame ===

Copyright (C) 2011 Giovanni Amati

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
***/

package org.anddev.andengine.braingame.singleton;

import java.io.IOException;

import org.anddev.andengine.audio.sound.SoundFactory;
import org.anddev.andengine.braingame.BrainGame;
import org.anddev.andengine.braingame.util.MyScene;
import org.anddev.andengine.braingame.util.MySound;
import org.anddev.andengine.engine.handler.timer.ITimerCallback;
import org.anddev.andengine.engine.handler.timer.TimerHandler;
import org.anddev.andengine.entity.modifier.ScaleModifier;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.opengl.font.Font;
import org.anddev.andengine.opengl.font.FontFactory;
import org.anddev.andengine.opengl.texture.Texture;
import org.anddev.andengine.opengl.texture.TextureOptions;
import org.anddev.andengine.opengl.texture.region.TextureRegion;
import org.anddev.andengine.opengl.texture.region.TextureRegionFactory;
import org.anddev.andengine.opengl.texture.region.TiledTextureRegion;

import android.graphics.Color;

public class Resource {
	private static Resource mInstance = null;
	
	// data utils
	private BrainGame mGame = null;
	
	// sound
	private MySound mFail;
	private MySound mDone;
	
	// colors
	private float mColor[][];
	
	// summary
	public Font fontLook;
	public Font fontCount;
	public Font fontFind;
	public Font fontBall;
	public Font fontCatch;
	public Font fontSum;
	
	// font
	public Font fontScore;
	public Font fontMainMenu;
	public Font fontCountDown; // start countdown
	public Font fontBalloon;
	public Font fontBox;
	public Font fontStart; // scritta del via
	public Font fontSumNum;
	public Font fontTime;
	public Font fontMenu;
	public Font fontPlayer; // numero dello start
	public Font fontPlayer2; // numeri p1 e p2 della end
	public Font fontSeqNum1;
	public Font fontSeqNum2;
	public Font fontSeqNote1;
	public Font fontSeqNote2;
	public Font fontErrorP1;
	public Font fontErrorP2;
	public Font fontTimeP1;
	public Font fontTimeP2;
	
	// texture
	public TextureRegion texInfo;
	public TextureRegion texTitle;
	public TextureRegion texScore;
	public TextureRegion texQuad;
	public TextureRegion texQuad2;
	public TextureRegion texSplash;
	public TextureRegion texBack;
	public TextureRegion texBack2;
	public TextureRegion texEyes;
	public TextureRegion texTrue;
	public TextureRegion texFalse;
	public TextureRegion texBox;
	public TextureRegion texBase;
	public TextureRegion texStep;
	public TextureRegion texPos;
	public TextureRegion texSomm;
	public TextureRegion texArrow;
	public TextureRegion texBalloon;
	public TextureRegion texTazza;
	public TextureRegion texShadow;
	public TextureRegion texTubo;
	public TextureRegion texTubo2;
	public TextureRegion texPaletta;
	public TextureRegion texSlot;
	public TextureRegion texLavagna;
	public TextureRegion texLavagnaProf;
	public TextureRegion texTitlePlayer;
	public TextureRegion texTitleFinish;
	public TextureRegion texCloud;
	
	// Costruttore
	private Resource() {
		
	}
	
	public static synchronized Resource instance() {
		if (mInstance == null) 
			mInstance = new Resource();
		return mInstance;
	}
	
	public void loadResources(BrainGame game) {
		this.mGame = game;
		
		this.mDone = Resource.instance().getSound("ok");
		this.mFail = Resource.instance().getSound("fail");
		
		// color
    	this.mColor = new float[9][3];
    	this.mColor[0][0] = 1.0f; this.mColor[0][1] = 0.3f; this.mColor[0][2] = 0.3f;
    	this.mColor[1][0] = 0.2f; this.mColor[1][1] = 0.9f; this.mColor[1][2] = 0.2f;
    	this.mColor[2][0] = 0.4f; this.mColor[2][1] = 0.4f; this.mColor[2][2] = 1.0f;
    	this.mColor[3][0] = 1.0f; this.mColor[3][1] = 0.9f; this.mColor[3][2] = 0.0f;
    	this.mColor[4][0] = 0.9f; this.mColor[4][1] = 0.2f; this.mColor[4][2] = 1.0f;
    	this.mColor[5][0] = 0.2f; this.mColor[5][1] = 0.8f; this.mColor[5][2] = 1.0f;
    	this.mColor[6][0] = 1.0f; this.mColor[6][1] = 0.6f; this.mColor[6][2] = 0.2f;
    	this.mColor[7][0] = 0.7f; this.mColor[7][1] = 0.4f; this.mColor[7][2] = 0.4f;
    	this.mColor[8][0] = 1.0f; this.mColor[8][1] = 0.8f; this.mColor[8][2] = 1.0f;
    	
    	// global
    	this.texTrue = getTexture(512, 512, "true");
    	this.texFalse = getTexture(512, 512, "false");
    	this.texBack = getTexture(512, 1024, "back"); // main
    	this.texBack2 = getTexture(512, 1024, "back2"); // sfondo
    	this.texEyes = getTexture(64, 32, "eyes");
    	this.texSplash = getTexture(512, 1024, "splash");
    	this.texQuad = getTexture(512, 512, "quad"); // sommario quadrante
    	this.texQuad2 = getTexture(512, 512, "quad2");
    	this.texPos = getTexture(64, 64, "step2"); // cubetti
    	this.texSomm = getTexture(256, 256, "somm"); // sommario piccolo
    	this.texInfo = getTexture(256, 256, "info"); // info
    	
		// main menu
    	this.texTitle = getTexture(512, 256, "title");
    	this.fontMainMenu = getFont(512, 512, "akaDylan Plain", 40, 3, Color.WHITE, Color.BLACK);
    	
    	// start / end
    	this.texTitlePlayer = getTexture(512, 128, "player");
    	this.texLavagna = getTexture(512, 256, "lavagna");
    	this.texLavagnaProf = getTexture(512, 512, "lavagna_prof");
    	
    	this.fontPlayer = getFont("akaDylan Plain", 150, 4, Color.WHITE, Color.BLACK);
    	this.fontStart = getFont("chalkdustextended", 75, Color.WHITE);
    	this.fontCountDown = getFont(512, 512, "chalkdustextended", 120, Color.WHITE);
    	
    	this.texTitleFinish = getTexture(512, 128, "finish");
    	this.fontPlayer2 = getFont("akaDylan Plain", 50, 3, Color.WHITE, Color.BLACK);
    	this.fontErrorP1 = getFont("chalkdustextended", 36, Color.WHITE);
    	this.fontErrorP2 = getFont("chalkdustextended", 33, Color.WHITE);
    	this.fontTimeP1 = getFont("chalkdustextended", 33, Color.WHITE);
    	this.fontTimeP2 = getFont("chalkdustextended", 33, Color.WHITE);
    	
    	// context menu
    	this.fontMenu = getFont(512, 512, "akaDylan Plain", 48, 3, Color.WHITE, Color.BLACK);
    	
    	// score
    	this.texScore = getTexture(512, 128, "score");
    	this.fontScore = getFont(512, 512, "akaDylan Plain", 33, 3, Color.WHITE, Color.BLACK);
    	
    	// score layer
    	this.fontTime = getFont("akaDylan Plain", 30, 3, Color.WHITE, Color.BLACK);
    	this.texStep = getTexture(64, 64, "step1");
    	
		// sum box
    	this.fontSum = getFont("akaDylan Plain", 35, 3, Color.WHITE, Color.BLACK);
    	this.fontSumNum = getFont("akaDylan Plain", 50, 3, Color.WHITE, Color.BLACK);
    	this.texBase = getTexture(256, 128, "base");
    	this.texBox = getTexture(128, 128, "box");
    	this.fontBox = getFont("akaDylan Plain", 48, 4, Color.WHITE, Color.BLACK);
    	
    	// mem sequence
    	this.fontLook = getFont("akaDylan Plain", 38, 3, Color.WHITE, Color.BLACK);
    	this.texSlot = getTexture(128, 128, "slot");
    	this.fontSeqNum1 = getFont("akaDylan Plain", 48, 4, Color.WHITE, Color.BLACK);
    	this.fontSeqNum2 = getFont(512, 512, "akaDylan Plain", 75, 4, Color.WHITE, Color.BLACK);
    	this.fontSeqNote1 = getFont("akaDylan Plain", 43, 4, Color.WHITE, Color.BLACK);
    	this.fontSeqNote2 = getFont(512, 512, "akaDylan Plain", 51, 4, Color.WHITE, Color.BLACK);
    	
    	// catch elem
    	this.fontCatch = getFont("akaDylan Plain", 38, 3, Color.WHITE, Color.BLACK);
    	this.texArrow = getTexture(128, 128, "arrow");
    	this.texPaletta = getTexture(128, 128, "paletta");
    	this.texTubo = getTexture(128, 128, "tubo");
    	this.texTubo2 = getTexture(128, 32, "tubo2");
    	
    	// count down ballon
    	this.fontCount = getFont("akaDylan Plain", 38, 3, Color.WHITE, Color.BLACK);
    	this.texBalloon = getTexture(256, 256, "balloon");
    	this.fontBalloon = getFont("akaDylan Plain", 50, 4, Color.WHITE, Color.BLACK);
    	
    	// mem shuffle
    	this.fontFind = getFont("akaDylan Plain", 38, 3, Color.WHITE, Color.BLACK);
    	this.texTazza = getTexture(128, 128, "tazza");
    	this.texShadow = getTexture(128, 64, "shadow");
    	
    	// fly ball
    	this.fontBall = getFont("akaDylan Plain", 32, 3, Color.WHITE, Color.BLACK);
    	this.texCloud = getTexture(256, 128, "cloud");
	}
	
	public float[][] getColor() {
		return this.mColor;
	}
	
	private Font getFont(String name, int size, int width, int fillColor, int borderColor) {
		return getFont(256, 256, name, size, width, fillColor, borderColor);
	}
	
	private Font getFont(int w, int h, String name, int size, int width, int fillColor, int borderColor) {
		Texture tex = new Texture(w, h, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
		Font font = FontFactory.createStrokeFromAsset(tex, this.mGame, "font/" + name + ".ttf", size, true, fillColor, width, borderColor, false);
		this.mGame.getEngine().getTextureManager().loadTexture(tex);
		this.mGame.getEngine().getFontManager().loadFont(font);
		return font;
	}
	
	private Font getFont(String name, int size, int fillColor) {
		return getFont(256, 256, name, size, fillColor);
	}
	
	private Font getFont(int w, int h, String name, int size, int fillColor) {
		Texture tex = new Texture(w, h, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
		Font font = FontFactory.createFromAsset(tex, this.mGame, "font/" + name + ".ttf", size, true, fillColor);
		this.mGame.getEngine().getTextureManager().loadTexture(tex);
		this.mGame.getEngine().getFontManager().loadFont(font);
		return font;
	}
	
	private TextureRegion getTexture(int w, int h, String name) {
		Texture tex = new Texture(w, h, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
		TextureRegion texReg = TextureRegionFactory.createFromAsset(tex, this.mGame, "gfx/" + name + ".png", 0, 0);
		this.mGame.getEngine().getTextureManager().loadTexture(tex);
		return texReg;
	}
	
	private TiledTextureRegion getTexture(int w, int h, String name, int col, int row) {
		Texture tex = new Texture(w, h, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
		TiledTextureRegion texReg = TextureRegionFactory.createTiledFromAsset(tex, this.mGame, "gfx/" + name + ".png", 0, 0, col, row);
		this.mGame.getEngine().getTextureManager().loadTexture(tex);
		return texReg;
	}
	
	public MySound getSound(String name) {
		MySound sound = null;
		try {
			sound = new MySound(SoundFactory.createSoundFromAsset(this.mGame.getEngine().getSoundManager(), this.mGame, "mfx/" + name + ".wav"));
		} catch (final IOException e) {
		}
		return sound;
	}
	
	public void done() {
		Enviroment.instance().getScene().setOnAreaTouchListener(null);
		
		Sprite trueSprite = new Sprite(90, 250, Resource.instance().texTrue);
		trueSprite.setAlpha(0.8f);
		
		trueSprite.registerEntityModifier(
				new ScaleModifier(0.2f, 0f, 1.0f)
		);
		((MyScene) Enviroment.instance().getScene()).getGameLayer().attachChild(trueSprite);
		
		this.mDone.play();
		Enviroment.instance().getScoreLayer().nextStep(); // pallino del livello
		if (Enviroment.instance().getCurrentPlayer() == 1)
			Enviroment.instance().setTimeP1(Enviroment.instance().getScoreLayer().getTime());
		else
			Enviroment.instance().setTimeP2(Enviroment.instance().getScoreLayer().getTime());
		
		Enviroment.instance().getScene().registerUpdateHandler(new TimerHandler(1.5f, false, new ITimerCallback() {
			@Override
			public void onTimePassed(TimerHandler pTimerHandler) {
				((MyScene)Enviroment.instance().getScene()).getFadeLayer().FadeIn(null);
			}
		}));
	}
	
	public void fail(final MyScene scene) {
		Enviroment.instance().getScene().setOnAreaTouchListener(null);
		
		Sprite falseSprite = new Sprite(90, 250, Resource.instance().texFalse);
		falseSprite.setAlpha(0.8f);
		
		falseSprite.registerEntityModifier(
                new ScaleModifier(0.2f, 0f, 1.0f)
		);
		((MyScene) Enviroment.instance().getScene()).getGameLayer().attachChild(falseSprite);
		
		this.mFail.play();
		Enviroment.instance().vibrate();
		if (Enviroment.instance().getCurrentPlayer() == 1)
			Enviroment.instance().incErrorP1();
		else
			Enviroment.instance().incErrorP2();
		
		Enviroment.instance().getScene().registerUpdateHandler(new TimerHandler(1.5f, false, new ITimerCallback() {
			@Override
			public void onTimePassed(TimerHandler pTimerHandler) {
				((MyScene)Enviroment.instance().getScene()).getFadeLayer().FadeIn(scene);
			}
		}));
	}
	
}
