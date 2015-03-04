package com.leyou.ui.dungeonTeam {


	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TDungeon_Base;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.TimerManager;

	public class DungeonTeamStart extends AutoWindow {

		private var imgUrl:Array=["ui/num/0_lz.png"];

		private var type:int=0;
		private var timeImg:Image;
		private var time:int=0;

		private var nameLbl:Label;
		private var numImg:Image;


		public function DungeonTeamStart() {
			super(LibManager.getInstance().getXML("config/ui/dungeonTeam/dungeonTeamStart.xml"));
			this.init();
			this.hideBg();
			this.clsBtn.visible=false;
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.numImg=this.getUIbyID("numImg") as Image;

		}

		/**
		 *
		 * @param num 时间数
		 * @param type 自定义类型
		 *
		 */
		public function showPanel(num:int, id:int):void {
			var cinfo:TDungeon_Base=TableManager.getInstance().getGuildCopyInfo(id);
			if (cinfo == null)
				return;

			if (this.time > 0)
				return;

			if (this.parent == null)
				LayerManager.getInstance().windowLayer.addChild(this);

			this.time=num;

			this.show(true, UIEnum.WND_LAYER_TOP, true);

			this.nameLbl.text="" + cinfo.Dungeon_Name;
			this.reSize();

			this.numImg.updateBmp(this.imgUrl[type].replace(/\d/g, this.time));
			TimerManager.getInstance().add(updateTime);
		}

		private function updateTime(i:int):void {

			if (this.time - i <= 0) {
				this.time=0;
				TimerManager.getInstance().remove(updateTime);
				this.hide();
			}

			this.numImg.updateBmp(this.imgUrl[0].replace(/\d/g, this.time - i));
		}

		public function reSize():void {

			this.x=UIEnum.WIDTH - this.width >> 1;
			this.y=UIEnum.HEIGHT - this.height >> 1;

			this.numImg.x=this.width - this.numImg.width >> 1;
			this.numImg.y=(this.height - this.numImg.height >> 1)+20;

		}
	}
}
