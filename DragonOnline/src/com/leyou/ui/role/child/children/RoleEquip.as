package com.leyou.ui.role.child.children {

	import com.ace.enum.LibEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.data.role.RoleInfo;
	import com.leyou.utils.ColorUtil;
	
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.utils.flash_proxy;

	public class RoleEquip extends AutoSprite {

		private var thetitleLbl:Label;

		private var fightKeyLbl:Label;
		private var playerImg:Image;
		
		private var bgeff:SwfLoader;

//		private var fightkey:Bitmap;
		private var rollPower:RollNumWidget;

		public function RoleEquip() {
			super(LibManager.getInstance().getXML("config/ui/role/RoleEquipWnd.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.fightKeyLbl=this.getUIbyID("fightKeyLbl") as Label;
			this.playerImg=this.getUIbyID("playerImg") as Image;
			
			this.scrollRect=new Rectangle(0,0,332,446);
			
//			this.fightkey=new Bitmap();
//			this.addChild(this.fightkey);
//			this.fightkey.x=this.fightKeyLbl.x;
//			this.fightkey.y=this.fightKeyLbl.y + 10;

			this.rollPower=new RollNumWidget();
			this.rollPower.loadSource("ui/num/{num}_zdl.png");
			this.addChild(this.rollPower);
			this.rollPower.x=this.fightKeyLbl.x;
			this.rollPower.y=this.fightKeyLbl.y + 12;

//			this.rollPower.visibleOfBg=false;
			this.rollPower.alignCenter();

//			this.y=3;
//			this.x=300;
		}

		public function updateInfo(info:RoleInfo, otherPlayer:Boolean=false):void {
			
//			this.fightkey.bitmapData=ColorUtil.getBitmapDataByInt(info.fight + "");
//			this.fightkey.x=270-this.fightkey.width>>1;

			if (this.rollPower.number != info.fight) {
				
				this.rollPower.alignCenter();
				
				if (otherPlayer) {
					this.rollPower.setNum(info.fight);
				} else {
					this.rollPower.rollToNum(info.fight);
					NoticeManager.getInstance().rollToPower(info.fight);
				}

				this.rollPower.x=317 - info.fight.toString().length*15 >> 1;
			}
			
		}

		public function updateEquip(otherPlayer:Boolean=false):void {

			 
		}

		public function deleteEquip(pos:int):void {
			 
			
		}

	}
}
