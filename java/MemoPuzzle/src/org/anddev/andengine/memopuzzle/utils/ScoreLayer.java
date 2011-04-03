package org.anddev.andengine.memopuzzle.utils;

import org.anddev.andengine.entity.layer.Layer;
import org.anddev.andengine.entity.sprite.AnimatedSprite;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.opengl.font.Font;

public class ScoreLayer extends Layer {
	private static int SPACE = 45;
	private int mStep = 0;
	
	private String mTimeLabel = "Time ";
	private MyChangeableText mTimeText;
	private int mTime = 0;
	
	public ScoreLayer() {
		this.mTimeText = new MyChangeableText(23, 72, Enviroment.instance().fontTime, this.mTimeLabel + "0", 15);
		this.mTimeText.setColor(0.5f, 1.0f, 0.2f);
		attachChild(this.mTimeText);
		
		for (int i = 0; i < Enviroment.MINIGAME; i++) {
			Sprite step = new Sprite(10 + i * SPACE, 10, Enviroment.instance().texStep);
			step.setColor(1.0f, 1.0f, 0.5f);
			step.setScale(0.6f);
			attachChild(step);
		}
	}
	
	public void increaseStep(int value) {
		this.mStep += value;
		
		AnimatedSprite step = new AnimatedSprite(10 + (this.mStep - 1) * SPACE, 10, Enviroment.instance().texAnimStep);
		step.animate(new long[] { 70, 70, 70 }, 0, 2, false);
		step.setColor(0.5f, 1.0f, 0.2f);
		step.setScale(0.7f);
		attachChild(step);
	}
	
	public void increaseTime(int value) {
		this.mTime += value;
		this.mTimeText.setText(this.mTimeLabel + Integer.toString(this.mTime));
	}
	
}