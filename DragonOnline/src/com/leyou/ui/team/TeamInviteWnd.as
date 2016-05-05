package com.leyou.ui.team {

	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Tm;
	import com.leyou.utils.PlayerUtil;

	import flash.events.MouseEvent;

	public class TeamInviteWnd extends AutoWindow {

		private var playNameLbl:Label;
		private var lvLbl:Label;
		private var proLbl:Label;
		private var timeLbl:Label;

		private var accBtn:NormalButton;
		private var noBtn:NormalButton;

		private var type:int=0;
		private var time:int=0;

		public function TeamInviteWnd() {
			super(LibManager.getInstance().getXML("config/ui/team/TeamInviteWnd.xml"));
			this.init();
			this.hideBg();
//			this.clsBtn.y-=10;
		}

		private function init():void {

			this.playNameLbl=this.getUIbyID("playNameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.proLbl=this.getUIbyID("proLbl") as Label;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;

			this.accBtn=this.getUIbyID("accBtn") as NormalButton;
			this.noBtn=this.getUIbyID("noBtn") as NormalButton;

			this.accBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.noBtn.addEventListener(MouseEvent.CLICK, onClick);

		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			if (this.parent == null)
				LayerManager.getInstance().windowLayer.addChild(this);
		}

		private function onClick(e:MouseEvent):void {
			switch (e.target.name) {
				case "accBtn":
					Cmd_Tm.cm_teamAccept(type, 1, this.playNameLbl.text);
					break;
				case "noBtn":
					Cmd_Tm.cm_teamAccept(type, 0, this.playNameLbl.text);
					break;
			}

			this.hide();
		}

		/**
		 *组队
		 * @param d
		 *
		 */
		public function showPanel(d:Object):void {
			this.show();

			if (d.mk == "A") {
				type=2;

				this.playNameLbl.text="" + d.leaguer[0];
				this.proLbl.text="" + PlayerUtil.getPlayerRaceByIdx(d.leaguer[1]);
				this.lvLbl.text="" + d.leaguer[2];

			} else if (d.mk == "W") {
				type=1;

				this.playNameLbl.text="" + d.leader[0];
				this.proLbl.text="" + PlayerUtil.getPlayerRaceByIdx(d.leader[1]);
				this.lvLbl.text="" + d.leader[2];
			}

			this.timeLbl.text="";

			time=30;
			TimerManager.getInstance().add(exeTime);
		}

		/**
		 *
		 * @param d
		 *
		 */
		public function showGuildPanel(d:Object):void {
			this.show();

			if (d.mk == "A") {
				type=2;

				this.playNameLbl.text="" + d.leaguer[0];
				this.proLbl.text="" + PlayerUtil.getPlayerRaceByIdx(d.leaguer[1]);
				this.lvLbl.text="" + d.leaguer[2];

			} else if (d.mk == "W") {
				type=1;

				this.playNameLbl.text="" + d.leader[0];
				this.proLbl.text="" + PlayerUtil.getPlayerRaceByIdx(d.leader[1]);
				this.lvLbl.text="" + d.leader[2];
			}

			this.timeLbl.text="";

			time=30;
			TimerManager.getInstance().add(exeTime);
		}

		private function exeTime(i:int):void {

			if (time - i > 0) {
				this.timeLbl.text="(" + (time - i) + ")";
			} else {
				this.hide();
				this.time=0;
			}

		}

		override public function hide():void {
			super.hide();

			if (this.visible)
				Cmd_Tm.cm_teamAccept(type, 0, this.playNameLbl.text);

			TimerManager.getInstance().remove(exeTime);
			time=0;
		}


	}
}
