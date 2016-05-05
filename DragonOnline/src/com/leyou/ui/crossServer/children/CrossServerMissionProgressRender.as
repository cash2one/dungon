package com.leyou.ui.crossServer.children
{
	import com.ace.config.Core;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCSLvInfo;
	import com.ace.gameData.table.TCSMissionInfo;
	import com.ace.gameData.table.TCSPlayerRankInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.crossServer.CrossServerData;
	import com.leyou.net.cmd.Cmd_Across;
	import com.leyou.ui.mail.child.MaillGrid;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class CrossServerMissionProgressRender extends AutoSprite
	{
		private var titleNameLbl:Label;
		
		private var progressLbl:Label;
		
		private var ruleLbl:Label;
		
		private var timeLbl:Label;
		
		private var targetLbl:Label;
		
		private var getBtn:NormalButton;
		
		private var rankLbl:Label;
		
		private var rewardBtn:ImgButton;
		
		private var rankBtn:ImgButton;
		
		private var grids:Vector.<MarketGrid>;
		
		private var myProgressLbl:Label;
		
		private var rankGrids:Vector.<MaillGrid>;
		
		private var noneLbl:Label;
		
		public function CrossServerMissionProgressRender(){
			super(LibManager.getInstance().getXML("config/ui/crossServer/kfdtMissionRender2.xml"));
			init();
		}
		
		private function init():void{
			mouseEnabled = true;
			mouseChildren =  true;
			titleNameLbl = getUIbyID("titleNameLbl") as Label;
			progressLbl = getUIbyID("progressLbl") as Label;
			ruleLbl = getUIbyID("ruleLbl") as Label;
			timeLbl = getUIbyID("timeLbl") as Label;
			targetLbl = getUIbyID("targetLbl") as Label;
			getBtn = getUIbyID("getBtn") as NormalButton;
			rankLbl = getUIbyID("rankLbl") as Label;
			rewardBtn = getUIbyID("rewardBtn") as ImgButton;
			rankBtn = getUIbyID("rankBtn") as ImgButton;
			myProgressLbl = getUIbyID("myProgressLbl") as Label;
			noneLbl = getUIbyID("noneLbl") as Label;
			
			rankBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			rewardBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			getBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			
			grids = new Vector.<MarketGrid>();
			for(var n:int = 0; n < 5; n++){
				var grid:MarketGrid = new MarketGrid();
				grid.x = 211 + n*80;
				grid.y = 178;
				addChild(grid);
				grids.push(grid);
			}
			
			rankGrids = new Vector.<MaillGrid>();
			for(var m:int = 0; m < 5; m++){
				var g:MaillGrid = new MaillGrid();
				g.x = 282 + m*48;
				g.y = 318;
				addChild(g);
				rankGrids.push(g);
			}
			
			ruleLbl.mouseEnabled = true;
			ruleLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			var content:String;
			switch(event.target.name){
				case "ruleLbl":
					content = TableManager.getInstance().getSystemNotice(11001).content;
					break;
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY))
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "rewardBtn":
					UILayoutManager.getInstance().open(WindowEnum.CROSS_SERVER_RANK_AWARD);
					break;
				case "rankBtn":
					Cmd_Across.cm_ACROSS_L();
					UILayoutManager.getInstance().open(WindowEnum.CROSS_SERVER_RANK);
					break;
				case "getBtn":
					accomplishTask();
					break;
			}
		}
		
		public function addTimer():void{
			if(!TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().addITick(1000, updateTime);
			}
		}
		
		public function removeTimer():void{
			if(TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().removeITick(updateTime);
			}
		}
		
		private function updateTime():void{
			timeLbl.text = PropUtils.getStringById(2245)+ ":" + DateUtil.formatTime(DataManager.getInstance().crossServerData.remianTime(), 2);
		}
		
		private function accomplishTask():void{
			var taskInfo:TCSMissionInfo = TableManager.getInstance().getCrossServerMissionInfo(DataManager.getInstance().crossServerData.taskId);
			switch(taskInfo.type){
				case 1:
				case 2:
				case 3:
				case 4:
				case 5:
				case 9:
					var pt:TPointInfo = TableManager.getInstance().getPointInfo(taskInfo.missionpoint);
					Core.me.gotoMap(new Point(pt.tx, pt.ty), pt.sceneId, true);
					break;
				case 6:
					UILayoutManager.getInstance().open(WindowEnum.CROSS_SERVER_DONATE);
					UIManager.getInstance().crossServerDonate.updateInfo(taskInfo.type, ItemEnum.MONEY_VIR_ITEM_ID, UIManager.getInstance().backpackWnd.jb, UIManager.getInstance().backpackWnd.bjb);
					break;
				case 7:
					UILayoutManager.getInstance().open(WindowEnum.CROSS_SERVER_DONATE);
					UIManager.getInstance().crossServerDonate.updateInfo(taskInfo.type, ItemEnum.ENERGY_VIR_ITEM_ID, Core.me.info.baseInfo.hunL, 0);
					break;
				case 8:
					var ic:int = MyInfoManager.getInstance().getBagItemNumById(taskInfo.missionTarget.split("|")[0]);
					var bic:int = MyInfoManager.getInstance().getBagItemNumById(taskInfo.missionTarget.split("|")[1]);
					UILayoutManager.getInstance().open(WindowEnum.CROSS_SERVER_DONATE);
					UIManager.getInstance().crossServerDonate.updateInfo(taskInfo.type, taskInfo.missionTarget.split("|")[0], ic, bic);
					break;
			}
		}
		
		public function updateInfo():void{
			var data:CrossServerData = DataManager.getInstance().crossServerData;
			if(0 == data.taskId){
				return;
			}
			if(data.myServerData.lv <= 0){
				return;
			}
			var taskInfo:TCSMissionInfo = TableManager.getInstance().getCrossServerMissionInfo(data.taskId);
			titleNameLbl.text = taskInfo.name;
			var progressRate:int = data.tnum/taskInfo.missionNum*100;
			progressLbl.text = "("+PropUtils.getStringById(2246)+progressRate+"%)";
			timeLbl.text = PropUtils.getStringById(2245)+ ":" + DateUtil.formatTime(data.remianTime(), 2);
			targetLbl.text = getTargetContent(taskInfo.type, taskInfo);
			getBtn.text = getBtnName(taskInfo.type);
			var serverInfo:TCSLvInfo = TableManager.getInstance().getCrossServerInfo(data.myServerData.lv);
			var rl:int = grids.length;
			for(var n:int = 0; n < rl; n++){
				grids[n].updateInfoII(serverInfo.itemIdlist[n], serverInfo.itemNumlist[n]);
			}
			rankLbl.text = ((data.myrank == 0) || (data.myrank > 10) || (0 == data.ptnum)) ? PropUtils.getStringById(101571) : data.myrank+"";
			myProgressLbl.text = StringUtil.substitute(getMyProgress(taskInfo.type), data.ptnum);
			var playerRankInfo:TCSPlayerRankInfo = TableManager.getInstance().getCrossPlayerRankInfo(data.myrank);
			var hasReward:Boolean = (null != playerRankInfo) && (0 != data.ptnum);
			for(var m:int = 0; m < 5; m++){
				rankGrids[m].visible = hasReward;
				if(hasReward){
					rankGrids[m].updateInfo(playerRankInfo.itemList[m], playerRankInfo.itemNumList[m]);
				}
			}
			noneLbl.visible = !hasReward;
		}
		
		private function getBtnName(type:int):String{
			switch(type){
				case 1:
				case 2:
				case 3:
				case 4:
				case 5:
				case 9:
					return PropUtils.getStringById(2261);
				case 6:
					return PropUtils.getStringById(2262);
				case 7:
					return PropUtils.getStringById(2263);
				case 8:
					return PropUtils.getStringById(2264);
			}
			return null;
		}
		
		private function getMyProgress(type:int):String{
			switch(type){
				case 1:
				case 2:
				case 5:
					return PropUtils.getStringById(2265);
				case 3:
				case 4:
					return PropUtils.getStringById(2266);
				case 6:
					return PropUtils.getStringById(2267);
				case 7:
					return PropUtils.getStringById(2268);
				case 8:
					return PropUtils.getStringById(2269);
				case 9:
					return PropUtils.getStringById(2270);
			}
			return null;
		}
		
		private function getTargetContent(type:int, taskInfo:TCSMissionInfo):String{
			var data:CrossServerData = DataManager.getInstance().crossServerData;
			var item:TItemInfo = TableManager.getInstance().getItemInfo(taskInfo.missionItem);;
			var monsterInfo:TLivingInfo = TableManager.getInstance().getLivingInfo(int(taskInfo.missionTarget));
			switch(type){
				case 1:
					return StringUtil.substitute(PropUtils.getStringById(2252), data.tnum+"/"+taskInfo.missionNum);
				case 2:
					return StringUtil.substitute(PropUtils.getStringById(2253), monsterInfo.name, data.tnum+"/"+taskInfo.missionNum);
				case 3:
					return StringUtil.substitute(PropUtils.getStringById(2254), item.name, data.tnum+"/"+taskInfo.missionNum);
				case 4:
					return StringUtil.substitute(PropUtils.getStringById(2255), monsterInfo.name, item.name, data.tnum+"/"+taskInfo.missionNum);
				case 5:
					return StringUtil.substitute(PropUtils.getStringById(2256), data.tnum+"/"+taskInfo.missionNum);
				case 6:
					return StringUtil.substitute(PropUtils.getStringById(2257), data.tnum+"/"+taskInfo.missionNum);
				case 7:
					return StringUtil.substitute(PropUtils.getStringById(2258), data.tnum+"/"+taskInfo.missionNum);
				case 8:
					item = TableManager.getInstance().getItemInfo(taskInfo.missionTarget.split("|")[0]);
					return StringUtil.substitute(PropUtils.getStringById(2259), item.name, data.tnum+"/"+taskInfo.missionNum);
				case 9:
					item = TableManager.getInstance().getItemInfo(taskInfo.missionTarget.split("|")[0]);
					return StringUtil.substitute(PropUtils.getStringById(2260), item.name, data.tnum+"/"+taskInfo.missionNum);
			}
			return null;
		}
	}
}