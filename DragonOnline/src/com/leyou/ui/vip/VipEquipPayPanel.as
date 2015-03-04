package com.leyou.ui.vip
{
	import com.ace.config.Core;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TVIPDetailInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.leyou.utils.PayUtil;
	
	import flash.events.MouseEvent;
	
	public class VipEquipPayPanel extends AutoSprite{
		
		private var movie:SwfLoader;
		
		private var payBtn:ImgButton;
		
		public function VipEquipPayPanel(){
			super(LibManager.getInstance().getXML("config/ui/vip/vipUpWnd.xml"));
			init();
		}
		
		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			movie = new SwfLoader();
			addChild(movie);
			movie.x = 222;
			movie.y = 337;
			
			var vipInfo:TVIPDetailInfo = TableManager.getInstance().getVipDetailInfo(1);
			movie.update(vipInfo.modelBigId);
			movie.playAct("stand", 4);
			
			payBtn = getUIbyID("payBtn") as ImgButton;
			if(!Core.PAY_OPEN){
				payBtn.setActive(false, 1, true);
			}else{
				payBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			PayUtil.openPayUrl();
		}
		
		public override function die():void{
			movie = null;
			payBtn = null;
		}
	}
}