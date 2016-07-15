package com.leyou.ui.task {
	import com.ace.config.Core;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TDailytask;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.leyou.net.cmd.Cmd_Tsk;
	import com.leyou.ui.task.child.MissionGrid;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MessageMissionWnd extends AutoWindow {

		private var confirmBtn:NormalButton;
		private var loopRewardVec:Array=[];

		public function MessageMissionWnd() {
			super(LibManager.getInstance().getXML("config/ui/messagebox/messageMissionWnd.xml"));
			this.init();
			this.hideBg();
			this.mouseChildren=true;
//			this.mouseEnabled=true;
		}

		private function init():void {
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(e:MouseEvent):void {
			
			Cmd_Tsk.cmTaskDailyReward();
			
			var exphun:Array=[0, 0];
			var flyArr:Array=[[], []];
			var mgrid:MissionGrid;
			for each (mgrid in this.loopRewardVec) {
//				if (mgrid != null && mgrid.dataId != 65533 && mgrid.dataId != 65534 && mgrid.dataId != 65535) {
				if (mgrid != null) {
					if (mgrid.dataId == 65534) {
						exphun[0]=mgrid.parent.localToGlobal(new Point(mgrid.x, mgrid.y));
						exphun[1]=mgrid.getNum();
					} else if (mgrid.dataId == 65533) { 
						exphun[2]=mgrid.parent.localToGlobal(new Point(mgrid.x, mgrid.y));
						exphun[3]=mgrid.getNum();
					} else {
						flyArr[0].push(mgrid.dataId);
						flyArr[1].push(mgrid.parent.localToGlobal(new Point(mgrid.x, mgrid.y)));
					}
				}
			}

			FlyManager.getInstance().flyBags(flyArr[0], flyArr[1]);
			
			if (exphun[0] != 0)
				FlyManager.getInstance().flyExpOrHonour(1, exphun[1], 1, exphun[0]);
			
			if (exphun[2] != 0)
				FlyManager.getInstance().flyExpOrHonour(1, exphun[3], 2, exphun[2]);
			
			this.hide();
		}

		public function updateLoopReward():void {
			var mgrid:MissionGrid;
			for each (mgrid in this.loopRewardVec) {
				if (mgrid != null && mgrid.parent == this) {
					this.removeChild(mgrid);
					mgrid.die();
				}
			}

			this.loopRewardVec.length=0;

			var dxml:XML=LibManager.getInstance().getXML("config/table/dailytask.xml");
			var xml:XML;

			for each (xml in dxml.data) {
				if (Core.me.info.level >= xml.@lv_min && Core.me.info.level < int(xml.@lv_min) + 10)
					break;
			}

			var dinfo:TDailytask=new TDailytask(xml);

			if (dinfo.exp != "" && dinfo.exp != null) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65534);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(int(dinfo.exp));

				//				if (int(dinfo.exp) >= 10000)
				//					mgrid.setNum(Math.floor(int(dinfo.exp) / 10000) + "万");
				//				else
				mgrid.setNum((dinfo.exp));

				mgrid.x=17 + (this.loopRewardVec.length % 6) * (46);
				mgrid.y=105 + Math.floor(this.loopRewardVec.length / 6) * (mgrid.height);

				this.addChild(mgrid);
				this.loopRewardVec.push(mgrid);
			}

			if (dinfo.money != "" && dinfo.money != null) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65535);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(int(dinfo.money));

				//				if (int(dinfo.money) >= 10000)
				//					mgrid.setNum(Math.floor(int(dinfo.money) / 10000) + "万");
				//				else
				mgrid.setNum((dinfo.money));

				mgrid.x=17 + (this.loopRewardVec.length % 6) * (46);
				mgrid.y=105 + Math.floor(this.loopRewardVec.length / 6) * (mgrid.height);

				this.addChild(mgrid);
				this.loopRewardVec.push(mgrid);
			}


			if (dinfo.energy != "" && dinfo.energy != null) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65533);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(int(dinfo.energy));

				//				if (int(dinfo.energy) >= 10000)
				//					mgrid.setNum(Math.floor(int(dinfo.energy) / 10000) + "万");
				//				else
				mgrid.setNum((dinfo.energy));

				mgrid.x=17 + (this.loopRewardVec.length % 6) * (46);
				mgrid.y=105 + Math.floor(this.loopRewardVec.length / 6) * (mgrid.height);

				this.addChild(mgrid);
				this.loopRewardVec.push(mgrid);
			}

			if (dinfo.bg != "" && dinfo.bg != null) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65531);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(int(dinfo.bg));

				//				if (int(dinfo.bg) >= 10000)
				//					mgrid.setNum(Math.floor(int(dinfo.bg) / 10000) + "万");
				//				else
				mgrid.setNum((dinfo.bg));

				mgrid.x=17 + (this.loopRewardVec.length % 6) * (46);
				mgrid.y=105 + Math.floor(this.loopRewardVec.length / 6) * (mgrid.height);

				this.addChild(mgrid);
				this.loopRewardVec.push(mgrid);
			}

			if (dinfo.Bd_Yb != "" && dinfo.Bd_Yb != null) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65532);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(int(dinfo.Bd_Yb));

				//				if (int(dinfo.Bd_Yb) >= 10000)
				//					mgrid.setNum(Math.floor(int(dinfo.Bd_Yb) / 10000) + "万");
				//				else
				mgrid.setNum((dinfo.Bd_Yb));

				mgrid.x=17 + (this.loopRewardVec.length % 6) * (46);
				mgrid.y=105 + Math.floor(this.loopRewardVec.length / 6) * (mgrid.height);

				this.addChild(mgrid);
				this.loopRewardVec.push(mgrid);
			} 

			var item:Object;
			var reward:String;

			for (var i:int=0; i < 4; i++) {
				mgrid=new MissionGrid();

				if (dinfo["item" + (i + 1)] == "" || dinfo["item" + (i + 1)] == null)
					continue;

				this.addChild(mgrid);

				reward=String(dinfo["item" + (i + 1)]); //.split("|")[Core.me.info.profession - 1];

				if (reward.length == 4)
					item=TableManager.getInstance().getEquipInfo(int(reward));
				else
					item=TableManager.getInstance().getItemInfo(int(reward));

				mgrid.updataInfo(item);

				if (int(dinfo["num" + (i + 1)]) > 1)
					mgrid.setNum(dinfo["num" + (i + 1)]);

				mgrid.canMove=false;

				mgrid.x=17 + (this.loopRewardVec.length % 6) * (46);
				mgrid.y=105 + Math.floor(this.loopRewardVec.length / 6) * (mgrid.height + 1);

				this.loopRewardVec.push(mgrid);
			}
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			this.updateLoopReward();
		}


	}
}
