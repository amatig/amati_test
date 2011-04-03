package org.anddev.andengine.memopuzzle.utils;

import org.anddev.andengine.entity.layer.Layer;
import org.anddev.andengine.entity.sprite.AnimatedSprite;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.opengl.font.Font;

public class ScoreLayer extends Layer {
	private String mStepLabel = "Step ";
	private int mStep;
	private MyChangeableText mStepText;
	
	private String mTimeLabel = "Time ";
	private int mTime;
	private MyChangeableText mTimeText;
	
	public ScoreLayer() {
		Font font = Enviroment.instance().fontScore;
		
		this.mStep = 0;
		this.mStepText = new MyChangeableText(90, 20, font, this.mStepLabel + "0", 15);
		attachChild(this.mStepText);
		
		this.mTime = 0;
		this.mTimeText = new MyChangeableText(90, 60, font, this.mTimeLabel + "0", 15);
		attachChild(this.mTimeText);
		
		for (int i = 0; i < 10; i++) {
			Sprite step = new Sprite(20, 20 + i * 56, Enviroment.instance().texStep);
			step.setColor(1.0f, 1.0f, 0.5f);
			attachChild(step);
		}
	}
	
	public void increaseStep(int value) {
		this.mStep += value;
		this.mStepText.setText(this.mStepLabel + Integer.toString(this.mStep));
		
		AnimatedSprite step = new AnimatedSprite(20, 20 + (10 - this.mStep) * 56, Enviroment.instance().texAnimStep);
		step.animate(new long[] { 300, 200, 100 }, 0, 2, false);
		step.setColor(0.5f, 1.0f, 0.2f);
		attachChild(step);
	}
	
	public void increaseTime(int value) {
		this.mTime += value;
		this.mTimeText.setText(this.mTimeLabel + Integer.toString(this.mTime));
	}
	
}