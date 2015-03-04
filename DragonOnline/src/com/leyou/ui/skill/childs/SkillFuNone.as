package com.leyou.ui.skill.childs {

	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.FilterUtil;

	public class SkillFuNone extends AutoSprite {

		private var nameLbl:Label;

		private var fuwenImg1:Image;
		private var bgImg:Image;

		public var state:Boolean=false;

		public function SkillFuNone() {
			super(LibManager.getInstance().getXML("config/ui/skill/skillFuNone.xml"));
			this.init();
			this.mouseEnabled=true;
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;

			this.fuwenImg1=this.getUIbyID("fuwenImg1") as Image;
			this.bgImg=this.getUIbyID("bgImg") as Image;

		}

		public function updateInfo(arr:Object):void {

		}

		public function set hight(v:Boolean):void {

			if (v) {
				this.bgImg.updateBmp("ui/skill/skill_fuwen_over.jpg");
			} else {
				if (!this.state)
					this.bgImg.updateBmp("ui/skill/skill_fuwen_out.jpg");
			}
			
		}


	}
}
