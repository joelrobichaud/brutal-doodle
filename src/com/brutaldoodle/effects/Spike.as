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

package com.brutaldoodle.effects
{
	import com.brutaldoodle.emitters.EnemyCollidableEmitter;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.resource.ImageResource;
	
	import flash.geom.Point;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.initializers.CollisionRadiusInit;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.PointZone;
	
	/*
	 * Contain the definition of the look and behavior of the Spike particle emitter
	 * The particles emitted are to collide with any "enemy" bounding box registered within the CollisionManager
	 */
	public class Spike extends EnemyCollidableEmitter
	{
		public function Spike()
		{
			super();
			
			// The amount of damage dealt by each particle emitted
			_damageAmount = 1;
			
			// One particle is instantly emitted
			counter = new Blast(1);
			
			// The direction in which the particle will move (either left or right)
			var direction:int = Math.floor(Math.random() * 2) ? 1 : -1;
			
			// Particle's Appearance
			var spike:ImageResource = PBE.resourceManager.load("../assets/Images/Spike.png", ImageResource) as ImageResource;
			addInitializer( new SharedImage( spike.image ) );
			addInitializer( new Position( new PointZone( new Point(direction * 30, 0) ) ) );
			
			// Particle's Behavior
			addInitializer( new Velocity( new PointZone( new Point(direction * 10, 0) ) ) );
			addInitializer( new CollisionRadiusInit(0.01) );
			addAction( new Move() );
		}
	}
}