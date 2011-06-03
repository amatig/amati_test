package org.anddev.andengine.mmcomix;

import org.anddev.andengine.engine.Engine;
import org.anddev.andengine.engine.options.EngineOptions.ScreenOrientation;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.extra.Enviroment;
import org.anddev.andengine.extra.ExtraGameActivity;
import org.anddev.andengine.mmcomix.scene.Game;

public class MasterMindComix extends ExtraGameActivity {

	private static int WIDTH = 480;
	private static int HEIGHT = 720;
	
	@Override
	public void onLoadComplete() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public Engine onLoadEngine() {
		return Enviroment.createEngine(ScreenOrientation.PORTRAIT, WIDTH, HEIGHT, true);
	}

	@Override
	public void onLoadResources() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public Scene onLoadScene() {
		return new Game();
	}
    
}