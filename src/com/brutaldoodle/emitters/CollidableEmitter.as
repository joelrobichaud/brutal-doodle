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

package com.brutaldoodle.emitters
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.events.CollisionEvent;
	
	import flash.utils.getQualifiedSuperclassName;
	
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.twoD.actions.CollisionZone;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.zones.Zone2D;
	
	public class CollidableEmitter extends Emitter2D
	{
		/*
		 * Constants used in order to easily identify action types
		 */
		public static const DEAL_DAMAGE:String = "dealDamage";
		public static const UPDATE_MONEY_COUNT:String = "updateMoneyCount";
		
		/*
		 * The amount of damage dealt by each particle
		 */
		protected var _damageAmount:Number;
		
		/*
		 * The action that is performed when a collision occurs
		 */
		protected var _actionOnCollision:String;
		
		public function CollidableEmitter() {
			super();
			
			// The default damage dealt by collidable emitters
			_damageAmount = 100;
			// The default action performed on collision (deal damage)
			_actionOnCollision = CollidableEmitter.DEAL_DAMAGE;
			
			// The name of the unit type is retrieved from the child classe's name
			var unitName:String = getQualifiedSuperclassName(this).replace(/.*::(.*)CollidableEmitter/, "$1").toLowerCase();
			var units:Vector.<Zone2D> = CollisionManager.instance.getCollidableObjectsByType(unitName);
			
			// All the units that the emitter need to check collisions with are added as collidable zones
			for (var i:int = 0; i < units.length; ++i) {
				if (units[i] != null) {
					addAction( new CollisionZone(units[i], 0) );
				}	
			}
			
			addEventListener(ParticleEvent.ZONE_COLLISION, onCollide);
		}
		
		/*
		 * To be overriden...
		 * The particle is removed on collision and the collisionOccured event is dispatched via the CollisionManager
		 */
		protected function onCollide (event:ParticleEvent):void {
			CollisionManager.instance.dispatchEvent(new CollisionEvent(CollisionEvent.COLLISION_OCCURED, event.otherObject));
			event.particle.isDead = true;
		}
		
		public function get damageAmount ():Number { return _damageAmount; }
		public function set damageAmount (value:Number):void { _damageAmount = value; }
	}
}