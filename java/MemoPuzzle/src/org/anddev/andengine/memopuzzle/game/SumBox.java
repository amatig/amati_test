package org.anddev.andengine.memopuzzle.game;

import java.util.LinkedList;
import org.anddev.andengine.entity.primitive.Rectangle;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.entity.scene.background.ColorBackground;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.entity.text.Text;
import org.anddev.andengine.extension.physics.box2d.PhysicsConnector;
import org.anddev.andengine.extension.physics.box2d.PhysicsFactory;
import org.anddev.andengine.extension.physics.box2d.PhysicsWorld;
import org.anddev.andengine.extension.physics.box2d.util.Vector2Pool;
import org.anddev.andengine.memopuzzle.MemoPuzzle;
import org.anddev.andengine.memopuzzle.utils.Enviroment;
import org.anddev.andengine.memopuzzle.utils.IGameScene;
import org.anddev.andengine.memopuzzle.utils.MyText;
import org.anddev.andengine.opengl.font.Font;
import org.anddev.andengine.opengl.font.FontFactory;
import org.anddev.andengine.opengl.texture.Texture;
import org.anddev.andengine.opengl.texture.TextureOptions;
import org.anddev.andengine.opengl.texture.region.TextureRegion;
import org.anddev.andengine.opengl.texture.region.TextureRegionFactory;
import org.anddev.andengine.util.HorizontalAlign;
import android.graphics.Color;
import android.hardware.SensorManager;
import android.widget.Toast;

import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.physics.box2d.Body;
import com.badlogic.gdx.physics.box2d.FixtureDef;
import com.badlogic.gdx.physics.box2d.BodyDef.BodyType;

public class SumBox extends Scene implements IGameScene {
	private static final int SUP = 9;
	private static final int INF = 1;
	
	private PhysicsWorld mPhysicsWorld;
	private LinkedList<Integer> mListValue;
	private LinkedList<Integer> mTempListValue;
	private Integer sum;
	private MemoPuzzle mGame;
	
	public SumBox(MemoPuzzle game) {
		super(1);
		this.mGame = game;
		
		// dati
		this.mListValue = new LinkedList<Integer>();
		this.mTempListValue = new LinkedList<Integer>();
		
    	// fisica
    	this.mPhysicsWorld = new PhysicsWorld(new Vector2(0, SensorManager.GRAVITY_EARTH + 30), false);
    	registerUpdateHandler(this.mPhysicsWorld);
    	
		// background
        setBackground(new ColorBackground(1f, 1f, 1f));
        
        // touch listner
        setOnAreaTouchListener(game);
        
        // texture
    	final Texture tex1  = new Texture(128, 128, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
    	final TextureRegion tex1reg = TextureRegionFactory.createFromAsset(tex1, game, "gfx/1.png", 0, 0);
    	
    	game.getEngine().getTextureManager().loadTexture(tex1); // prende + text con la ,
    	
    	// font
    	final Texture tex2 = new Texture(256, 256, TextureOptions.BILINEAR_PREMULTIPLYALPHA);
    	
		final Font font1 = FontFactory.createFromAsset(tex2, game, "font/akaDylan Collage.ttf", 48, true, Color.WHITE);

		game.getEngine().getTextureManager().loadTexture(tex2);
		game.getEngine().getFontManager().loadFont(font1);
		
        // objects
    	final Rectangle ground = new Rectangle(0, MemoPuzzle.CAMERA_HEIGHT - 2, MemoPuzzle.CAMERA_WIDTH, 2);  		
		final FixtureDef wallFixtureDef = PhysicsFactory.createFixtureDef(0, 0f, 0f);
    	PhysicsFactory.createBoxBody(this.mPhysicsWorld, ground, BodyType.StaticBody, wallFixtureDef);
       	getLastChild().attachChild(ground);
       	
    	int num = 4; // difficult
        for (int i = 1; i <= num; i++) {
        	int value = Enviroment.random(INF, SUP);
        	
        	this.mListValue.add(new Integer(value));
        	this.mTempListValue.add(new Integer(value));
        	
        	final Sprite box = new Sprite(185, - i * 150, tex1reg);
        	switch (value%3) {
        		case 0: 
        			box.setColor(1.0f, (float)value/SUP, (float)value/SUP);
        			break;
        		case 1: 
        			box.setColor((float)value/SUP, 1.0f, (float)value/SUP);
        			break;
        		case 2: 
        			box.setColor((float)value/SUP, (float)value/SUP, 1.0f);
        			break;
        	}
        	getLastChild().attachChild(box);
        	registerTouchArea(box); // reg touch
        	
        	//Toast.makeText(mGame, Integer.toString(value), Toast.LENGTH_SHORT).show();
        	final Text label = new MyText(32, 19, font1, Integer.toString(value), HorizontalAlign.CENTER);
        	box.attachChild(label);
        	
        	final FixtureDef objectFixtureDef = PhysicsFactory.createFixtureDef(0, 0f, 0f);
        	final Body bodyBox = PhysicsFactory.createBoxBody(this.mPhysicsWorld, box, BodyType.DynamicBody, objectFixtureDef);
        	
        	this.mPhysicsWorld.registerPhysicsConnector(new PhysicsConnector(box, bodyBox, true, false)); // false updata la rotazione
        }
    	
        // logic
    	int to_remove = Enviroment.random(1, num - 3);
    	for (int i = 1; i <= to_remove; i++) {
    		int index = Enviroment.random(0, this.mTempListValue.size() - 1);         	
    		this.mTempListValue.remove(index);
    	}
    	sum = new Integer(0);
    	for (int i = 0; i < this.mTempListValue.size(); i++) {
    		sum += (Integer)this.mTempListValue.get(i);
    	}
    	Toast.makeText(game, sum.toString(), Toast.LENGTH_LONG).show();
	}
	
	public void manageTouch(ITouchArea pTouchArea) {
		final Sprite box = (Sprite)pTouchArea;
		final Body bodyBox = this.mPhysicsWorld.getPhysicsConnectorManager().findBodyByShape(box);
		final Vector2 velocity = Vector2Pool.obtain(-50, 0);
		bodyBox.setLinearVelocity(velocity);
		Vector2Pool.recycle(velocity);
		
		Integer value = new Integer(((MyText)box.getFirstChild()).getText());
		Toast.makeText(mGame, ((MyText)box.getFirstChild()).getText(), Toast.LENGTH_LONG).show();
		this.mListValue.remove(value);
		
		Integer temp_sum = new Integer(0);
    	for (int i = 0; i < this.mListValue.size(); i++) {
    		temp_sum += (Integer)this.mListValue.get(i);
    	}
    	//Toast.makeText(mGame, temp_sum.toString(), Toast.LENGTH_LONG).show();
    	if (temp_sum <= this.sum) {
    		this.mGame.nextScene();
    	}
	}
	
}
