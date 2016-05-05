package com.leyou.ui.tips {

	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.ace.utils.StringUtil;
	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class FcmTips extends AutoWindow {

		private var descLbl:TextArea;
		private var confirmBtn:NormalButton;

		public function FcmTips() {
			super(LibManager.getInstance().getXML("config/ui/tips/fcmTips.xml"));
			this.init();
			this.hideBg();
		}

		private function init():void {
			this.descLbl=this.getUIbyID("descLbl") as TextArea;
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.descLbl.visibleOfBg=false;
			
			this.reSize();
// 			this.clsBtn.y=-5;
//			this.clsBtn.x=195;
			this.allowDrag=false;
		}

		private function onClick(e:MouseEvent):void {
			navigateToURL(new URLRequest(TableManager.getInstance().getSystemNotice(9707).content), "_self");
		}

		public function updateInfo(ctx:String, isfcm:Boolean=false):void {
			this.show();
			this.reSize();
			this.descLbl.setHtmlText(ctx + "");
			this.confirmBtn.visible=isfcm;
		}

		public function reSize():void {
			this.x=UIEnum.WIDTH - 220;
			this.y=UIEnum.HEIGHT - 253
		}


	}
}
