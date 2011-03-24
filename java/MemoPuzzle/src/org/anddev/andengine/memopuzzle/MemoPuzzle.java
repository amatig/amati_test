package org.anddev.andengine.memopuzzle;

import org.anddev.andengine.engine.Engine;
import org.anddev.andengine.engine.camera.Camera;
import org.anddev.andengine.engine.options.EngineOptions;
import org.anddev.andengine.engine.options.EngineOptions.ScreenOrientation;
import org.anddev.andengine.engine.options.resolutionpolicy.RatioResolutionPolicy;
import org.anddev.andengine.entity.primitive.Rectangle;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.entity.scene.background.ColorBackground;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.entity.util.FPSLogger;
import org.anddev.andengine.extension.physics.box2d.PhysicsConnector;
import org.anddev.andengine.extension.physics.box2d.PhysicsFactory;
import org.anddev.andengine.extension.physics.box2d.PhysicsWorld;
import org.anddev.andengine.opengl.texture.Texture;
import org.anddev.andengine.opengl.texture.TextureOptions;
import org.anddev.andengine.opengl.texture.region.TextureRegion;
import org.anddev.andengine.opengl.texture.region.TextureRegionFactory;
import org.anddev.andengine.opengl.texture.region.TiledTextureRegion;
import org.anddev.andengine.ui.activity.BaseGameActivity;
import org.anddev.andengine.util.MathUtils;

import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.physics.box2d.Body;
import com.badlogic.gdx.physics.box2d.FixtureDef;
import com.badlogic.gdx.physics.box2d.BodyDef.BodyType;

import android.graphics.drawable.shapes.Shape;
import android.hardware.SensorManager;
import android.util.Log;
import android.widget.Toast;

public class MemoPuzzle extends BaseGameActivity {
    public static final int CAMERA_WIDTH = 480;
    public static final int CAMERA_HEIGHT = 720;
	
	public void onLoadComplete() {
		loadSumBox();
	}
	
	public Engine onLoadEngine() {
		//Toast.makeText(this, "Ready", Toast.LENGTH_LONG).show();
		final Camera camera = new Camera(0, 0, CAMERA_WIDTH, CAMERA_HEIGHT);
        final EngineOptions opt = new EngineOptions(true, 
        											ScreenOrientation.PORTRAIT, 
        											new RatioResolutionPolicy(CAMERA_WIDTH, CAMERA_HEIGHT), 
        											camera);
        return new Engine(opt);
	}
	
	public void onLoadResources() {
		
	}
	
	public Scene onLoadScene() {
		return new MainMenu();
	}
	
	private void loadSumBox() {
		final Texture tex1  = new Texture(128, 128, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
		final TextureRegion tex1reg = TextureRegionFactory.createFromAsset(tex1, this, "gfx/1.png", 0, 0);
		
		mEngine.getTextureManager().loadTexture(tex1);
		
		mEngine.setScene(new SumBox(tex1reg));
	}
	
}
