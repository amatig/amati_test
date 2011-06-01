package org.prova;

import org.anddev.andengine.engine.Engine;
import org.anddev.andengine.engine.options.EngineOptions.ScreenOrientation;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.extra.Enviroment;
import org.anddev.andengine.extra.ExtraGameActivity;

public class Prova extends ExtraGameActivity {
	
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
		return new Scene1();
	}
    
}