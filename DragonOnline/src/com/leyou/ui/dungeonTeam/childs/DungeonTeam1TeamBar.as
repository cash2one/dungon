package com.leyou.ui.dungeonTeam.childs {

	import com.ace.config.Core;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_CpTm;
	import com.leyou.ui.backpack.child.MessageInputWnd;
	
	import flash.events.MouseEvent;

	public class DungeonTeam1TeamBar extends AutoSprite {

		private var nameLbl:Label;
		private var countLbl:Label;
		private var enterBtn:NormalButton;
		private var lockImg:Image;

		private var rollPower:RollNumWidget;

		public function DungeonTeam1TeamBar() {
			super(LibManager.getInstance().getXML("config/ui/dungeonTeam/dungeonTeam1TeamBar.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;

//			this.scrollRect=new Rectangle(0, 0, 456, 446);
		}

		private function init():void {
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.countLbl=this.getUIbyID("countLbl") as Label;
			this.enterBtn=this.getUIbyID("enterBtn") as NormalButton;
			this.lockImg=this.getUIbyID("lockImg") as Image;

			this.rollPower=new RollNumWidget();
			this.rollPower.loadSource("ui/num/{num}_zdl.png");
			this.addChild(this.rollPower);
			this.rollPower.x=119
			this.rollPower.y=43;

			this.rollPower.alignLeft();

			this.enterBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(e:MouseEvent):void {

			if (this.nameLbl.text != "" && this.nameLbl.text != null) {
				if (UIManager.getInstance().teamCopyWnd.myTeamName != "") {
					PopupManager.showConfirm(TableManager.getInstance().getSystemNotice(6610).content, function():void {
						if (lockImg.visible) {
							UIManager.getInstance().messageBoxWnd.showPanel(-1, 1, [nameLbl.text]);
						} else {
							Cmd_CpTm.cmTeamCopyAdd(nameLbl.text);
						}
					}, null, false, "teamCopyChange");
				} else {
					if (lockImg.visible) {
						UIManager.getInstance().messageBoxWnd.showPanel(-1, 1, [this.nameLbl.text]);
					} else {
						Cmd_CpTm.cmTeamCopyAdd(nameLbl.text);
					}
				}
			}
		}

		/**
		 *lname -- 队伍队长名字
			people -- 队伍人数
		  mzdl   -- 战斗力需求
		  tst   -- 进入是否需要密码（0不需要 ，1需要）
		 * @param o
		 *
		 */
		public function updateInfo(o:Object,level:int, count:int):void {
			this.nameLbl.text="" + o[0];
			this.countLbl.text="(" + (o[1] + "/4") + ")";
			this.rollPower.setNum(int(o[2]));

			this.lockImg.visible=(o[3] == 1);

			if (Core.me.info.level<level  || UIManager.getInstance().roleWnd.getPower() < int(o[2]) || o[0] == UIManager.getInstance().teamCopyWnd.myTeamName || count <= 0)
				this.enterBtn.setActive(false, .6, true);
			else
				this.enterBtn.setActive(true, 1, true);

		}

	}
}
