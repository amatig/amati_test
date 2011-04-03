package org.anddev.andengine.memopuzzle.game;

import java.util.LinkedList;

import org.anddev.andengine.engine.handler.timer.ITimerCallback;
import org.anddev.andengine.engine.handler.timer.TimerHandler;
import org.anddev.andengine.entity.primitive.Rectangle;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.entity.text.Text;
import org.anddev.andengine.extension.physics.box2d.PhysicsConnector;
import org.anddev.andengine.extension.physics.box2d.PhysicsFactory;
import org.anddev.andengine.extension.physics.box2d.PhysicsWorld;
import org.anddev.andengine.extension.physics.box2d.util.Vector2Pool;
import org.anddev.andengine.memopuzzle.MemoPuzzle;
import org.anddev.andengine.memopuzzle.utils.Enviroment;
import org.anddev.andengine.memopuzzle.utils.GameScene;
import org.anddev.andengine.memopuzzle.utils.MyChangeableText;
import org.anddev.andengine.memopuzzle.utils.Setting;

import android.hardware.SensorManager;

import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.physics.box2d.Body;
import com.badlogic.gdx.physics.box2d.FixtureDef;
import com.badlogic.gdx.physics.box2d.BodyDef.BodyType;

public class SumBox extends GameScene {
	private static final int INF = 1;
	private static final int SUP = 9;
	
	private PhysicsWorld mPhysicsWorld;
	
	private LinkedList<Integer> mListValue;
	private LinkedList<Integer> mTempListValue;
	
	private Integer mSum;
	private Integer mTempSum;
	
	public SumBox(int [] boxList, int[] boxRemoveList) {
		super();
    			
    	// fisica
    	this.mPhysicsWorld = new PhysicsWorld(new Vector2(0, SensorManager.GRAVITY_EARTH + 30), false);
    	
        // base
		Rectangle ground = new Rectangle(0, MemoPuzzle.CAMERA_HEIGHT - 2, MemoPuzzle.CAMERA_WIDTH, 2);  		
    	FixtureDef wallFixtureDef = PhysicsFactory.createFixtureDef(0, 0f, 0f);
    	PhysicsFactory.createBoxBody(this.mPhysicsWorld, ground, BodyType.StaticBody, wallFixtureDef);
    	getGameLayer().attachChild(ground);
       			
    	int num = 0;
    	switch (Enviroment.instance().getDifficult()) {
    		case 0: num = 4; break;
    		case 1: num = 5; break;
    		case 2: num = 6; break;
    	}
    	
		// dati
		this.mListValue = new LinkedList<Integer>();
		this.mTempListValue = new LinkedList<Integer>();
		
    	// add box   	
    	int[] setting1 = new int[num];
    	
        for (int i = 1; i <= num; i++) {
        	int value = -1;
        	if (boxList == null) {
        		value = Enviroment.random(INF, SUP);
        		setting1[i - 1] = value;
        	} else
        		value = boxList[i - 1];
        	this.mListValue.add(new Integer(value));
        	this.mTempListValue.add(new Integer(value));
        	addBox(value, i);
        }
    	
        if (boxList == null)
        	 Setting.instance().setSumBoxSetting1(setting1);
        
        // calc solution
        int[] setting2 = null;
        
        if (boxRemoveList == null) {
        	int to_remove = Enviroment.random(1, num - 3);
        	setting2 = new int[to_remove];
        	for (int i = 1; i <= to_remove; i++) {
        		int index = Enviroment.random(0, this.mTempListValue.size() - 1);
        		this.mTempListValue.remove(index);
        		setting2[i - 1] = index;
        	}
        	Setting.instance().setSumBoxSetting2(setting2);
        } else {
        	for (int i = 1; i <= boxRemoveList.length; i++) {
        		this.mTempListValue.remove(boxRemoveList[i - 1]);
        	}
        }
    	
    	this.mSum = new Integer(0);
    	for (int i = 0; i < this.mTempListValue.size(); i++) {
    		this.mSum += this.mTempListValue.get(i);
    	}
    	
    	// label
    	Text sumText = new Text(90, 100, Enviroment.instance().fontSum, "Sum " + this.mSum.toString());
    	getGameLayer().attachChild(sumText);
		
        // physics
        registerUpdateHandler(this.mPhysicsWorld);
        // touch listener
        setOnAreaTouchListener(this.mGame);
	}
	
	private void addBox(int value, int pos) {
		Sprite box = new Sprite(190, - pos * 150, Enviroment.instance().texBox);
		MyChangeableText label = new MyChangeableText(32, 19, Enviroment.instance().fontBox, Integer.toString(value), 1);
		
		float[][] color = Enviroment.instance().getColor();
		box.setColor(color[value-1][0], color[value-1][1], color[value-1][2]);
    	
    	FixtureDef objectFixtureDef = PhysicsFactory.createFixtureDef(0, 0f, 0f);
    	Body bodyBox = PhysicsFactory.createBoxBody(this.mPhysicsWorld, box, BodyType.DynamicBody, objectFixtureDef); 	
    	this.mPhysicsWorld.registerPhysicsConnector(new PhysicsConnector(box, bodyBox, true, false)); // false update la rotazione
    	
    	registerTouchArea(box); // reg touch
    	
    	box.attachChild(label);
    	getGameLayer().attachChild(box);
	}
	
	public void manageTouch(ITouchArea pTouchArea) {
		Sprite box = (Sprite)pTouchArea;
		Body bodyBox = this.mPhysicsWorld.getPhysicsConnectorManager().findBodyByShape(box);
		
		Vector2 velocity = Vector2Pool.obtain(-40, 0);
		bodyBox.setLinearVelocity(velocity);
		Vector2Pool.recycle(velocity);
		
		Integer value = Integer.parseInt(((MyChangeableText)box.getFirstChild()).getText());
		this.mListValue.remove(value);
		
		this.mTempSum = new Integer(0);
    	for (int i = 0; i < this.mListValue.size(); i++) {
    		this.mTempSum += this.mListValue.get(i);
    	}
    	
    	if (this.mTempSum < this.mSum) {
    		setOnAreaTouchListener(null);
    		
    		Sprite falseSprite = new Sprite(90, 200, Enviroment.instance().texFalse);
    		getGameLayer().attachChild(falseSprite);
    		
    		registerUpdateHandler(new TimerHandler(1f, false, new ITimerCallback() {
    			public void onTimePassed(TimerHandler pTimerHandler) {
    				SumBox.this.mGame.setScene(new SumBox(Setting.instance().getSumBoxSetting1(), 
							              	              Setting.instance().getSumBoxSetting2()));
    			}
    		}));
    	} else if (this.mTempSum == this.mSum) {
    		setOnAreaTouchListener(null);
    		
    		getScoreLayer().increaseStep(1);
    		
    		Sprite trueSprite = new Sprite(80, 200, Enviroment.instance().texTrue);
    		getGameLayer().attachChild(trueSprite);
    		
    		registerUpdateHandler(new TimerHandler(1f, false, new ITimerCallback() {
    			public void onTimePassed(TimerHandler pTimerHandler) {
    				SumBox.this.mGame.nextScene();
    			}
    		}));
    	}
	}
	
}
