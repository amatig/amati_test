package org.anddev.andengine.memopuzzle.utils;

import org.anddev.andengine.entity.text.Text;
import org.anddev.andengine.opengl.font.Font;
import org.anddev.andengine.util.HorizontalAlign;

public class MyText extends Text {
	private String mText2;
	
	public MyText(final float pX, final float pY, final Font pFont, final String pText) {
        super(pX, pY, pFont, pText);
	}
	
	public MyText(final float pX, final float pY, final Font pFont, final String pText, final HorizontalAlign pHorizontalAlign) {
        super(pX, pY, pFont, pText, pHorizontalAlign);
	}
	
	protected MyText(float pX, float pY, Font pFont, String pText, HorizontalAlign pHorizontalAlign, int pCharactersMaximum) {
		super(pX, pY, pFont, pText, pHorizontalAlign, pCharactersMaximum);
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
