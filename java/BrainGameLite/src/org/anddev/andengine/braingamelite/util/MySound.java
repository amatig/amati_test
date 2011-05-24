/***
=== BrainGame ===

Copyright (C) 2011 Giovanni Amati

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
***/

package org.anddev.andengine.braingamelite.util;

import org.anddev.andengine.audio.sound.Sound;
import org.anddev.andengine.braingamelite.singleton.Enviroment;

import android.media.AudioManager;

public class MySound {
	private Sound mSound;
	
	public MySound(Sound sound) {
		this.mSound = sound;
	}
	
	public void play() {
		int mode = Enviroment.instance().getAudioManager().getRingerMode();
		
		if (mode == AudioManager.RINGER_MODE_NORMAL && Enviroment.instance().getAudio())
			this.mSound.play();
	}
	
}