package org.anddev.andengine.memopuzzle;

import org.anddev.andengine.entity.layer.Layer;
import org.anddev.andengine.entity.text.ChangeableText;
import org.anddev.andengine.memopuzzle.utils.Enviroment;
import org.anddev.andengine.opengl.font.Font;

public class ScoreLayer extends Layer {
	private String mStepLabel = "Step: ";
	private int mStep;
	private ChangeableText mStepText;
	
	public ScoreLayer() {
		final Font font = Enviroment.instance().getGame().mFontSmallBlack;
		
		this.mStep = 0;
		this.mStepText = new ChangeableText(20, 20, font, this.mStepLabel + "0", 15);
		
		attachChild(this.mStepText);
	}
	
	public void increaseStep(int value) {
		this.mStep += value;
		this.mStepText.setText(this.mStepLabel + Integer.toString(this.mStep));
	}
}