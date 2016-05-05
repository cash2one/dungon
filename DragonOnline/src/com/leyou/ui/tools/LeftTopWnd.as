package com.leyou.ui.tools
{
	import com.ace.enum.FilterEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	public class LeftTopWnd extends AutoSprite
	{
		private var _wingBtn:ImgButton;
		
		private var _legendaryBtn:ImgButton;
		
		private var _giftBtn:ImgButton;
		
		private var _giftSwf:SwfLoader;
		
//		private var _timeLbl:Label;
		
//		private var remianT:int;
		
		private var tick:uint;
		
		public function LeftTopWnd(){
			super(LibManager.getInstance().getXML("config/ui/ToolsUPWnd2.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			_wingBtn = getUIbyID("wingBtn") as ImgButton;
//			_timeLbl = getUIbyID("timeLbl") as Label;
			_legendaryBtn = getUIbyID("legendaryBtn") as ImgButton;
			_giftBtn = getUIbyID("gtiftBtn") as ImgButton;
			_giftSwf = getUIbyID("giftSwf") as SwfLoader;
			_wingBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			_legendaryBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			_giftBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			_legendaryBtn.visible = false;
			_wingBtn.visible = false;
		}
		
		public function setFirstGift(value:Boolean/*, rtime:int*/):void{
			if(value){
				DataManager.getInstance().commonData.payStatus = 1;
			}else{
				DataManager.getInstance().commonData.payStatus = 2;
			}
			_giftBtn.visible = value;
			_giftSwf.visible = value;
//			_timeLbl.visible = value;
//			remianT = rtime;
			tick = getTimer();
//			if(value && rtime > 0){
//				if(!TimeManager.getInstance().hasITick(uddateTime)){
//					TimeManager.getInstance().addITick(1000, uddateTime);
//				}
//				uddateTime();
//			}else{
//				if(TimeManager.getInstance().hasITick(uddateTime)){
//					TimeManager.getInstance().removeITick(uddateTime);
//				}
//			}
		}
		
		public function get wingBtn():ImgButton{
			return _wingBtn;
		}
		
		// 更新翅膀信息
		public function updateWingInfo(obj:Object):void{
//			var wingExist:Boolean = obj.st;
//			_wingBtn.visible = wingExist;
		}
		
//		private function uddateTime():void{
//			var hour:String = StringUtil.fillTheStr(int(remianT/60/60), 2, "0", true);
//			var minutes:String = StringUtil.fillTheStr(int(remianT/60)%60, 2, "0", true);
//			var seconds:String = StringUtil.fillTheStr(remianT%60, 2, "0", true);
//			_timeLbl.text = StringUtil.substitute("{1}:{2}:{3}", hour, minutes, seconds);
//		}
		
		protected function onMouseClick(event:MouseEvent):void{
			switch(event.target.name){
				case "wingBtn":
					UILayoutManager.getInstance().open(WindowEnum.MARKET);
					UIManager.getInstance().marketWnd.changeTable(4);
					break;
				case "legendaryBtn":
					UILayoutManager.getInstance().open(WindowEnum.LEGENDAREY_WEAPON);
					break;
				case "gtiftBtn":
					UILayoutManager.getInstance().open(WindowEnum.FIRST_PAY);
					break;
			}
		}
		
		public function activeLegendaryBtn():void{
//			_legendaryBtn.visible = true;
		}
		
		public function toAcrossServer():void{
			_giftBtn.setActive(false, 1, true);
			_giftSwf.filters = [FilterEnum.enable];
		}
		
		public function toNormalServer():void{
			_giftBtn.setActive(true, 1, true);
			_giftSwf.filters = null;
		}
		
		public function resize():void{
			x = 333;
			y = 0;
		}
	}
}