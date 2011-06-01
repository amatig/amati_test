/***
=== BrainGame ===

Copyright (C) 2011 Giovanni Amati

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
***/

package org.anddev.andengine.braingamelite.singleton;

import org.anddev.andengine.braingamelite.BrainGameLite;
import org.anddev.andengine.braingamelite.scene.CountDown;
import org.anddev.andengine.braingamelite.scene.End;
import org.anddev.andengine.braingamelite.scene.MemShuffle;
import org.anddev.andengine.braingamelite.scene.Start;
import org.anddev.andengine.braingamelite.scene.SumBox;
import org.anddev.andengine.engine.Engine;
import org.anddev.andengine.entity.scene.Scene;

import android.app.Service;
import android.media.AudioManager;

public class Enviroment {
	
	public static final int CAMERA_WIDTH = 480;
    public static final int CAMERA_HEIGHT = 720;
    
	private static Enviroment mInstance = null;
	
	// data utils
	private BrainGameLite mGame = null;
	
	// mini game vars
	private int[] mMiniGameScene;
	public static int NUMMINIGAME = 10;
	
	private int mCurrenteMiniGame = -1;
	// seting global
	private int mDifficult = 0;  // 0 Easy 1 Normal 2 Hard
	private int mDifficultStart = 0;
	// player vars
	private int mCurrentPlayer = 1;
	private int mNumPlayers = 1;
	
	private boolean mAudio = true;
	private boolean mVibro = true;
	
	private AudioManager mAudioManager;
	
	// Costruttore
	private Enviroment() {
		
	}
	
	public static synchronized Enviroment instance() {
		if (mInstance == null) 
			mInstance = new Enviroment();
		return mInstance;
	}
	
	public void initVariables(BrainGameLite game) {
		this.mGame = game;
		
		this.mAudio = StoreMyData.instance().getDBValue("audio", true);
		this.mVibro = StoreMyData.instance().getDBValue("vibro", true);
		
		// minigame
		this.mMiniGameScene = new int[NUMMINIGAME];
		
		getEngine().enableVibrator(this.mGame);
		this.mAudioManager = (AudioManager) this.mGame.getSystemService(Service.AUDIO_SERVICE);
	}
	
	public void reInitVariables() {
		this.mMiniGameScene[0] = 1;
		this.mMiniGameScene[1] = 2;
		this.mMiniGameScene[2] = 3;
		this.mMiniGameScene[3] = 1;
		this.mMiniGameScene[4] = 2;
		this.mMiniGameScene[5] = 3;
		this.mMiniGameScene[6] = 1;
		this.mMiniGameScene[7] = 2;
		this.mMiniGameScene[8] = 3;
		this.mMiniGameScene[9] = 1;
		
		this.mCurrenteMiniGame = -1;
		this.mDifficult = 0;
		this.mDifficultStart = 0;
		this.mCurrentPlayer = 1;
		this.mNumPlayers = 1;
	}
	
	public AudioManager getAudioManager() {
        return this.mAudioManager;
	}
	
	public BrainGameLite getGame() {
        return this.mGame;
	}
	
	public Engine getEngine() {
		return this.mGame.getEngine();
	}
		
	public Scene getScene() {
		return this.mGame.getEngine().getScene();
	}
	
	public void setScene(Scene scene) {
		// need clean object old scene
		this.mGame.getEngine().setScene(scene);
	}
	
	public int nextMiniGame() {
		this.mCurrenteMiniGame += 1;
		if (this.mCurrenteMiniGame < NUMMINIGAME)
			return this.mMiniGameScene[this.mCurrenteMiniGame];
		else {
			this.mCurrenteMiniGame = -1;
			return 0;
		}
	}
	
	public void nextScene() {
		Scene scene = null;
		// aumenta difficolta' a meta percorso
		if (this.mCurrenteMiniGame == 4) {
			this.mDifficult += 1;
			if (this.mDifficult > 2)
				this.mDifficult = 2;
		}
		switch (this.nextMiniGame()) {
		case 0:
			if (this.nextPlayer() != 0)
				scene = new Start();
			else
				scene = new End();
			break;
		case 2: scene = new SumBox(null, 0); break;
		case 1: scene = new CountDown(null, null); break;
		case 3: scene = new MemShuffle(null, null, null); break;
		}
		setScene(scene);
	}
	
	public int getDifficult() {
		return this.mDifficult;
	}
	
	public int getDifficultStart() {
		return this.mDifficultStart;
	}
	
	public void toggleDifficult() {
		this.mDifficult = (this.mDifficult + 1) % 3;
		this.mDifficultStart = this.mDifficult;
	}
	
	public int getCurrentPlayer() {
		return this.mCurrentPlayer;
	}
	
	public int nextPlayer() {
		this.mCurrentPlayer += 1;
		this.mDifficult = this.mDifficultStart;
		if (this.mCurrentPlayer <= this.mNumPlayers)
			return this.mCurrentPlayer;
		else {
			this.mCurrentPlayer = 0;
			return 0;
		}
	}	
	
	public int getNumPlayers() {
		return this.mNumPlayers;
	}
	
	public void toggleNumPlayers() {
		if (this.mNumPlayers == 1)
			this.mNumPlayers = 2;
		else
			this.mNumPlayers = 1;
	}
	
	public boolean getAudio() {
		return this.mAudio;
	}
	
	public void toggleAudio() {
		this.mAudio = !(this.mAudio);
		StoreMyData.instance().setDBValue("audio", this.mAudio);
	}
	
	public boolean getVibro() {
		return this.mVibro;
	}
	
	public void toggleVibro() {
		this.mVibro = !(this.mVibro);
		StoreMyData.instance().setDBValue("vibro", this.mVibro);
	}
	
	public void vibrate() {
		int mode = this.mAudioManager.getRingerMode();
		if (mode >= AudioManager.RINGER_MODE_VIBRATE && this.mVibro) {
			try {
				getEngine().vibrate(500);
			} catch (Exception e) {
			}
		}
	}
	
}
