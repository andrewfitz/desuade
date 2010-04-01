/*

Desuade Motion Package (DMP) 1.1 Sequence Example
http://desuade.com/dmp

This .fla goes over how basic sequencing works with the package.
Working knowledge of the DMP tween classes is required.

////Overview////

A sequence is an ordered array of tweens that get fired off in order, after each tween finishes.
The Sequence class is a subclass of Array, so working with and managing tweens in a sequence is as easy as working with arrays.

For the most part, all motion objects that have start/stop methods and broadcast MotionEvent.ENDED can be sequenced


There are 2 kinds of sequences:
Sequence: standard sequence takes motion objects (Tween, Sequence, MotionController, DelayableFunc, etc)
ClassSequence: this creates a sequence from regular config objects, each the same class


The following can be passed into a Sequence:
Tweens: any tween inherited from BasicTween is acceptable
MotionControllers: controllers can be sequenced
Sequences: any sequences can be nested inside other sequences
DelayableFunc: this is a function that can be ran in a sequence, with optional delay
SequenceGroup: these can contain any of the above objects and will be ran together instead of sequental.
Arrays: arrays get turned into SequenceGroups


The following can be passed into a ClassSequence:
Objects: passing regular objects {} into the sequence will create items from them based on the given class of the sequence.
Sequences: any sequences can be nested inside other sequences
SequenceGroup: these can contain any of the above objects and will be ran together instead of sequental.
Arrays: arrays get turned into SequenceGroups

If BasicTween or Tween is used as the class, you can use the following in v1.1:
-duration
-startAtTime()
-getPositionInTime()


////Syntax////

Sequence:

new Sequence(... {objects desired to be passed});

ex:
var ns:new Sequence(
	new Tween(myobj, {property:'x', value:300, duration:3, bezier:[-100, 500]}),
	new Tween(myobj, {property:'y', value:300, duration:2, bezier:[-100, 500]})
);
ns.start();


ClassSequence:

new ClassSequence(motionclass, ... {objects desired to be passed});

ex:
var ns:ClassSequence = new ClassSequence(Tween, {target:myobj, property:'x', value:40, duration:2}, {target:newobj, property:'y', value:'80', duration:5});
ns.start();


For more information, consult the docs on properties and syntax guidelines: http://api.desuade.com/

*/

package {

	import flash.display.*;

	public class motion_sequences extends MovieClip {
	
		public function motion_sequences()
		{
			super();
			
						
			
			/////////////////////////////////////////////////
			//
			//
			//How to use: each block of code is a seperate example, with the start method commented out.
			//Uncommenting this will show the resulting example in the compiled SWF.
			//Go through each example and uncomment the lines, test the movie,
			//then recomment the line and continue to the next demo.
			//
			//Note: Everything here you can easily copy and run in an FLA
			//code was provided in this .as file for users without the Flash IDE.
			//
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
			target1.graphics.drawRect(0, 0, 100, 100);
			target1.name = "target1";
			addChild(target1);
			target1.x = 150;
			target1.y = 150;

			var target2:Sprite = new Sprite();
			target2.graphics.beginFill(0xDD77F0);
			target2.graphics.drawRect(0, 0, 100, 100);
			addChild(target2);
			target2.x = 50;
			target2.y = 270;

			//This is for all the debugging classes
			//Comment out or set Debug.enabled = false to disable debugging
			import com.desuade.debugging.*
			import com.desuade.motion.*
			Debug.load(new DebugCodesMotion());
			Debug.level = 60000;
			Debug.enabled = true;
			//Debug.onlyCodes = true;

			//import controllers, tweens, sequencers, and eases
			import com.desuade.motion.controllers.*;
			import com.desuade.motion.tweens.*;
			import com.desuade.motion.sequences.*;
			import com.desuade.motion.eases.*;



			////
			//this is a basic example
			var afms:ClassSequence = new ClassSequence(Tween,
				{target:target1, property:'x', value:0},
				{target:target2, property:'y', value:'-100'},
				[
				 {target:target1, property:'x', value:200},
				 {target:target2, property:'x', value:200},
				]
			);
			afms.overrides = {duration: 2}; //override all durations
			//afms.start();



			////
			//this is a sequence that uses arrays (Sequence Groups) and Tweens
			var fnms:Sequence = new Sequence(
				[
				new Tween(target1, {property:'x', value:300, duration:3, bezier:[-100, 500]}),
				new Tween(target1, {property:'y', value:300, duration:2, bezier:[-100, 500]})
				],
				new BasicTween({target:target2, property:'y', value:0, duration:3})
			);
			//fnms.start();




			////
			//this sequence uses the BasicColorTween class to change a mc's color.
			//the basic class is used because there is no delay used or any advanced features needed
			//use the standard ColorTween, MultiTween, and Tween classes if you're not sure, or require more standard properties
			var ncss:ClassSequence = new ClassSequence(BasicColorTween,
				{value:'ff3300'},
				{target:target1, value:'fa3090', duration:5, amount:1},
				{value:'df3700', ease:'easeOutBounce'},
				{type:'clear'}
			);
			ncss.overrides = {target:target1, amount:.8, duration:2};
			//trace("arr: " + ncss.splice(0)); //traces all items removed
			//ncss.start();




			/////////////////
			//This is a complex example to show just how powerful the sequencer is
			//This sequences Controllers, Tweens, Sequences, Arrays, SequenceGroups, and a ClassSequence
			var dncs:ClassSequence = new ClassSequence(Tween,
				{property:'y', value:300, duration:3, bezier:[-100, 500]},
				{property:'x', value:'100', delay: 1, duration:1},
				{property:'x', value:50, delay: 0, duration:1},
				[
				{property:'y', value:'-200', delay: .5, duration:2.5, ease:'easeOutBounce'},
				{property:'alpha', value:.5, delay: 0, duration:2}
				]
			);
			dncs.overrides = {target:target1};

			var my_mc:MotionController = new MotionController(target1, 'y', 4, KeyframeContainer);
			//my_mc.keyframes.tweenclass = Tween;
			my_mc.keyframes.end.value = null;
			//my_mc.keyframes.end.extras = {bezier:[50, "100", 45]};
			//my_mc.keyframes.begin.value = 0;
			my_mc.keyframes.poker = new Keyframe(.5, 150, 'easeOutBounce', 400);

			function traceme($words:String = "default"){
				trace($words);
			}

			var ns:Sequence = new Sequence(
				[
					new BasicTween(target1, {property:'x', value:'200', duration:2, ease:'easeOutSine'}),
					new BasicTween(target1, {property:'alpha', value:0.5, duration:3, ease:'easeOutBounce'}),
					my_mc
				],
				new BasicTween(target2, {property:'x', value:0, duration:1, ease:'easeInSine'}),
				my_mc,
				new BasicMultiTween(target1, {properties:{x:200, y:200, rotation:300}, duration:2, ease:'linear'}),
				ncss,
				new SequenceGroup(
					new BasicTween(target1, {property:'alpha', value:1, duration:3, ease:'easeOutQuad'}),
					new Tween(target1, {property:'rotation', delay: 2, value:'360', duration:4, ease:'easeOutElastic'})
				),
				new DelayableFunc({func:traceme, delay:1, args:["hello!"]}),
				dncs
			);
			//ns.manualAdvance = true; //if this is true, the sequence wont advance unless advance() is called
			//ns.start();
			
			
			
			
			////
			//Shows new features in 1.1
			var ndncs:ClassSequence = new ClassSequence(Tween,
				{property:'y', value:300, duration:3, bezier:[-100, 500]},
				{property:'x', value:'100', delay: 1, duration:1},
				{property:'x', value:50, delay: 0, duration:1},
				new SequenceGroup(
				{property:'y', value:'-200', delay: .5, duration:2.5, ease:'easeOutBounce'},
				{property:'alpha', value:.5, delay: 0, duration:2}
				)
			);
			ndncs.overrides = {target:target1};
			//trace(ndncs.duration);
			//ndncs.startAtTime(3.2);
			
		}
	
	}

}
