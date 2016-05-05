package com.ace.game.scene.ui.child
{
	import com.ace.enum.GameFileEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.utils.ReuseUtil;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.table.TTitle;
	import com.ace.manager.ToolTipManager;
	import com.ace.movie.PnfMovie;
	import com.ace.ui.img.child.Image;
	import com.leyou.data.tips.TipsInfo;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class TitleRender extends Sprite
	{
		private var movie:PnfMovie; 
		
		private var bgImg:Image;
		
		private var pnfId:int;
		
		private var tipsInfo:TipsInfo;
		
		public function TitleRender(bgColour:Boolean=false){
			init();
		}
		
		private function init():void{
			tipsInfo = new TipsInfo();
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			tipsInfo.isUse = false;
			var info:LivingInfo = MyInfoManager.getInstance();
			var tInfo:TTitle;
			for (var i:int=1; i < info.tileNames.length; i++) {
				if (int(info.tileNames[i]) == tipsInfo.itemid){
					tipsInfo.isUse = true;
				}
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_TITLE, tipsInfo, new Point(stage.mouseX, stage.mouseX));
		}
		
		public function disableMouse():void{
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		public function enableMouse():void{
			mouseEnabled = true;
			mouseChildren = true;
		}
		
		public function updateInfo(tInfo:TTitle):void{
			tipsInfo.itemid = tInfo.typeId;
			if("" != tInfo.Bottom_Pic){
				if(null == bgImg){
					bgImg = new Image();
					addChild(bgImg);
				}
				var url:String = GameFileEnum.URL_TITLE+tInfo.Bottom_Pic+".png";
				bgImg.updateBmp(url);
			}
			if(pnfId != int(tInfo.model)){
				if(null != movie){
					removeChild(movie);
					ReuseUtil.recyclePnf(movie);
				}
				movie = ReuseUtil.getPnf(int(tInfo.model));
				addChild(movie);
			}
		}
	}
}