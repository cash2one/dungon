package com.leyou.ui.crossServer
{
	import com.ace.config.Core;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCSMissionInfo;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenMax;
	import com.leyou.data.crossServer.CrossServerData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Across;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.StyleSheet;
	
	public class CrossServerMissionTrack extends AutoSprite
	{
		private var timeLbl:Label;
		
		private var detailLbl:Label;
		
		private var rankLbl:Label;
		
		private var taskLbl:Label;
		
		private var gotoLbl:Label;
		
//		private var flyBtn:ImgButton;
		
		private var rtimeLbl:Label;
		
		private var ttimeVLbl:Label;
		
		private var mapLbl:Label;
		
		public function CrossServerMissionTrack(){
			super(LibManager.getInstance().getXML("config/ui/crossServer/missionKFBar.xml"));
			init();
		}
		
		public function init():void{
			mouseChildren = true;
			timeLbl = getUIbyID("timeLbl") as Label;
			detailLbl = getUIbyID("detailLbl") as Label;
			rankLbl = getUIbyID("rankLbl") as Label;
			taskLbl = getUIbyID("taskLbl") as Label;
			gotoLbl = getUIbyID("gotoLbl") as Label;
//			flyBtn = getUIbyID("flyBtn") as ImgButton;
			rtimeLbl = getUIbyID("rtimeLbl") as Label;
			ttimeVLbl =getUIbyID("timeLbl1") as Label;
			mapLbl = getUIbyID("mapLbl") as Label;
//			flyBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			var style:StyleSheet=new StyleSheet();
			style.setStyle("body", {leading: 0.5});
			style.setStyle("a:hover", {color: "#ff0000"});
			detailLbl.styleSheet=style;
			detailLbl.htmlText=StringUtil_II.addEventString(detailLbl.text, detailLbl.text, true);
			detailLbl.mouseEnabled = true;
			detailLbl.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			gotoLbl.styleSheet = style;
			gotoLbl.htmlText = StringUtil_II.addEventString(gotoLbl.text, gotoLbl.text, true);
			gotoLbl.mouseEnabled = true;
			gotoLbl.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			mapLbl.styleSheet = style;
			mapLbl.htmlText = StringUtil_II.addEventString(mapLbl.text, mapLbl.text, true);
			mapLbl.mouseEnabled = true;
			mapLbl.addEventListener(MouseEvent.CLICK, onMouseClick);
//			taskLbl.visible = false;
//			gotoLbl.visible = false;
//			flyBtn.visible = false;
			
			timeLbl.mouseEnabled = true;
			timeLbl.addEventListener(TextEvent.LINK, onTextLink);
		}
		
		protected function onTextLink(event:TextEvent):void{
			accomplishTask();
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
		
		protected function onMouseClick(event:MouseEvent):void{
			switch(event.target.name){
				case "detailLbl":
					UIOpenBufferManager.getInstance().open(WindowEnum.CROSS_SERVER);
					TweenMax.delayedCall(.7, onChange);
					break;
				case "gotoLbl":
					Cmd_Across.cm_ACROSS_Y(gotoThere);
					break;
				case "mapLbl":
					var pt:TPointInfo = TableManager.getInstance().getPointInfo(900001);
					Core.me.gotoMap(new Point(pt.tx, pt.ty), pt.sceneId, true);
					break;
			}
			function onChange():void{
				UIManager.getInstance().crossServerWnd.changeTabIdx(1);
			}
		}
		
		public function gotoThere(sceneId:int, tx:int, ty:int):void{
			Core.me.gotoMap(new Point(tx, ty), ""+sceneId, true);
		}
		
		public function updateInfo():void{
			var data:CrossServerData = DataManager.getInstance().crossServerData;
			if(0 == data.taskId){
				rankLbl.visible = false;
				rtimeLbl.visible = false;
				ttimeVLbl.visible = false;
				var timeArr:Array = ConfigEnum.multiple2.split("|");
				var serverDate:Date = new Date(data.stime*1000);
				var startTick1:Date = new Date(serverDate.fullYear, serverDate.month, serverDate.date, int(timeArr[0].split(":")[0]), int(timeArr[0].split(":")[1]));
				var startTick2:Date = new Date(serverDate.fullYear, serverDate.month, serverDate.date, int(timeArr[1].split(":")[0]), int(timeArr[1].split(":")[1]));
				if(serverDate.time < startTick1.time){
					timeLbl.text = timeArr[0];
				}else if((serverDate.time >= startTick1.time) && (serverDate.time < startTick2.time)){
					timeLbl.text = timeArr[1];
				}else{
					timeLbl.text = timeArr[0];
				}
				timeLbl.appendText(PropUtils.getStringById(2277));
				removeTimer();
				
				taskLbl.visible = false;
				detailLbl.visible = false;
//				flyBtn.visible = false;
				
			}else{
				detailLbl.visible = true;
				rtimeLbl.visible = true;
				rankLbl.visible = true;
				ttimeVLbl.visible = true;
				var taskInfo:TCSMissionInfo = TableManager.getInstance().getCrossServerMissionInfo(data.taskId);
				var progressRate:int = data.tnum/taskInfo.missionNum*100;
				var tplStr:String = "<Font face='Simsun' size='12' color='#ff00'><u><a href='event:seekMonster'>{1}</a></u></Font><Font face='Simsun' size='12' color='#ff0000'>({2}\/{3})</Font>";
				tplStr = StringUtil_II.translate(tplStr, taskInfo.name, data.tnum, taskInfo.missionNum);
				timeLbl.htmlText = StringUtil.substitute(PropUtils.getStringById(2278), tplStr);
				tplStr = "<Font face='Simsun' size='12' color='#ffffff'>({1})</Font>";
				tplStr = StringUtil_II.translate(tplStr, StringUtil.substitute(getMyProgress(taskInfo.type), data.ptnum));
				var rank:String = ((data.myrank == 0) || (data.myrank > 10) || (0 == data.ptnum)) ? PropUtils.getStringById(101571) : data.myrank+"";
				rankLbl.htmlText = StringUtil.substitute(PropUtils.getStringById(2279), rank, tplStr);
				
				ttimeVLbl.text = DateUtil.formatTime(DataManager.getInstance().crossServerData.remianTime(), 2);
				addTimer();
				
			}
			
			if((null != data.gname) && ("" != data.gname)){
				taskLbl.visible = true;
				gotoLbl.visible = true;
//				flyBtn.visible = true;
				if(data.gname == data.myServerData.serverName){
					taskLbl.text = PropUtils.getStringById(2289);
					gotoLbl.htmlText = StringUtil_II.addEventString(gotoLbl.text, PropUtils.getStringById(2288), true);
				}else{
					gotoLbl.htmlText = StringUtil_II.addEventString(gotoLbl.text, PropUtils.getStringById(2287), true);
					taskLbl.text = StringUtil.substitute(PropUtils.getStringById(2286), data.gname);
				}
			}else{
				taskLbl.visible = false;
				gotoLbl.visible = false;
//				flyBtn.visible = false;
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
			ttimeVLbl.text = DateUtil.formatTime(DataManager.getInstance().crossServerData.remianTime(), 2);
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
	}
}