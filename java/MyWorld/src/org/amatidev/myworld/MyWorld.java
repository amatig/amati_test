package org.amatidev.myworld;

import org.amatidev.activity.AdGameActivity;
import org.amatidev.util.AdEnviroment;
import org.anddev.andengine.engine.Engine;
import org.anddev.andengine.engine.options.EngineOptions.ScreenOrientation;
import org.anddev.andengine.entity.scene.Scene;

public class MyWorld extends AdGameActivity {
	private static int WIDTH = 480;
	private static int HEIGHT = 720;
	
	@Override
	public void onLoadComplete() {
		
	}

	@Override
	public Engine onLoadEngine() {
		return AdEnviroment.createEngine(ScreenOrientation.PORTRAIT, WIDTH, HEIGHT, false, false);
	}

	@Override
	public void onLoadResources() {
		
	}

	@Override
	public Scene onLoadScene() {
		return new Game();
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