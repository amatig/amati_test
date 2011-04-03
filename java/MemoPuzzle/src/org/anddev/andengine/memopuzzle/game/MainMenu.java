package org.anddev.andengine.memopuzzle.game;

import javax.microedition.khronos.opengles.GL10;

import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.entity.scene.background.ColorBackground;
import org.anddev.andengine.entity.scene.menu.MenuScene;
import org.anddev.andengine.entity.scene.menu.item.IMenuItem;
import org.anddev.andengine.entity.scene.menu.item.TextMenuItem;
import org.anddev.andengine.entity.scene.menu.item.decorator.ColorMenuItemDecorator;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.entity.text.Text;
import org.anddev.andengine.memopuzzle.MemoPuzzle;
import org.anddev.andengine.memopuzzle.utils.Enviroment;
import org.anddev.andengine.opengl.font.Font;

public class MainMenu extends Scene {
	
	public MainMenu() {
		super(1);
		setBackground(new ColorBackground(1f, 1f, 1f));
		
    	Sprite back = new Sprite(0, 0, Enviroment.instance().texBack);
    	back.setScale(0.9f);
    	attachChild(back);
    	
    	Text titleText = new Text(70, 180, Enviroment.instance().fontMainTitle, "Brain\nChallenge");
    	titleText.setColor(0.5f, 1.0f, 0.2f);
    	attachChild(titleText);
    	
    	setChildScene(createMenu(), false, true, true);
	}
	
	public Scene createMenu() {
		MenuScene mainMenu = new MenuScene(Enviroment.instance().getGame().getEngine().getCamera());
		
		Font font = Enviroment.instance().fontMainMenu;
		
		IMenuItem eMenuItem = new ColorMenuItemDecorator(new TextMenuItem(MemoPuzzle.MENU_EASY, font, "EASY"), 1.0f, 0.1f, 0.1f, 1.0f, 1.0f, 0.5f);
		eMenuItem.setBlendFunction(GL10.GL_SRC_ALPHA, GL10.GL_ONE_MINUS_SRC_ALPHA);
		mainMenu.addMenuItem(eMenuItem);
		
		IMenuItem nMenuItem = new ColorMenuItemDecorator(new TextMenuItem(MemoPuzzle.MENU_NORMAL, font, "NORMAL"), 1.0f, 0.1f, 0.1f, 1.0f, 1.0f, 0.5f);
		nMenuItem.setBlendFunction(GL10.GL_SRC_ALPHA, GL10.GL_ONE_MINUS_SRC_ALPHA);
		mainMenu.addMenuItem(nMenuItem);
		
		IMenuItem hMenuItem = new ColorMenuItemDecorator(new TextMenuItem(MemoPuzzle.MENU_HARD, font, "HARD"), 1.0f, 0.1f, 0.1f, 1.0f, 1.0f, 0.5f);
		hMenuItem.setBlendFunction(GL10.GL_SRC_ALPHA, GL10.GL_ONE_MINUS_SRC_ALPHA);
		mainMenu.addMenuItem(hMenuItem);
		
		mainMenu.buildAnimations();
		
		mainMenu.setBackgroundEnabled(false);
		
		mainMenu.setOnMenuItemClickListener(Enviroment.instance().getGame());
		
		mainMenu.setPosition(0, 150);
		
		return mainMenu;
	}
	
}
