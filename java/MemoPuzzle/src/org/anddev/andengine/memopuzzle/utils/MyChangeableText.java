package org.anddev.andengine.memopuzzle.utils;

import org.anddev.andengine.entity.text.ChangeableText;
import org.anddev.andengine.opengl.font.Font;
import org.anddev.andengine.util.HorizontalAlign;

public class MyChangeableText extends ChangeableText {
	protected String mText2;
	
	public MyChangeableText(final float pX, final float pY, final Font pFont, final String pText) {
        super(pX, pY, pFont, pText);
        this.mText2 = pText;
	}
	
	public MyChangeableText(final float pX, final float pY, final Font pFont, final String pText, final int pCharactersMaximum) {
		super(pX, pY, pFont, pText, HorizontalAlign.LEFT, pCharactersMaximum);
		this.mText2 = pText;
	}
	
	public MyChangeableText(final float pX, final float pY, final Font pFont, final String pText, final HorizontalAlign pHorizontalAlign, final int pCharactersMaximum) {
		super(pX, pY, pFont, pText, pHorizontalAlign, pCharactersMaximum);
		this.mText2 = pText;
	}
	
	public String getText() {
		return this.mText2;
	}
	
	public void setText(final String pText) {
		super.setText(pText);
		this.mText2 = pText;
	}
	
}
