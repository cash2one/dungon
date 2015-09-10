package com.leyou.ui.guild.child {

	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.FilterUtil;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class GuildSci extends AutoSprite {

		private var countLbl:Label;
		private var ruleLbl:Label;
		private var guildSciArc:GuildSciArc;

		private var ImgList:Vector.<Image>;
		private var rendersList:Vector.<GuildSciRender>;

		public function GuildSci() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildSci.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {
			this.countLbl=this.getUIbyID("countLbl") as Label;
			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;

			this.ImgList=new Vector.<Image>();

			var einfo1:MouseEventInfo=new MouseEventInfo();

			var bgimg:Image;
			for (var i:int=0; i < 6; i++) {
				bgimg=this.getUIbyID("bgImg" + (i + 1)) as Image;
				this.ImgList.push(bgimg);

				einfo1=new MouseEventInfo();
				einfo1.onLeftClick=onMouseClick;
				einfo1.onMouseMove=onMouseImgOver;
				einfo1.onMouseOut=onMouseImgOut;

				MouseManagerII.getInstance().addEvents(bgimg, einfo1);
			}

			this.rendersList=new Vector.<GuildSciRender>();

			this.guildSciArc=new GuildSciArc();
			LayerManager.getInstance().windowLayer.addChild(this.guildSciArc);
			this.guildSciArc.hide();

			this.ruleLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.ruleLbl.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.ruleLbl.mouseEnabled=true;

			this.y+=2;
			this.x=-17;
		}

		private function onMouseClick(e:Image):void {
			var i:int=int(e.name.charAt(e.name.length - 1));
			this.guildSciArc.showPanel(i - 1);
		}

		private function onMouseImgOver(e:Image):void {
			e.filters=[FilterUtil.showBorder(0xffff00)];
		}

		private function onMouseImgOut(e:Image):void {
			e.filters=[];
		}

		private function onMouseOver(e:MouseEvent):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(23221).content, new Point(e.stageX, e.stageY));
		}

		private function onMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		public function updateInfo(o:Object):void {

			var render:GuildSciRender;
			for each (render in this.rendersList) {
				this.removeChild(render);
			}

			this.rendersList.length=0;

			var arr:Array=o.blist;
			var i:int=0;
			var img:Image;

			for (i=0; i < arr.length; i++) {

				if (arr[i] == null || arr[i] == "" || arr[i].length == 0)
					continue;

				img=this.ImgList[i];

				render=new GuildSciRender();
				render.updateInfo(arr[i], i, o.sc);

				this.addChild(render);
				this.rendersList.push(render);

				render.x=img.x;
				render.y=img.y - 175 + 82;
			}

			this.countLbl.text="" + o.sc;
		}


	}
}
