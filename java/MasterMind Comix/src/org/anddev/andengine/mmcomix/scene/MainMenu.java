package org.anddev.andengine.mmcomix.scene;

import org.anddev.andengine.entity.IEntity;
import org.anddev.andengine.entity.modifier.ScaleModifier;
import org.anddev.andengine.entity.modifier.SequenceEntityModifier;
import org.anddev.andengine.entity.modifier.IEntityModifier.IEntityModifierListener;
import org.anddev.andengine.entity.scene.menu.MenuScene;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.entity.text.Text;
import org.anddev.andengine.extra.Enviroment;
import org.anddev.andengine.extra.ExtraScene;
import org.anddev.andengine.extra.Resource;
import org.anddev.andengine.input.touch.TouchEvent;
import org.anddev.andengine.opengl.font.Font;
import org.anddev.andengine.opengl.texture.region.TextureRegion;
import org.anddev.andengine.util.modifier.IModifier;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;

public class MainMenu extends ExtraScene {
	
	private Font fontMainMenu;
	private TextureRegion mBack;
	
	@Override
	public MenuScene createMenu() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void createScene() {
		this.mBack = Resource.getTexture(512, 1024, "back");
		Sprite back = new Sprite(0, 0, this.mBack);
		getChild(ExtraScene.GAME_LAYER).attachChild(back);
		
		this.fontMainMenu = Resource.getFont(512, 512, "akaDylan Plain", 45, 3, Color.WHITE, Color.BLACK);
		
		int x = Enviroment.getInstance().getScreenWidth() / 2;
		int y = 380;
		
    	Text play = new Text(0, 0, this.fontMainMenu, "PLAY");
    	play.setPosition(x - play.getWidthScaled() / 2, y);
    	play.setColor(1.0f, 1.0f, 0.6f);
    	
    	Text score = new Text(0, 0, this.fontMainMenu, "SCORE");
    	score.setPosition(x - score.getWidthScaled() / 2, y + 90);
    	score.setColor(1.0f, 1.0f, 0.6f);
    	
    	Text more = new Text(0, 0, this.fontMainMenu, "More Games");
    	more.setPosition(x - more.getWidthScaled() / 2, y + 180);
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
		Enviroment.getInstance().setScene(new Game());
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
		if ((int) item.getY() == 380) {
			Enviroment.getInstance().nextScene();
		} else if ((int) item.getY() == 470) {
			try {
				//Dashboard.open();
			} catch (Exception e) {
			}
		} else if ((int) item.getY() == 560) {
			try{
				Enviroment.getInstance().getContext().startActivity(new Intent (Intent.ACTION_VIEW, Uri.parse("market://details?id=org.anddev.andengine.braingame")));
			} catch (ActivityNotFoundException e) {
			}
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
