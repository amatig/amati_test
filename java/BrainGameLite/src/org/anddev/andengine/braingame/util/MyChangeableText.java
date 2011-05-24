/***
=== BrainGame ===

Copyright (C) 2011 Giovanni Amati

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
***/

package org.anddev.andengine.braingame.util;

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
