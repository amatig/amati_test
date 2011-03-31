package org.anddev.andengine.memopuzzle.utils;

import org.anddev.andengine.entity.layer.Layer;
import org.anddev.andengine.memopuzzle.MemoPuzzle;
import org.anddev.andengine.memopuzzle.ScoreLayer;
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
		
		this.mTexFont0 = new Texture(256, 256, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
		this.mTexFont1 = new Texture(256, 256, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
    	this.mTexFont2 = new Texture(256, 256, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
    	
    	this.mFontDefault = new Font(this.mTexFont0, Typeface.create(Typeface.DEFAULT, Typeface.NORMAL), 20, true, Color.BLACK);
    	this.mFontBigWhite = FontFactory.createFromAsset(this.mTexFont1, this.mGame, "font/akaDylan Collage.ttf", 48, true, Color.WHITE);
		this.mFontSmallBlack = FontFactory.createFromAsset(this.mTexFont2, this.mGame, "font/akaDylan Collage.ttf", 30, true, Color.BLACK);
		
		this.mGame.getEngine().getTextureManager().loadTextures(this.mTexFont0, this.mTexFont1, this.mTexFont2);
		this.mGame.getEngine().getFontManager().loadFonts(this.mFontDefault, this.mFontBigWhite, this.mFontSmallBlack);
		
		this.mScore = new ScoreLayer();
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
