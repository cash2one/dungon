package com.leyou.ui.copy.child
{
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCopyInfo;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.component.ProgressBarII;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.copy.CopyData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.CopyEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_SCP;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.CopyUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	
	public class CopyItem extends AutoSprite
	{
		public var info:CopyData;
		
		// 等级
		protected var levelLbl:Label;
		
		// 名称
		protected var nameLbl:Label;
		
		// 副本图标
		protected var iconImg:Image;
		
		// 通关等级
		protected var rankImg:Image;
		
		// 扫荡副本
		protected var flagBtn:NormalButton;
		
		// 加速
		protected var catalysisBtn:ImgButton;
		
		// 扫荡进度条
		protected var progressImg:Image;
		
		// 今日已通关
		protected var pastImg:Image;
		
		// 开始副本
		protected var beginBtn:NormalButton;
		
		// 领取奖励
		protected var receiveBtn:ImgButton;
		
		protected var progressContainer:Sprite;
		
		protected var progressBar:ProgressBarII;
		
		// 扫荡剩余事件
		protected var sTime:int;
		
		private var timeLbl:Label;
		
		public function CopyItem(){
			super(LibManager.getInstance().getXML("config/ui/copy/dungeonStoryRender.xml"));
			init();
		}
		
		public function get status():int{
			return info.status;
		}
		
		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			info = new CopyData();
			progressContainer = new Sprite();
			addChild(progressContainer);
			levelLbl = getUIbyID("levelLbl") as Label;
			nameLbl = getUIbyID("nameLbl") as Label;
			iconImg = getUIbyID("iconImg") as Image;
			rankImg = getUIbyID("rankImg") as Image;
			flagBtn = getUIbyID("flagBtn") as NormalButton;
			catalysisBtn = getUIbyID("catalysisBtn") as ImgButton;
			progressImg = getUIbyID("progressImg") as Image;
			beginBtn = getUIbyID("beginBtn") as NormalButton;
			pastImg = getUIbyID("pastImg") as Image;
			receiveBtn = getUIbyID("receiveBtn") as ImgButton;
			timeLbl = getUIbyID("timeLbl") as Label;
			progressBar = new ProgressBarII();
			
			progressBar.updateResource("ui/dungeon/fuben_jdt_bg.png", "ui/dungeon/fuben_jdt_bar.png", onLoaded);
			progressBar.x = 2;
			progressBar.y = 115;
			progressContainer.addChild(progressBar);
			progressContainer.addChild(catalysisBtn);
			progressContainer.addChild(progressImg);
			progressContainer.addChild(timeLbl);
			
			flagBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			beginBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			catalysisBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			receiveBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		/**
		 * <T>鼠标移入</T>
		 * 
		 * @param event 鼠标事件
		 * 
		 */		
		protected function onMouseOver(event:MouseEvent):void{
			if(event.target == catalysisBtn){
				return;
			}
			if(event.target == flagBtn){
				return;
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_COPY, info, new Point(stage.mouseX+15, stage.mouseY+15));
		}
		
		/**
		 * <T>按钮点击</T>
		 * @param event
		 * 
		 */		
		protected function onButtonClick(event:MouseEvent):void{
			var n:String = event.target.name;
			switch(n){
				case "flagBtn":
					Cmd_SCP.cm_SCP_A(info.id);
					break;
				case "beginBtn":
					Cmd_SCP.cm_SCP_E(info.id);
					GuideManager.getInstance().removeGuide(30);
					break;
				case "catalysisBtn":
					var content:String = TableManager.getInstance().getSystemNotice(4404).content;
					content = StringUtil.substitute(content, ConfigEnum.StoryCopyPastCost);
					PopupManager.showConfirm(content, catalysis, null, false, "storyCopy.catalysis");
					break;
				case "receiveBtn":
					Cmd_SCP.cm_SCP_R(info.id);
					break;
			}
		}
		
		protected function catalysis():void{
			Cmd_SCP.cm_SCP_C(info.id);
		}
		
		private function onLoaded():void{
			if(CopyEnum.COPYSTATUS_PASTING == info.status){
				shaodang();
			}
		}
		
		/**
		 * <T>扫荡副本</T>
		 * 
		 */		
		public function shaodang():void{
			//			t = getTimer();
			var ct:int = ConfigEnum.StoryShaodangTime;
			progressContainer.visible = true;
			if(!progressBar.loaded){
				return;
			}
			progressBar.setProgress((ct-sTime)/ct);
			progressBar.rollToProgress(1, sTime/*, onComplete*/);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			//			function onComplete():void{
			//				var interval:int = getTimer() - t;
			//				trace("----------------------------------------------cost time = " + interval);
			//			}
		}
		
		protected function onEnterFrame(event:Event):void{
			var rt:int = progressBar.getRemainTime();
			if(rt >= 0){
				timeLbl.text = "剩余:"+DateUtil.formatTime(rt, 1);
			}else{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		/**
		 * <T>设置副本状态</T>
		 * 
		 * @param $status 状态
		 * 
		 */		
		public function setStatus($status:int):void{
			info.status = $status;
			visibleOfAllBtn = false;
			iconImg.filters = null;
			switch($status){
				case CopyEnum.COPYSTATUS_LOCK:
					var f:ColorMatrixFilter = new ColorMatrixFilter([0, 0, 0, 0, 0, 
						0, 0, 0, 0, 0, 
						0, 0, 0, 0, 0, 
						0, 0, 0, 1, 0]);
					rankImg.visible = true;
					rankImg.updateBmp("ui/dungeon/icon_wen.png");
					iconImg.filters = [f];
					break;
				case CopyEnum.COPYSTATUS_UNLOCK:
					beginBtn.visible = true;
					flagBtn.visible = true;
					flagBtn.setActive(info.convenience, 1, true);
					break;
				case CopyEnum.COPYSTATUS_PAST:
					rankImg.visible = true;
					rankImg.updateBmp(CopyUtil.getQualityImg(info.pastLvel));
					pastImg.updateBmp("ui/dungeon/fuben_jrytg.png");
					pastImg.visible = true;
					break;
				case CopyEnum.COPYSTATUS_UNPAST:
					rankImg.visible = true;
					rankImg.updateBmp(CopyUtil.getQualityImg(info.pastLvel));
					beginBtn.visible = true;
					flagBtn.visible = true;
					flagBtn.setActive(info.convenience, 1, true);
					break;
				case CopyEnum.COPYSTATUS_REWARD:
					rankImg.visible = true;
					rankImg.updateBmp(CopyUtil.getQualityImg(info.pastLvel));
					receiveBtn.visible = true;
					break;
				case CopyEnum.COPYSTATUS_PASTING:
					rankImg.visible = true;
					rankImg.updateBmp(CopyUtil.getQualityImg(info.pastLvel));
					shaodang();
					break;
				case CopyEnum.COPYSTATUS_FAIL:
					pastImg.updateBmp("ui/dungeon/fuben_jrytg2.png");
					pastImg.visible = true;
					break;
			}
		}
		
		/**
		 * <T>设置按钮的表现状态<T>
		 * 
		 */		
		public function set visibleOfAllBtn(v:Boolean):void{
			progressContainer.visible = false;
			flagBtn.visible = false;
			pastImg.visible = false;
			beginBtn.visible = false;
			receiveBtn.visible = false;
			rankImg.visible = false;
		}
		
		/**
		 * <T>加载数据</T>
		 * 
		 * @param copyData 副本数据
		 * 
		 */		
		public function loadData(copyData:Object):void{
			info.id = copyData.cid;
			sTime = copyData.stime;
			info.status = copyData.s;
			info.convenience = copyData.c;
			info.pastLvel = copyData.pl;
			info.init();
			var table:TCopyInfo = info.copyTable;
			setStatus(info.status);
			var tt:String;
			//			if(info.convenience){
			tt = TableManager.getInstance().getSystemNotice(4606).content;
			//			}else{
			//				tt = TableManager.getInstance().getSystemNotice(4604).content;
			//			}
			flagBtn.setToolTip(StringUtil.substitute(tt, CopyUtil.getCharCode(info.pastLvel)));
			
			levelLbl.text = "Lv"+table.openLevel;
			nameLbl.text = table.name;
			iconImg.updateBmp("ui/dungeon/"+info.copyTable.sourceUrl);
		}
	}
}