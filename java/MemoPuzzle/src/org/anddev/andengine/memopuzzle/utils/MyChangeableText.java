package org.anddev.andengine.memopuzzle.utils;

import org.anddev.andengine.entity.text.ChangeableText;
import org.anddev.andengine.opengl.font.Font;

public class MyChangeableText extends ChangeableText {
	protected String mText2;
	
	public MyChangeableText(final float pX, final float pY, final Font pFont, final String pText) {
        super(pX, pY, pFont, pText);
        this.mText2 = pText;
	}
	
	public String getText() {
		return this.mText2;
	}
	
	protected void updateText(final String pText) {
		super.updateText(pText);
		this.mText2 = pText;
	}

}
