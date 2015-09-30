package com.leyou.data.pet
{
	public class PetData
	{
		private var petList:Vector.<PetEntryData> = new Vector.<PetEntryData>();
		
		private var petShortcutList:Vector.<PetEntryData> = new Vector.<PetEntryData>();
		
		// 升级任务
		public var lvTaskId:int;
		
		// 0--未完成 1--未完成 -1--可领取
		public var lvTaskStatus:int;
		
		public var lvPogress:int;
		
		public var lvPetId:int;
		
		// 亲密度任务
		public var qmdTaskId:int;
		
		// 0--未完成 1--未完成 -1--可领取
		public var qmdTaskStatus:int;
		
		public var qmdPogress:int;
		
		public var qmdPetId:int;
		
		public var currentPetId:int;
		
		public function PetData(){
		}
		
		public function get petListCount():int{
			return petList.length;
		}
		
		public function getShortcutlistCount():int{
			return petShortcutList.length;
		}
		
		public function loadData_L(obj:Object):void{
			var pl:Array = obj.petlist;
			var length:int = pl.length;
			var gfList:Array = obj.gift_f;
//			petList.length = length;
			for(var n:int = 0; n < length; n++){
				var petEntryData:PetEntryData = getPetById(pl[n][0]);
				if(null == petEntryData){
					petEntryData = new PetEntryData();
					petList.push(petEntryData);
				}
				petEntryData.unserialize_L(pl[n]);
				petEntryData.qmGiftReceived = (-1 != gfList.indexOf(petEntryData.id));
			}
		}
		
		public function loadData_I(obj:Object):void{
			var petInfo:Array = obj.petinfo;
			if(null == petInfo){
				return;
			}
			var petSl:Array = obj.pskl;
			var petEntry:PetEntryData = getPetById(petInfo[0]);
			petEntry.unserialize_I(petInfo, petSl);
			petEntry = getShortcutPetById(petInfo[0]);
			if(null == petEntry) return;
			petEntry.unserialize_I(petInfo, petSl);
		}
		
		private function getShortcutPetById(id:int):PetEntryData{
			for each(var petEntry:PetEntryData in petShortcutList){
				if((null != petEntry) && (petEntry.id == id)){
					return petEntry;
				}
			}
			return null;
		}
		
		public function loadData_T(obj:Object):void{
			var expT:Array = obj.exp_t;
			var qmdT:Array = obj.qmd_t;
			lvTaskId = expT[0];
			lvTaskStatus = expT[1];
			lvPogress = expT[2];
			lvPetId = expT[3];
			
			qmdTaskId = qmdT[0];
			qmdTaskStatus = qmdT[1];
			qmdPogress = qmdT[2];
			qmdPetId = qmdT[3];
			
			var expf:Array = obj.exp_f;
			var qmdf:Array = obj.qmd_f;
			var length:int = petList.length;
			for(var n:int = 0; n < length; n++){
				var petEntryData:PetEntryData = petList[n];
				if(null == petEntryData){
					continue;
				}
				petEntryData.lvMissionComplete = (expf.indexOf(petEntryData.id) > -1);
				petEntryData.qmMissionComplete = (qmdf.indexOf(petEntryData.id) > -1);
			}
		}
		
		public function getPetByIdx(index:int):PetEntryData{
			if(index < petList.length){
				return petList[index];
			}
			return null;
		}
		
		public function containsPet(id:int):Boolean{
			for each(var petEntry:PetEntryData in petList){
				if((null != petEntry) && (petEntry.id == id)){
					return true;
				}
			}
			return false;
		}
		
		public function getPetById(id:int):PetEntryData{
			for each(var petEntry:PetEntryData in petList){
				if((null != petEntry) && (petEntry.id == id)){
					return petEntry;
				}
			}
			return null;
		}
		
		public function getShortcutPet(index:int):PetEntryData{
			return petShortcutList[index];
		}
		
		public function loadData_K(obj:Object):void{
			var pl:Array = obj.klist;
			var length:int = pl.length;
			petShortcutList.length = length;
			for(var n:int = 0; n < length; n++){
				var petEntryData:PetEntryData = petShortcutList[n];
				if(null == petEntryData){
					petEntryData = new PetEntryData();
					petShortcutList[n] = petEntryData;
				}
				petEntryData.unserialize_I(pl[n]);
				if((0 != petEntryData.id) && !containsPet(petEntryData.id)){
					var pn:PetEntryData = new PetEntryData();
					pn.unserialize_I(pl[n]);
					petList.push(pn);
				}
			}
		}
	}
}