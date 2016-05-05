package com.leyou.ui.task.child {

	import com.ace.ICommon.IGuide;
	import com.ace.manager.LibManager;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	
	import flash.display.BitmapData;
	import flash.events.Event;

	public class TaskTrackBtn extends ImgButton{

		private var imgII:Image;
		private var numLbl:Label;

		public function TaskTrackBtn() {
			super("ui/character/btn_ccc.jpg");
			this.init();
			this.mouseEnabled=this.mouseChildren=true;
		}

		private function init():void {
			imgII=new Image("ui/mission/font_accept.png");
			this.addChild(imgII);
			imgII.x=50;
			imgII.y=10;

			this.numLbl=new Label();
			this.addChild(this.numLbl);

			this.numLbl.x=imgII.x + 85;
			this.numLbl.y=imgII.y;
		}

		/**
		 * @param _i 0, 接受; 1 继续; 2 完成
		 */
		public function updateIcon(_i:int):void {
			switch (_i) {
				case 0:
					imgII.updateBmp("ui/mission/font_accept.png", onComplete);
					break;
				case 1:
					imgII.updateBmp("ui/mission/font_continue.png", onComplete);
					break;
				case 2:
					imgII.updateBmp("ui/mission/font_finish.png", onComplete);
					break;
				case 3: //押镖
					imgII.updateBmp("ui/mission/title_lqjl.png", onComplete);
					break;
				case 4: //竞技场
					imgII.updateBmp("ui/delivery/font_zzbc.png", onComplete);
					break;
				case 5: //答题
					imgII.updateBmp("ui/question/font_ljcy.png", onComplete);
					break;
				case 6: //取消强化
					imgII.updateBmp("ui/equip/btn_qxqh.png", onComplete);
					break;
			}

		}

		public function updateIcons(url:String):void {
			imgII.updateBmp(url, onComplete);
		}

		private function onComplete(e:Image):void {
			this.imgII.x=(this.width - this.imgII.width) >> 1;
		}

		public function setNum(s:String):void {
			this.numLbl.text="" + s;
		}

//		public function removeGuide($gid:int,fun:Function):void {
//			
//			
//		}
//		
//		public function removeGuideEvent():void {
//			
//			
//		}

	}
}
