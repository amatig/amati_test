package org.anddev.andengine.examples.game.pong.adt;

/**
 * @author Nicolas Gramlich
 * @since 12:11:58 - 01.03.2011
 */
public class Score {
	// ===========================================================
	// Constants
	// ===========================================================

	// ===========================================================
	// Fields
	// ===========================================================

	private int mScore = 0;

	// ===========================================================
	// Constructors
	// ===========================================================

	// ===========================================================
	// Getter & Setter
	// ===========================================================

	public int getScore() {
		return this.mScore;
	}

	// ===========================================================
	// Methods for/from SuperClass/Interfaces
	// ===========================================================

	// ===========================================================
	// Methods
	// ===========================================================

	public void increase() {
		this.mScore++;
	}

	// ===========================================================
	// Inner and Anonymous Classes
	// ===========================================================
}
