/*

Desuade Partigen 2 Introduction Examples
http://desuade.com/

This .fla goes over the basics of how to use Emitters with Partigen and the Desuade Motion Package

IMPORTANT!
Understanding of the Motion Package's MotionControllers is necessary. Working knowledge of the tween, sequencing, and physics classes is also highly recommended.
While it is possible to jump right in without it and be fine, this .fla assumes you are familiar with these before getting started.

////Overview////

This is an introduction to the Desuade Partigen API. It's recommended to have access to 
the official API docs as you're working along.

Partigen uses concepts (as well as the library itself) from the Motion Package such as 
MotionControllers heavily, as the DMP was designed with Partigen in mind.

In Partigen 1, there was a defined set of properties that could be changed for particles, 
with only a beginning and end value, and only a few offered random ranges. While this made 
it straightforward for novices, expert developers were looking for more freedom.

Thus the concept of MotionControllers was born, even before Partigen 1 was finished. This 
core architecture design allows for unlimited amount of tweens on each property during a 
particle's life - for any of the particle's tweenable properties.

While this comes with a bit more required code, much of it is duplicatable 
across emitters and provides incredible value. Also, since everything is dynamic, file 
size has decreased considerably, from the original default standard size of 40k, to an 
average of 20k (for all the libraries) - that includes and entire tween and physics engine, as 
well as the entire Partigen engine. The minimum is around 5k (this excludes controllers, etc).

If you're migrating from 1.x/AS2, there is very little in common with the old API besides 
some general concepts. Partigen 2 is a revolutionary new framework that's here to stay, 
with an architecture and syntax that is open to the future and community contributions.


////Usage////

Components of Partigen 2:

Renderers: these control how the particles are displayed
Pools: this manages the actual particle objects in memory
Events: particle events
Particles: these are dynamic objects that get created by emitters
Emitters: creates, manages, and configures particles


On average, the majority of your time with Partigen will be spent with emitters and their controllers.
Each emitter creates two "master controllers" by default:

emitter.controllers.emitter //this controls the properties of the emitter itself when start() is called
emitter.controllers.particle //this controls the properties of new particles


Any property under those will be the actual property being controlled.

For example:

emitter.controllers.particle.x //controls each particle's x value
emitter.controllers.particle.alpha //controls each particle's alpha value
emitter.controllers.emitter.x //controls the emitter's x value

-----

>To create emitter controllers, use one of the following methods on emitter.controllers.emitter:

addTween(property:String, duration:Number)
addPhysics(property:String, duration:Number, flip:Boolean = false)
addBeginValue(property:String, value:*, spread:* = 0, precision:* = 0, extras:* = null)

These methods will either create an EmitterTweenController or an EmitterePhysicsController
Each inherits a real MotionController or a PhysicsMultiController respectivly.


>To create particle controllers, use one of the following methods on emitter.controllers.particle:

addTween(property:String, duration:Number = 0)
addColorTween(property:String = "color", duration:Number = 0)
addPhysics(property:String, duration:Number = 0, flip:Boolean = false)
addBeginValue(property:String, value:*, spread:* = 0, precision:* = 0, extras:* = null)

These methods will either create a ParticleTweenController or a ParticlePhysicsController
Each resembles a MotionController or a PhysicsMultiController respectivly.


These controllers work the same way as MotionControllers from the Motion Package, so each 
one has a keyframes property than can be used to create more intricate effects:

emitter.controllers.particle.x.keyframes;

-----

The emitter has an angle and angleSpread property that is only used for ParticlePhysicsControllers
and will effect all Physics-based properties unless explicitly set not to via the 'useangle' property
on the given ParticlePhysicsController.


Emitters are controlled by start() and stop() methods, and do just what they say.
These methods also start and stop any controllers in my_emitter.controllers.emitter

-----

To make a custom Particle, simply create your class/Sprite/MovieClip and extend the partigen Particle class.
Then asign that class to the emitter:

my_em.particle = CustomParticle;


Consult the official API docs for more details http://api.desuade.com/. The examples in this .fla should provide a majority of common approaches.

*/

package {

	import flash.display.*;
	import CircleParticle;
	
	public class partigen_intro extends MovieClip {
	
		public function partigen_intro()
		{
			super();
			
			/////////////////////////////////////////////////
			//
			//How to use: each block of code is a seperate example, with the start method commented out.
			//Uncommenting this will show the resulting example in the compiled SWF.
			//Note: Everything here you can easily copy and run in an FLA
			//
			/////////////////////////////////////////////////

			//you may want to disable debugging or set the level lower if the traces don't get overwhelming

			//fla setup
			stop();
			import flash.display.MovieClip;
			import flash.display.StageAlign;
			import flash.display.StageScaleMode;
			import flash.display.BitmapData;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			//This is for all the debugging classes
			import com.desuade.debugging.*;
			import com.desuade.partigen.*;
			import com.desuade.motion.*;

			Debug.load(new DebugCodesPartigen()); //load partigen debug codes
			Debug.load(new DebugCodesMotion()); //load motion codes
			Debug.level = 50000;
			Debug.enabled = true;
			//Debug.onlyCodes = true;

			import com.desuade.partigen.emitters.*;
			import com.desuade.partigen.particles.*;
			import com.desuade.partigen.controllers.*;
			import com.desuade.partigen.renderers.*;
			import com.desuade.partigen.pools.*;
			import com.desuade.partigen.events.*;

			import com.desuade.motion.eases.*;
			import com.desuade.motion.controllers.*
			import com.desuade.motion.events.*
			import com.desuade.utils.*
			
			import CircleParticle;

			var t1:MovieClip = new MovieClip(); //make a container for particles for the renderer
			addChild(t1);

			var sr:Renderer = new StandardRenderer(t1, 'top'); //by default, emitters create nullpools and nullrenderes. let's make a StandardRenderer to share between all of them

			//basic example, using physics for motion
			var em1:Emitter = new Emitter(); //create emitter
			em1.x = em1.y = 100;
			em1.particle = CircleParticle; //assign the particle class to use for new particles
			em1.renderer = sr; //sets the renderer we made
			em1.eps = 10; //how many times to emit per second
			em1.life = 2; //set the life
			em1.lifeSpread = '0'; //we want the same life for all, so we set the spread to '0'
			em1.controllers.particle.addPhysics('y', 0, true); //creates a new ParticlePhysicsController
			em1.controllers.particle.y.velocity.keyframes.begin.value = -3; //sets the velocity
			em1.controllers.particle.y.acceleration.keyframes.begin.value = -0.1; //sets the acceleration
			em1.controllers.particle.addPhysics('x', 0);
			em1.controllers.particle.x.velocity.keyframes.begin.value = 5;
			em1.controllers.particle.x.acceleration.keyframes.flatten(0.1); //makes the acceleration controller flat, which sets a steady accel
			//em1.start();

			//example using tweening for particle motion and common properties, with events
			var em2:Emitter = new Emitter();
			em2.x = em2.y = 100;
			em2.particle = CircleParticle;
			em2.renderer = sr;
			em2.eps = 10;
			em2.life = 2.5;
			em2.lifeSpread = '0';
			em2.controllers.particle.addTween('alpha').setSingleTween(1, '0', 0, '0'); //adds a ParticleTweenController and since it returns the controller, we can call a method on the same line
			em2.controllers.particle.addTween('scale').setSingleTween(.2, '0', 1, '0');
			em2.controllers.particle.addTween('x').setSingleTween('0', '0', 300, '0', 'easeOutBounce');
			em2.controllers.particle.addTween('y').setSingleTween('0', '0', '200', '0');
			em2.addEventListener(ParticleEvent.DIED, deathFunc);
			function deathFunc(o){
				trace(o.data.particle.name + " died");
			}

			em2.addEventListener(ParticleEvent.BORN, birthFunc);
			function birthFunc(o){
				trace(o.data.particle.name + " was born");
			}
			//em2.start();

			//the same example as above, but taking advantage of spread and burst, also using the SweepPool
			var em3:Emitter = new Emitter();
			em3.x = em3.y = 100;
			em3.particle = CircleParticle;
			em3.renderer = sr;
			em3.pool = new SweepPool(5000);
			em3.burst = 2;
			em3.eps = 10;
			em3.life = 2.5;
			em3.lifeSpread = '1';
			em3.controllers.particle.addTween('alpha').setSingleTween(1, '0', 0, '0');
			em3.controllers.particle.addTween('scale').setSingleTween(.2, '0', 1, '0');
			em3.controllers.particle.addTween('x').setSingleTween('0', '0', 300, '50', 'easeOutBounce');
			em3.controllers.particle.addTween('y').setSingleTween('0', '0', '200', '0');
			//em3.start();

			//color example with grouping
			var em4:Emitter = new Emitter();
			em4.x = em4.y = 100;
			em4.particle = CircleParticle;
			em4.groupAmount = 4;
			em4.groupProximity = 50;
			em4.renderer = sr;
			em4.eps = 10;
			em4.life = 2;
			em4.controllers.particle.addColorTween();
			em4.controllers.particle.color.keyframes.begin.value = 'ff4444';
			em4.controllers.particle.color.keyframes.begin.spread = 'dd4444'; //different color each time it's started
			em4.controllers.particle.addTween('x').setSingleTween('0', '0', 300, '0', 'easeOutBounce');
			em4.controllers.particle.addTween('y').setSingleTween('0', '0', '200', '50');
			//em4.start();


			//example taking full advantage of controller keyframes
			var em5:Emitter = new Emitter();
			em5.x = em5.y = 100;
			em5.particle = CircleParticle;
			em5.renderer = sr;
			em5.eps = 10;
			em5.life = 3;
			em5.lifeSpread = '0';
			var e5pc:ParticleController = em5.controllers.particle;
			e5pc.addTween('scale').setSingleTween(1, '0', .5, '.5');
			e5pc.scale.keyframes.precision = 2;
			e5pc.scale.keyframes.add(new Keyframe(.4, .3));
			e5pc.scale.keyframes.add(new Keyframe(.7, .5, 'easeInSine', 1));
			e5pc.addTween('alpha');
			e5pc.alpha.keyframes.precision = 2;
			e5pc.alpha.keyframes.begin.value = 0;
			e5pc.alpha.keyframes.begin.spread = '0';
			e5pc.alpha.keyframes.end.value = 0;
			e5pc.alpha.keyframes.add(new Keyframe(.1, 1));
			e5pc.alpha.keyframes.add(new Keyframe(.8, 1));
			e5pc.addTween('x', 2).setSingleTween('0', '0', 200, '0', 'easeOutBounce');
			e5pc.x.keyframes.add(new Keyframe(.5, 400, null, '50'));
			e5pc.x.keyframes.keyframe_3.ease = 'easeOutElastic';
			e5pc.addTween('y').setSingleTween('0', '0', '200', '100');
			e5pc.addColorTween();
			e5pc.color.keyframes.begin.value = 'ff4444';
			e5pc.color.keyframes.begin.spread = 'dd4444';
			e5pc.color.keyframes.add(new Keyframe(.4, 0x00ce00, 'easeInQuint', '0', {amount:1, type:'tint'}));
			e5pc.addPhysics('rotation');
			e5pc.rotation.velocity.keyframes.begin.value = 1;
			//em5.start();

			//demos emitter controllers and physics angle
			var em6:Emitter = new Emitter();
			em6.x = 100;
			em6.y = 50;
			em6.particle = CircleParticle;
			em6.renderer = sr;
			em6.eps = 10;
			em6.angle = 0;
			//em6.angleSpread = '40'; this makes an angle between whatever the angle is and angle+40
			em6.life = 1;
			em6.lifeSpread = '1';
			em6.controllers.particle.addPhysics('y', 0, true);
			em6.controllers.particle.y.velocity.keyframes.begin.value = 3;
			em6.controllers.particle.y.acceleration.keyframes.begin.value = -0.1;
			em6.controllers.particle.addPhysics('x');
			em6.controllers.particle.x.velocity.keyframes.begin.value = 5;
			em6.controllers.particle.x.acceleration.keyframes.flatten(0.1);
			em6.controllers.particle.addBeginValue('scale', .75, '0', 2);
			em6.controllers.emitter.addTween('y', 5).setSingleTween('0', '0', 200, '100', 'easeOutBounce');
			em6.controllers.emitter.addTween('angle', 10).setSingleTween('0', 0, 360, '0');
			//em6.start();

			//this example clones the 5th emitter with XML
			var e5x:XML = em5.toXML();
			//trace(e5x);
			var em7:Emitter = new Emitter().fromXML(e5x);
			em7.x = 100;
			em7.y = 50;
			em7.renderer = sr;
			//em7.start();

			//this example creates an emitter from XML and shows how to use the BitmapRenderer
			var t2:MovieClip = new MovieClip(); //create an empty movieclip to hold duplicated bitmaps
			addChild(t2); //add it to the display
			t2.x = -250;
			t2.y = 0;

			var canvas:BitmapData = new BitmapData(stage.stageWidth+300, stage.stageHeight, true, 0); //create a new bitmapdata object
			addChild(new Bitmap(canvas)); //show this on the stage

			t2.addChild(new Bitmap(canvas)); //use the same bitmapdata for 2 other clips

			var mbr = new BitmapRenderer(canvas, 'bottom'); //create new BitmapRenderer spawing particles from the bottom
			mbr.fade = 0.8; //enable a 'trail' for the particles
			mbr.fadeBlur = 8; // add a nice blur to the trails to soften them

			var em8:Emitter = new Emitter();
			em8.x = 250;
			em8.renderer = mbr;
			var emmx:XML = 
			<Emitter particle="CircleParticle" eps="20" burst="8" group="GroupParticle" groupAmount="3" groupProximity="50" life="1.2" lifeSpread="1.6" angle="120" angleSpread="*50">
			  <Controllers>
			    <EmitterController>
			      <EmitterTweenController duration="5" property="y">
			        <KeyframeContainer tweenClass="BasicTween" precision="0">
			          <Keyframe position="0" ease="linear" value="*0" spread="*0" label="begin"/>
			          <Keyframe position="0.5" ease="linear" value="*200" spread="*0" label="mid"/>
			          <Keyframe position="1" ease="linear" spread="*0" label="end"/>
			        </KeyframeContainer>
			      </EmitterTweenController>
			    </EmitterController>
			    <ParticleController>
			      <ParticleTweenController duration="0" property="x">
			        <KeyframeContainer tweenClass="BasicTween" precision="0">
			          <Keyframe position="0" ease="linear" value="*0" spread="*200" label="begin"/>
			          <Keyframe position="1" ease="easeOutElastic" value="*50" spread="*0" label="end"/>
			        </KeyframeContainer>
			      </ParticleTweenController>
			      <ParticleTweenController duration="0" property="color">
			        <ColorKeyframeContainer tweenClass="BasicColorTween" precision="0">
			          <Keyframe position="0" ease="linear" value="ffaaaa" spread="*0" label="begin"/>
			          <Keyframe position="1" ease="linear" value="d9f5d3" spread="*0" label="end"/>
			        </ColorKeyframeContainer>
			      </ParticleTweenController>
			      <ParticlePhysicsController duration="0" flip="true" useAngle="true" property="y">
			        <ParticleTweenController duration="0" property="velocity">
			          <KeyframeContainer tweenClass="BasicTween" precision="3">
			            <Keyframe position="0" ease="linear" spread="*0" label="begin"/>
			            <Keyframe position="1" ease="linear" spread="*0" label="end"/>
			          </KeyframeContainer>
			        </ParticleTweenController>
			        <ParticleTweenController duration="0" property="acceleration">
			          <KeyframeContainer tweenClass="BasicTween" precision="3">
			            <Keyframe position="0" ease="linear" value="-0.7" spread="*0" label="begin"/>
			            <Keyframe position="1" ease="linear" spread="*0" label="end"/>
			          </KeyframeContainer>
			        </ParticleTweenController>
			        <ParticleTweenController duration="0" property="friction">
			          <KeyframeContainer tweenClass="BasicTween" precision="3">
			            <Keyframe position="0" ease="linear" spread="*0" label="begin"/>
			            <Keyframe position="1" ease="linear" spread="*0" label="end"/>
			          </KeyframeContainer>
			        </ParticleTweenController>
			      </ParticlePhysicsController>
			      <ParticleTweenController duration="0" property="scale">
			        <KeyframeContainer tweenClass="BasicTween" precision="0">
			          <Keyframe position="0" ease="linear" value="1" spread="3" label="begin"/>
			          <Keyframe position="1" ease="linear" spread="*0" label="end"/>
			        </KeyframeContainer>
			      </ParticleTweenController>
			    </ParticleController>
			  </Controllers>
			</Emitter>;
			em8.fromXML(emmx); //load the XML
			//em8.start(); //start the emitter
			//mbr.start(); //we have to start the BitmapRenderer to output to the bitmapdata
			
		}
	
	}

}