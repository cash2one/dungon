package com.leyou.ui.guildBattle
{
	import com.ace.enum.ItemEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TGuildBattleInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.guildBattle.GuildBattleResultData;
	import com.leyou.ui.mail.child.MaillGrid;
	
	import flash.events.MouseEvent;
	
	public class GuildBattleMessageWnd extends AutoWindow
	{
		private var ryLbl:Label;
		
		private var expLbl:Label;
		
		private var energyLbl:Label;
		
		private var memRankLbl:Label;
		
		private var guildRankLbl:Label;
		
		private var gmRankLbl:Label;
		
		private var memRLbl:Label;
		
		private var guildRLbl:Label;
		
		private var gmRLbl:Label;
		
		private var receiveBtn:NormalButton;
//		
//		private var memGrid1Img:Image;
//		
//		private var memGrid2Img:Image;
//		
//		private var memGrid3Img:Image;
//		
//		private var memGrid4Img:Image;
		
		private var gridImgs1:Vector.<Image>;
		
		private var grids1:Vector.<MaillGrid>;
		
//		private var guildGrid1Img:Image;
//		
//		private var guildGrid2Img:Image;
//		
//		private var guildGrid3Img:Image;
//		
//		private var guildGrid4Img:Image;
		
		private var gridImgs2:Vector.<Image>;
		
		private var grids2:Vector.<MaillGrid>;
		
//		private var gmGrid1Img:Image;
//		
//		private var gmGrid2Img:Image;
//		
//		private var gmGrid3Img:Image;
//		
//		private var gmGrid4Img:Image;
		
		private var gridImgs3:Vector.<Image>;
		
		private var grids3:Vector.<MaillGrid>;
		
		public function GuildBattleMessageWnd(){
			super(LibManager.getInstance().getXML("config/ui/guildBattle/warGuildMegWnd.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
			clsBtn.visible = false;
			ryLbl = getUIbyID("ryLbl") as Label;
			expLbl = getUIbyID("expLbl") as Label;
			energyLbl = getUIbyID("energyLbl") as Label;
			memRankLbl = getUIbyID("memRankLbl") as Label;
			guildRankLbl = getUIbyID("guildRankLbl") as Label;
			gmRankLbl = getUIbyID("gmRankLbl") as Label;
			memRLbl = getUIbyID("memRLbl") as Label;
			guildRLbl = getUIbyID("guildRLbl") as Label;
			gmRLbl = getUIbyID("gmRLbl") as Label;
			receiveBtn = getUIbyID("receiveBtn") as NormalButton;
//			memGrid1Img = getUIbyID("memGrid1Img") as Image;
//			memGrid2Img = getUIbyID("memGrid2Img") as Image;
//			memGrid3Img = getUIbyID("memGrid3Img") as Image;
//			memGrid4Img = getUIbyID("memGrid4Img") as Image;
			gridImgs1 = new Vector.<Image>();
			gridImgs1.push(getUIbyID("memGrid1Img"));
			gridImgs1.push(getUIbyID("memGrid2Img"));
			gridImgs1.push(getUIbyID("memGrid3Img"));
			gridImgs1.push(getUIbyID("memGrid4Img"));
			var length:int = gridImgs1.length;
			grids1 = new Vector.<MaillGrid>(length);
			for(var i:int = 0; i < length; i++){
				var g1:MaillGrid = new MaillGrid();
				grids1[i] = g1;
				g1.x = gridImgs1[i].x;
				g1.y = gridImgs1[i].y;
				pane.addChild(g1);
			}
//			guildGrid1Img = getUIbyID("memGrid1Img") as Image;
//			guildGrid2Img = getUIbyID("memGrid2Img") as Image;
//			guildGrid3Img = getUIbyID("memGrid3Img") as Image;
//			guildGrid4Img = getUIbyID("memGrid4Img") as Image;
			gridImgs2 = new Vector.<Image>();
			gridImgs2.push(getUIbyID("guildGrid1Img"));
			gridImgs2.push(getUIbyID("guildGrid2Img"));
			gridImgs2.push(getUIbyID("guildGrid3Img"));
			gridImgs2.push(getUIbyID("guildGrid4Img"));
			length = gridImgs2.length;
			grids2 = new Vector.<MaillGrid>(length);
			for(var m:int = 0; m < length; m++){
				var g2:MaillGrid = new MaillGrid();
				grids2[m] = g2;
				g2.x = gridImgs2[m].x;
				g2.y = gridImgs2[m].y;
				pane.addChild(g2);
			}
//			gmGrid1Img = getUIbyID("gmGrid1Img") as Image;
//			gmGrid2Img = getUIbyID("gmGrid2Img") as Image;
//			gmGrid3Img = getUIbyID("gmGrid3Img") as Image;
//			gmGrid4Img = getUIbyID("gmGrid4Img") as Image;
			gridImgs3 = new Vector.<Image>();
			gridImgs3.push(getUIbyID("gmGrid1Img"));
			gridImgs3.push(getUIbyID("gmGrid2Img"));
			gridImgs3.push(getUIbyID("gmGrid3Img"));
			gridImgs3.push(getUIbyID("gmGrid4Img"));
			length = gridImgs3.length;
			grids3 = new Vector.<MaillGrid>(length);
			for(var n:int = 0; n < length; n++){
				var g3:MaillGrid = new MaillGrid();
				grids3[n] = g3;
				g3.x = gridImgs3[n].x;
				g3.y = gridImgs3[n].y;
				pane.addChild(g3);
			}
//			updateInfo();
			receiveBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			hide();
			UILayoutManager.getInstance().show(WindowEnum.MAILL);
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, UIEnum.WND_LAYER_TOP, toCenter);
		}
		
		public override function get width():Number{
			return 530;
		}
		
		public override function get height():Number{
			return 310;
		}
		
		public function fillGirds(info:TGuildBattleInfo, type:int):void{
			var cImgs:Vector.<Image>;
			var cgrids:Vector.<MaillGrid>;
			switch(type){
				case 1:
					cgrids = grids1;
					cImgs = gridImgs1;
					break;
				case 2:
					cgrids = grids2;
					cImgs = gridImgs2;
					break;
				case 3:
					cgrids = grids3;
					cImgs = gridImgs3;
					break;
			}
			var index:int = 0;
			var grid:MaillGrid;
			index = 0;
			if(info.exp > 0){
				grid = cgrids[index];
				grid.updateInfo(ItemEnum.EXP_VIR_ITEM_ID, info.exp);
				grid.visible = true;
				index++;
			}
			if(info.money > 0){
				grid = cgrids[index];
				grid.updateInfo(ItemEnum.MONEY_VIR_ITEM_ID, info.money);
				grid.visible = true;
				index++;
			}
			if(info.energy > 0){
				grid = cgrids[index];
				grid.updateInfo(ItemEnum.ENERGY_VIR_ITEM_ID, info.energy);
				grid.visible = true;
				index++;
			}
			if(info.byb > 0){
				grid = cgrids[index];
				grid.updateInfo(ItemEnum.BYB_VIR_ITEM_ID, info.byb);
				grid.visible = true;
				index++;
			}
			if(info.bg > 0){
				grid = cgrids[index];
				grid.updateInfo(ItemEnum.BG_VIR_ITEM_ID, info.bg);
				grid.visible = true;
				index++;
			}
			if(info.item1 > 0){
				grid = cgrids[index];
				grid.updateInfo(info.item1, info.item1Count);
				grid.visible = true;
				index++;
			}
			if(info.item2 > 0){
				grid = cgrids[index];
				grid.updateInfo(info.item2, info.item2Count);
				grid.visible = true;
				index++;
			}
			if(info.item3 > 0){
				grid = cgrids[index];
				grid.updateInfo(info.item3, info.item3Count);
				grid.visible = true;
				index++;
			}
			if(info.item4 > 0){
				grid = cgrids[index];
				grid.updateInfo(info.item4, info.item4Count);
				grid.visible = true;
				index++;
			}
			for(var n:int = 0; n < index; n++){
				cImgs[n].visible = cgrids[n].visible;
			}
		}
		
		private function hideGrids(type:int):void{
			var cImgs:Vector.<Image>;
			var cgrids:Vector.<MaillGrid>;
			switch(type){
				case 1:
					cgrids = grids1;
					cImgs = gridImgs1;
					break;
				case 2:
					cgrids = grids2;
					cImgs = gridImgs2;
					break;
				case 3:
					cgrids = grids3;
					cImgs = gridImgs3;
					break;
			}
			for each(var g:MaillGrid in cgrids){
				g.visible = false;
			}
			for each(var img:Image in cImgs){
				img.visible = false;
			}
		}
		
		public function updateInfo():void{
			var data:GuildBattleResultData = DataManager.getInstance().guildBattleData.resultData;
			expLbl.text = data.exp+"";
			ryLbl.text = data.honour+"";
			energyLbl.text = data.energy+"";
			memRankLbl.text = data.memRank+"";
			guildRankLbl.text = data.guildRank+"";
			gmRankLbl.text = data.guildMemRank+"";
			
			// 个人
			var prInfo:TGuildBattleInfo = TableManager.getInstance().getGuildBattleInfo(1+"|"+data.memRank);
			hideGrids(1);
			memRLbl.visible = (null == prInfo);
			if(null != prInfo){
				fillGirds(prInfo, 1);
			}
			
			// 行会
			var rate:int = DataManager.getInstance().guildBattleData.getRankAdd(data.guildRank);
			hideGrids(2);
			var addHonour:int = data.honour*rate/100;
			guildRLbl.visible = (0 >= addHonour);
			if(0 < addHonour){
				grids2[0].updateInfo(ItemEnum.HONOUR_VIR_ITEM_ID, addHonour);
				grids2[0].visible = true;
				gridImgs2[0].visible = true;
			}
			
			// 行会内排名
			var gmrInfo:TGuildBattleInfo = TableManager.getInstance().getGuildBattleInfo(2+"|"+data.guildMemRank);
			hideGrids(3);
			gmRLbl.visible = (null == gmrInfo);
			if(null != gmrInfo){
				fillGirds(gmrInfo, 3);
			}
		}
	}
}