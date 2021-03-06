/*
* Brutal Doodle
* Copyright (C) 2011  Joel Robichaud, Maxime Basque, Maxime St-Louis-Fortier, Raphaelle Cantin & Simon Garnier
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.

* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

package com.brutaldoodle.rendering
{
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.twoD.actions.DeathZone;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.zones.PointZone;
	import org.flintparticles.twoD.zones.Zone2D;
	
	public class FlintBitmapRenderer
	{
		/*
		 * Contains all the emitters that need to be rendered for this specific effect
		 */
		protected var _emitters:Vector.<Emitter2D>;
		
		/*
		 * The number of emitters that are done emitting all their particles
		 */
		private var _counterCompletedEmitters:uint;
		
		/*
		 * The number of emitters that no longer contain any particle
		 */
		private var _emptyEmitters:uint;
		
		/*
		 * The entity from which the emitter was created
		 */
		public var trueOwner:IEntity;
		
		public function FlintBitmapRenderer() {
			super();
			_emptyEmitters = 0;
			_counterCompletedEmitters = 0;
			_emitters = new Vector.<Emitter2D>();
		}
		
		/*
		 * To be overriden...
		 * Register all the emitters to the Particle Manager for rendering
		 */
		public function addEmitters():void {
			for (var i:int=0; i < _emitters.length; i++) {
				ParticleManager.instance.registerEmitter(_emitters[i]);
				
				// Listeners used for cleaning references when the emitters are done emitting particles
				_emitters[i].addEventListener(EmitterEvent.EMITTER_EMPTY, destroyOwner, false, 0, true);
				_emitters[i].addEventListener(EmitterEvent.COUNTER_COMPLETE, destroyOwner, false, 0, true);
				_emitters[i].addEventListener(ParticleEvent.PARTICLE_DEAD, removeParticle, true, 0, true);
			}
		}
		
		/*
		 * Add a default position and dead zone to the emitter
		 *
		 * @emitter  The emitter that need to be initialized
		 * @position  The position at which emitter is created
		 */
		protected function initializeEmitter(emitter:Emitter2D, position:Zone2D=null):void {
			var _emitLocation:Zone2D;
			
			// The emit location is determined by the position of its owner or by the optional parameter "position" (if supplied)
			if (position != null)
				_emitLocation = position;
			else if (trueOwner != null)
				_emitLocation = new PointZone( (trueOwner.lookupComponentByName("Spatial") as SimpleSpatialComponent).position );
			else return;
			emitter.addInitializer( new Position( _emitLocation ));
			
			// The particles die as soon as they become off-screen (dead zone)
			emitter.addAction( new DeathZone(ParticleManager.instance.sceneBoundaries, true) );
			_emitters.push(emitter);
		}
		
		/*
		 * Check whether an emitter is empty or whether its done emitting particles
		 * The emitters are then properly removed from the display list and unreferenced to be garbage collected
		 */
		private function destroyOwner(event:EmitterEvent):void {
			var emitter:Emitter2D = event.target as Emitter2D;
			
			switch (event.type) {
				case EmitterEvent.EMITTER_EMPTY:
					emitter.removeEventListener(EmitterEvent.EMITTER_EMPTY, destroyOwner);
					_emptyEmitters++;
					break;
				case EmitterEvent.COUNTER_COMPLETE:
					emitter.removeEventListener(EmitterEvent.COUNTER_COMPLETE, destroyOwner);
					_counterCompletedEmitters++;
					break;
				default:
					throw new Error();
			}
			
			// When one of the emitters is done emitting
			if (emitter.counter.complete && !emitter.particles.length) {
				ParticleManager.instance.removeEmitter(emitter);
			}
			
			// When all emitters are done emitting
			if (_emptyEmitters == _emitters.length && _counterCompletedEmitters == _emitters.length) {
				_emitters = new Vector.<Emitter2D>();
				trueOwner = null;
			}
		}
		
		/*
		 * Remove the particle for the factory once it dies
		 */
		private function removeParticle(event:ParticleEvent):void {
			Emitter2D.defaultParticleFactory.disposeParticle(event.particle);
		}
	}
}