package org.anddev.andengine.memopuzzle.utils;

import org.anddev.andengine.entity.layer.Layer;
import org.anddev.andengine.memopuzzle.MemoPuzzle;
import org.anddev.andengine.opengl.font.Font;
import org.anddev.andengine.opengl.font.FontFactory;
import org.anddev.andengine.opengl.texture.Texture;
import org.anddev.andengine.opengl.texture.TextureOptions;

import android.graphics.Color;
import android.graphics.Typeface;

public class Enviroment {
	private static Enviroment mInstance = null;
	
	private int mDifficult = 1;  // 0 Easy 1 Normal 2 Hard
	private MemoPuzzle mGame = null;
	private Layer mScore = null;
	
	private float mColor[][];
	private Texture mTexFont0;
    private Texture mTexFont1;
    private Texture mTexFont2;
	private Font mFontBigWhite;
	private Font mFontSmallBlack;
	private Font mFontDefault;
	
	private Enviroment() {
		
	}
	
	public static synchronized Enviroment instance() {
		if (mInstance == null) 
			mInstance = new Enviroment();
		return mInstance;
	}
	
	public static int random(int min, int max) {
		int range = max - min + 1;
    	int value = (int)(range * Math.random()) + min;
    	return value;
	}
	
	public void setDifficult(int value) {
		this.mDifficult = value;
	}
	
	public int getDifficult() {
		return this.mDifficult;
	}
	
	public void loadResource(MemoPuzzle game) {
		this.mGame = game;
		
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
    	
    	// font
		this.mTexFont0 = new Texture(256, 256, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
		this.mTexFont1 = new Texture(256, 256, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
    	this.mTexFont2 = new Texture(256, 256, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
    	
    	this.mFontDefault = new Font(this.mTexFont0, Typeface.create(Typeface.DEFAULT, Typeface.NORMAL), 20, true, Color.BLACK);
    	this.mFontBigWhite = FontFactory.createFromAsset(this.mTexFont1, this.mGame, "font/akaDylan Plain.ttf", 48, true, Color.WHITE);
		this.mFontSmallBlack = FontFactory.createFromAsset(this.mTexFont2, this.mGame, "font/actionj.ttf", 40, true, Color.BLACK);
		
		this.mGame.getEngine().getTextureManager().loadTextures(this.mTexFont0, this.mTexFont1, this.mTexFont2);
		this.mGame.getEngine().getFontManager().loadFonts(this.mFontDefault, this.mFontBigWhite, this.mFontSmallBlack);
		
		this.mScore = new ScoreLayer();
	}
	
	public float[][] getColor() {
		return this.mColor;
	}
	
	public Font getFont(int type) {
		switch (type) {
		case 1: return this.mFontBigWhite;
		case 2: return this.mFontSmallBlack;
		}
		return this.mFontDefault;
	}
	
	public MemoPuzzle getGame() {
        return this.mGame;
	}
	
	public Layer getScoreLayer() {
        return this.mScore;
	}
	
}
