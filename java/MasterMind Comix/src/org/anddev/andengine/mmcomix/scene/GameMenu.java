package org.anddev.andengine.mmcomix.scene;

import javax.microedition.khronos.opengles.GL10;

import org.anddev.andengine.entity.scene.menu.MenuScene;
import org.anddev.andengine.entity.scene.menu.item.IMenuItem;
import org.anddev.andengine.entity.scene.menu.item.TextMenuItem;
import org.anddev.andengine.entity.scene.menu.item.decorator.ColorMenuItemDecorator;
import org.anddev.andengine.extra.Enviroment;
import org.anddev.andengine.extra.ExtraMenu;
import org.anddev.andengine.extra.Resource;
import org.anddev.andengine.opengl.font.Font;

import android.graphics.Color;

public class GameMenu extends ExtraMenu {
	
	private static final int MENU_NEW = 0;
	private static final int MENU_EXIT = 1;
	
	private Font mFont1;
	
	public GameMenu() {
		this.mFont1 = Resource.getFont(512, 512, "akaDylan Plain", 48, 3, Color.WHITE, Color.BLACK);
		
		IMenuItem newMenuItem = new ColorMenuItemDecorator(new TextMenuItem(MENU_NEW, this.mFont1, "NEW GAME"), 1f, 0.7f, 0.7f, 1.0f, 1.0f, 0.6f);
		newMenuItem.setBlendFunction(GL10.GL_SRC_ALPHA, GL10.GL_ONE_MINUS_SRC_ALPHA);
		addMenuItem(newMenuItem);
		
		IMenuItem quitMenuItem = new ColorMenuItemDecorator(new TextMenuItem(MENU_EXIT, this.mFont1, "EXIT"), 1f, 0.7f, 0.7f, 1.0f, 1.0f, 0.6f);
		quitMenuItem.setBlendFunction(GL10.GL_SRC_ALPHA, GL10.GL_ONE_MINUS_SRC_ALPHA);
		addMenuItem(quitMenuItem);
		
		buildAnimations();
	}

	@Override
	public boolean onMenuItemClicked(MenuScene pMenuScene, IMenuItem pMenuItem, float pMenuItemLocalX, float pMenuItemLocalY) {
		switch(pMenuItem.getID()) {
		case MENU_NEW:
			Enviroment.getInstance().setScene(new Game());
			return true;
		case MENU_EXIT:
			Enviroment.getInstance().setScene(new MainMenu());
			return true;
		default:
			return false;
		}
	}
	
}
