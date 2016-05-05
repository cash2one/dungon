package com.leyou.ui.v3exp {


	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.leyou.net.cmd.Cmd_V3Exp;
	import com.leyou.utils.PayUtil;

	import flash.events.MouseEvent;

	public class V3ExpWnd extends AutoWindow {

		private var vtitleImg:Image
		private var vsubjectImg:Image

		private var iconBtnImg:Image
		private var confirmBtn:ImgButton

		private var isok:Boolean=false;

		public function V3ExpWnd() {
			super(LibManager.getInstance().getXML("config/ui/v3exp/v3ExpWnd.xml"));
			this.init();
			this.hideBg();
			this.mouseChildren=true;
		}

		private function init():void {

			this.vtitleImg=this.getUIbyID("vtitleImg") as Image;
			this.vsubjectImg=this.getUIbyID("vsubjectImg") as Image;
			this.iconBtnImg=this.getUIbyID("iconBtnImg") as Image;

			this.confirmBtn=this.getUIbyID("confirmBtn") as ImgButton;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);
			
			this.clsBtn.x-=50;
			this.clsBtn.y+=30;
		}

		private function onClick(e:MouseEvent):void {
			if (!this.isok)
				Cmd_V3Exp.cmV3expGet();
			else
				PayUtil.openPayUrl();
			
			this.hide()
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);


		}

		public function setNoGet():void {

			this.vtitleImg.updateBmp("ui/v3/font_v3zfgq.png");
			this.vsubjectImg.updateBmp("ui/v3/font_njsq.png");
			this.iconBtnImg.updateBmp("ui/v3/font_ljxf.png");
			isok=true;
		}

	}
}
