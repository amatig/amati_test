package org.anddev.andengine.memopuzzle.game;

import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.entity.scene.background.ColorBackground;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.memopuzzle.utils.Enviroment;

public class EndScene extends Scene {
	
	public EndScene() {
		super(1);
		setBackground(new ColorBackground(0,9f, 0.5f, 0.5f));
		
    	Sprite back = new Sprite(0, 0, Enviroment.instance().texBack);
    	back.setScale(0.95f);
    	attachChild(back);
	}
	
}
