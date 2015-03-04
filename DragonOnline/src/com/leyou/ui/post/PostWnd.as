package com.leyou.ui.post {

	import com.ace.enum.FontEnum;
	import com.ace.enum.UIEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.SOLManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.LoadUtil;

	import flash.events.MouseEvent;

	public class PostWnd extends AutoWindow {

		private var gridlist:ScrollPane;
		private var closeBtn:NormalButton;
		private var text:Label;

		public function PostWnd() {
			super(LibManager.getInstance().getXML("config/ui/post/postWnd.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.gridlist=this.getUIbyID("gridlist") as ScrollPane;
			this.closeBtn=this.getUIbyID("closeBtn") as NormalButton;
			this.text=new Label();
			this.gridlist.addToPane(this.text);

			this.text.wordWrap=true;
			this.text.multiline=true;

			this.text.width=460;

			this.closeBtn.addEventListener(MouseEvent.CLICK, onClose);

//			LibManager.getInstance().load([LoadUtil.lib2Cach("config/table/post.xml")], onComplete);
			onComplete();
//			this.updateLoade();
		}

		private function onClose(e:MouseEvent):void {
			this.hide();
		}

		public function updateLoade():void {

			var ver:Object=SOLManager.getInstance().readCookie("gameVersion");

			if (ver == null || (ver != null && ver.version != UIEnum.VERSIONCM)) {
				if (this.text.text != "" && this.text.text != null)
					this.show(true, UIEnum.WND_LAYER_MIDDLE);
			}

			SOLManager.getInstance().saveCookie("gameVersion", {"version": UIEnum.VERSIONCM});
		}

		private function onComplete():void {

			var xml:XML=LibManager.getInstance().getXML("config/table/post.xml");

			var str:String="";
			if (xml.data.length() > 0)
				str+=xml.data[int(xml.data.length() - 1)].@des + "<br>";

			if (xml.data.length() > 1)
				str+=xml.data[int(xml.data.length() - 2)].@des + "<br>";

			if (xml.data.length() > 2)
				str+=xml.data[int(xml.data.length() - 3)].@des;

			this.text.htmlText=str + "";

		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			if (this.text.text != "" && this.text.text != null)
				super.show(toTop, $layer, toCenter);
			else
				NoticeManager.getInstance().broadcastById(9607);
		}

		public function resize():void {
			this.x=UIEnum.WIDTH - this.width >> 1;
			this.y=UIEnum.HEIGHT - this.height >> 1;
		}

	}
}
