package com.brutaldoodle.components.collisions
{
	import com.pblabs.components.basic.HealthComponent;
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.GroupManagerComponent;
	import com.pblabs.engine.core.LevelEvent;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.engine.core.PBGroup;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.mxml.GroupReference;
	
	import flash.events.Event;
	
	public class RemoveHeartOnDeath extends EntityComponent
	{
		private var _hearts:Vector.<IEntity>;
		
		public function RemoveHeartOnDeath()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			_hearts = new Vector.<IEntity>;
			PBE.levelManager.addEventListener(LevelEvent.LEVEL_LOADED_EVENT, registerHearts);
			owner.eventDispatcher.addEventListener(HealthEvent.DIED, removeHeart);
		}
		
		private function registerHearts(event:LevelEvent):void
		{
			var heart:IEntity, i:int = 1;
			
			while (heart = PBE.lookup("Heart"+i) as IEntity) {
				_hearts.push(heart);
				i++;
			}
		}
		
		override protected function onRemove():void
		{
			super.onRemove();
			owner.eventDispatcher.removeEventListener(HealthEvent.DIED, removeHeart);
		}
		
		private function removeHeart (event:HealthEvent):void {
			var length:int = _hearts.length
			if(length){
				_hearts[length-1].destroy();
				_hearts.pop();
				var healthComponent:HealthComponent = owner.lookupComponentByName("Health") as HealthComponent;
				healthComponent.health = healthComponent.maxHealth;
				Logger.print(this, String(healthComponent.isDead));
				//healthComponent.
			}
			
		}
	}
}