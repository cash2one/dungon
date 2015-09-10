package com.leyou.ui.pkCopy {

	import com.ace.enum.EventEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.EventManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.ui.map.MapWnd;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Blt;
	import com.leyou.utils.TimeUtil;

	public class DungeonBWTrack extends AutoSprite {

		private var nameArr:Array=[]
		private var valueArr:Array=[];

		private var countLbl:Label;
		private var chLbl:Label;
		private var ybLbl:Label;

		private var timeLbl:Label;
		private var timLbl:Label;
		private var ruleLbl:Label;

		private var time:int=0;

		public function DungeonBWTrack() {
			super(LibManager.getInstance().getXML("config/ui/pkCopy/dungeonBWTrack.xml"));
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {

			this.ybLbl=this.getUIbyID("ybLbl") as Label;
			this.countLbl=this.getUIbyID("countLbl") as Label;
			this.chLbl=this.getUIbyID("chLbl") as Label;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			this.timLbl=this.getUIbyID("timLbl") as Label;
			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;

			EventManager.getInstance().addEvent(EventEnum.COPY_QUIT, onClick);
			
			this.ruleLbl.setToolTip(TableManager.getInstance().getSystemNotice(5505).content);
		}

		private function onClick():void {

			if (SceneEnum.SCENE_TYPE_BWBLT == MapInfoManager.getInstance().type) {
//				wnd=PopupManager.showConfirm(TableManager.getInstance().getSystemNotice(9935).content, function():void {
				Cmd_Blt.cmBltExit();
				NoticeManager.getInstance().stopCount();
//				}, null, false, "pkcopyExit");
			}

		}

		public function updateInfo(o:Object):void {

//			var lb:Label;
//			for (var i:int=0; i < this.nameArr.length; i++) {
//				if (this.nameArr[i] != null) {
//					lb=this.nameArr[i] as Label;
//					this.removeChild(lb);
//
//					lb=this.valueArr[i] as Label;
//					this.removeChild(lb);
//				}
//			}
//
//			this.nameArr.length=0;
//			this.valueArr.length=0;
//
//			var living:TLivingInfo;
//			var str:String;
//			var _x:int=0;
//			for (str in o.nlist) {
//
//				living=TableManager.getInstance().getLivingInfo(int(str));
//				if (living == null)
//					continue;
//
//				lb=new Label();
//				lb.defaultTextFormat=FontEnum.getTextFormat("DefaultFont");
//				lb.text="场景内 " + living.name + ":"
//				lb.x=10;
//				lb.y=26 + this.nameArr.length * lb.height;
//
//				_x=lb.x + lb.width;
//
//				this.nameArr.push(lb);
//				this.addChild(lb);
//
//				lb=new Label(o.nlist[str]);
//				lb.defaultTextFormat=FontEnum.getTextFormat("Yellow12");
////				lb.x=111;
//				lb.x=_x + 5;
//				lb.y=26 + this.valueArr.length * lb.height;
//
//				this.valueArr.push(lb);
//				this.addChild(lb);
//			}
//
//			this.timeLbl.y=this.timLbl.y=lb.y + lb.height + 5;

//			if (o.hasOwnProperty("1712"))
//				this.countLbl.text=int(o["1712"]) + "";
//			else
//				this.countLbl.text="0";

			if (o.hasOwnProperty("1710"))
				this.ybLbl.text=int(o["1710"]) + "";
			else
				this.ybLbl.text="0";

//			if (o.hasOwnProperty("1711"))
//				this.chLbl.text=int(o["1711"]) + "";
//			else
//				this.chLbl.text="0";

//			trace(this.time,"99999999");
//			this.timeLbl.text="" + TimeUtil.getIntToTime(o.stime);
			if (this.time <= o.stime - 1 || this.time >= o.stime + 1)
				this.time=o.stime;
//			trace(this.time,"7777777777",getTimer(),getTimer()/1000);

			TimerManager.getInstance().remove(exeTime);
			TimerManager.getInstance().add(exeTime);
		}

		private function exeTime(i:int):void {

			if (this.time - i > 0) {
				this.timeLbl.text="" + TimeUtil.getIntToTime(this.time - i);
			} else {
				this.time=0;
				this.timeLbl.text="00:00";
				TimerManager.getInstance().remove(exeTime);
			}

		}

		public function showPanel(o:Object):void {
			this.show();

			this.reSize();
			this.updateInfo(o);

			UIManager.getInstance().smallMapWnd.switchToType(2);
			UIManager.getInstance().rightTopWnd.hideBar(1);
			MapWnd.getInstance().hideSwitch();

			UIManager.getInstance().taskTrack.hide();
			UIManager.getInstance().hideWindow(WindowEnum.PKCOPY);
			UIManager.getInstance().hideWindow(WindowEnum.PKCOPYPANEL);
		}

		public function reSize():void {
			this.x=UIEnum.WIDTH - 270;
			this.y=UIEnum.HEIGHT - 267 >> 1;
		}


	}
}
