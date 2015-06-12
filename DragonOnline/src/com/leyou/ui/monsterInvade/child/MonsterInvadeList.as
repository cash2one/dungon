package com.leyou.ui.monsterInvade.child {

	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.PropUtils;

	public class MonsterInvadeList extends AutoSprite {

		private var nameLbl:Label;
		private var damLbl:Label;
		private var iconImg:Image;

		public function MonsterInvadeList() {
			super(LibManager.getInstance().getXML("config/ui/monsterInvade/monsterInvadeList.xml"));
			this.init();
			this.mouseEnabled=true;
		}

		private function init():void {
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.damLbl=this.getUIbyID("damLbl") as Label;

			this.iconImg=this.getUIbyID("iconImg") as Image;
		}

		public function updateInfo(o:Object):void {
			this.nameLbl.text="" + o[0];
			this.nameLbl.filters=[FilterUtil.showBorder(0x000000)]
			var mstr:String="";

			if (int(o[1]) > 100000000) {
				mstr=int(int(o[1]) / 100000000) + PropUtils.getStringById(1531);
			} else if (int(o[1]) > 10000) {
				mstr=int(int(o[1]) / 10000) + PropUtils.getStringById(1532);
			} else {
				if (int(o[1]) != 0)
					mstr=int(o[1]) + "";
			}

			this.damLbl.text="" + mstr;
			this.damLbl.setToolTip(PropUtils.getStringById(1795) + o[1]);
		}

		public function setIconState(v:Boolean):void {
			this.iconImg.visible=v;
		}

		override public function get height():Number {
			return 28;
		}

	}
}
