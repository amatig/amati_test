package org.anddev.andengine.memopuzzle.utils;

import javax.microedition.khronos.opengles.GL10;

import org.anddev.andengine.entity.scene.menu.MenuScene;
import org.anddev.andengine.entity.scene.menu.item.IMenuItem;
import org.anddev.andengine.entity.scene.menu.item.TextMenuItem;
import org.anddev.andengine.entity.scene.menu.item.decorator.ColorMenuItemDecorator;
import org.anddev.andengine.memopuzzle.MemoPuzzle;
import org.anddev.andengine.opengl.font.Font;

public class GameMenu extends MenuScene {
	
	public GameMenu() {
		super(Enviroment.instance().getGame().getEngine().getCamera());
		
		String audio = "";
		if (Enviroment.instance().getAudio())
			audio += "ON";
		else
			audio += "OFF";
		
		Font font = Enviroment.instance().fontMenu;
		
		IMenuItem resetMenuItem = new ColorMenuItemDecorator(new TextMenuItem(MemoPuzzle.MENU_AUDIO, font, "AUDIO " + audio), 1.0f, 0.1f, 0.1f, 1.0f, 1.0f, 0.5f);
		resetMenuItem.setBlendFunction(GL10.GL_SRC_ALPHA, GL10.GL_ONE_MINUS_SRC_ALPHA);
		addMenuItem(resetMenuItem);
		
		IMenuItem quitMenuItem = new ColorMenuItemDecorator(new TextMenuItem(MemoPuzzle.MENU_EXIT, font, "EXIT"), 1.0f, 0.1f, 0.1f, 1.0f, 1.0f, 0.5f);
		quitMenuItem.setBlendFunction(GL10.GL_SRC_ALPHA, GL10.GL_ONE_MINUS_SRC_ALPHA);
		addMenuItem(quitMenuItem);
		
		buildAnimations();
		
		setBackgroundEnabled(false);
		
		setOnMenuItemClickListener(Enviroment.instance().getGame());
	}
	
}
