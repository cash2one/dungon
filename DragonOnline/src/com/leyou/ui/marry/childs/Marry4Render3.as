package com.leyou.ui.marry.childs {

	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Marry;
	import com.leyou.utils.PropUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Marry4Render3 extends AutoSprite {

		private var confirmBtn:NormalButton;
		private var desc1Lbl:Label;
		private var descLbl:Label;
		private var ybLbl:Label;
		private var raceImg:Image;
		private var select1Img:Image;
		private var select2Img:Image;

		public function Marry4Render3() {
			super(LibManager.getInstance().getXML("config/ui/marry/marry4Render3.xml"));
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {

			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;

			this.desc1Lbl=this.getUIbyID("desc1Lbl") as Label;
			this.descLbl=this.getUIbyID("descLbl") as Label;
			this.ybLbl=this.getUIbyID("ybLbl") as Label;

			this.raceImg=this.getUIbyID("raceImg") as Image;

			this.select1Img=this.getUIbyID("select1Img") as Image;
			this.select2Img=this.getUIbyID("select2Img") as Image;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.ybLbl.text="" + ConfigEnum.marry5;
			this.desc1Lbl.width=134;
			this.desc1Lbl.wordWrap=true;

			this.descLbl.text="" + PropUtils.getStringById(2238);

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onLeftClick=onMClick;

			MouseManagerII.getInstance().addEvents(this.select1Img, einfo);

			einfo=new MouseEventInfo();
			einfo.onLeftClick=onMClick;

			MouseManagerII.getInstance().addEvents(this.select2Img, einfo);

//			this.select1Img.alpha=0;
			this.select2Img.alpha=0;

			var clickSpr:Sprite;

			clickSpr=new Sprite();
			clickSpr.graphics.beginFill(0x000000);
			clickSpr.graphics.drawRect(0, 0, select2Img.width, select2Img.height);
			clickSpr.graphics.endFill();

			clickSpr.alpha=0;
			this.addChild(clickSpr);

			clickSpr.x=select1Img.x;
			clickSpr.y=select1Img.y;
			clickSpr.name="s_1";

			clickSpr.addEventListener(MouseEvent.CLICK, onMClick);
			
			
			clickSpr=new Sprite();
			clickSpr.graphics.beginFill(0x000000);
			clickSpr.graphics.drawRect(0, 0, select2Img.width, select2Img.height);
			clickSpr.graphics.endFill();

			clickSpr.alpha=0;
			this.addChild(clickSpr);

			clickSpr.x=select2Img.x;
			clickSpr.y=select2Img.y;
			clickSpr.name="s_2";

			clickSpr.addEventListener(MouseEvent.CLICK, onMClick);

		}

		private function onMClick(e:MouseEvent):void {

			var str:String=e.target.name;

			if (str.split("_")[1] == "1") {
				this.select1Img.alpha=1;
				this.select2Img.alpha=0;
			} else {
				this.select1Img.alpha=0;
				this.select2Img.alpha=1;
			}

		}

		private function onClick(e:MouseEvent):void {
			if (this.select1Img.alpha == 1)
				PopupManager.showConfirm(StringUtil.substitute(TableManager.getInstance().getSystemNotice(23323).content, [ConfigEnum.marry5]), okFunc, null, false, "marry_exit");
			else if (this.select2Img.alpha == 1)
				PopupManager.showConfirm(TableManager.getInstance().getSystemNotice(23322).content, okFunc, null, false, "marry_exit");
		}

		private function okFunc():void {
			if (this.select1Img.alpha == 1)
				Cmd_Marry.cmMarryDivorce(1);
			else if (this.select2Img.alpha == 1)
				Cmd_Marry.cmMarryDivorce(2);

			UIManager.getInstance().hideWindow(WindowEnum.MARRY4);
		}

		public function updateInfo(o:Object):void {

			this.desc1Lbl.htmlText="" + StringUtil.substitute(TableManager.getInstance().getSystemNotice(23302).content, [ConfigEnum.marry4, o.leave]);


		}




	}
}
