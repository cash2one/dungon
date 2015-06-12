package com.leyou.ui.pet.children
{
	import com.ace.config.Core;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.leyou.data.pet.PetData;
	import com.leyou.data.pet.PetEntryData;
	import com.leyou.enum.ConfigEnum;
	
	import flash.display.Sprite;
	
	public class PetSkillPage extends Sprite
	{
		private var skillList:Vector.<PetSkillItem>;
		
		public function PetSkillPage(){
			init();
		}
		
		private function init():void{
			skillList = new Vector.<PetSkillItem>(4);
			for(var n:int = 0; n < 4; n++){
				var skillItem:PetSkillItem = skillList[n];
				if(null == skillItem){
					skillItem = new PetSkillItem();
					skillList[n] = skillItem;
					addChild(skillItem);
					skillItem.y = 10 + 100*n;
				}
				skillItem.index = n;
			}
		}
		
		public function updateInfo(petTId:int):void{
			var data:PetData = DataManager.getInstance().petData;
			var petEntryData:PetEntryData = data.getPetById(petTId);
			if(null != petEntryData){
				var c:int = skillList.length;
				for(var m:int = 0; m < c; m++){
					skillList[m].petId = petTId;
					var skillItem:PetSkillItem = skillList[m];
					if(petEntryData.level >= skillItem.openLv()){
						skillItem.setStatus(1);
						skillItem.updateInfo(petEntryData.getSkill(m));
					}else{
						skillItem.setStatus(0);
					}
				}
			}
		}
	}
}