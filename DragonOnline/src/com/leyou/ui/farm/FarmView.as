package com.leyou.ui.farm
{
	import com.ace.enum.WindowEnum;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.PopupManager;
	import com.leyou.ui.farm.children.FarmFriendRender;
	import com.leyou.ui.farm.children.Farmland;
	
	import flash.events.MouseEvent;
	
	public class FarmView extends AutoWindow
	{
		protected var farmLand:Farmland;
		
		protected var friendRender:FarmFriendRender;
		
		protected var logBtn:ImgButton;
		
		protected var irrigationBtn:ImgButton;
		
		protected var accelerateBtn:ImgButton;
		
		protected var rateImg:Image;
		
		protected var rateLbl:Label;
		
		protected var blessingLbl:Image;
		
		protected var cdImg:Image;
		
		protected var irrigationLbl:Label;
		
		protected var irrigationFriendLbl:Label;
		
		protected var stealLbl:Label;
		
		protected var ownerLbl:Label;
		
		public var ownerName:String;
		
		public function FarmView(){
			super(LibManager.getInstance().getXML("config/ui/farmWnd.xml"));
			init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		private function init():void{
//			mouseEnabled = true;
//			mouseChildren = true;
			farmLand = new Farmland();
			farmLand.x = 375;
			farmLand.y = 260;
			addChild(farmLand);
			
			friendRender = new FarmFriendRender();
			friendRender.x = 631;
			friendRender.y = 74;
			addChild(friendRender);
			
			logBtn = getUIbyID("logBtn") as ImgButton;
			irrigationBtn = getUIbyID("irrigationBtn") as ImgButton;
			accelerateBtn = getUIbyID("accelerateBtn") as ImgButton;
			logBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			irrigationBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			accelerateBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			rateImg = getUIbyID("rateImg") as Image;
			rateLbl = getUIbyID("rateLbl") as Label;
			blessingLbl = getUIbyID("blessingLbl") as Image;
			cdImg = getUIbyID("cdImg") as Image;
			irrigationLbl = getUIbyID("irrigationLbl") as Label;
			irrigationFriendLbl = getUIbyID("irrigationFriendLbl") as Label;
			stealLbl = getUIbyID("stealLbl") as Label;
			ownerLbl = getUIbyID("ownerLbl") as Label;
		}
		
		public override function hide():void{
			super.hide();
			UIManager.getInstance().hideWindow(WindowEnum.FARM_SHOP);
			PopupManager.closeConfirm("wind.confirm.unlock");
			PopupManager.closeConfirm("farm.block.unearth");
			PopupManager.closeConfirm("farm.block.accelerate");
			PopupManager.closeConfirm("farm.tree.accelerate");
		}
		
		/**
		 * <T>界面按钮点击响应</T>
		 * 
		 * @param event 鼠标事件
		 * 
		 */		
		protected function onMouseClick(event:MouseEvent):void{
		}
	}
}