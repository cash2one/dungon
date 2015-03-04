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
	import com.leyou.net.cmd.Cmd_Arena;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class ArenaMessage extends AutoWindow {

		private var hour4Btn:RadioButton;
		private var hour8Btn:RadioButton;
		private var hour12Btn:RadioButton;

		private var confirmBtn:NormalButton;
		private var cancelBtn:NormalButton;

		private var bybimg:Image;
		
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

			this.goldLbl=this.getUIbyID("goldLbl") as Label;
			this.bybimg=this.getUIbyID("bybimg") as Image;

			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.hour12Btn.addEventListener(MouseEvent.CLICK, onClick);
			this.hour8Btn.addEventListener(MouseEvent.CLICK, onClick);
			this.hour4Btn.addEventListener(MouseEvent.CLICK, onClick);

			this.hour4Btn.turnOn();
			this.goldLbl.text=""+ConfigEnum.Miliyary14;
			
			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onMouseOver;
			einfo.onMouseOut=onMouseOut;
			
			MouseManagerII.getInstance().addEvents(this.bybimg, einfo);
		}
		
		private function onMouseOver(e:DisplayObject):void{
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9559).content, new Point(this.stage.mouseX, this.stage.mouseY));
		}
		
		private function onMouseOut(e:DisplayObject):void{
			
			
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "confirmBtn":
					Cmd_Arena.cm_ArenaBuyFreeCount(this.houeTime);
					this.hide();
					break;
				case "cancelBtn":
					this.hide();
					break;
				case "hour12Btn":
					this.houeTime=12;
					this.goldLbl.text=""+ConfigEnum.Miliyary16;
					break;
				case "hour8Btn":
					this.houeTime=8;
					this.goldLbl.text=""+ConfigEnum.Miliyary15;
					break;
				case "hour4Btn":
					this.houeTime=4;
					this.goldLbl.text=""+ConfigEnum.Miliyary14;
					break;
			}

		}

	}
}
