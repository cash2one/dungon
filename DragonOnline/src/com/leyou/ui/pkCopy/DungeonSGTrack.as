package com.leyou.ui.pkCopy {

	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.FontEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.manager.EventManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.window.children.SimpleWindow;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Ecp;
	import com.leyou.ui.question.childs.QuestionQBtn;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TimeUtil;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;

	public class DungeonSGTrack extends AutoSprite {

		private var timeLbl:Label;
		private var ruleLbl:Label;
		private var monsterArr:Array=[];
		private var jfArr:Array=[];
		private var time:int=0;

		private var roll:RollNumWidget;
		private var leaveBtn:QuestionQBtn;

		private var wnd:SimpleWindow;

		public function DungeonSGTrack() {
			super(LibManager.getInstance().getXML("config/ui/pkCopy/dungeonSGTrack.xml"));
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {

			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;

			var lb:Label;
			for (var i:int=0; i < 5; i++) {
				lb=this.getUIbyID("monster" + (i + 1) + "Lbl") as Label;
				lb.addEventListener(TextEvent.LINK, onLink);
				lb.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
				lb.mouseEnabled=true;
				this.monsterArr.push(lb);
			}

			this.jfArr.push(this.getUIbyID("jf1Lbl") as Label);
			this.jfArr.push(this.getUIbyID("jf2Lbl") as Label);
			this.jfArr.push(this.getUIbyID("jf3Lbl") as Label);
			this.jfArr.push(this.getUIbyID("jf4Lbl") as Label);
			this.jfArr.push(this.getUIbyID("jf5Lbl") as Label);

//			this.leaveBtn=new QuestionQBtn();
//			LayerManager.getInstance().windowLayer.addChild(this.leaveBtn);
//
//			this.leaveBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.roll=new RollNumWidget();
			this.roll.loadSource("ui/num/{num}_zdl.png");
			this.addChild(this.roll);
			this.roll.x=100;
			this.roll.y=60;

			this.roll.isPopNum=false;

			this.ruleLbl.setToolTip(TableManager.getInstance().getSystemNotice(5504).content);
			EventManager.getInstance().addEvent(EventEnum.COPY_QUIT, onClick);
		}

		private function onClick():void {

			if (SceneEnum.SCENE_TYPE_SGLX == MapInfoManager.getInstance().type) {
//				wnd=PopupManager.showConfirm(TableManager.getInstance().getSystemNotice(9935).content, function():void {
					Cmd_Ecp.cmExpExit()
					NoticeManager.getInstance().stopCount();
//				}, null, false, "pkcopyExit");
			}

		}

		private function onLink(e:TextEvent):void {
			var info:TPointInfo=TableManager.getInstance().getPointInfo(int(e.text));

			if (info == null)
				return;

			//跨场景寻路
			Core.me.gotoMap(new Point(info.tx, info.ty), info.sceneId);
		}

		public function updateInfo(o:Object):void {

			if (o.hasOwnProperty("npcl")) {

				var info:TLivingInfo;
				for (var i:int=0; i < this.monsterArr.length; i++) {
					if (o.npcl[i] != null) {

						info=TableManager.getInstance().getLivingInfo(int(o.npcl[i][0]));
						if (info != null)
							this.monsterArr[i].htmlText="<u><a href='event:" + ConfigEnum["Exp_Fb" + (13 + i)] + "'>" + info.name + "</a></u>";

						if (o.npcl[i][1] == 1)
							this.jfArr[i].text=PropUtils.getStringById(1826);
						else
							this.jfArr[i].text="";
					}
				}

			}

			this.roll.rollToNum(o.jf);
			this.timeLbl.text="" + TimeUtil.getIntToTime(o.stime);

//			if (this.time == 0)
				this.time=o.stime;

			TimerManager.getInstance().remove(exeTime);
			TimerManager.getInstance().add(exeTime);
		}

		private function exeTime(i:int):void {

			if (this.time - i > 0) {

				if (this.time - i == 30)
					NoticeManager.getInstance().countdown(4409, 30);

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

			UIManager.getInstance().taskTrack.hide();
			UIManager.getInstance().hideWindow(WindowEnum.PKCOPY);
			UIManager.getInstance().hideWindow(WindowEnum.PKCOPYPANEL);
		}

		public function reSize():void {
			this.x=UIEnum.WIDTH - 270;
			this.y=UIEnum.HEIGHT - 267 >> 1;

//			this.leaveBtn.x=UIEnum.WIDTH - this.leaveBtn.width;
		}

		override public function hide():void {
			super.hide();

			UIManager.getInstance().taskTrack.show();
			UIManager.getInstance().rightTopWnd.show();

			if (wnd != null) {
				wnd.hide();
				wnd=null;
			}
		}
	}
}
