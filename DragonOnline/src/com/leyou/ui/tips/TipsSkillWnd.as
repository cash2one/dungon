package com.leyou.ui.tips {


	import com.ace.enum.ItemEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.leyou.data.playerSkill.SkillInfo;
	import com.leyou.ui.skill.childs.SkillGrid;
	import com.leyou.utils.PropUtils;

	public class TipsSkillWnd extends AutoWindow {

		private var skillLbl:Label;
		private var runeLbl:Label;

		private var runeActLbl:Label;
		private var getFuncLbl:Label;

		private var desLbl:Label;
		private var des1Lbl:Label;

		private var skillgrid:SkillGrid;
		private var runegrid:SkillGrid;

		public function TipsSkillWnd() {
			super(LibManager.getInstance().getXML("config/ui/tips/TipsSkillWnd.xml"));
			this.init();
			this.hideBg();
			this.clsBtn.visible=false;
		}

		private function init():void {
			return ;
			this.skillLbl=this.getUIbyID("skillLbl") as Label;
			this.runeLbl=this.getUIbyID("runeLbl") as Label;

			this.runeActLbl=this.getUIbyID("runeActLbl") as Label;
			this.getFuncLbl=this.getUIbyID("getFuncLbl") as Label;

			this.desLbl=this.getUIbyID("desLbl") as Label;
			this.des1Lbl=this.getUIbyID("des1Lbl") as Label;

			this.skillgrid=new SkillGrid();
			this.addChild(this.skillgrid);

			this.skillgrid.gridType=ItemEnum.TYPE_GRID_SKILL
			this.skillgrid.x=10;
			this.skillgrid.y=30;

			this.runegrid=new SkillGrid();
			this.addChild(this.runegrid);
			this.runegrid.gridType=ItemEnum.TYPE_GRID_RUNE
			this.runegrid.x=20;
			this.runegrid.y=110;

			this.runegrid.hidBg();
			
			this.des1Lbl.wordWrap=true;
			this.desLbl.wordWrap=true;

			this.des1Lbl.width=152;
			this.des1Lbl.height=63;
			this.desLbl.width=152;
			this.desLbl.height=63;
		}

		/**
		 * @param id id
		 * @param pos 位置
		 */
		public function updateInfo(id:int, pos:int):void {

			var skilldata:SkillInfo=MyInfoManager.getInstance().skilldata;
			var arr:Array=skilldata.skillItems[id];

			var skillvec:Vector.<TSkillInfo>=TableManager.getInstance().getSkill(arr[1] as int);

			var _pos:int=pos+2;

			var skill:TSkillInfo=skillvec[pos];

			this.skillLbl.text=skillvec[0].name + "";
			this.runeLbl.text=skill.runeName;

			switch (arr[_pos]) {
				case 0:
					this.runeActLbl.textColor=0xaaaaaa;
					this.runeActLbl.text=PropUtils.getStringById(1946);
					break;
				case 1:
					this.runeActLbl.textColor=0xffd700;
					this.runeActLbl.text=PropUtils.getStringById(1947);
					break;
				case 2:
					this.runeActLbl.textColor=0x6abd18;
					this.runeActLbl.text=PropUtils.getStringById(1948);
					break;
			}

			this.getFuncLbl.text="";
			this.desLbl.text=skillvec[0].skillDes;
			this.des1Lbl.text=skill.runeDes;

			this.skillgrid.updataInfo(skillvec[0]);
			this.runegrid.updataInfo(skill);

		}

		public function showPane():void {


		}

	}
}
