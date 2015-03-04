package com.leyou.ui.tips {


	import com.ace.ICommon.ITip;
	import com.ace.config.Core;
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.playerSkill.TipSkillInfo;
	import com.leyou.ui.tips.childs.TipsSkillGrid;

	public class TipsSkillTip extends AutoSprite implements ITip {
		// 最大高度
		private static const TIP_HEIGHT_MAX:int=238;

		// 文本显示最大高度
		private static const TEXT_HEIGHT_MAX:int=75;

		private var bg:ScaleBitmap;

		private var nameLbl:Label;

		private var desLbl:Label;

		private var costLbl:Label;

		private var timeLbl:Label;

		private var openLevelLbl:Label;

		private var levelLbl:Label;

		private var runeLbl:Label;
		
		private var autoLbl:Label;

		private var lineImg:Image;

		private var grid:TipsSkillGrid;

		public function TipsSkillTip() {
			super(LibManager.getInstance().getXML("config/ui/tips/TipsSkillWnd.xml"));
			init();
		}

		/**
		 * <T>初始化</T>
		 *
		 */
		private function init():void {
			bg=getUIbyID("bg") as ScaleBitmap;
			nameLbl=getUIbyID("nameLbl") as Label;
			desLbl=getUIbyID("desLbl") as Label;
			costLbl=getUIbyID("costLbl") as Label;
			timeLbl=getUIbyID("timeLbl") as Label;
			openLevelLbl=getUIbyID("openLevelLbl") as Label;
			runeLbl=getUIbyID("runeLbl") as Label;
			levelLbl=getUIbyID("levelLbl") as Label;
			lineImg=getUIbyID("lineImg") as Image;
			autoLbl=getUIbyID("autoLbl") as Label;
			desLbl.wordWrap=true;
			desLbl.multiline=true;
			grid=new TipsSkillGrid();
			grid.gridType=ItemEnum.TYPE_GRID_SKILL;
			grid.x=16;
			grid.y=16;
			addChild(grid);
		}

		/**
		 * <T>更新信息</T>
		 * @param info 信息
		 */
		public function updateInfo(info:Object):void {
			var tipInfo:TipSkillInfo=info as TipSkillInfo;
			var skill:TSkillInfo=tipInfo.skillInfo;
			nameLbl.text=skill.name;
			desLbl.htmlText=skill.des;
			costLbl.text=skill.getMpCost(tipInfo.level) + "";
			timeLbl.text=(skill.cdTime / 1000) + "秒";
			autoLbl.visible=(1 == skill.auto);
			var id:int = int(skill.id);
			openLevelLbl.text=TableManager.getInstance().getSkillById(id - id%4).autoLv + "级开启";

			if (Core.me.info.level < int(skill.autoLv))
				openLevelLbl.textColor=0xff0000;
			else
				openLevelLbl.textColor=0xffffff;

//			runeLbl.visible=false; //(tipInfo.runde == 0); // !tipInfo.hasRune;
			runeLbl.visible = (tipInfo.runde == 0);
			grid.updataInfo(skill);
			correct();
		}
		
		public function get isFirst():Boolean{
			return false;
		}

		/**
		 * <T>调整TIP的大小</T>
		 *
		 */
		private function correct():void {
			lineImg.y=desLbl.y + desLbl.height + 10;
			levelLbl.y=lineImg.y + lineImg.height + 10;
			runeLbl.y=levelLbl.y + levelLbl.height;
			autoLbl.y=levelLbl.y;
			bg.setSize(bg.width, runeLbl.y + runeLbl.height + 10);
		}
	}
}
