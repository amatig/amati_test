package org.anddev.andengine.memopuzzle;

import org.anddev.andengine.engine.Engine;
import org.anddev.andengine.entity.primitive.Rectangle;
import org.anddev.andengine.entity.scene.Scene;
import org.anddev.andengine.entity.scene.background.ColorBackground;
import org.anddev.andengine.entity.sprite.Sprite;
import org.anddev.andengine.entity.util.FPSLogger;
import org.anddev.andengine.extension.physics.box2d.PhysicsConnector;
import org.anddev.andengine.extension.physics.box2d.PhysicsFactory;
import org.anddev.andengine.extension.physics.box2d.PhysicsWorld;
import org.anddev.andengine.opengl.texture.Texture;
import org.anddev.andengine.opengl.texture.TextureOptions;
import org.anddev.andengine.opengl.texture.region.TextureRegion;
import org.anddev.andengine.opengl.texture.region.TextureRegionFactory;
import org.anddev.andengine.util.MathUtils;

import android.hardware.SensorManager;

import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.physics.box2d.Body;
import com.badlogic.gdx.physics.box2d.FixtureDef;
import com.badlogic.gdx.physics.box2d.BodyDef.BodyType;

public class SumBox extends Scene {
	
	public SumBox(TextureRegion tex1reg) {
		super(1);
        setBackground(new ColorBackground(1, 1, 1));
        
        PhysicsWorld mPhysicsWorld = new PhysicsWorld(new Vector2(0, SensorManager.GRAVITY_EARTH), false);
        
        final Rectangle ground = new Rectangle(0, MemoPuzzle.CAMERA_HEIGHT, MemoPuzzle.CAMERA_WIDTH, 2);  		
		final Sprite face = new Sprite(100, 0, tex1reg);
		final Sprite face2 = new Sprite(100, 160, tex1reg);
		final Sprite face3 = new Sprite(100, 320, tex1reg);
		
		getLastChild().attachChild(ground);
		getLastChild().attachChild(face);
		getLastChild().attachChild(face2);
		getLastChild().attachChild(face3);
		
        final FixtureDef wallFixtureDef = PhysicsFactory.createFixtureDef(0, 0.5f, 0.5f);
		PhysicsFactory.createBoxBody(mPhysicsWorld, ground, BodyType.StaticBody, wallFixtureDef);
		
		final FixtureDef objectFixtureDef = PhysicsFactory.createFixtureDef(1, 0.5f, 0.5f);
		final Body body = PhysicsFactory.createCircleBody(mPhysicsWorld, face, BodyType.DynamicBody, objectFixtureDef);
		final Body body2 = PhysicsFactory.createCircleBody(mPhysicsWorld, face2, BodyType.DynamicBody, objectFixtureDef);
		final Body body3 = PhysicsFactory.createCircleBody(mPhysicsWorld, face3, BodyType.DynamicBody, objectFixtureDef);
		
		//setTouchAreaBindingEnabled(true);
		registerUpdateHandler(mPhysicsWorld);
		
		mPhysicsWorld.registerPhysicsConnector(new PhysicsConnector(face, body, true, false)); // false updata la rotazione
		mPhysicsWorld.registerPhysicsConnector(new PhysicsConnector(face2, body2, true, false));
		mPhysicsWorld.registerPhysicsConnector(new PhysicsConnector(face3, body3, true, false));
	
	}
	
}
