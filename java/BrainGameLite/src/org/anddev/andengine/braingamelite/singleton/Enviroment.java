/***
=== BrainGame ===

Copyright (C) 2011 Giovanni Amati

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
***/

package org.anddev.andengine.braingamelite.singleton;

import java.util.Collections;
import java.util.LinkedList;

import org.anddev.andengine.braingamelite.BrainGameLite;
import org.anddev.andengine.braingamelite.scene.CatchElement;
import org.anddev.andengine.braingamelite.scene.CountDown;
import org.anddev.andengine.braingamelite.scene.End;
import org.anddev.andengine.braingamelite.scene.FlyBall;
import org.anddev.andengine.braingamelite.scene.MemSequence;
import org.anddev.andengine.braingamelite.scene.MemShuffle;
import org.anddev.andengine.braingamelite.scene.Start;
import org.anddev.andengine.braingamelite.scene.SumBox;
import org.anddev.andengine.braingamelite.utils.ScoreLayer;
import org.anddev.andengine.engine.Engine;
import org.anddev.andengine.entity.scene.Scene;

import android.app.Service;
import android.content.Context;
import android.content.SharedPreferences;
import android.media.AudioManager;

public class Enviroment {
	private static Enviroment mInstance = null;
	
	// data utils
	private BrainGameLite mGame = null;
	private ScoreLayer mScoreLayer = null;
	
	// mini game vars
	private int[] mMiniGameScene;
	private int mCurrenteMiniGame = -1;
	public static int NUMMINIGAME = 10;
	
	// player vars
	private int mCurrentPlayer = 1;
	private int mNumPlayers = 1;
	
	// stats
	private int mErrorPlayer1 = 0;
	private int mErrorPlayer2 = 0;
	private int mTimePlayer1 = 0;
	private int mTimePlayer2 = 0;
	
	// seting global
	private int mDifficult = 0;  // 0 Easy 1 Normal 2 Hard
	private int mDifficultStart = 0;
	private boolean mAudio = true;
	private boolean mVibro = true;
	
	private AudioManager mAudioManager;
	
	// store date
	private SharedPreferences mScoreDb;
	private SharedPreferences.Editor mScoreDbEditor;
	
	// Costruttore
	private Enviroment() {
		
	}
	
	public static synchronized Enviroment instance() {
		if (mInstance == null) 
			mInstance = new Enviroment();
		return mInstance;
	}
	
	public void loadVariables(BrainGameLite game) {
		this.mGame = game;
		
		// init db
		this.mScoreDb = this.mGame.getSharedPreferences("BrainGameData", Context.MODE_PRIVATE);
		this.mScoreDbEditor = this.mScoreDb.edit();
		
		this.mAudio = this.mScoreDb.getBoolean("audio", true);
		this.mVibro = this.mScoreDb.getBoolean("vibro", true);
		
		// minigame
		this.mMiniGameScene = new int[NUMMINIGAME];
		
		getEngine().enableVibrator(this.mGame);
		this.mAudioManager = (AudioManager) this.mGame.getSystemService(Service.AUDIO_SERVICE); 
	}
	
	public void setDBValue(String key, int value) {
		this.mScoreDbEditor.putInt(key, value);
		this.mScoreDbEditor.commit();
	}
	
	public int getDBValue(String key) {
		return this.mScoreDb.getInt(key, 0);
	}
	
	public void addScore(int value) {
		LinkedList<Integer> temp = new LinkedList<Integer>();
		for (int i = 0; i < 10; i++) {
			int time = getDBValue(Integer.toString(i));
			if (time != 0)
				temp.add(new Integer(time));
		}
		temp.add(new Integer(value));
		Collections.sort(temp);
		for (int i = 0; i < temp.size(); i++)
			setDBValue(Integer.toString(i), temp.get(i));
	}
	
	public void reInitVariables() {
		this.mMiniGameScene[0] = 4;
		this.mMiniGameScene[1] = 1;
		this.mMiniGameScene[2] = 5;
		this.mMiniGameScene[3] = 4;
		this.mMiniGameScene[4] = 1;
		this.mMiniGameScene[5] = 5;
		this.mMiniGameScene[6] = 4;
		this.mMiniGameScene[7] = 1;
		this.mMiniGameScene[8] = 5;
		this.mMiniGameScene[9] = 4;
		
		this.mCurrenteMiniGame = -1;
		this.mDifficult = 0;
		this.mDifficultStart = 0;
		this.mCurrentPlayer = 1;
		this.mNumPlayers = 1;
		this.mErrorPlayer1 = 0;
		this.mErrorPlayer2 = 0;
		this.mTimePlayer1 = 0;
		this.mTimePlayer2 = 0;
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
	
	public void createScoreLayer() {
		// need clean object layer....
		this.mScoreLayer = new ScoreLayer();
	}
	
	public ScoreLayer getScoreLayer() {
        return this.mScoreLayer;
	}
		
	public Scene getScene() {
		return this.mGame.getEngine().getScene();
	}
	
	public void setScene(Scene scene) {
		// need clean object old scene
		this.mGame.getEngine().setScene(scene);
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
		case 1: scene = new SumBox(null, 0); break;
		case 2: scene = new MemSequence(null); break;
		case 3: scene = new CatchElement(null); break;
		case 4: scene = new CountDown(null, null); break;
		case 5: scene = new MemShuffle(null, null, null); break;
		case 6: scene = new FlyBall(null, 0); break;
		}
		setScene(scene);
	}
	
	public static int random(int min, int max) {
		int range = max - min + 1;
    	int value = (int)(range * Math.random()) + min;
    	return value;
	}
	
	public static String toTime(int time) {
		String m = Integer.toString((int)(time / 60));
		if (m.length() < 2)
			m = "0" + m;
		String s = Integer.toString(time % 60);
		if (s.length() < 2)
			s = "0" + s;
		return m + ":" + s;
	}
	
	public void incErrorP1() {
		this.mErrorPlayer1 += 1;
	}
	
	public void incErrorP2() {
		this.mErrorPlayer2 += 1;
	}
	
	public int getErrorP1() {
		return this.mErrorPlayer1;
	}
	
	public int getErrorP2() {
		return this.mErrorPlayer2;
	}
	
	public void setTimeP1(int time) {
		this.mTimePlayer1 = time;
	}
	
	public void setTimeP2(int time) {
		this.mTimePlayer2 = time;
	}
	
	public int getTimeP1() {
		return this.mTimePlayer1;
	}
	
	public int getTimeP2() {
		return this.mTimePlayer2;
	}
	
	public boolean getAudio() {
		return this.mAudio;
	}
	
	public void toggleAudio() {
		this.mAudio = !(this.mAudio);
		this.mScoreDbEditor.putBoolean("audio", this.mAudio);
		this.mScoreDbEditor.commit();
	}
	
	public boolean getVibro() {
		return this.mVibro;
	}
	
	public void toggleVibro() {
		this.mVibro = !(this.mVibro);
		this.mScoreDbEditor.putBoolean("vibro", this.mVibro);
		this.mScoreDbEditor.commit();
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
	
	public void toggleDifficult() {
		this.mDifficult = (this.mDifficult + 1) % 3;
		this.mDifficultStart = this.mDifficult;
	}
	
	public int getDifficult() {
		return this.mDifficult;
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
	
	public int getCurrentPlayer() {
		return this.mCurrentPlayer;
	}
	
	public void toggleNumPlayers() {
		this.mNumPlayers = 1;
	}
	
	public int getNumPlayers() {
		return this.mNumPlayers;
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
	
}
