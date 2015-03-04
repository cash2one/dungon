package com.ace.game.scene.ui.child
{
	import com.ace.enum.GameFileEnum;
	import com.ace.game.utils.ReuseUtil;
	import com.ace.gameData.table.TTitle;
	import com.ace.movie.PnfMovie;
	import com.ace.tools.SpriteNoEvt;
	import com.ace.ui.img.child.Image;
	
	public class TitleRender extends SpriteNoEvt
	{
		private var movie:PnfMovie; 
		
		private var bgImg:Image;
		
		private var pnfId:int;
		
		public function TitleRender(bgColour:Boolean=false){
			super(bgColour);
			init();
		}
		
		private function init():void{
		}
		
		public function updateInfo(tInfo:TTitle):void{
			if("" != tInfo.Bottom_Pic){
				if(null == bgImg){
					bgImg = new Image();
					addChild(bgImg);
				}
				var url:String = GameFileEnum.URL_TITLE+tInfo.Bottom_Pic+".png";
				bgImg.updateBmp(url);
			}
			if(pnfId != tInfo.model){
				if(null != movie){
					removeChild(movie);
					ReuseUtil.recyclePnf(movie);
				}
				movie = ReuseUtil.getPnf(tInfo.model);
				addChild(movie);
			}
		}
	}
}