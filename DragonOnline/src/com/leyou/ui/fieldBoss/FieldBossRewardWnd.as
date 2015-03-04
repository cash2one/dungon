package com.leyou.ui.fieldBoss
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFieldBossInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.ui.market.child.MarketGrid;
	
	import flash.events.MouseEvent;
	
	public class FieldBossRewardWnd extends AutoWindow
	{
		private var descLbl:Label;
		
		private var accpetBtn:ImgButton;
		
		private var grid:MarketGrid;

		public function FieldBossRewardWnd(){
			super(LibManager.getInstance().getXML("config/ui/fieldBoss/dungeonSGFinish.xml"));
			init();
		}
		
		private function init():void{
			grid = new MarketGrid();
			grid.x = 103;
			grid.y = 88;
			addChild(grid);
			descLbl = getUIbyID("descLbl") as Label;
			accpetBtn = getUIbyID("accpetBtn") as ImgButton;
			accpetBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			descLbl.multiline = true;
			descLbl.wordWrap = true;
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			hide();
		}
		
		public function updateInfo(rank:int, bossId:int, damage:int):void{
			var bossInfo:TFieldBossInfo = TableManager.getInstance().getFieldBossInfo(bossId);
			var monsterInfo:TLivingInfo = TableManager.getInstance().getLivingInfo(bossInfo.monsterId);
			var bName:String = monsterInfo.name +"[lv"+monsterInfo.level+"]";
			var rewardId:int = bossInfo.getRewardByRank(rank);
			var item:TItemInfo = TableManager.getInstance().getItemInfo(rewardId);
			grid.updataById(rewardId);
			var content:String = TableManager.getInstance().getSystemNotice(5001).content;
			content = StringUtil.substitute(content, bName, damage, rank, bossInfo.getRewardCountByRank(rank), item.name);
			descLbl.text = content;
		}
	}
}