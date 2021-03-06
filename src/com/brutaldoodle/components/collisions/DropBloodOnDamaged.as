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

package com.brutaldoodle.components.collisions
{
	import com.brutaldoodle.entities.Projectile;
	import com.brutaldoodle.rendering.BloodDropRenderer;
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.entity.EntityComponent;
	
	public class DropBloodOnDamaged extends EntityComponent
	{
		public function DropBloodOnDamaged() {
			super();
		}
		
		override protected function onAdd():void {
			super.onAdd();
			owner.eventDispatcher.addEventListener(HealthEvent.DAMAGED, onDamaged);
		}
		
		override protected function onRemove():void {
			super.onRemove();
			owner.eventDispatcher.removeEventListener(HealthEvent.DAMAGED, onDamaged);
		}
		
		/*
		 * Drop blood when the owner is damaged
		 */
		private function onDamaged (event:HealthEvent):void {
			// Shoot a projectile rendered by the BloodDropRenderer
			var p:Projectile = new Projectile(BloodDropRenderer, owner);
		}
	}
}