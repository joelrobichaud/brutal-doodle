package com.brutaldoodle.rendering
{
	import com.pblabs.rendering2D.DisplayObjectRenderer;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.twoD.actions.DeathZone;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.renderers.BitmapRenderer;
	import org.flintparticles.twoD.zones.RectangleZone;
	import org.flintparticles.twoD.zones.Zone2D;
	
	public class FlintBitmapRenderer extends DisplayObjectRenderer
	{
		protected var _renderer:BitmapRenderer;
		private var _emptyEmitters:uint;
		
		private var _width:Number;
		private var _height:Number;
		
		protected var _emitters:Array;
		
		public function FlintBitmapRenderer(width:Number=960, height:Number=680)
		{
			super();
			_width = width;
			_height = height;
			_emptyEmitters = 0;
			_emitters = new Array();
			_renderer = new BitmapRenderer( new Rectangle(-_width/2, -_height/2, _width, _height) );
		}
		
		public function addEmitters():void
		{
			for (var i:int=0; i < _emitters.length; i++) {
				_renderer.addEmitter(_emitters[i]);
				(_emitters[i] as Emitter2D).addEventListener("emitterEmpty", destroyOwner, false, 0, true);
			}
			
			this.displayObject = _renderer;
		}
		
		protected function initializeEmitter(emitter:Emitter2D, position:Zone2D=null):void {
			emitter.addAction( new DeathZone( new RectangleZone(-_width/2, -_height/2, _width, _height), true) );
			if (position != null)
				emitter.addInitializer( new Position( position ) );
			
			_emitters.push(emitter);
			emitter.start();
		}
		
		private function destroyOwner(event:EmitterEvent):void
		{
			(event.target as Emitter2D).removeEventListener("emitterEmpty", destroyOwner);
			_emptyEmitters++;
			
			if (_emptyEmitters == _emitters.length)
				owner.destroy();
		}
		
		public function get sprite ():Sprite { return _renderer as Sprite; }
	}
}