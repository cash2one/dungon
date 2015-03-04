package com.leyou.ui.pkCopy.child {

	import com.ace.config.Core;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TTzActiive;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.leyou.enum.PkCopyEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.net.cmd.Cmd_Act;
	import com.leyou.ui.task.child.TaskTrackBtn;

	import flash.events.MouseEvent;

	public class DungeonTZPanel extends AutoWindow {

		private var mvImg:Image;
		private var titleImg:Image;

		private var descTxt:TextArea;
		private var requirTxt:TextArea;
		private var rewardTxt:TextArea;
		private var timeLbl:Label;
		private var titleNameLbl:Label;

		private var accpetBtn:TaskTrackBtn;

		private var actid:int=0;
		private var serverId:int=0;

		public function DungeonTZPanel() {
			super(LibManager.getInstance().getXML("config/ui/pkCopy/dungeonTZPanel.xml"));
			this.init();
			this.hideBg();
			this.clsBtn.y-=10;
		}

		private function init():void {

			this.mvImg=this.getUIbyID("mvImg") as Image;
			this.titleImg=this.getUIbyID("titleImg") as Image;

			this.descTxt=this.getUIbyID("descTxt") as TextArea;
			this.requirTxt=this.getUIbyID("requirTxt") as TextArea;
			this.rewardTxt=this.getUIbyID("rewardTxt") as TextArea;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			this.titleNameLbl=this.getUIbyID("titleNameLbl") as Label;

			this.descTxt.visibleOfBg=false;
			this.requirTxt.visibleOfBg=false;
			this.rewardTxt.visibleOfBg=false;

			this.accpetBtn=new TaskTrackBtn();
			this.addChild(this.accpetBtn);
			this.accpetBtn.updateIcon(5);

			this.accpetBtn.x=this.width - this.accpetBtn.width >> 1;
			this.accpetBtn.y=this.height - this.accpetBtn.height - 10;

			this.accpetBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(e:MouseEvent):void {

			if (this.serverId == 0) {
				UIManager.getInstance().openWindow(WindowEnum.EXPCOPY);
				this.hide();
				return;
			}

			Cmd_Act.cmActNowAccept(this.actid);
			this.hide();
		}

		public function updateInfo(o:Object):void {

//			Cmd_Act.cmActInit();
			this.descTxt.setText("");
			this.requirTxt.setText("");
			this.rewardTxt.setText("");
			this.timeLbl.text="";

//			this.lastTime(o.actid);
			this.actid=o.actid;

			var tinfo:TTzActiive=TableManager.getInstance().getTzActiveByID(o.actid);

			if (tinfo == null)
				return;

			if (Core.me == null || tinfo.lv > Core.me.info.level)
				return;

			if (MapInfoManager.getInstance().type != SceneEnum.SCENE_TYPE_PTCJ && MapInfoManager.getInstance().type != tinfo.clientId) {
				return;
			}

			this.serverId=tinfo.serverId;

			this.titleImg.updateBmp("ui/tz/" + tinfo.nameImage);
			this.mvImg.updateBmp("ui/tz/" + tinfo.bImage);

			this.timeLbl.text=tinfo.time.replace("|", "\-").replace(/(\d?\d):(\d\d):(\d\d)/, "$1:$2").replace(/(\d?\d):(\d\d):(\d\d)/, "$1:$2");
			this.descTxt.setText("" + tinfo.des2);
			this.requirTxt.setText("" + tinfo.des3);
			this.rewardTxt.setText("" + tinfo.des4);

			if (tinfo.serverId == 1) {
				this.show();
//				UIManager.getInstance().rightTopWnd.active("questBtn")
			} else if (tinfo.serverId == 0) {
				if (1 == o.state) {
					var wc:String="双倍经验怪物入侵<font color='#ff00'><u><a href='event:other_doubleExp--doubleExp'>立即参与</a></u></font>"
					var arr:Array=["[双倍]", wc, "", "", callback];
					UIManager.getInstance().taskTrack.updateOhterTrack(TaskEnum.taskLevel_doubleLine, arr);

					this.show();
				} else {
					UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_doubleLine);
				}
			} else
				this.show();

			this.reSize();
		}

		public function reSize():void {
			this.x=UIEnum.WIDTH - this.width >> 1;
			this.y=UIEnum.HEIGHT - this.height >> 1;
		}

		private function callback(tag:String):void {
			UILayoutManager.getInstance().open(WindowEnum.EXPCOPY);
		}

	}
}
