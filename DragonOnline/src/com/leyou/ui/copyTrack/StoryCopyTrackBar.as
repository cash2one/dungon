package com.leyou.ui.copyTrack {
	import com.ace.enum.EventEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.manager.EventManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_BCP;
	import com.leyou.net.cmd.Cmd_Longz;
	import com.leyou.net.cmd.Cmd_SCP;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.utils.getTimer;

	public class StoryCopyTrackBar extends AutoSprite {
		private var type:int;

		private var monsterLbls:Vector.<Label>;

		private var countLbls:Vector.<Label>;

		private var costLbl:Label;

//		private var addLbl:Label;
//		
//		private var iconImg:Image;
//		
//		private var promotionImg:Image;
//		
//		private var promotionBtn:ImgButton;
//		
//		private var leaveBtn:ImgButton;

		private var timeEdit:Label;

		private var tick:uint;

		private var remainTime:int;

		private var complete:Boolean;

		public function StoryCopyTrackBar() {
			super(LibManager.getInstance().getXML("config/ui/dungeonTrack.xml"));
			init();
		}

		private function init():void {
			visible=false;
//			mouseEnabled = true;
			mouseChildren=true;
			monsterLbls=new Vector.<Label>();
			for (var n:int=0; n < 4; n++) {
				monsterLbls.push(getUIbyID("monster" + (n + 1) + "Lbl"));
			}

			countLbls=new Vector.<Label>();
			for (var m:int=0; m < 4; m++) {
				countLbls.push(getUIbyID("count" + (m + 1) + "Lbl"));
			}

//			addLbl = getUIbyID("addLbl") as Label;
//			iconImg = getUIbyID("iconImg") as Image;
			costLbl=getUIbyID("remainLbl") as Label;
			timeEdit=getUIbyID("remainELbl") as Label;
//			leaveBtn = getUIbyID("leaveBtn") as ImgButton;
//			promotionImg = getUIbyID("promotionImg") as Image;
//			promotionBtn = getUIbyID("promotionBtn") as ImgButton;
//			promotionBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			leaveBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
		}

//		protected function onMouseClick(event:MouseEvent):void{
//			var n:String = event.target.name;
//			switch(n){
//				case "promotionBtn":
//					break;
//				case "leaveBtn":
//						var content:String = TableManager.getInstance().getSystemNotice(4603).content;
//						if(0 == type){
//							if(complete){
//								Cmd_SCP.cm_SCP_L();
//							}else{
//								PopupManager.showConfirm(content, Cmd_SCP.cm_SCP_L, null, false, "copy.story.leave");
////								var wnd:WindInfo = WindInfo.getConfirmInfo(content, Cmd_SCP.cm_SCP_L);
////								PopWindow.showWnd(UIEnum.WND_TYPE_CONFIRM, wnd, "copy.story.leave")
//							}
//						}else if(1 == type){
//							if(complete){
//								Cmd_BCP.cm_BCP_L();
//							}else{
//								PopupManager.showConfirm(content, Cmd_BCP.cm_BCP_L, null, false, "copy.boss.leave");
////								var bWnd:WindInfo = WindInfo.getConfirmInfo(content, Cmd_BCP.cm_BCP_L);
////								PopWindow.showWnd(UIEnum.WND_TYPE_CONFIRM, bWnd, "copy.boss.leave")
//							}
//						}
//					break;
//			}
//		}

		public function addExitEvent():void {
			if (!EventManager.getInstance().hasEvent(EventEnum.COPY_QUIT, onExit)) {
				EventManager.getInstance().addEvent(EventEnum.COPY_QUIT, onExit);
			}
		}

		private function onExit():void {
			var content:String=TableManager.getInstance().getSystemNotice(4603).content;
			if (0 == type) {
				if (complete) {
					Cmd_SCP.cm_SCP_L();
				} else {
					PopupManager.showConfirm(content, Cmd_SCP.cm_SCP_L, null, false, "copy.story.leave");
				}
			} else if (1 == type) {
				if (complete) {
					Cmd_BCP.cm_BCP_L();
				} else {
					PopupManager.showConfirm(content, Cmd_BCP.cm_BCP_L, null, false, "copy.boss.leave");
				}
			} else if (3 == type) {
				if (complete) {
					Cmd_Longz.cm_Longz_L();
				} else {
					PopupManager.showConfirm(content, Cmd_Longz.cm_Longz_L, null, false, "copy.dragon.leave");
				}
			}
		}

		public function removeExitEvent():void {
			if (EventManager.getInstance().hasEvent(EventEnum.COPY_QUIT, onExit)) {
				EventManager.getInstance().removeEvent(EventEnum.COPY_QUIT, onExit);
			}
		}

		public function resize():void {
			x=(UIEnum.WIDTH - 271);
			y=((UIEnum.HEIGHT - 246) >> 1) + 13;
		}

		public function updateTime():void {
			var re:int=remainTime - (getTimer() - tick) / 1000;
			re=(re >= 0 ? re : 0);
			timeEdit.text=StringUtil_II.lpad(int(re / 60) + "", 2, "0") + ":" + StringUtil_II.lpad(int(re % 60) + "", 2, "0");
		}

		/**
		 * <T>副本追踪信息</T>
		 *
		 * @param obj
		 * @param $type
		 *
		 */
		public function updateInfo(obj:Object, $type:int):void {
			type=$type;
			complete=true;
			if (0 == type || 1 == type) { // 剧情副本追踪
//				addLbl.visible = false;
//				costLbl.visible = false;
//				timeEdit.visible = false;
//				iconImg.visible = false;
//				promotionImg.visible = false;
//				promotionBtn.visible = false;
				var monsterList:Array=obj.m;
				var length:int=monsterLbls.length;
				for (var n:int=0; n < length; n++) {
					var monster:Object=monsterList[n];
					var monsterLbl:Label=monsterLbls[n];
					var countLbl:Label=countLbls[n];
					if (null != monster) {
						var monsterInfo:TLivingInfo=TableManager.getInstance().getLivingInfo(monster.mid);
						monsterLbl.text=PropUtils.getStringById(1674)+ monsterInfo.name;
						countLbl.textColor=(monster.cc == monster.mc) ? 0xff00 : 0xff0000
						countLbl.text="(" + monster.cc + "/" + monster.mc + ")";
						countLbl.x=monsterLbl.x + monsterLbl.width + 5;
						if (monster.cc != monster.mc) {
							complete=false;
						}
					} else {
						monsterLbl.text="";
						countLbl.text="";
					}
				}
				tick=getTimer();
				remainTime=obj.rt;
			} else if (1 == type) { // boss副本追踪
			}
			if (!visible) {
				show();
			}
		}

		public override function show():void {
			super.show();
			resize();
			if (!TimeManager.getInstance().hasITick(updateTime)) {
				TimeManager.getInstance().addITick(1000, updateTime);
			}
		}

		public override function hide():void {
			super.hide();
			if (TimeManager.getInstance().hasITick(updateTime)) {
				TimeManager.getInstance().removeITick(updateTime);
			}
		}
	}
}
