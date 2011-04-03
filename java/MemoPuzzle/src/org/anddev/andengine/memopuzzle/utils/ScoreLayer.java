package org.anddev.andengine.memopuzzle.utils;

import org.anddev.andengine.entity.layer.Layer;
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
	}
	
	public void increaseStep(int value) {
		this.mStep += value;
		this.mStepText.setText(this.mStepLabel + Integer.toString(this.mStep));
	}
	
	public void increaseTime(int value) {
		this.mTime += value;
		this.mTimeText.setText(this.mTimeLabel + Integer.toString(this.mTime));
	}
	
}