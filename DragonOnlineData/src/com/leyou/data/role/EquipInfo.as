package com.leyou.data.role {
	import com.ace.gameData.table.TEquipInfo;
	import com.leyou.data.tips.TipsInfo;
	

	public class EquipInfo extends ProperInfo {
		
		public function EquipInfo() {
			
		}
		
		/**
		 *id 
		 */		
		public var id:int;
		
		public var position:int=-1;
		
		/**
		 *强化等级 
		 */		
		public var strengthLv:int;
		
		/**
		 *是否绑定 
		 */		
		public var bind:int;
		
		public var info:TEquipInfo;
		
		public var tips:TipsInfo;
		
		public function strengthZdl(lv:int):uint{
			return tips.strengthZdl(lv);
		}
		
		
		
		
	}
}