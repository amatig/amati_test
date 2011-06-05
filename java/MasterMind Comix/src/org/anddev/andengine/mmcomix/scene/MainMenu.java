package org.anddev.andengine.mmcomix.scene;

import org.anddev.andengine.entity.IEntity;
import org.anddev.andengine.entity.modifier.ScaleModifier;
import org.anddev.andengine.entity.modifier.SequenceEntityModifier;
import org.anddev.andengine.entity.modifier.IEntityModifier.IEntityModifierListener;
import org.anddev.andengine.entity.scene.menu.MenuScene;
import org.anddev.andengine.entity.text.Text;
import org.anddev.andengine.extra.Enviroment;
import org.anddev.andengine.extra.ExtraScene;
import org.anddev.andengine.extra.Resource;
import org.anddev.andengine.input.touch.TouchEvent;
import org.anddev.andengine.opengl.font.Font;
import org.anddev.andengine.util.modifier.IModifier;

import android.graphics.Color;

public class MainMenu extends ExtraScene {
	
	private Font fontMainMenu;
	
	@Override
	public MenuScene createMenu() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void createScene() {
		this.fontMainMenu = Resource.getFont(512, 512, "akaDylan Plain", 40, 3, Color.WHITE, Color.BLACK);
		
		int x = Enviroment.getInstance().getScreenWidth() / 2;
		int y = 422;
		
    	Text play = new Text(0, 0, this.fontMainMenu, "PLAY");
    	play.setPosition(x - play.getWidthScaled() / 2, y);
    	play.setColor(1.0f, 1.0f, 0.6f);
    	
    	Text score = new Text(0, 0, this.fontMainMenu, "SCORE");
    	score.setPosition(x - score.getWidthScaled() / 2, y + 70);
    	score.setColor(1.0f, 1.0f, 0.6f);
    	
    	Text more = new Text(0, 0, this.fontMainMenu, "MORE GAMES");
    	more.setPosition(x - more.getWidthScaled() / 2, y + 140);
    	more.setColor(1.0f, 1.0f, 0.6f);
    	
    	getChild(ExtraScene.GAME_LAYER).attachChild(play);
    	getChild(ExtraScene.GAME_LAYER).attachChild(score);
    	getChild(ExtraScene.GAME_LAYER).attachChild(more);
    	
    	registerTouchArea(play);
    	registerTouchArea(score);
    	registerTouchArea(more);
	}

	@Override
	public void endScene() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void manageAreaTouch(final ITouchArea pTouchArea) {
		final Text item = (Text) pTouchArea;
		item.setColor(1f, 0.7f, 0.7f);
		
		item.registerEntityModifier(
				new SequenceEntityModifier(
						new IEntityModifierListener() {
							@Override
							public void onModifierFinished(IModifier<IEntity> pModifier, IEntity pItem) {
								item.setColor(1.0f, 1.0f, 0.6f);
								MainMenu.this.execute(pTouchArea);
							}
						},
						new ScaleModifier(0.1f, 1f, 1.3f),
						new ScaleModifier(0.1f, 1.3f, 1f)
		));
	}

	private void execute(ITouchArea pTouchArea) {
		Text item = (Text) pTouchArea;
		if ((int) item.getY() == 422) {
			Enviroment.getInstance().setScene(new Game());
		}
	}
	
	@Override
	public void manageSceneTouch(TouchEvent pSceneTouchEvent) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void startScene() {
		// TODO Auto-generated method stub
		
	}

}
