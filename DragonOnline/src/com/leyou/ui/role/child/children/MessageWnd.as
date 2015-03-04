package com.leyou.ui.role.child.children {

	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.ace.utils.FileUtil;
	import com.leyou.ui.team.TeamWnd;
	import com.leyou.utils.FilterUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class MessageWnd extends AutoWindow {

		private var sureBtn:NormalButton;
		private var cancleBtn:NormalButton;
		private var text:TextArea;
		private var titleNameLbl:Label;
		private var f:Boolean;

		public function MessageWnd() {
			super(LibManager.getInstance().getXML("config/ui/role/Message.xml"));
			this.init();
		}

		private function init():void {
			this.sureBtn=this.getUIbyID("sureBtn") as NormalButton;
			this.cancleBtn=this.getUIbyID("cancleBtn") as NormalButton;
			this.text=this.getUIbyID("contentLbl") as TextArea;
			this.titleNameLbl=this.getUIbyID("titleNameLbl") as Label;
			
			this.sureBtn.addEventListener(MouseEvent.CLICK, this.onBtnClick);
			this.cancleBtn.addEventListener(MouseEvent.CLICK, this.onBtnClick);

			this.text.addEventListener(MouseEvent.MOUSE_OVER, this.onTextOver);
			this.text.visibleOfBg=false;
			this.hideBg();
		}

		private function onBtnClick(evt:MouseEvent):void {

			switch (evt.target.name) {
				case "sureBtn":
					if (this.f) { //需要判断是否有元素之心

						if (MyInfoManager.getInstance().getBagItemNumByName("元素之心") > 0) { //背包中有元素之心
							UIManager.getInstance().roleWnd.elementWnd.setGuildElement();
						} else { //背包中没有
							UIManager.getInstance().quickBuyWnd.open();
						}

					} else { //不需要元素之心
						if (this.titleNameLbl.text.indexOf("切换符文") > -1) {
							UIManager.getInstance().skillWnd.setChangeRune();
						} else
							UIManager.getInstance().roleWnd.elementWnd.setGuildElement();
					}
					this.hide();
					break;
				case "cancleBtn":
					this.hide();
					break;
			}

		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			if (this.isShow)
				return;

			super.show(toTop, $layer, toCenter);
		}


		public function setStr(str:String, title:String, f:Boolean=false):void {
			this.titleNameLbl.text=title + "";
			this.f=f;
			this.text.setHtmlText(str);
			this.text.filters=FilterUtil.blackStrokeFilters;
		}

		private function onTextOver(evt:MouseEvent):void {
			if (!this.text.hasEventListener(MouseEvent.MOUSE_MOVE))
				this.text.addEventListener(MouseEvent.MOUSE_MOVE, this.onTextMove);
			evt.stopPropagation();
		}

		private function onTextMove(evt:MouseEvent):void {

			var target:TextField=evt.currentTarget.tf as TextField;
			var n:int=target.getCharIndexAtPoint(target.mouseX, target.mouseY);
			if (n >= 0) {
				var url:String=target.getTextFormat(n, n + 1).url;
				if (url != null && url != "") {
					ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, int(url.split(":")[1]), new Point(evt.stageX, evt.stageY));
				}
			}
		}

//		private function onTextOut(evt:MouseEvent):void {
//			evt.stopPropagation();
//			var target:TextField=evt.target as TextField;
//			var n:int=target.getCharIndexAtPoint(target.mouseX, target.mouseY);
//			if (n >= 0) {
//				if (target.getTextFormat(n, n + 1).url) {
//					trace("out");
////					if(this.onOutFun!=null)
////						this.onOutFun();
//				}
//			}
//		}
//
//		private function onTextClick(evt:MouseEvent):void {
//			var target:TextField=evt.currentTarget as TextField;
//			var n:int=target.getCharIndexAtPoint(target.mouseX, target.mouseY);
//			if (n >= 0) {
//				var url:String=target.getTextFormat(n, n + 1).url;
//				if (url != null && url != "") {
//					trace("click:" + url);
//						//					if(this.onOutFun!=null)
//						//						this.onOutFun();
//				}
//			}
//		}

	}
}
