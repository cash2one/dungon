package com.leyou.ui.tips {
	import com.ace.ICommon.ITip;
	import com.ace.config.Core;
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.playerSkill.TipSkillInfo;
	import com.leyou.ui.tips.childs.TipsSkillGrid;
	import com.leyou.utils.PropUtils;

	public class TipsRuneTip extends AutoSprite implements ITip {
		private var bg:ScaleBitmap;

		private var nameLbl:Label;

		private var levelLbl:Label;

		private var desLbl:Label;

		private var lineImg:Image;

		private var useImg:Image;

		private var grid:TipsSkillGrid;

		public function TipsRuneTip() {
			super(LibManager.getInstance().getXML("config/ui/tips/TipsSkillFuWnd.xml"));
			init();
		}

		/**
		 * <T>初始化</T>
		 *
		 */
		private function init():void {
			bg=getUIbyID("bg") as ScaleBitmap;
			nameLbl=getUIbyID("nameLbl") as Label;
			levelLbl=getUIbyID("levelLbl") as Label;
			desLbl=getUIbyID("desLbl") as Label;
			lineImg=getUIbyID("lineImg") as Image;
			useImg=getUIbyID("useImg") as Image;
			desLbl.wordWrap=true;
			desLbl.multiline=true;
			grid=new TipsSkillGrid();
			grid.gridType=ItemEnum.TYPE_GRID_RUNE;
			grid.x=12;
			grid.y=12;
			addChild(grid);
		}

		public function get isFirst():Boolean {
			return false;
		}

		/**
		 * <T>更新信息</T>
		 *
		 * @param info 信息
		 *
		 */
		public function updateInfo(info:Object):void {
			var tipInfo:TipSkillInfo=info as TipSkillInfo;
			var skill:TSkillInfo=tipInfo.skillInfo;
			nameLbl.text=skill.runeName;
			desLbl.htmlText=skill.runeDes;
			levelLbl.text=skill.autoLv + PropUtils.getStringById(1583);

			if (tipInfo.skillLv < int(skill.autoLv))
				levelLbl.textColor=0xff0000;
			else
				levelLbl.textColor=0xffffff;

			useImg.visible=(tipInfo.runde == int(skill.rune));
			grid.updataInfo(skill);
			correct();
		}

		/**
		 * <T>调整TIP的大小</T>
		 *
		 */
		private function correct():void {
			lineImg.y=desLbl.y + desLbl.height + 10;
			levelLbl.y=lineImg.y + lineImg.height + 10;
			bg.setSize(bg.width, levelLbl.y + levelLbl.height + 10);
		}
	}
}
