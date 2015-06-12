package com.leyou.ui.skill.childs {

	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.leyou.utils.FilterUtil;

	public class SkillFuBar extends AutoSprite {

		private var nameLbl:Label;
		private var lvLbl:Label;
		private var desLbl0:Label;
		private var descLbl:TextArea;

		private var bgImg:Image;
		private var fuwenImg1:Image;

		/**
		 *0 --未获得,1 --未激活 ,2 --已激活
		 */
		private var _state:int=1;

		public var index:int=0;

		public function SkillFuBar() {
			super(LibManager.getInstance().getXML("config/ui/skill/skillFuBar.xml"));
			this.init();
			this.mouseEnabled=true;
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.desLbl0=this.getUIbyID("desLbl0") as Label;
			this.descLbl=this.getUIbyID("descLbl") as TextArea;

			this.descLbl.visibleOfBg=false;

			this.fuwenImg1=this.getUIbyID("fuwenImg1") as Image;
			this.bgImg=this.getUIbyID("bgImg") as Image;

		}

		public function updateInfo(info:TSkillInfo):void {
			this.nameLbl.text="" + info.runeName;

			if (info.autoLv == 0) {
				this.lvLbl.text="套装解锁";
				this.desLbl0.visible=false;
			} else {
				this.desLbl0.visible=true;
				this.lvLbl.text="" + info.autoLv;
			}

			this.descLbl.setText("" + info.runeDes);

			this.fuwenImg1.updateBmp("ico/skills/" + info.runeIcon + ".png");

			//重置状态
			this.resetState();
		}

		public function set enable(v:Boolean):void {

			if (v) {
				this.filters=[];
			} else {
				this.filters=[FilterUtil.enablefilter];
			}
		}

		public function set hight(v:Boolean):void {
			if (this._state == 0 || this._state == 2)
				return;

			if (v) {
				this.bgImg.updateBmp("ui/skill/skill_fuwen_over.jpg");
			} else {
				this.bgImg.updateBmp("ui/skill/skill_fuwen_out.jpg");
			}
		}

		public function resetState():void {
			this._state=1;
			this.hight=false;
		}

		public function set active(s:int):void {
			switch (s) {
				case 0:
					this.enable=false;
					break;
				case 1:
					this.enable=true;
					break;
				case 2:
					this.enable=true;
					this.hight=true;
					break;
			}

			_state=s;
		}


		public function get state():int {
			return this._state;
		}

		override public function get height():Number {
			return 86;
		}


	}
}
