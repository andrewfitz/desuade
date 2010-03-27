/*

Desuade Motion Package (DMP) 1.1 Tween Example
http://desuade.com/dmp

This .fla goes over how basic tweening works with the package.

////Overview////

The design of the package is very OOP and based heavily in inheritance.

///Tween Inheritances:

Primitive: these are the absolute minimal tweens that have no built in management. These get created by BasicTweens and Tweens, and should not get created manually.
Basic: these are the basic forms of tweens that manage PrimitiveTweens, and can be used when file size is critical and basic tweening is needed.
Tween(no prefix): these are the standard tweens that should be used that offer the most functionality.


///Tween Kinds:

Tween: this is a basic tween that works for most properties. It also allows bezier curving.
Multi: this lets you tween multiple properties on a single target at the same time, with only 1 tween
Color: this uses a multitween to change the color transformation object on DisplayObjects


////Events////

There are 3 events that all tweens call: STARTED, UPDATED, ENDED.

STARTED: this gets broadcasted when the tween starts
UPDATED: this gets broadcasted each time the value gets updated
ENDED: this gets broadcasted when the tween ends


////Syntax////

The standard syntax is to pass an object with the desired parameters to a new Tween().
ex: var nt:Tween = new Tween(myobj, {property:'x', value:200, duration:2, ease:'easeOutBounce', delay:1, round:false, position:0, update:false, bezier:[100]});

Creating a tween object will not start unless .start() is called on it, where as a static call will start it right away.

MultiTweens allow you to pass an object of properties and values instead:
ex: var nt:MultiTween = new MultiTween(myobj, {properties:{x:100, y:'50', alpha:.5}, value:200, duration:2, ease:'easeOutBounce', delay:1, round:false, position:0, update:false, bezier:[100]});


/////
In v1.1, you can now call BasicTweens and Tweens with a static method using run() in a strict syntax:
Tween.run(target:Object, property:String, value:*, duration:Number, ease:* = 'linear', position:Number = 0, endfunc:Function = null);


For more information, consult the docs on properties and syntax guidelines: http://api.desuade.com/

*/

package {

	import flash.display.*;

	public class motion_tweens extends MovieClip {
	
		public function motion_tweens()
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

			//This is for all the debugging classes
			//Comment out or set Debug.enabled = false to disable debugging
			import com.desuade.debugging.*
			import com.desuade.motion.*
			Debug.load(new DebugCodesMotion());
			Debug.level = 60000;
			Debug.enabled = true;
			//Debug.onlyCodes = true;

			//import tweens and eases
			import com.desuade.motion.tweens.*;
			import com.desuade.motion.eases.*;



			////
			//BasicTween
			var mbt:BasicTween = new BasicTween(target1, {property:'x', value:400, duration:3});
			//mbt.start();



			////
			//Tween with delay and relative value
			var mt:Tween = new Tween(target1, {property:'y', value:'-100', duration:2, delay:1, ease:'easeInBounce'});
			//mt.start();
			


			////
			//Tween as a static call with run()
			function completecall(){
				trace("Static tweens!");
			}
			//Tween.run(target1, 'x', '300',  2, 'easeOutSine', 0, completecall);
			


			////
			//uses the previous tween to load it's XML (cloning the tween)
			var mtx:XML = mt.toXML();
			//trace(mtx.toXMLString());
			//var mt2:Tween = new Tween(target1).fromXML(mtx).start();
			


			////
			//Bezier tweens
			var mtb1:Tween = new Tween(target1, {property:'x', value:'150', duration:3, bezier:[50, '-200'], ease:'easeOutQuint'});
			//var mtb2:Tween = new Tween(target1, {property:'y', value:'-130', duration:3, bezier:[-100, 0,'150'], ease:'easeInOutSine'}).start(); //start it in the same line, start() returns the tween
			//mtb1.start();



			////
			//MultiTween
			var mmt:MultiTween = new MultiTween(target1, {properties:{x:'200', y:'-100', alpha:.5}, value:'50', duration:2, ease:'easeInQuad'});
			//mmt.start();



			////
			//ColorTween
			var mct:ColorTween = new ColorTween(target1, {value:'#FF0034', duration:2, amount:.8 });
			//mct.start();



			///////
			//////Event demo
			///////

			//uncomment this block for the whole demo

			import flash.events.MouseEvent;
			import com.desuade.motion.events.*;

			//creates a new tween and adds listeners
			var cth:Tween = new Tween(target1, {property:'y', value:'250', duration:5, update:true, ease:'easeOutBounce'});
			cth.addEventListener(TweenEvent.UPDATED, pfunc1);
			cth.addEventListener(TweenEvent.STARTED, startset);
			cth.start();

			//sets the starting position when the tween starts
			//since start event is a TweenEvent, we use the 'tween' value in the data object
			function startset(i:Object){
				i.data.tween.target.y = 50;
			}

			//traces the current position on update from the tween
			//since Tweens inherit the BaseBasic class, we can use both 'basic' and 'primitive'
			//values in the event's data object, instead of 'tween'
			//basic refers to the actual Tween object, and we can get the position from that
			function pfunc1(i:Object){
				trace("Pos: " + i.data.basic.position);
			}

			//clicking on the box will start/stop (play/pause) the tween
			//once finished, it will reset and start over
			var os:Boolean = false;
			addEventListener(MouseEvent.CLICK, clickHandler);
			function clickHandler(evt:MouseEvent){
				var ics:Boolean = true;
				if(!os){
					os = true;
					ics = cth.stop();
				}else {
					os = false;
					ics = cth.start();
				}
				if(!ics){
					//this resets the tween
					//since there is an STARTED event that resets the position
					//it resets the tween and goes back to the start point
					trace("COMPELTED");
					cth.reset();
				}
			}

			
			
		}
	
	}

}

