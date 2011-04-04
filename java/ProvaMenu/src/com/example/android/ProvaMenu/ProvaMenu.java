package com.example.android.ProvaMenu;

import javax.microedition.khronos.opengles.GL10;

import org.anddev.andengine.engine.Engine;
import org.anddev.andengine.engine.camera.Camera;
import org.anddev.andengine.engine.options.EngineOptions;
import org.anddev.andengine.engine.options.EngineOptions.ScreenOrientation;
import org.anddev.andengine.engine.options.resolutionpolicy.RatioResolutionPolicy;
import org.anddev.andengine.entity.modifier.MoveModifier;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.entity.scene.background.ColorBackground;
import org.anddev.andengine.entity.scene.menu.MenuScene;
import org.anddev.andengine.entity.scene.menu.MenuScene.IOnMenuItemClickListener;
import org.anddev.andengine.entity.scene.menu.item.IMenuItem;
import org.anddev.andengine.entity.scene.menu.item.SpriteMenuItem;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.entity.text.Text;
import org.anddev.andengine.entity.util.FPSLogger;
import org.anddev.andengine.opengl.font.Font;
import org.anddev.andengine.opengl.font.FontFactory;
import org.anddev.andengine.opengl.texture.Texture;
import org.anddev.andengine.opengl.texture.TextureOptions;
import org.anddev.andengine.opengl.texture.region.TextureRegion;
import org.anddev.andengine.opengl.texture.region.TextureRegionFactory;
import org.anddev.andengine.ui.activity.BaseGameActivity;
import org.anddev.andengine.util.HorizontalAlign;

import android.graphics.Color;
import android.graphics.Typeface;
import android.view.KeyEvent;

/**
 * @author Nicolas Gramlich
 * @since 11:54:51 - 03.04.2010
 */
public class ProvaMenu extends BaseGameActivity {
		// ===========================================================
		// Constants
		// ===========================================================

		private static final int CAMERA_WIDTH = 480;
		private static final int CAMERA_HEIGHT = 720;

		protected static final int MENU_RESET = 0;
		protected static final int MENU_QUIT = MENU_RESET + 1;

		// ===========================================================
		// Fields
		// ===========================================================

		protected Camera mCamera;

		protected Scene mMainScene;

		protected MenuScene mMenuScene;

		private Texture mMenuTexture;
		protected TextureRegion mMenuResetTextureRegion;
		protected TextureRegion mMenuQuitTextureRegion;
		private Texture mTexture;
		private int borderColor;
		private Font font;
		private TextureRegion tex;

		// ===========================================================
		// Constructors
		// ===========================================================

		// ===========================================================
		// Getter & Setter
		// ===========================================================

		// ===========================================================
		// Methods for/from SuperClass/Interfaces
		// ===========================================================

		@Override
		public Engine onLoadEngine() {
			this.mCamera = new Camera(0, 0, CAMERA_WIDTH, CAMERA_HEIGHT);
			return new Engine(new EngineOptions(true, ScreenOrientation.PORTRAIT, new RatioResolutionPolicy(CAMERA_WIDTH, CAMERA_HEIGHT), this.mCamera));
		}

		@Override
		public void onLoadResources() {
			this.mTexture = new Texture(256, 256, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
			font = FontFactory.createFromAsset(this.mTexture, this, "gfx/akaDylan Plain.ttf", 16, true, Color.BLACK);
			tex = TextureRegionFactory.createFromAsset(this.mTexture, this, "gfx/prova2.png", 0, 0);
			getEngine().getTextureManager().loadTexture(this.mTexture);
			getEngine().getFontManager().loadFont(font);
		}

		@Override
		public Scene onLoadScene() {
			//this.mEngine.registerUpdateHandler(new FPSLogger());

			/* Just a simple scene with an animated face flying around. */
			this.mMainScene = new Scene(1);
			this.mMainScene.setBackground(new ColorBackground(1f, 1f, 1f));
			
			
			
			//Texture tex2 = new Texture(64, 64, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
			
			//this.getEngine().getTextureManager().loadTexture(tex2);
			Text text1 = new Text(0, 0, font, "a12z3aafjss45");
			text1.setScale(3.5f);
			this.mMainScene.attachChild(text1);
			this.mMainScene.attachChild(new Text(0, 100, font, "67adbs8te90"));
			this.mMainScene.attachChild(new Sprite(0, 200, tex));
			this.mMainScene.attachChild(new Text(0, 400, font, "qwlcv"));
			return this.mMainScene;
		}

		@Override
		public void onLoadComplete() {

		}

}