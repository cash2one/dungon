package com.leyou.ui.marry {

	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TMarry_ring;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.greensock.TweenMax;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.net.cmd.Cmd_Marry;
	import com.leyou.utils.PropUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;

	public class MarryWnd1 extends AutoWindow {

		private var yb0Img:Image;
		private var yb1Img:Image;
		private var yb2Img:Image;

		private var ImgSwfArr:Array=[]

		private var nameLbl:TextInput;
		private var descLbl:TextInput;

		private var yb1Lbl:Label;
		private var yb2Lbl:Label;
		private var yb3Lbl:Label;

		private var ruleLbl:Label;

		private var confirmBtn:ImgButton;
		private var cancelBtn:ImgButton;

		private var itemsArr:Array=[];
		private var itemsClickArr:Array=[];

		private var currentSelectIndex:int=-1;
		private var tweenmax:TweenMax;

		private var tipinfo:TipsInfo;

		private var cross:Boolean=false;

		public function MarryWnd1() {
			super(LibManager.getInstance().getXML("config/ui/marry/marryWnd1.xml"));
			this.init();
			this.hideBg();
		}

		private function init():void {

			this.yb0Img=this.getUIbyID("yb0Img") as Image;
			this.yb1Img=this.getUIbyID("yb1Img") as Image;
			this.yb2Img=this.getUIbyID("yb2Img") as Image;

			this.nameLbl=this.getUIbyID("nameLbl") as TextInput;
			this.descLbl=this.getUIbyID("descLbl") as TextInput;

			this.nameLbl.input.maxChars=20;
			this.descLbl.input.maxChars=56;

			this.descLbl.input.width=190;
			this.descLbl.input.wordWrap=true;

			this.yb1Lbl=this.getUIbyID("yb1Lbl") as Label;
			this.yb2Lbl=this.getUIbyID("yb2Lbl") as Label;
			this.yb3Lbl=this.getUIbyID("yb3Lbl") as Label;

			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;

			this.confirmBtn=this.getUIbyID("confirmBtn") as ImgButton;
			this.cancelBtn=this.getUIbyID("cancelBtn") as ImgButton;

			this.nameLbl.mouseChildren=false;
			this.nameLbl.mouseEnabled=true;
			this.descLbl.mouseChildren=false;
			this.descLbl.mouseEnabled=true;

			this.nameLbl.addEventListener(MouseEvent.CLICK, onClick);
			this.descLbl.addEventListener(MouseEvent.CLICK, onClick);
			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.descLbl.input.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			this.descLbl.input.addEventListener(Event.CHANGE, onKeyDown);
			this.descLbl.mouseChildren=false;
			this.descLbl.mouseEnabled=true;
			
			this.nameLbl.input.addEventListener(KeyboardEvent.KEY_DOWN, onKeyNDown);
			this.nameLbl.input.addEventListener(Event.CHANGE, onKeyNDown);
			this.nameLbl.mouseChildren=false;
			this.nameLbl.mouseEnabled=true;

			this.ruleLbl.setToolTip(TableManager.getInstance().getSystemNotice(23303).content);

			var items:Object=TableManager.getInstance().getMarryRingAll();

			var einfo:MouseEventInfo;
			var clickSpr:Sprite;
			var swf:SwfLoader;
			var img:Image;
			var i:int=0;
			var tmring:TMarry_ring;
			for each (tmring in items) {
				img=new Image("ico/items/" + tmring.Ring_Pic);
				this.addChild(img);

				img.x=127 + i * 90;
				img.y=180;

				this.itemsArr.push(img);

				this["yb" + (i + 1) + "Lbl"].text="" + tmring.Ring_Tag;

//				einfo=new MouseEventInfo();
//				einfo.onLeftClick=onSelect
//				einfo.onMouseMove=onTipsMouseOver;
//				einfo.onMouseOut=onTipsMouseOut;
//
//				MouseManagerII.getInstance().addEvents(img, einfo);

				swf=new SwfLoader(tmring.Ring_Eff2);
				this.addChild(swf);

				swf.x=127 + i * 90;
				swf.y=180;
//				swf.visible=false;

				this.ImgSwfArr.push(swf);

				clickSpr=new Sprite();
				clickSpr.graphics.beginFill(0x000000);
				clickSpr.graphics.drawRect(0, 0, 60, 60);
				clickSpr.graphics.endFill();

				clickSpr.alpha=0;
				this.addChild(clickSpr);

				clickSpr.x=img.x;
				clickSpr.y=img.y;

				clickSpr.addEventListener(MouseEvent.CLICK, onSelect);
				clickSpr.addEventListener(MouseEvent.MOUSE_OVER, onTipsMouseOver);
				clickSpr.addEventListener(MouseEvent.MOUSE_OUT, onTipsclickMouseOut);

				clickSpr.name="s_" + tmring.ID;

				this.itemsClickArr.push(clickSpr);

				i++;
			}

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsybMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(yb0Img, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsybMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(yb1Img, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsybMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(yb2Img, einfo);

			this.tipinfo=new TipsInfo();

			this.nameLbl.text="" + TableManager.getInstance().getSystemNotice(23327).content;
		}

		private function onKeyDown(e:Event):void {
//			trace(this.descLbl.text);

			var by:ByteArray=new ByteArray();
			by.clear();
			by.writeMultiByte(this.descLbl.text, "cn-gb");
			by.position=0;
			
			if (by.length > 56) {
				this.descLbl.text="" + by.readMultiByte(56, "cn-gb");
			}
 
		}
		
		private function onKeyNDown(e:Event):void {

			var by:ByteArray=new ByteArray();
			by.clear();
			by.writeMultiByte(this.nameLbl.text, "cn-gb");
			by.position=0;
			
			if (by.length > 20) {
				this.nameLbl.text="" + by.readMultiByte(20, "cn-gb");
			}
 
		}

		private function onTipsybMouseOver(e:Image):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9559).content, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOver(e:MouseEvent):void {
			var i:int=int(e.target.name.split("_")[1]);
			this.tipinfo.itemid=i;
			this.tipinfo.zf=1;
			this.tipinfo.qh=0;

			ToolTipManager.getInstance().show(TipEnum.TYPE_MARRY, this.tipinfo, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:Image):void {
			ToolTipManager.getInstance().hide();
		}

		private function onTipsclickMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		private function onSelect(e:MouseEvent):void {

			if (this.currentSelectIndex != -1) {
				if (tweenmax != null) {
					tweenmax.pause();
					tweenmax.kill();
					tweenmax=null;

				}

				this.itemsArr[this.currentSelectIndex].filters=[];
			}

			this.currentSelectIndex=this.itemsClickArr.indexOf(e.target);

			tweenmax=TweenMax.to(this.itemsArr[this.currentSelectIndex], 1, {glowFilter: {color: 0xfa9611, alpha: 1, blurX: 12, blurY: 12, strength: 2}, yoyo: true, repeat: -1});

		}

		private function onClick(e:MouseEvent):void {
			switch (e.target.name) {
				case "confirmBtn":
					if (this.nameLbl.text != null && this.nameLbl.text != "" && this.currentSelectIndex != -1)
						Cmd_Marry.cmMarryStart(this.nameLbl.text, (this.currentSelectIndex + 1), this.descLbl.text);
					this.hide();
					break;
				case "cancelBtn":
					this.hide();
					break;
				case "descLbl":
					this.descLbl.input.setSelection(0, this.descLbl.text.length);
					this.stage.focus=this.descLbl.input;
					break;
				case "nameLbl":
					this.nameLbl.input.setSelection(0, this.nameLbl.text.length);
					this.stage.focus=this.nameLbl.input;
					break;
			}


		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			if (this.currentSelectIndex != -1) {
				if (tweenmax != null) {
					tweenmax.pause();
					tweenmax.kill();
					tweenmax=null;

				}

				this.itemsArr[this.currentSelectIndex].filters=[];
			}

			this.currentSelectIndex=0;

			tweenmax=TweenMax.to(this.itemsArr[this.currentSelectIndex], 1, {glowFilter: {color: 0xfa9611, alpha: 1, blurX: 12, blurY: 12, strength: 2}, yoyo: true, repeat: -1});

			if (!this.cross)
				this.nameLbl.text="" + TableManager.getInstance().getSystemNotice(23327).content;

			this.descLbl.text="" + PropUtils.getStringById(2213);

			UIManager.getInstance().hideWindow(WindowEnum.MARRY2);
			UIManager.getInstance().hideWindow(WindowEnum.MARRY3);

			this.cross=false;
		}

		public function showPanel(name:String=""):void {

			this.cross=true;

			if (name == "")
				this.nameLbl.text="" + TableManager.getInstance().getSystemNotice(23327).content;
			else
				this.nameLbl.text="" + name;

			this.descLbl.text="" + PropUtils.getStringById(2213);

		}


	}
}
