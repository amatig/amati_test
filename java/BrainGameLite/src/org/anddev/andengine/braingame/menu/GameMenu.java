/***
=== BrainGame ===

Copyright (C) 2011 Giovanni Amati

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
***/

package org.anddev.andengine.braingame.menu;

import javax.microedition.khronos.opengles.GL10;

import org.anddev.andengine.braingame.scene.MainMenu;
import org.anddev.andengine.braingame.singleton.Enviroment;
import org.anddev.andengine.braingame.singleton.Resource;
import org.anddev.andengine.braingame.util.MyMenuScene;
import org.anddev.andengine.braingame.util.MyScene;
import org.anddev.andengine.entity.scene.menu.MenuScene;
import org.anddev.andengine.entity.scene.menu.item.IMenuItem;
import org.anddev.andengine.entity.scene.menu.item.TextMenuItem;
import org.anddev.andengine.entity.scene.menu.item.decorator.ColorMenuItemDecorator;
import org.anddev.andengine.opengl.font.Font;

public class GameMenu extends MyMenuScene {
	private static final int MENU_AUDIO = 0;
	private static final int MENU_VIBRO = 1;
	private static final int MENU_EXIT = 2;
	
	public GameMenu() {
		Font font = Resource.instance().fontMenu;
		
		String audio = "";
		if (Enviroment.instance().getAudio())
			audio += "ON";
		else
			audio += "OFF";
		
		String vibro = "";
		if (Enviroment.instance().getVibro())
			vibro += "ON";
		else
			vibro += "OFF";
		
		IMenuItem resetMenuItem = new ColorMenuItemDecorator(new TextMenuItem(MENU_AUDIO, font, "AUDIO " + audio), 1f, 0.7f, 0.7f, 1.0f, 1.0f, 0.6f);
		resetMenuItem.setBlendFunction(GL10.GL_SRC_ALPHA, GL10.GL_ONE_MINUS_SRC_ALPHA);
		addMenuItem(resetMenuItem);
		
		IMenuItem vibroMenuItem = new ColorMenuItemDecorator(new TextMenuItem(MENU_VIBRO, font, "VIBRO " + vibro), 1f, 0.7f, 0.7f, 1.0f, 1.0f, 0.6f);
		vibroMenuItem.setBlendFunction(GL10.GL_SRC_ALPHA, GL10.GL_ONE_MINUS_SRC_ALPHA);
		addMenuItem(vibroMenuItem);
		
		IMenuItem quitMenuItem = new ColorMenuItemDecorator(new TextMenuItem(MENU_EXIT, font, "EXIT"), 1f, 0.7f, 0.7f, 1.0f, 1.0f, 0.6f);
		quitMenuItem.setBlendFunction(GL10.GL_SRC_ALPHA, GL10.GL_ONE_MINUS_SRC_ALPHA);
		addMenuItem(quitMenuItem);
		
		buildAnimations();
	}
	
	public boolean onMenuItemClicked(MenuScene pMenuScene, IMenuItem pMenuItem, float pMenuItemLocalX, float pMenuItemLocalY) {
		switch(pMenuItem.getID()) {
		case MENU_AUDIO:
			Enviroment.instance().getScene().clearChildScene();
			Enviroment.instance().toggleAudio();
			((MyScene)Enviroment.instance().getScene()).getFadeLayer().getFirstChild().setAlpha(0f);
			return true;
		case MENU_VIBRO:
			Enviroment.instance().getScene().clearChildScene();
			Enviroment.instance().toggleVibro();
			((MyScene)Enviroment.instance().getScene()).getFadeLayer().getFirstChild().setAlpha(0f);
			return true;
		case MENU_EXIT:
			Enviroment.instance().setScene(new MainMenu());
			return true;
		default:
			return false;
		}
	}

}
