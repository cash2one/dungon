package com.leyou.ui.vip
{
	import com.ace.config.Core;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TVIPDetailInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.leyou.data.vip.TipVipEquipInfo;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class VipArmBar extends AutoSprite
	{
		private var movie:SwfLoader;
		
		private var num:RollNumWidget;
		
		private var tipsInfo:TipVipEquipInfo;
		
		private var nameImg:Image;
		
		public function VipArmBar(){
			super(LibManager.getInstance().getXML("config/ui/vip/vipSWnd.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			nameImg = getUIbyID("nameImg") as Image;
			movie = new SwfLoader();
			movie.x = 158;
			movie.y = 355;
			movie.mouseEnabled = true;
			movie.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
//			movie.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addChild(movie);
			num = new RollNumWidget();
			num.loadSource("ui/num/{num}_lz.png");
			num.x = 245;
			num.y = 54;
			num.alignRound();
			addChild(num);
			tipsInfo = new TipVipEquipInfo();
		}
		
//		protected function onMouseOut(event:MouseEvent):void{
//			trace("mouse out")
//		}
		protected function onMouseOver(event:MouseEvent):void{
			tipsInfo.lv = Core.me.info.level;
			tipsInfo.vipLv = Core.me.info.vipLv+1;
			ToolTipManager.getInstance().show(TipEnum.TYPE_VIP_QUEIP, tipsInfo, new Point(stage.mouseX, stage.mouseY));
		}
		
		public function updateInfo():void{
			var vipLv:int = Core.me.info.vipLv + 1;
			if(vipLv > 1 && vipLv < 11){
				var currentInfo:TVIPDetailInfo = TableManager.getInstance().getVipDetailInfo(vipLv-1);
				var nextInfo:TVIPDetailInfo = TableManager.getInstance().getVipDetailInfo(vipLv);
				var rate:int = ((nextInfo.rate - currentInfo.rate) / currentInfo.rate) * 100;
				movie.update(nextInfo.modelBigId);
				num.setNum(rate);
				var vipDetail:TVIPDetailInfo = TableManager.getInstance().getVipDetailInfo(vipLv);
				var snUrl:String = "ui/vip/"+vipDetail.equipSourceurl;
				nameImg.updateBmp(snUrl);
			}
		}
		
		public override function die():void{
			movie.die();
			num.die();
			num = null;
			movie = null;
			tipsInfo = null;
		}
	}
}