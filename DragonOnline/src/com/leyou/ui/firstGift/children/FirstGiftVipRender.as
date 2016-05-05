package com.leyou.ui.firstGift.children
{
	import com.ace.config.Core;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TVIPDetailInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.leyou.data.vip.TipVipEquipInfo;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class FirstGiftVipRender extends FirstGiftRender
	{
		private var movie:SwfLoader;
		
		private var tipsInfo:TipVipEquipInfo;

		public function FirstGiftVipRender(){
			super(LibManager.getInstance().getXML("config/ui/firstGift/schl2Render.xml"));
			init();
		}
		
		protected override function init():void{
			super.init();
			movie = new SwfLoader();
			addChild(movie);
			movie.x = 251;
			movie.y = 212;
			movie.mouseEnabled = false;
//			movie.addEventListener(MouseEvent.MOUSE_OVER, onSptOver);
			
			var vipDetail:TVIPDetailInfo = TableManager.getInstance().getVipDetailInfo(1);
			movie.update(vipDetail.modelBigId);
			movie.playAct("stand", 4);
			
			tipsInfo = new TipVipEquipInfo();
			
			var hitW:int = 60;
			var hitH:int = 180;
			var sp:Sprite = new Sprite();
			var g:Graphics = sp.graphics;
			g.beginFill(0, 0);
			g.drawRect(0, 0, hitW, hitH);
			g.endFill();
			addChild(sp);
			sp.x = 251 - hitW*0.5;
			sp.y = 212 - hitH;
			sp.addEventListener(MouseEvent.MOUSE_OVER, onSptOver);
		}
		
		protected function onSptOver(event:MouseEvent):void{
//			tipsInfo.lv = Core.me.info.level;
//			tipsInfo.vipLv = 1;
			ToolTipManager.getInstance().show(TipEnum.TYPE_VIP_QUEIP, tipsInfo, new Point(stage.mouseX, stage.mouseY));
		}
	}
}