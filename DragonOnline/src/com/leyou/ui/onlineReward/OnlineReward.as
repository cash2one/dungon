package com.leyou.ui.onlineReward
{
	import com.ace.enum.WindowEnum;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	/**
	 * 已废弃
	 * @author Administrator
	 * 
	 */	
	public class OnlineReward extends AutoSprite
	{
//		private var receiveBtn:ImgButton;
//		
//		private var receiveLbl:Label;
//		
//		private var timeLbl:Label;
//		
//		private var _status:int;
//		
//		private var tick:uint;
//		
//		private var remain:int;
//		
//		public function OnlineReward(){
//			super(LibManager.getInstance().getXML("config/ui/timeReward/timeGiftWnd.xml"));
//			init();
//			this.cacheAsBitmap=true;
//		}
//		
//		public function get status():int{
//			return _status;
//		}
//		
//		private function init():void{
//			name = "onlineReward";
//			mouseChildren = true;
//			receiveBtn = getUIbyID("receiveBtn") as ImgButton;
//			receiveLbl = getUIbyID("receiveLbl") as Label;
//			timeLbl = getUIbyID("timeLbl") as Label;
//			timeLbl.y += 5;
//			timeLbl.x = (width - timeLbl.width)*0.5;
//			
//			receiveBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			visible = false;
//		}
//		
//		protected function onMouseClick(event:MouseEvent):void{
//			var n:String = event.target.name;
//			switch(n){
//				case "receiveBtn":
//					//					if(1 == status){
//					//					UILayoutManager.getInstance().open(WindowEnum.ACHIEVEMENT);
////					UIManager.getInstance().onlinePanel.open();
//					//					}else if(2 == status){
//					UILayoutManager.getInstance().open(WindowEnum.ONLINDREWARD);
//					GuideManager.getInstance().removeGuide(23);
//					//					}
//					break;
//			}
//		}
//		
//		public function updateInfo(obj:Object):void{
//			visible = true;
//			tick = getTimer();
//			remain = obj.stime;
//			if(remain > 0){
//				if(!TimeManager.getInstance().hasITick(updateTime)){
//					TimeManager.getInstance().addITick(1000, updateTime);
//				}
//				timeLbl.visible = true;
//				receiveLbl.visible = false;
//				_status = 1; // 计时状态
//			}else{
//				timeLbl.visible = false;
//				receiveLbl.visible = true;
//				_status = 2; // 可领取状态
//				GuideManager.getInstance().showGuide(23, this, true);
//			}
//			updateTime();
//		}
//		
//		public function updateTime():void{
//			var tt:int = remain - (getTimer() - tick)/1000;
//			var hour:int = tt/3600;
//			hour = (hour > 0) ? hour : 0;
//			var minutes:int = tt/60%60;
//			minutes = (minutes > 0) ? minutes : 0;
//			var scends:int = tt%60;
//			scends = (scends > 0) ? scends : 0;
//			timeLbl.text = StringUtil_II.lpad(hour+"", 2, "0") + ":" + StringUtil_II.lpad(minutes+"", 2, "0") + ":" + StringUtil_II.lpad(scends+"", 2, "0");
//			if(hour <= 0 && minutes <= 0 && scends <= 0){
//				timeLbl.visible = false;
//				receiveLbl.visible = true;
//				if(TimeManager.getInstance().hasITick(updateTime)){
//					TimeManager.getInstance().removeITick(updateTime);
//				}
//				_status = 2; // 可领取状态
//				GuideManager.getInstance().showGuide(23, this, true);
//			}
//		}
//		
//		public override function hide():void{
//			super.hide();
//			if(hasEventListener(Event.ENTER_FRAME)){
//				removeEventListener(Event.ENTER_FRAME, updateTime);
//			}
//		}
//		
//		//		public function resize():void{
//		//			x = UIEnum.WIDTH - 270;
//		//			y = 125;
//		//		}
	}
}