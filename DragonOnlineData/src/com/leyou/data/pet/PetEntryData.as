package com.leyou.data.pet
{
	import com.ace.manager.EventManager;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	
	import flash.utils.getTimer;

	public class PetEntryData
	{
		private var _isInit:Boolean = false;
		
		public var id:int;
		
		public var level:int = -1;
		
		public var starLv:int = -1;
		
		public var lvMissionComplete:Boolean;
		
		public var qmMissionComplete:Boolean;
		
		public var qmGiftReceived:Boolean;
		
		// 0 -- 休息 1-- 出战
		public var status:int;
		
		public var exp:int;
		
		public var qmd:int;
		
		public var qmdLv:int = -1;
		
		// 剩余召唤时间
		private var _callt:int;
		
		private var _tick:int;
		
//		 [id, level]
		public var petSkillList:Vector.<Array> = new Vector.<Array>();
		
		public function PetEntryData(){
		}
		
		public function get callt():int{
			var t:int = (_callt - (getTimer() - _tick)/1000);
			if(t < 0){
				t = 0;
			}
			return t;
		}
		
		public function get canGetGift():Boolean{
			return (qmdLv >= ConfigEnum.servent34);
		}

//		public function get isInit():Boolean{
//			return false;
//		}

		public function unserialize_L(data:Array):void{
			id = data[0];
			var tmpLV:int = data[1];
			var tmpSL:int = data[2];
			status = data[3];
			var tmpQmdLv:int = data[4];
			if((-1 != level) && (level != tmpLV)){
				EventManager.getInstance().dispatchEvent("petLvUp", id);
			}
			level = tmpLV;
			if((-1 != starLv) && (starLv != tmpSL)){
				EventManager.getInstance().dispatchEvent("petStarLvUp", id);
			}
			starLv = tmpSL;
			if((-1 != qmdLv) && (qmdLv != tmpQmdLv)){
				EventManager.getInstance().dispatchEvent("petQmLvUp", id);
			}
			qmdLv = tmpQmdLv;
		}
		
		private var count:int;
		
		public function unserialize_I(petInfo:Array, petSl:Array=null):void{
			if(petInfo.length <= 0){
				return;
			}
			_tick = getTimer();
			_isInit = true;
			id = petInfo[0];
			var tmpLV:int = petInfo[1];
			var tmpSL:int = petInfo[2];
			status = petInfo[3];
			exp = petInfo[4];
			qmd = petInfo[5];
			var tmpQmdLv:int = petInfo[6];
			if((-1 != level) && (level != tmpLV)){
				EventManager.getInstance().dispatchEvent("petLvUp", id);
			}
			level = tmpLV;
			if((-1 != starLv) && (starLv != tmpSL)){
				EventManager.getInstance().dispatchEvent("petStarLvUp", id);
			}
			starLv = tmpSL;
			if((-1 != qmdLv) && (qmdLv != tmpQmdLv)){
				EventManager.getInstance().dispatchEvent("petQmLvUp", id);
			}
			qmdLv = tmpQmdLv;
			if(null == petSl) return;
			var l:int = petSl.length;
			petSkillList.length = l;
			for(var n:int = 0; n < l; n++){
					petSkillList[n] = petSl[n].concat();
			}
		}
		
		public function get skillLength():int{
			return petSkillList.length;
		}
		
		public function getSkill(index:int):Array{
			if(index < petSkillList.length){
				return petSkillList[index];
			}
			return null;
		}
		
		public function containsSID(sid:int):Boolean{
			for each(var arr:Array in petSkillList){
				if(int(arr[0]) == sid){
					return true;
				}
			}
			return false;
		}
	}
}