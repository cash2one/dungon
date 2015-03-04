package com.leyou.ui.guild.child {


	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class GuildZCPoint extends AutoSprite {

		private var iconImg:Image
		private var txtLbl:Label

		private var currentValue:int=0;
		private var currentRate:int=0;

		public function GuildZCPoint() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildZCPoint.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.txtLbl=this.getUIbyID("txtLbl") as Label;

			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}

		private function onMouseOver(e:MouseEvent):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(3082).content,[this.currentValue,this.currentRate]), new Point(e.stageX, e.stageY));
		}

		private function onMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide()
		}

		public function updateInfo(rate:int, value:int):void {

			this.currentRate=rate;
			this.currentValue=value;

			this.txtLbl.text=rate + "倍收益";
		}



	}
}
