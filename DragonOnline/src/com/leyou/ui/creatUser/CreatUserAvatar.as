package com.leyou.ui.creatUser {
	import com.ace.enum.FilterEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPnfInfo;
	import com.ace.ui.img.child.Image;
	
	import flash.geom.Point;

	public class CreatUserAvatar extends BigAvatar {
		public var info:XML;
		public var img:Image;

		public function CreatUserAvatar() {
			super();

			this.init();
		}

		private function init():void {
			this.img=new Image();
//			this.img.x=0, this.img.y=40;
			this.img.visible=false;

			this.addChild(img);
		}

		private function get bodyPnfId():int {
			return this.avatarsId[1];
		}

		override public function isOpacity():Boolean {
			var pt:Point=this.globalToLocal(new Point(this.stage.mouseX, this.stage.mouseY));
			var pnfInfo:TPnfInfo=TableManager.getInstance().getPnfInfo(this.body.currentPnfId);

			if (Math.abs(pt.x * this.scaleX) < pnfInfo.width && pt.y < 0 && Math.abs(pt.y * this.scaleY) < (2 * pnfInfo.radius)) {
				return true;
			}
			return false;
		}

		public function set lighten(value:Boolean):void {
			if (value) {
				this.filters=[];
				this.playAct(PlayerEnum.ACT_STAND, PlayerEnum.DIR_S, true);
			} else {
				this.filters=[FilterEnum.enable];
				this.stop();
			}

			this.img.visible=value;
		}

		override public function onOver():void {
			super.onOver();
			this.lighten=true;
		}

		override public function cancelOver():void {
			super.cancelOver();
			this.lighten=false;
		}

		override protected function sortAvtIndex(dir:int):void {
			super.sortAvtIndex(dir);
			this.addChild(img);
		}
	}
}
