package com.leyou.ui.dungeonTeam.childs {

	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.net.cmd.Cmd_CpTm;
	import com.leyou.utils.PlayerUtil;

	import flash.events.MouseEvent;

	public class DungeonTeam1PlayerBar extends AutoSprite {

		private var iconImg:Image;
		private var stImg:Image;
		private var bossImg:Image;
		private var nameLbl:Label;
		private var lvLbl:Label;
		private var powerLbl:Label;

		private var killBtn:NormalButton;

		private var bossName:String;

		public function DungeonTeam1PlayerBar() {
			super(LibManager.getInstance().getXML("config/ui/dungeonTeam/dungeonTeam1PlayerBar.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;

//			this.scrollRect=new Rectangle(0, 0, 456, 446);
		}

		private function init():void {
			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.stImg=this.getUIbyID("stImg") as Image;
			this.bossImg=this.getUIbyID("bossImg") as Image;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.powerLbl=this.getUIbyID("powerLbl") as Label;

			this.killBtn=this.getUIbyID("killBtn") as NormalButton;

			this.killBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(e:MouseEvent):void {
			if (this.nameLbl.text != "" && this.nameLbl.text != null) {
				if (this.bossName == MyInfoManager.getInstance().name)
					Cmd_CpTm.cmTeamCopyTeamKill(this.nameLbl.text);
				else {
					Cmd_CpTm.cmTeamCopyPrepare((this.stImg.visible ? 0 : 1));
				}
			}
		}

		/**
		 * name -- 玩家名字
			 vocation --职业
			 gender  -- 性别
			 level   -- 等级
			 zdl     -- 玩家战斗力
			 ready   -- 是否已准备 （0未准备, 1已准备）
		 * @param o
		 *
		 */
		public function updateInfo(o:Array, bossName:String):void {

			this.iconImg.updateBmp(PlayerUtil.getPlayerFullHeadImg(o[1], o[2]));

			if (o[5] == 1) {
				this.stImg.visible=true;
			} else {
				this.stImg.visible=false;
			}

			this.bossName=bossName;

			if (bossName == o[0]) {
				this.bossImg.visible=true;
				this.killBtn.visible=false;
				this.stImg.visible=false;
			} else {
				this.bossImg.visible=false;
				this.killBtn.visible=true;
			}


			if (bossName != o[0]) {

				if (MyInfoManager.getInstance().name == bossName) {
					this.killBtn.visible=true;
					this.killBtn.text="踢出";
				} else if (MyInfoManager.getInstance().name != o[0]) {
					this.killBtn.visible=false;
				} else if (MyInfoManager.getInstance().name == o[0]) {
					this.killBtn.visible=true;

					if (o[5] == 1) {
						this.killBtn.text="取消准备";
					} else {
						this.killBtn.text="准备";
					}
				}


			}


			this.nameLbl.text="" + o[0];
			this.lvLbl.text="LV." + o[3];
			this.powerLbl.text="战斗力：" + o[4];

		}

	}
}
