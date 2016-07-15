package com.leyou.ui.arena.childs {


	import com.ace.enum.UIEnum;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.net.cmd.Cmd_Arena;

	import flash.events.MouseEvent;

	public class ArenaFinish extends AutoWindow {

		private var goldLbl:Label;
		private var expLbl:Label;
		private var soulLbl:Label;
		private var integralLbl:Label;
		private var stateImg:Image;

		private var confirmBtn:ImgButton;

		public function ArenaFinish() {
			super(LibManager.getInstance().getXML("config/ui/arena/arenaFinish.xml"));
			this.init();
			this.hideBg();
			this.clsBtn.visible=false;
			this.allowDrag=false;
		}

		private function init():void {

			this.goldLbl=this.getUIbyID("goldLbl") as Label;
			this.expLbl=this.getUIbyID("expLbl") as Label;
			this.soulLbl=this.getUIbyID("soulLbl") as Label;
			this.integralLbl=this.getUIbyID("integralLbl") as Label;
			this.stateImg=this.getUIbyID("stateImg") as Image;

			this.confirmBtn=this.getUIbyID("confirmBtn") as ImgButton;
			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(e:MouseEvent):void {
			Cmd_Arena.cm_ArenaQuit();
			this.hide();
		}


		/**
		 *-- fresult   战斗结果 (1胜利 0失败 )
		  -- money     金币
		  -- exp       经验
		  -- energy    魂力
		  -- fscore    积分(失败为负)
		 * @param o
		 *
		 */
		public function showPanel(o:Object):void {
			this.show();

			this.x=UIEnum.WIDTH - this.width >> 1;
			this.y=UIEnum.HEIGHT - this.height >> 1;

			this.goldLbl.text=o.money + "";
//			this.expLbl.text=o.exp + "";
			this.expLbl.text=o.honour + "";
			this.soulLbl.text=o.energy + "";
			this.integralLbl.text=o.fscore + "";

			if (o.fresult == 1) {
				this.stateImg.updateBmp("ui/arena/title_sl.png");
			} else {
				this.stateImg.updateBmp("ui/arena/title_sb.png");
			}
		}

		override public function get height():Number {
			return 219;
		}
		
		override public function get width():Number {
			return 542;
		}

	}
}
