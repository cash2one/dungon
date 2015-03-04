package com.leyou.ui.achievement.child
{
	import com.ace.enum.FilterEnum;
	import com.ace.enum.GameFileEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TAchievementInfo;
	import com.ace.gameData.table.TTitle;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.achievement.AchievementEraData;
	import com.leyou.data.achievement.AchievementRoleProgressData;
	
	public class AchievementEraItem extends AutoSprite
	{
		private var iconImg:Image;
		
		private var achievementLbl:Label;
		
		private var nameLbl:Label;
		
		private var dateLbl:Label;
		
		private var requirementLbl:Label;
		
		private var moneyLbl:Label;
		
		private var energyLbl:Label;
		
		private var ybLbl:Label;
		
		private var titleLbl:Label;
		
		private var unfinishImg:Image;
		
		private var _tid:int;
		
		private var progressBgImg:Image;
		
		private var progressImg:Image;
		
		private var progressLbl:Label;
		
		public function AchievementEraItem(){
			super(LibManager.getInstance().getXML("config/ui/achievement/achievementEraItem.xml"));
			init();
		}
		
		public function get tid():int{
			return _tid;
		}

		private function init():void{
			iconImg = getUIbyID("iconImg") as Image;
			achievementLbl = getUIbyID("achievementLbl") as Label;
			nameLbl = getUIbyID("nameLbl") as Label;
			dateLbl = getUIbyID("dateLbl") as Label;
			requirementLbl = getUIbyID("requirementLbl") as Label;
			moneyLbl = getUIbyID("moneyLbl") as Label;
			energyLbl = getUIbyID("energyLbl") as Label;
			ybLbl = getUIbyID("ybLbl") as Label;
			unfinishImg = getUIbyID("unfinishedImg") as Image;
			titleLbl = getUIbyID("titleLbl") as Label;
			progressLbl = getUIbyID("progressLbl") as Label;
			progressImg = getUIbyID("progressImg") as Image;
			progressBgImg = getUIbyID("progressBgImg") as Image;
		}
		
		public function update(info:TAchievementInfo):void{
			var title:TTitle = TableManager.getInstance().getTitleByID(info.titleId);
			_tid = info.id;
			achievementLbl.text = info.name;
			requirementLbl.text = info.des;
			moneyLbl.text = info.money+"";
			energyLbl.text = info.energy+"";
			ybLbl.text = info.boundIB+"";
			titleLbl.text = title.name;
			var url:String = GameFileEnum.URL_ITEM_ICO + info.ico;
			iconImg.updateBmp(url);
//			unfinishImg.visible = true;
//			nameLbl.visible = false;
//			dateLbl.visible = false;
//			progressLbl.visible = false;
//			progressImg.visible = false;
//			progressBgImg.visible = false;
			filters = [FilterEnum.enable];
		}
		
		public function updateByData(data:AchievementEraData):void{
			filters = null;
			nameLbl.visible = true;
			dateLbl.visible = true;
			unfinishImg.visible = false;
			nameLbl.text = data.name;
			dateLbl.text = data.date;
			progressLbl.visible = false;
			progressImg.visible = false;
			progressBgImg.visible = false;
		}
		
//		public function reset():void{
//			nameLbl.visible = false;
//			dateLbl.visible = false;
//			unfinishImg.visible = true;
//			filters = [FilterEnum.enable];
//		}
		
		public function resetProgress():void{
			unfinishImg.visible = true;
			nameLbl.visible = false;
			dateLbl.visible = false;
			progressLbl.visible = false;
			progressImg.visible = false;
			progressBgImg.visible = false;
		}
		
		public function updateProgress(mData:AchievementRoleProgressData):void{
			nameLbl.visible = false;
			dateLbl.visible = false;
			unfinishImg.visible = false;
			progressLbl.visible = true;
			progressImg.visible = true;
			progressBgImg.visible = true;
			filters = [FilterEnum.enable];
			var tinfo:TAchievementInfo = TableManager.getInstance().getAchievementInfo(mData.id);
			if((9 == tinfo.type) || (10 == tinfo.type)){
				progressLbl.text = "您的达成进度：" + mData.value + "/" + 14;
				progressImg.scaleX = mData.value/14;
			}else if(7 == tinfo.type){
				progressLbl.text = "您的达成进度：" + mData.value + "/" + 5;
				progressImg.scaleX = mData.value/5;
			}else{
				progressLbl.text = "您的达成进度：" + mData.value + "/" + tinfo.threshold;
				progressImg.scaleX = mData.value/tinfo.threshold;
			}
		}
		
		public function updateForRank(info:TAchievementInfo):void{
			var title:TTitle = TableManager.getInstance().getTitleByID(info.titleId);
			_tid = info.id;
			achievementLbl.text = info.name;
			requirementLbl.text = info.des;
			moneyLbl.text = info.money+"";
			energyLbl.text = info.energy+"";
			ybLbl.text = info.boundIB+"";
			titleLbl.text = title.name;
			var url:String = GameFileEnum.URL_ITEM_ICO + info.ico;
			iconImg.updateBmp(url);
			nameLbl.visible = false;
			dateLbl.visible = false;
			unfinishImg.visible = true;
			progressImg.visible = false;
			progressBgImg.visible = false;
			progressLbl.visible = false;
		}
		
		public function hideName():void{
			nameLbl.visible = false;
			dateLbl.visible = false;
		}
	}
}