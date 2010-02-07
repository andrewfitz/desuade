/*

Desuade Motion Package (DMP) 1.0 Physics Example
http://desuade.com/

This .fla goes over how physics works with the package.

////Overview////

This Motion Package offers a very simple, yet powerful approach to physics motion. Compared to full-blown physics engines, the DMP offers a very basic "physics manager" to calculate physics equations for individual objects.

The advantage of this design is that any object's property can be used, not just x and y values on a specific special subclass. Similar to tweening an object's value, except there is no end value or duration, and it uses physics equations rather than easeing.

This means you can apply "physics type velocity" to a Sprite's alpha value, or change the acceleration of the volume of a sound object.

You can use a BasicPhysics object to change a property's value at a specific rate, rather than over a given duration.

Like a Tween object, a BasicPhysics object changes the value of a given property, but unlike a Tween, there is no final value or duration. This means the velocity will continue to be applied until the BasicPhysics object stops.

BasicPhysics has 3 import properties:velocity, acceleration, and friction. These 3 values influence the value of the property on each update. The acceleration and friction affect the velocity, which gets added to the value each frame.

The angle and flip properties are useful mostly for display properties:x, y, z.

////Events////

BasicPhysics has 3 events:

STARTED:when start() is called.
UPDATED:when the velocity is applied
ENDED:when stop() is called.

////Usage////

var po:BasicPhysics = new BasicPhysics(target:Object, {property:String, velocity:Number = 0, acceleration:Number = 0, friction:Number = 0, angle:* = null, flip:Boolean = false, update:false});

See the documentation for more information on each property.

ex:
var mybp:BasicPhysics = new BasicPhysics(myclip, {property:'x', velocity:2});
mybp.start();

Very similar to a Tween object, you start() and stop() a BasicPhysics object.

For more information, consult the docs on properties and syntax guidelines: http://api.desuade.com/

*/

package {

	import flash.display.*;

	public class motion_physics extends MovieClip {
	
		public function motion_physics()
		{
			super();
			
			/////////////////////////////////////////////////
			//
			//How to use: each block of code is a seperate example, with the start method commented out.
			//Uncommenting this will show the resulting example in the compiled SWF.
			//Note: Everything here you can easily copy and run in an FLA
			//
			/////////////////////////////////////////////////
			
			//Fla setup
			stop();
			import flash.display.MovieClip;
			import flash.display.StageAlign;
			import flash.display.StageScaleMode;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			//create movieclip to tween
			var target1:Sprite = new Sprite();
			target1.graphics.beginFill(0xAADDF0);
			target1.graphics.drawRect(0, 0, 30, 30);
			target1.name = "target1";
			addChild(target1);
			target1.x = 50;
			target1.y = 50;

			//This is for all the debugging classes
			//Comment out or set Debug.enabled = false to disable debugging
			import com.desuade.debugging.*
			import com.desuade.motion.*
			Debug.load(new DebugCodesMotion());
			Debug.level = 60000;
			Debug.enabled = true;
			//Debug.onlyCodes = true;

			//import physics class
			import com.desuade.motion.physics.*;
			import com.desuade.motion.events.*;

			//basic velocity
			var bp1:BasicPhysics = new BasicPhysics(target1, {property:'x', velocity:1});
			//bp1.start();

			//adding acceleration
			var bp2:BasicPhysics = new BasicPhysics(target1, {property:'x', velocity:1, acceleration:.1});
			//bp2.start();

			//use the BP object from the previous demo for XML cloning
			//var b2x:XML = bp2.toXML();
			//trace(b2x.toXMLString());
			//var bp22:BasicPhysics = new BasicPhysics(target1).fromXML(b2x).start(); //create and start physics from XML

			//friction
			var bp3:BasicPhysics = new BasicPhysics(target1, {property:'x', velocity:10, friction:3});
			//bp3.start();

			//x&y
			var bp4:BasicPhysics = new BasicPhysics(target1, {property:'x', velocity:1, friction:.3});
			var bp5:BasicPhysics = new BasicPhysics(target1, {property:'y', velocity:2, acceleration:-.1, flip:true});
			//bp4.start();
			//bp5.start();

			//x&y with angle and events
			var bp6:BasicPhysics = new BasicPhysics(target1, {property:'x', velocity:5, angle:300});
			var bp7:BasicPhysics = new BasicPhysics(target1, {property:'y', velocity:5, acceleration:.1, angle:300, flip:true});
			bp6.addEventListener(PhysicsEvent.STARTED, setSt);
			function setSt(i){
				target1.x = 200;
				target1.y = 200;
			}
			//bp6.start();
			//bp7.start();


			//3Dish animation for FP 10 CS4 only
			var t1p:BasicPhysics = new BasicPhysics(target1, {property:'x', velocity:0.1, acceleration:0.01});
			//t1p.start();
			var t1p2:BasicPhysics = new BasicPhysics(target1, {property:'y', velocity:5, acceleration:-0.05, friction:1, angle:90, flip:true});
			//t1p2.start();
			var t1p3:BasicPhysics = new BasicPhysics(target1, {property:'z', velocity:-20, acceleration:0.2, angle:90, flip:true}); //z for flash 10
			//t1p3.start();
			
		}
	
	}

}
