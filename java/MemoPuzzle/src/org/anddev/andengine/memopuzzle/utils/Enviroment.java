package org.anddev.andengine.memopuzzle.utils;

import org.anddev.andengine.memopuzzle.MemoPuzzle;
import org.anddev.andengine.opengl.font.Font;
import org.anddev.andengine.opengl.font.FontFactory;
import org.anddev.andengine.opengl.texture.Texture;
import org.anddev.andengine.opengl.texture.TextureOptions;
import org.anddev.andengine.opengl.texture.region.TextureRegion;
import org.anddev.andengine.opengl.texture.region.TextureRegionFactory;

import android.graphics.Color;;

public class Enviroment {
	private static Enviroment mInstance = null;
	
	private int mDifficult = 1;  // 0 Easy 1 Normal 2 Hard
	private boolean mAudio = true;
	
	private MemoPuzzle mGame = null;
	
	private float mColor[][];
	
	public Font fontMainMenu;
	public Font fontMainTitle;
	public TextureRegion texBack;
	public TextureRegion texTrue;
	public TextureRegion texFalse;
	public TextureRegion texBox;
	public Font fontBox;
	public Font fontSum;
	public Font fontScore;
	public Font fontMenu;
	
	// Costruttore
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
	
	public boolean getAudio() {
		return this.mAudio;
	}
	
	public void toggleAudio() {
		this.mAudio = !(this.mAudio);
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
    	
    	this.texTrue = getTexture(512, 512, "true");
    	this.texFalse = getTexture(512, 512, "false");
		
		// main
    	this.texBack = getTexture(1024, 1024, "back");
    	this.fontMainMenu = getFont("akaDylan Plain", 40, 2, Color.WHITE, Color.BLACK);
    	this.fontMainTitle = getFont("akaDylan Plain", 45, 4, Color.WHITE, Color.BLACK);
    	
    	// menu
    	this.fontMenu = getFont("akaDylan Plain", 40, 2, Color.WHITE, Color.BLACK);
    	
    	// score layer
    	fontScore = getFont("akaDylan Plain", 35, 2, Color.WHITE, Color.BLACK);
    	
		// sum box
    	this.texBox = getTexture(128, 128, "box");
    	this.fontBox = getFont("akaDylan Plain", 48, 4, Color.WHITE, Color.BLACK);
    	this.fontSum = getFont("akaDylan Plain", 35, 2, Color.WHITE, Color.BLACK);
	}
	
	public Font getFont(String name, int size, int width, int fillColor, int borderColor) {
		Texture tex = new Texture(256, 256, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
		Font font = FontFactory.createStrokeFromAsset(tex, this.mGame, "font/" + name + ".ttf", size, true, fillColor, width, borderColor, false);
		this.mGame.getEngine().getTextureManager().loadTexture(tex);
		this.mGame.getEngine().getFontManager().loadFont(font);
		return font;
	}
	
	public float[][] getColor() {
		return this.mColor;
	}
	
	public TextureRegion getTexture(int w, int h, String name) {
		Texture tex = new Texture(w, h, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
		TextureRegion texReg = TextureRegionFactory.createFromAsset(tex, this.mGame, "gfx/" + name + ".png", 0, 0);
		this.mGame.getEngine().getTextureManager().loadTexture(tex);
		return texReg;
	}
	
	public MemoPuzzle getGame() {
        return this.mGame;
	}
	
}
