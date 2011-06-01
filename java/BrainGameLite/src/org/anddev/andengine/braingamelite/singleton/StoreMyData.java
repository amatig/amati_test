/***
=== BrainGame ===

Copyright (C) 2011 Giovanni Amati

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
***/

package org.anddev.andengine.braingamelite.singleton;

import java.util.HashMap;
import java.util.Map;

import org.anddev.andengine.braingamelite.BrainGameLite;
import org.anddev.andengine.braingamelite.layer.ScoreLayer;
import org.anddev.andengine.util.TimeUtils;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.ActivityInfo;

import com.openfeint.api.OpenFeint;
import com.openfeint.api.OpenFeintDelegate;
import com.openfeint.api.OpenFeintSettings;
import com.openfeint.api.resource.Achievement;
import com.openfeint.api.resource.Leaderboard;
import com.openfeint.api.resource.Score;

public class StoreMyData {
	private static StoreMyData mInstance = null;
	
	private BrainGameLite mGame = null;
	private ScoreLayer mScoreLayer = null;
	
	// stats
	private int mErrorPlayer1 = 0;
	private int mErrorPlayer2 = 0;
	private int mTimePlayer1 = 0;
	private int mTimePlayer2 = 0;
	
	// store date
	private SharedPreferences mScoreDb;
	private SharedPreferences.Editor mScoreDbEditor;
	
	// Costruttore
	private StoreMyData() {
		
	}
	
	public static synchronized StoreMyData instance() {
		if (mInstance == null) 
			mInstance = new StoreMyData();
		return mInstance;
	}
	
	public void initVariables(BrainGameLite game) {
		this.mGame = game;
		
		// init db
		this.mScoreDb = this.mGame.getSharedPreferences("BrainGameData", Context.MODE_PRIVATE);
		this.mScoreDbEditor = this.mScoreDb.edit();
		
		try {
			Map<String, Object> options = new HashMap<String, Object>();
			options.put(OpenFeintSettings.SettingCloudStorageCompressionStrategy, OpenFeintSettings.CloudStorageCompressionStrategyDefault);
			// use the below line to set orientation
			options.put(OpenFeintSettings.RequestedOrientation, ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
			OpenFeintSettings settings = new OpenFeintSettings("BrainGameLite", "65oDEKQO5acTLj6ql9hfA", "oKqSm3PcDNxSVbJiUi5X7NLqfgLP02Z7QkCmxf0", "294813", options);
			
			OpenFeint.initialize(this.mGame, settings, new OpenFeintDelegate() { });
		} catch (Exception e) {
			
		}
	}
	
	public void reInitVariables() {
		this.mErrorPlayer1 = 0;
		this.mErrorPlayer2 = 0;
		this.mTimePlayer1 = 0;
		this.mTimePlayer2 = 0;
	}
	
	public boolean getDBValue(String key, boolean def) {
		return this.mScoreDb.getBoolean(key, def);
	}
	
	public int getDBValue(String key, int def) {
		return this.mScoreDb.getInt(key, def);
	}
	
	public void setDBValue(String key, int value) {
		this.mScoreDbEditor.putInt(key, value);
		this.mScoreDbEditor.commit();
	}
	
	public void setDBValue(String key, boolean value) {
		this.mScoreDbEditor.putBoolean(key, value);
		this.mScoreDbEditor.commit();
	}
	
	public void addScore(int player, int value) {
		String level = null;
		String nw = null;
		String hb = null;
		String simple = "992052";
		String hyper = "992172";
		String insane = "992192";
		int time = 0;
		
		if (Enviroment.instance().getDifficultStart() == 0) {
			level = "756276";
			nw = "991642";
			hb = "991682";
			time = 60; // 1:00
		} else if (Enviroment.instance().getDifficultStart() == 1) {
			level = "756286";
			nw = "991652";
			hb = "991702";
			time = 80; // 1:20
		} else {
			level = "756296";
			nw = "991672";
			hb = "991712";
			time = 110; // 1:50
		}
		submitScore(level, value);
		
		// OBIETTIVI
		if (getDBValue(nw, true)) {
			if (player == 1 && this.mErrorPlayer1 == 0)
				unlockObj(nw);
			else if (player == 2 && this.mErrorPlayer2 == 0)
				unlockObj(nw);
		}
		if (getDBValue(hb, true)) {
			if (player == 1 && this.mTimePlayer1 <= time)
				unlockObj(hb);
			else if (player == 2 && this.mTimePlayer2 <= time)
				unlockObj(hb);
		}
		
		if (getDBValue(simple, true)) { 
			if (getDBValue(simple + "_counter", 0) >= 20)
				unlockObj(simple);
			else
				setDBValue(simple + "_counter", getDBValue(simple + "_counter", 0) + 1);
		}
		if (getDBValue(hyper, true)) {
			if (getDBValue(hyper + "_counter", 0) >= 50)
				unlockObj(hyper);
			else
				setDBValue(hyper + "_counter", getDBValue(hyper + "_counter", 0) + 1);
		}
		if (getDBValue(insane, true)) {
			if (getDBValue(insane + "_counter", 0) >= 100)
				unlockObj(insane);
			else
				setDBValue(insane + "_counter", getDBValue(insane + "_counter", 0) + 1);
		}
	}
	
	private void submitScore(String leaderID, int value) {
		try {
			Score s = new Score((long)value, TimeUtils.formatSeconds(value));
			Leaderboard l = new Leaderboard(leaderID);
			s.submitTo(l, new Score.SubmitToCB() {
				@Override public void onSuccess(boolean newHighScore) {
					StoreMyData.this.mGame.setResult(Activity.RESULT_OK);
				}
				
				@Override public void onFailure(String exceptionMessage) {
					StoreMyData.this.mGame.setResult(Activity.RESULT_CANCELED);
				}
			});
		} catch (Exception e) {
			
		}
	}
	
	private void unlockObj(final String objID) {
		try {
			new Achievement(objID).unlock(new Achievement.UnlockCB () {
				@Override
				public void onSuccess(boolean newUnlock) {
					StoreMyData.this.setDBValue(objID, false);
					StoreMyData.this.mGame.setResult(Activity.RESULT_OK);
				}
				
				@Override public void onFailure(String exceptionMessage) {
					StoreMyData.this.mGame.setResult(Activity.RESULT_CANCELED);
				}
			});
		} catch (Exception e) {
			
		}
	}
	
	public void createScoreLayer() {
		// need clean object layer....
		this.mScoreLayer = new ScoreLayer();
	}
	
	public ScoreLayer getScoreLayer() {
        return this.mScoreLayer;
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
	
}
