package com.leyou.ui.arena.childs {

	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Arena;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class ArenaMessage extends AutoWindow {

		private var hour4Btn:RadioButton;
		private var hour8Btn:RadioButton;
		private var hour12Btn:RadioButton;

		private var ybBtn:RadioButton;
		private var bybBtn:RadioButton;

		private var confirmBtn:NormalButton;
		private var cancelBtn:NormalButton;

		private var bybimg:Image;
		private var ybimg:Image;

		private var goldLbl:Label;

		private var houeTime:int=4;

		public function ArenaMessage() {
			super(LibManager.getInstance().getXML("config/ui/arena/arenaMessage.xml"));
			this.init();
			this.hideBg();
			this.clsBtn.y-=10;
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {

			this.hour12Btn=this.getUIbyID("hour12Btn") as RadioButton;
			this.hour8Btn=this.getUIbyID("hour8Btn") as RadioButton;
			this.hour4Btn=this.getUIbyID("hour4Btn") as RadioButton;

			this.ybBtn=this.getUIbyID("ybBtn") as RadioButton;
			this.bybBtn=this.getUIbyID("bybBtn") as RadioButton;

//			this.goldLbl=this.getUIbyID("goldLbl") as Label;
			this.bybimg=this.getUIbyID("bybimg") as Image;
			this.ybimg=this.getUIbyID("ybimg") as Image;

			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.hour12Btn.addEventListener(MouseEvent.CLICK, onClick);
			this.hour8Btn.addEventListener(MouseEvent.CLICK, onClick);
			this.hour4Btn.addEventListener(MouseEvent.CLICK, onClick);

			this.hour4Btn.turnOn();
//			this.ybBtn.turnOn();
//			this.goldLbl.text="" + ConfigEnum.Miliyary14;

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onMouseOver;
			einfo.onMouseOut=onMouseOut;

			MouseManagerII.getInstance().addEvents(this.bybimg, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onMouseOver;
			einfo.onMouseOut=onMouseOut;

			MouseManagerII.getInstance().addEvents(this.ybimg, einfo);
		}

		private function onMouseOver(e:DisplayObject):void {
			if (e == this.ybimg)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9559).content, new Point(this.stage.mouseX, this.stage.mouseY));
			else
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9558).content, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onMouseOut(e:DisplayObject):void {


		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "confirmBtn":

					Cmd_Arena.cm_ArenaBuyFreeCount(this.houeTime, (this.ybBtn.isOn ? 0 : 1));

					this.hide();
					break;
				case "cancelBtn":
					this.hide();
					break;
				case "hour12Btn":
					this.houeTime=12;
					this.ybBtn.text="   " + ConfigEnum.Miliyary16.split("|")[0];
					this.bybBtn.text="   " + ConfigEnum.Miliyary16.split("|")[1];
					break;
				case "hour8Btn":
					this.houeTime=8;
					this.ybBtn.text="   " + ConfigEnum.Miliyary15.split("|")[0];
					this.bybBtn.text="   " + ConfigEnum.Miliyary15.split("|")[1];
					break;
				case "hour4Btn":
					this.houeTime=4;
					this.ybBtn.text="   " + ConfigEnum.Miliyary14.split("|")[0];
					this.bybBtn.text="   " + ConfigEnum.Miliyary14.split("|")[1];
					break;
			}

		}
		
		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop,$layer,toCenter);
			this.ybBtn.turnOn();
			this.hour4Btn.turnOn();
			this.hour4Btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			
		}

	}
}
