package com.leyou.ui.achievement.child
{
	import com.ace.enum.PlayerEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TAchievementInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.achievement.AchieveRoleData;
	
	public class AchievementRoleItem extends AutoSprite
	{
		private var finishLbl:Label;
		
		private var nameLbl:Label;
		
		private var headImg:Image;
		
		private var lineImg:Image;
		
		private var eraItems:Vector.<AchievementRoleEraItem>;
		
		public function AchievementRoleItem(){
			super(LibManager.getInstance().getXML("config/ui/achievement/achievementRoleItem.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			finishLbl = getUIbyID("finishLbl") as Label;
			nameLbl = getUIbyID("nameLbl") as Label;
			headImg = getUIbyID("headImg") as Image;
			lineImg = getUIbyID("lineImg") as Image;
			eraItems = new Vector.<AchievementRoleEraItem>();
		}
		
		public function update(data:AchieveRoleData):void{
			finishLbl.text = data.finishCount+"";
			nameLbl.text = data.name;
			var url:String = getUrl(data.pro, data.sex);
			headImg.updateBmp(url);
			var eraArr:Array = data.finishArr;
			var count:int = eraArr.length;
			if(count >　eraItems.length){
				eraItems.length = count;
			}
			var item:AchievementRoleEraItem;
			for(var n:int = 0; n < count; n++){
				var tdata:TAchievementInfo = TableManager.getInstance().getAchievementInfo(eraArr[n]);
				item = eraItems[n];
				if(null == item){
					item = new AchievementRoleEraItem();
					eraItems[n] = item;
				}
				item.update(tdata);
				if(!contains(item)){
					addChild(item);
				}
				item.y = 96 + int(n/2) * (38 + 2);
				if(0 == (n&1)){
					item.x = 61;
				}else{
					item.x = 286;
				}
			}
			if(null != item){
				lineImg.y = item.y + item.height + 8;
			}
			var l:int = eraItems.length;
			for(var m:int = count; m < l; m++){
				var vitem:AchievementRoleEraItem = eraItems[m];
				if(null != vitem && contains(vitem)){
					removeChild(vitem);
				}
			}
		}
		
		private function getUrl(pro:int, sex:int):String{
			if(0 == sex){
				switch(pro){
					case PlayerEnum.PRO_MASTER:
						return "ui/history/his_fs_m.png";
					case PlayerEnum.PRO_RANGER:
						return "ui/history/his_yx_m.png";
					case PlayerEnum.PRO_SOLDIER:
						return "ui/history/his_zs_m.png";
					case PlayerEnum.PRO_WARLOCK:
						return "ui/history/his_ss_m.png";
				}
			}else{
				switch(pro){
					case PlayerEnum.PRO_MASTER:
						return "ui/history/his_fs_f.png";
					case PlayerEnum.PRO_RANGER:
						return "ui/history/his_yx_f.png";
					case PlayerEnum.PRO_SOLDIER:
						return "ui/history/his_zs_f.png";
					case PlayerEnum.PRO_WARLOCK:
						return "ui/history/his_ss_f.png";
				}
			}
			return null;
		}
	}
}