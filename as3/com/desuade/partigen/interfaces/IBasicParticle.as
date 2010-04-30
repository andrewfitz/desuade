package com.desuade.partigen.interfaces {

	import flash.display.*;
	import flash.geom.*;
	
	import com.desuade.partigen.interfaces.*;
	import com.desuade.partigen.emitters.BasicEmitter;

	/**
	 *  Provides basic interface for BasicParticle classes.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  29.04.2010
	 */
	public interface IBasicParticle {
		
		function get id():int;
		function get emitter():BasicEmitter;
		
		function init($emitter:BasicEmitter):void;
		function makeGroup($particle:Class, $amount:int, $proximity:int):void;
		function makeGroupBitmap($particleData:BitmapData, $amount:int, $proximity:int, $origin:Point):void;
		function kill(... args):void;
		function addLife($life:Number):void;
		function removeLife():void;
		
	}

}

