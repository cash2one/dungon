package com.leyou.ui.guild {

	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Guild;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class GuildDonateMessage extends AutoWindow {

		private var conversionLbl:Label;
		private var rateLbl:Label;
		private var contributeTxt:TextInput;

		private var confirmBtn:ImgLabelButton;

		private var ybImg:Image;
		private var yb1img:Image;
		private var bg1img:Image;
		private var bgimg:Image;

		public function GuildDonateMessage() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildDonateMessage.xml"));
			this.init();
			this.hideBg();
			this.clsBtn.y-=10;
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.conversionLbl=this.getUIbyID("conversionLbl") as Label;
			this.ybImg=this.getUIbyID("ybImg") as Image;
			this.yb1img=this.getUIbyID("yb1img") as Image;
			this.bg1img=this.getUIbyID("bg1img") as Image;
			this.bgimg=this.getUIbyID("bgimg") as Image;

			this.rateLbl=this.getUIbyID("rateLbl") as Label;
			this.contributeTxt=this.getUIbyID("contributeTxt") as TextInput;
			this.contributeTxt.restrict="0-9";

			this.confirmBtn=this.getUIbyID("confirmBtn") as ImgLabelButton;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.contributeTxt.addEventListener(Event.CHANGE, onInputChange);

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.ybImg, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.yb1img, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.bg1img, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.bgimg, einfo);
		}

		private function onTipsMouseOver(e:DisplayObject):void {
			if (e == this.bgimg || e == this.bg1img)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9557).content, new Point(this.stage.mouseX, this.stage.mouseY));
			else if (e == this.ybImg || e == this.yb1img)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9559).content, new Point(this.stage.mouseX, this.stage.mouseY));

		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		private function onInputChange(e:Event):void {

			if (this.contributeTxt.text.length > 8) {
				this.contributeTxt.text=this.contributeTxt.text.substring(0, 8) + "";
			}

			if (ConfigEnum.union7 * int(this.contributeTxt.text) > int.MAX_VALUE) {
				this.contributeTxt.text="" + int(int.MAX_VALUE / ConfigEnum.union7);
			}

			var v:int=ConfigEnum.union7 * int(this.contributeTxt.text);
			v=(v > int.MAX_VALUE ? int.MAX_VALUE : v);
			this.conversionLbl.text="" + v;

			if (int(this.contributeTxt.text) > UIManager.getInstance().backpackWnd.yb)
				this.conversionLbl.textColor=0xff0000;
			else
				this.conversionLbl.textColor=0xcdb97c;

		}

		private function onClick(e:MouseEvent):void {
			if (this.contributeTxt.text != "") {
				Cmd_Guild.cm_GuildContribute(int(this.contributeTxt.text));
//				Cmd_Guild.cm_GuildMemInfo(MyInfoManager.getInstance().name);
			}

			if (this.conversionLbl.textColor != 0xff0000)
				this.hide();
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(true, $layer, toCenter);

			this.rateLbl.text=ConfigEnum.union7 + "";
			this.contributeTxt.text="";
			this.conversionLbl.text="0";

			if (this.parent == null)
				LayerManager.getInstance().windowLayer.addChild(this);

			this.stage.focus=this.contributeTxt.input;
		}

	}
}
