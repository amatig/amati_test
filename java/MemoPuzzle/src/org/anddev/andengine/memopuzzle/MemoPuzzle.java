package org.anddev.andengine.memopuzzle;

import org.anddev.andengine.engine.Engine;
import org.anddev.andengine.engine.camera.Camera;
import org.anddev.andengine.engine.options.EngineOptions;
import org.anddev.andengine.engine.options.EngineOptions.ScreenOrientation;
import org.anddev.andengine.engine.options.resolutionpolicy.RatioResolutionPolicy;
import org.anddev.andengine.entity.IEntity;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.entity.scene.Scene.IOnSceneTouchListener;
import org.anddev.andengine.entity.scene.background.ColorBackground;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.entity.util.FPSLogger;
import org.anddev.andengine.input.touch.TouchEvent;
import org.anddev.andengine.opengl.texture.Texture;
import org.anddev.andengine.opengl.texture.TextureOptions;
import org.anddev.andengine.opengl.texture.region.TextureRegion;
import org.anddev.andengine.opengl.texture.region.TextureRegionFactory;
import org.anddev.andengine.ui.activity.BaseGameActivity;

import android.util.Log;

public class MemoPuzzle extends BaseGameActivity {
    private static final int CAMERA_WIDTH = 480;
    private static final int CAMERA_HEIGHT = 720;
    
    private Camera mCamera;
	private TextureRegion text1;

	public void onLoadComplete() {
		// TODO Auto-generated method stub
		
	}

	public Engine onLoadEngine() {
		this.mCamera = new Camera(0, 0, CAMERA_WIDTH, CAMERA_HEIGHT);
        final Engine engine = new Engine(
        		new EngineOptions(true, 
        					      ScreenOrientation.PORTRAIT, 
        					      new RatioResolutionPolicy(CAMERA_WIDTH, CAMERA_HEIGHT), 
        					      this.mCamera));
        return engine;
	}

	public void onLoadResources() {
		TextureRegionFactory.setAssetBasePath("gfx/");
		Texture mTexture1 = new Texture(32, 32, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
		this.text1 = TextureRegionFactory.createFromAsset(mTexture1, this, "face_box.png", 0, 0);
		this.mEngine.getTextureManager().loadTextures(mTexture1);
	}

	public Scene onLoadScene() {
		this.mEngine.registerUpdateHandler(new FPSLogger());
        final Scene scene = new Scene(1);
        //scene.setOnAreaTouchTraversalFrontToBack();
        scene.setBackground(new ColorBackground(0.0f, 0.0f, 0.0f));
        //scene.setTouchAreaBindingEnabled(true);
        //scene.setOnSceneTouchListener(this);
        
        final Sprite face = new Sprite(60, 60, this.text1) {
            @Override
            public boolean onAreaTouched(final TouchEvent pSceneTouchEvent, final float pTouchAreaLocalX, final float pTouchAreaLocalY) {
            	this.setPosition(pSceneTouchEvent.getX() - this.getWidth() / 2, pSceneTouchEvent.getY() - this.getHeight() / 2);
                Log.i("TEST_ACT", "face touch");
                return true;
            }
        };
		//face.setScale(4);
        final IEntity lastChild = scene.getLastChild();
		lastChild.attachChild(face);
		
		scene.registerTouchArea(face);
		scene.setTouchAreaBindingEnabled(true);
        return scene;
	}
	
}
