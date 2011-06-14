package org.anddev.andengine.mmcomix;

import java.util.HashMap;
import java.util.Map;

import org.anddev.andengine.engine.Engine;
import org.anddev.andengine.engine.handler.timer.ITimerCallback;
import org.anddev.andengine.engine.handler.timer.TimerHandler;
import org.anddev.andengine.engine.options.EngineOptions.ScreenOrientation;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.entity.scene.SplashScene;
import org.anddev.andengine.extra.Enviroment;
import org.anddev.andengine.extra.ExtraGameActivity;
import org.anddev.andengine.extra.Resource;
import org.anddev.andengine.mmcomix.scene.MainMenu;
import org.anddev.andengine.opengl.texture.region.TextureRegion;

import android.content.pm.ActivityInfo;

import com.openfeint.api.OpenFeint;
import com.openfeint.api.OpenFeintDelegate;
import com.openfeint.api.OpenFeintSettings;

public class MasterMindComix extends ExtraGameActivity {

	private static int WIDTH = 480;
	private static int HEIGHT = 720;
	
	private TextureRegion mSplash;
	
	@Override
	public void onLoadComplete() {
		try {
			Map<String, Object> options = new HashMap<String, Object>();
			options.put(OpenFeintSettings.SettingCloudStorageCompressionStrategy, OpenFeintSettings.CloudStorageCompressionStrategyDefault);
			// use the below line to set orientation
			options.put(OpenFeintSettings.RequestedOrientation, ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
			OpenFeintSettings settings = new OpenFeintSettings("MasterMind Comix", "pLp32DqwJVpq6lRXC56wlA", "qQRUFFwweRDAq4pYAvvrpQ3hgYzHLaqTJO7h5N6ybWQ", "299863", options);
			
			OpenFeint.initialize(this, settings, new OpenFeintDelegate() { });
		} catch (Exception e) {
			
		}
	}

	@Override
	public Engine onLoadEngine() {
		return Enviroment.createEngine(ScreenOrientation.PORTRAIT, WIDTH, HEIGHT, false, false);
	}

	@Override
	public void onLoadResources() {
		this.mSplash = Resource.getTexture(512, 1024, "splash");
	}

	@Override
	public Scene onLoadScene() {
		SplashScene splashScene = new SplashScene(this.mEngine.getCamera(), this.mSplash, 0f, 1f, 1f);
        splashScene.registerUpdateHandler(new TimerHandler(7f, new ITimerCallback() {
        	@Override
        	public void onTimePassed(final TimerHandler pTimerHandler) {
        		MasterMindComix.this.mEngine.setScene(new MainMenu());
        	}
        }));
		return splashScene;
	}

	@Override
	protected int getLayoutID() {
		return R.layout.main;
	}

	@Override
	protected int getRenderSurfaceViewID() {
		return R.id.xmllayoutexample_rendersurfaceview;
	}
    
}