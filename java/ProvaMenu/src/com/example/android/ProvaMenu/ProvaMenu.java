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
public class ProvaMenu extends BaseGameActivity implements IOnMenuItemClickListener {
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
			this.mMenuTexture = new Texture(256, 128, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
			this.mMenuResetTextureRegion = TextureRegionFactory.createFromAsset(this.mMenuTexture, this, "gfx/menu_reset.png", 0, 0);
			this.mMenuQuitTextureRegion = TextureRegionFactory.createFromAsset(this.mMenuTexture, this, "gfx/menu_quit.png", 0, 50);
			this.mEngine.getTextureManager().loadTexture(this.mMenuTexture);
		}

		@Override
		public Scene onLoadScene() {
			//this.mEngine.registerUpdateHandler(new FPSLogger());

			this.createMenuScene();

			/* Just a simple scene with an animated face flying around. */
			this.mMainScene = new Scene(1);
			this.mMainScene.setBackground(new ColorBackground(0.09804f, 0.6274f, 0.8784f));
			
			
			TextureRegion tex = getTexture(128, 128, "gfx/face_box_tiled.png");
			//Texture tex2 = new Texture(64, 64, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
			//tex = TextureRegionFactory.createFromAsset(tex2, this, "gfx/face_box_tiled.png", 0, 0);
			//this.getEngine().getTextureManager().loadTexture(tex2);
			
			this.mMainScene.attachChild(new Sprite(0,0,tex));
			return this.mMainScene;
		}

		@Override
		public void onLoadComplete() {

		}

		@Override
		public boolean onKeyDown(final int pKeyCode, final KeyEvent pEvent) {
			if(pKeyCode == KeyEvent.KEYCODE_MENU && pEvent.getAction() == KeyEvent.ACTION_DOWN) {
				if(this.mMainScene.hasChildScene()) {
					/* Remove the menu and reset it. */
					//this.mMenuScene.back();
				} else {
					/* Attach the menu. */
					this.mMainScene.setChildScene(this.mMenuScene, false, true, true);
				}
				return true;
			} else {
				return super.onKeyDown(pKeyCode, pEvent);
			}
		}

		@Override
		public boolean onMenuItemClicked(final MenuScene pMenuScene, final IMenuItem pMenuItem, final float pMenuItemLocalX, final float pMenuItemLocalY) {
			switch(pMenuItem.getID()) {
				case MENU_RESET:
					/* Restart the animation. */
					//this.mMainScene.reset();

					/* Remove the menu and reset it. */
					//this.mMainScene.clearChildScene();
					//this.mMenuScene.reset();
					return true;
				case MENU_QUIT:
					/* End Activity. */
					this.finish();
					return true;
				default:
					return false;
			}
		}

		// ===========================================================
		// Methods
		// ===========================================================

		protected void createMenuScene() {
			this.mMenuScene = new MenuScene(this.mCamera);

			final SpriteMenuItem resetMenuItem = new SpriteMenuItem(MENU_RESET, this.mMenuResetTextureRegion);
			resetMenuItem.setBlendFunction(GL10.GL_SRC_ALPHA, GL10.GL_ONE_MINUS_SRC_ALPHA);
			this.mMenuScene.addMenuItem(resetMenuItem);

			final SpriteMenuItem quitMenuItem = new SpriteMenuItem(MENU_QUIT, this.mMenuQuitTextureRegion);
			quitMenuItem.setBlendFunction(GL10.GL_SRC_ALPHA, GL10.GL_ONE_MINUS_SRC_ALPHA);
			this.mMenuScene.addMenuItem(quitMenuItem);

			this.mMenuScene.buildAnimations();

			this.mMenuScene.setBackgroundEnabled(false);

			this.mMenuScene.setOnMenuItemClickListener(this);
		}

		// ===========================================================
		// Inner and Anonymous Classes
		// ===========================================================
		
		public TextureRegion getTexture(int w, int h, String name) {
			Texture tex = new Texture(w, h, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
			TextureRegion texReg = TextureRegionFactory.createFromAsset(tex, this, name, 0, 0);
			this.getEngine().getTextureManager().loadTexture(tex);
			return texReg;
		}
}