package com.leyou.ui.role.child {

	import com.ace.config.Core;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.UIManager;
	import com.leyou.data.role.RoleInfo;
	import com.leyou.ui.role.child.children.PropertyNum;
	import com.leyou.ui.role.child.children.RoleEquip;
	
	import flash.display.Sprite;

	public class PropertyWnd extends Sprite {

		private var roleEquip:RoleEquip;
//		private var propertyNum:PropertyNum;

		private var bodyEquipLen:int=0;
		
		private var otherPlayer:Boolean=false;

		public function PropertyWnd(otherPlayer:Boolean=false) {
			this.init();
			this.otherPlayer=otherPlayer;
		}

		private function init():void {

			this.roleEquip=new RoleEquip();

			this.roleEquip.x=-10;
			this.roleEquip.y=3;

			this.addChild(this.roleEquip);

			this.x=13;
			this.y=0;
			
//			this.opaqueBackground=0xff0000;
//			UIManager.getInstance().roleWnd.avatarSpr.addChild(this.bigAvatar);
		}


		public function updateInfo(info:RoleInfo):void {
			this.roleEquip.updateInfo(info,this.otherPlayer);
		}

		public function updateEquip(otherPlayer:Boolean=false):void {
			this.roleEquip.updateEquip(otherPlayer);
			UIManager.getInstance().backpackWnd.refresh();
		}

		public function deleteEquip(pos:int):void {

			this.roleEquip.deleteEquip(pos);
		}
	}
}
