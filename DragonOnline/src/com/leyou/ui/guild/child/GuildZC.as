package com.leyou.ui.guild.child {

	import com.ace.config.Core;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.ShopUtil;

	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFieldAutoSize;

	public class GuildZC extends AutoSprite {

		private var progressImg:Image;

		private var progress2Lbl:Label;
		private var progressLbl:Label;
		private var descLbl:Label;
		private var rateLbl:Label;
		private var bybLbl:Label;
		private var timeLbl:Label;
		private var meLbl:Label;
		private var bgLbl:Label;

		private var itemsList:ScrollPane;

		private var inputBtn:NormalButton;

		private var itemsArr:Array=[];

		private var un2Arr:Array=[];

		private var currentRate:int=1;

		public function GuildZC() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildZC.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.progressImg=this.getUIbyID("progressImg") as Image;

			this.progress2Lbl=this.getUIbyID("progress2Lbl") as Label;
			this.progressLbl=this.getUIbyID("progressLbl") as Label;

			this.descLbl=this.getUIbyID("descLbl") as Label;
			this.rateLbl=this.getUIbyID("rateLbl") as Label;

			this.bybLbl=this.getUIbyID("bybLbl") as Label;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;

			this.meLbl=this.getUIbyID("meLbl") as Label;
			this.bgLbl=this.getUIbyID("bgLbl") as Label;


			this.itemsList=this.getUIbyID("itemsList") as ScrollPane;

			this.inputBtn=this.getUIbyID("inputBtn") as NormalButton;

			this.inputBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.un2Arr=ConfigEnum.union27.split("|");
			var unArr:Array=ConfigEnum.union26.split("|");

			var zp:GuildZCPoint;
			for (var i:int=0; i < unArr.length; i++) {
				zp=new GuildZCPoint();

				zp.updateInfo(un2Arr[i], unArr[i]);

				zp.x=this.progressImg.x + (int(unArr[i]) / ConfigEnum.union36) * 541 - zp.width / 2;
				zp.y=this.progressImg.y;

				this.addChild(zp);
			}

			this.descLbl.wordWrap=true;
			this.descLbl.multiline=true;
			this.descLbl.width=195;

			this.descLbl.htmlText=TableManager.getInstance().getSystemNotice(3083).content;
			this.descLbl.height=236;

			this.y+=2;
			this.x=-17.62;
		}

		private function onClick(e:MouseEvent):void {
//			navigateToURL(new URLRequest(Core.URL_PAY), "_blank");
			PayUtil.openPayUrl()
		}

		public function updateInfo(o:Object):void {

			this.progressLbl.text=o.uzc + "/" + ConfigEnum.union36;
			this.progress2Lbl.text=o.uzc + "/" + ConfigEnum.union36;

			if (int(o.uzc) > ConfigEnum.union36)
				this.progressImg.setWH(541, 17);
			else
				this.progressImg.setWH(int(o.uzc) / ConfigEnum.union36 * 541, 17);

			this.timeLbl.text="" + o.dtime;

			if (o.uzc >= 10000) {
				this.currentRate=this.un2Arr[Math.floor(int(o.uzc) / 10000) - 1];
				var unArr:Array=ConfigEnum.union26.split("|");
				for (var i:int=0; i < unArr.length; i++) {
					if (int(o.uzc) < int(unArr[i])) {
						this.currentRate=this.un2Arr[i - 1];
						break;
					}
				}

				if (o.uzc >= int(unArr[unArr.length - 1]))
					this.currentRate=this.un2Arr[this.un2Arr.length - 1];

			} else
				this.currentRate=1;

			switch (this.currentRate) {
				case 2:
					GuideManager.getInstance().showGuide(100, UIManager.getInstance().rightTopWnd.getWidget("guildBtn"));
					break;
				case 3:
					GuideManager.getInstance().showGuide(101, UIManager.getInstance().rightTopWnd.getWidget("guildBtn"));
					break;
				case 4:
					GuideManager.getInstance().showGuide(102, UIManager.getInstance().rightTopWnd.getWidget("guildBtn"));
					break;
				case 5:
					GuideManager.getInstance().showGuide(103, UIManager.getInstance().rightTopWnd.getWidget("guildBtn"));
					break;
			}

			this.rateLbl.text="(" + this.currentRate + PropUtils.getStringById(1751) + ")";
			this.rateLbl.x=this.progressLbl.x + this.progressLbl.textWidth + 3;

			this.meLbl.text="" + o.mzc;
			this.bybLbl.text="" + (o.mzc * this.currentRate);
			this.bgLbl.text="" + (o.mzc * this.currentRate);

			this.progressLbl.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(3081).content, [o.uzc, this.currentRate]));
			this.progress2Lbl.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(3081).content, [o.uzc, this.currentRate]));

			this.updateList(o.zclist as Array);
		}

		private function updateList(arr:Array):void {

			var render:GuildZCRender;
			for each (render in this.itemsArr) {
				this.itemsList.delFromPane(render);
			}

			this.itemsArr.length=0;

			arr.sortOn("1", Array.DESCENDING | Array.NUMERIC);

			for (var i:int=0; i < arr.length; i++) {

				render=new GuildZCRender();

				render.updateInfo(arr[i], this.currentRate);
				render.y=i * render.height;
				render.x=2;

				this.itemsList.addToPane(render);
				this.itemsArr.push(render);

			}

			this.itemsList.scrollTo(0);
			this.itemsList.updateUI();

			DelayCallManager.getInstance().add(this, this.itemsList.scrollTo, "updateUI", 4, 0);
		}


	}
}
