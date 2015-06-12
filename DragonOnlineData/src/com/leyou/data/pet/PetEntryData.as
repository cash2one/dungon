package com.leyou.data.pet
{
	import com.ace.gameData.manager.TableManager;

	public class PetEntryData
	{
		private var _isInit:Boolean = false;
		
		public var id:int;
		
		public var level:int;
		
		public var starLv:int;
		
		// 0 -- 休息 1-- 出战
		public var status:int;
		
		public var exp:int;
		
		public var qmd:int;
		
		public var qmdLv:int;
		
		// 剩余召唤时间
		public var callt:int;
		
		public var petSkillList:Vector.<Array> = new Vector.<Array>();
		
		public function PetEntryData(){
		}
		
		public function get isInit():Boolean{
			return _isInit;
		}

		public function unserialize_L(data:Array):void{
			id = data[0];
			level = data[1];
			starLv = data[2];
			status = data[3];
			qmdLv = data[4];
		}
		
		public function unserialize_I(petInfo:Array, petSl:Array):void{
			_isInit = true;
			id = petInfo[0];
			level = petInfo[1];
			starLv = petInfo[2];
			status = petInfo[3];
			exp = petInfo[4];
			qmd = petInfo[5];
			qmdLv = petInfo[6];
			callt = petInfo[7];
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
	}
}