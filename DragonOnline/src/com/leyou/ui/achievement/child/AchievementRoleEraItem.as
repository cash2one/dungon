package com.leyou.ui.achievement.child
{
	import com.ace.enum.GameFileEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.table.TAchievementInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.achievement.AchievementTipInfo;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class AchievementRoleEraItem extends AutoSprite
	{
		private var iconImg:Image;
		
		private var nameLbl:Label;
		
		private var id:int;
		
		private var tipsInfo:AchievementTipInfo;
		
		public function AchievementRoleEraItem(){
			super(LibManager.getInstance().getXML("config/ui/achievement/achievementRoleEraItem.xml"));
			init();
		}
		
		private function init():void{
			mouseEnabled = true;
			tipsInfo = new AchievementTipInfo();
			iconImg = getUIbyID("iconImg") as Image;
			nameLbl = getUIbyID("nameLbl") as Label;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			tipsInfo.id = id;
			ToolTipManager.getInstance().show(TipEnum.TYPE_ACHIEVEMENT, tipsInfo, new Point(stage.mouseX, stage.mouseY));
		}
		
		public function update(tdata:TAchievementInfo):void{
			id = tdata.id;
			nameLbl.text = tdata.name;
			var url:String = GameFileEnum.URL_ITEM_ICO + tdata.ico;
			iconImg.updateBmp(url);
		}
	}
}