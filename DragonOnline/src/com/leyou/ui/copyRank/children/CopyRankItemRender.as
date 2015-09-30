package com.leyou.ui.copyRank.children
{
	import com.ace.game.scene.ui.child.TitleRender;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCopyInfo;
	import com.ace.gameData.table.TTitle;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.copyRank.children.CopyRankItemData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.utils.PlayerUtil;
	import com.leyou.utils.PropUtils;
	
	public class CopyRankItemRender extends AutoSprite
	{
		private var roleImg:Image;
		
		private var copyNameLbl:Label;
		
		private var playerNameLbl:Label;
		
		private var tickLbl:Label;
		
		private var timeLbl:Label;
		
		private var type:int;
		
		private var titleRender:TitleRender;
		
		public function CopyRankItemRender(){
			super(LibManager.getInstance().getXML("config/ui/copyRank/rank2Btn.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			roleImg = getUIbyID("roleImg") as Image;
			copyNameLbl = getUIbyID("copyNameLbl") as Label;
			playerNameLbl = getUIbyID("playerNameLbl") as Label;
			tickLbl = getUIbyID("tickLbl") as Label;
			timeLbl = getUIbyID("timeLbl") as Label;
			
			titleRender = new TitleRender();
			addChild(titleRender);
			titleRender.x = 413;
			titleRender.y = 14;
		}
		
		public function updateTInfo(tcopyInfo:TCopyInfo):void{
			copyNameLbl.text = StringUtil.substitute(PropUtils.getStringById(2207), tcopyInfo.name);
			playerNameLbl.x = copyNameLbl.x + copyNameLbl.width + 5;
			playerNameLbl.text = TableManager.getInstance().getSystemNotice(10095).content;
			tickLbl.text = "";
			timeLbl.text = "";
			roleImg.updateBmp("ui/history/his_none.png");
			var tid:int = 0;
			switch(tcopyInfo.type){
				case 1:
					tid = ConfigEnum.FastTop2;
					break;
				case 2:
					tid = ConfigEnum.FastTop3;
					break;
				case 12:
					tid = ConfigEnum.FastTop4;
					break;
			}
			var titleInfo:TTitle = TableManager.getInstance().getTitleByID(tid);
			titleRender.updateInfo(titleInfo);
		}
		
		public function updateDInfo(itemData:CopyRankItemData):void{
			roleImg.updateBmp(PlayerUtil.getPlayerFullHeadImg(itemData.vocation, itemData.gender));
			playerNameLbl.text = itemData.name;
			tickLbl.text = itemData.date;
			timeLbl.text = itemData.time+PropUtils.getStringById(2146);
		}
	}
}