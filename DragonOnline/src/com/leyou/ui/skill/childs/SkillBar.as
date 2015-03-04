package com.leyou.ui.skill.childs {

	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.FilterUtil;

	public class SkillBar extends AutoSprite {

		private var nameLbl:Label;
		private var lvLbl:Label;

		private var fuwenImg1:Image;
		private var bgImg:Image;

		private var grid:SkillGrid;

		private var state:Boolean=false;
		
		public function SkillBar() {
			super(LibManager.getInstance().getXML("config/ui/skill/skillBar.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.fuwenImg1=this.getUIbyID("fuwenImg1") as Image;
			this.bgImg=this.getUIbyID("bgImg") as Image;

			this.grid=new SkillGrid();
			this.addChild(this.grid);

			this.grid.x=17;
			this.grid.y=14;
			
//			this.grid.mouseChildren=false;
//			this.grid.mouseEnabled=false;

		}

		/**
		 * @param arr
		 */
		public function updateInfo(arr:Array):void {

			var skill:Array=TableManager.getInstance().getSkillArr(arr[1]);
			skill.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);
			
			this.nameLbl.text="" + skill[0].name;
			this.lvLbl.text="" + skill[0].autoLv;

			if (arr.indexOf(2, 3) != -1)
				this.fuwenImg1.updateBmp("ico/skills/" + skill[arr.indexOf(2, 3) - 2].runeIcon + ".png");
			else
				this.fuwenImg1.updateBmp("ui/skill/icon_fu_0.png");

			this.grid.updataInfo(skill[0]);
		}
		
		public function setAutoMagicEffect(v:Boolean):void{
			this.grid.setMagicEffect(v);
		}

		/**
		 * @param v
		 */		
		public function set hight(v:Boolean):void {
			
			if(this.state)
				return ;
			
			if (v)
				this.bgImg.updateBmp("ui/skill/skill_information_over.jpg");
			else
				this.bgImg.updateBmp("ui/skill/skill_information_out.jpg");
		}

		/**
		 * 
		 * @param v
		 * 
		 */		
		public function set enable(v:Boolean):void {

//			this.mouseChildren=this.mouseEnabled=!v;

			this.state=v;
			if (v) {
				this.filters=[FilterUtil.enablefilter];
			} else {
				this.filters=[];
			}
		}


	}
}
