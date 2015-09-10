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
	import com.ace.utils.StringUtil;
	import com.leyou.data.playerSkill.TipSkillInfo;
	import com.leyou.ui.tips.childs.TipsSkillGrid;
	import com.leyou.utils.PropUtils;

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

//		private var levelLbl:Label;

		private var skillLvLbl:Label;

		private var nSkillLvLbl:Label;

//		private var runeLbl:Label;

//		private var autoLbl:Label;

		private var lineImg:Image;

		private var lineUImg:Image;

		private var ndesLbl:Label;

		private var conLvLbl:Label;

		private var conGoldLbl:Label;

		private var conditionLbl:Label;

		private var lvLbl:Label;

		private var goldLbl:Label;

		private var effectLbl:Label;

		private var grid:TipsSkillGrid;
		
		private var conEnergyLbl:Label;
		
		private var energyLbl:Label;

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
//			runeLbl = getUIbyID("runeLbl") as Label;
//			levelLbl = getUIbyID("levelLbl") as Label;
			lineImg=getUIbyID("lineImg") as Image;
//			autoLbl = getUIbyID("autoLbl") as Label;
			skillLvLbl=getUIbyID("skillLvLbl") as Label;
			nSkillLvLbl=getUIbyID("nSkillLvLbl") as Label;
			lineUImg=getUIbyID("lineUImg") as Image;
			ndesLbl=getUIbyID("ndesLbl") as Label;
			conLvLbl=getUIbyID("conLvLbl") as Label;
			conGoldLbl=getUIbyID("conGoldLbl") as Label;
			conditionLbl=getUIbyID("conditionLbl") as Label;
			lvLbl=getUIbyID("lvLbl") as Label;
			goldLbl=getUIbyID("goldLbl") as Label;
			lvLbl=getUIbyID("lvLbl") as Label;
			effectLbl=getUIbyID("effectLbl") as Label;
			conEnergyLbl = getUIbyID("conEnergyLbl") as Label;
			energyLbl = getUIbyID("energyLbl") as Label;

			desLbl.wordWrap=true;
			desLbl.multiline=true;
			ndesLbl.wordWrap=true;
			ndesLbl.multiline=true;
			grid=new TipsSkillGrid();
			grid.gridType=ItemEnum.TYPE_GRID_SKILL;
			grid.x=14;
			grid.y=14;
			addChild(grid);
		}

		/**
		 * <T>更新信息</T>
		 * @param info 信息
		 */
		public function updateInfo(info:Object):void {

			var tipInfo:TipSkillInfo=info as TipSkillInfo;
			var skill:TSkillInfo=tipInfo.skillInfo;
			grid.updataInfo(skill);
			nameLbl.text=skill.name;
			costLbl.text=skill.getMpCost(tipInfo.level) + "";
			timeLbl.text=(skill.cdTime / 1000) + PropUtils.getStringById(2146);

			var id:int=int(skill.id);

			var skillInfo:TSkillInfo=TableManager.getInstance().getSkillById(id - id % 4);
			var num1:int=(skillInfo.addition1 + skillInfo.addition2 * tipInfo.skillLv) / 100;
			var num2:int=skillInfo.addition4 + skillInfo.addition3 * tipInfo.skillLv;
			desLbl.htmlText=StringUtil.substitute(skill.des, num1, num2);
			var openLv:int=skillInfo.autoLv;
			var hasNext:Boolean=((id % 4 + 1) < 4);
			if (((openLv <= Core.me.info.level) && hasNext) && !tipInfo.isPetSkill) {
				num1=(skillInfo.addition1 + skillInfo.addition2 * (tipInfo.skillLv + 1)) / 100;
				num2=skillInfo.addition4 + skillInfo.addition3 * (tipInfo.skillLv + 1);
				ndesLbl.htmlText=StringUtil.substitute(skill.des, num1, num2);
				openLevelLbl.visible=false;
				skillLvLbl.visible=true;
				nSkillLvLbl.visible=true;
				ndesLbl.visible=true;
				lineImg.visible=true;
				effectLbl.visible=true;
				conditionLbl.visible=true;
				lvLbl.visible=true;
				conLvLbl.visible=true;
				goldLbl.visible=true;
				conGoldLbl.visible=true;
				energyLbl.visible = true;
				conEnergyLbl.visible = true;
				lineUImg.y=desLbl.y + desLbl.height + 10;
				effectLbl.y=lineUImg.y + 2;
				nSkillLvLbl.y=effectLbl.y;
				ndesLbl.y=nSkillLvLbl.y + nSkillLvLbl.height;
				lineImg.y=ndesLbl.y + ndesLbl.height + 10;
				conditionLbl.y=lineImg.y + lineImg.height + 7;
				lvLbl.y=conditionLbl.y + conditionLbl.height - 2;
				goldLbl.y=lvLbl.y + lvLbl.height - 2;
				conLvLbl.y=lvLbl.y;
				conGoldLbl.y=goldLbl.y;
				conEnergyLbl.y = conGoldLbl.y;
				energyLbl.y = conGoldLbl.y;
				bg.setSize(bg.width, goldLbl.y + goldLbl.height + 10);

				skillLvLbl.text=tipInfo.skillLv + PropUtils.getStringById(1812);
				nSkillLvLbl.text=(tipInfo.skillLv + 1) + PropUtils.getStringById(1812);
				conLvLbl.text=(tipInfo.skillLv + 1) + PropUtils.getStringById(1812);
				conEnergyLbl.text=TableManager.getInstance().getSkillLvInfo(tipInfo.skillLv).energy + "";
				conGoldLbl.text=TableManager.getInstance().getSkillLvInfo(tipInfo.skillLv).money + "";
			} else {
				openLevelLbl.visible=(hasNext && !tipInfo.isPetSkill);
				openLevelLbl.text=openLv + PropUtils.getStringById(1583);
				skillLvLbl.visible=!(hasNext && !tipInfo.isPetSkill);
				skillLvLbl.text=tipInfo.skillLv + PropUtils.getStringById(1812);
				nSkillLvLbl.visible=false;
				ndesLbl.visible=false;
				lineImg.visible=false;
				effectLbl.visible=false;
				conditionLbl.visible=false;
				lvLbl.visible=false;
				conLvLbl.visible=false;
				energyLbl.visible = false;
				conEnergyLbl.visible = false;
				goldLbl.visible=false;
				conGoldLbl.visible=false;
//				conLvLbl.text = openLv+"";
//				conGoldLbl.text = TableManager.getInstance().getSkillLvInfo(openLv).money+"";
				lineUImg.y=desLbl.y + desLbl.height + 10;
//				conditionLbl.y = lineUImg.y + lineUImg.height + 7;
//				lvLbl.y = conditionLbl.y + conditionLbl.height - 2;
//				goldLbl.y = lvLbl.y + lvLbl.height - 2;
//				conLvLbl.y = lvLbl.y;
//				conGoldLbl.y = goldLbl.y;
				bg.setSize(bg.width, lineUImg.y + lineUImg.height + 10);
			}


//			autoLbl.visible = (1 == skill.auto);
//			if (Core.me.info.level < int(skill.autoLv)){
//				openLevelLbl.textColor = 0xff0000;
//			}else{
//				openLevelLbl.textColor = 0xffffff;
//			}
//			runeLbl.visible = false; //(tipInfo.runde == 0); // !tipInfo.hasRune;
//			runeLbl.visible = (tipInfo.runde == 0);
//			correct();
		}
		
		public function get isFirst():Boolean {
			return false;
		}
		
		public override function get height():Number{
			return bg.height;
		}

		/**
		 * <T>调整TIP的大小</T>
		 *
		 */
		private function correct():void {
//			lineImg.y = desLbl.y + desLbl.height + 10;
//			levelLbl.y = lineImg.y + lineImg.height + 10;
//			runeLbl.y = levelLbl.y + levelLbl.height;
//			autoLbl.y = levelLbl.y;
//			bg.setSize(bg.width, runeLbl.y + runeLbl.height + 10);
		}
	}
}
