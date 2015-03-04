package com.leyou.ui.celebrate
{
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.TabButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.leyou.data.celebrate.AreaCelebrateData;
	import com.leyou.data.celebrate.AreaCelebrateTask;
	import com.leyou.data.celebrate.AreaCelebrateTaskData;
	import com.leyou.net.cmd.Cmd_KF;
	import com.leyou.ui.celebrate.children.AreaCelebrateItem;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	public class AreaCelebrateWnd extends AutoWindow
	{
		private var dateLbl:Label;
		
		private var dayImgs:Object;
		
		private var lvBtn:TabButton;
		
		private var strengBtn:TabButton;
		
		private var rideBtn:TabButton;
		
		private var wingBtn:TabButton;
		
		private var payBtn:TabButton;
		
		private var items:Vector.<AreaCelebrateItem>;
		
		private var viewPanel:ScrollPane;
		
		private var effectController:TweenMax;
		
		private var showType:int = 1;
		
		private var lvImg:Image;
		
		private var strengImg:Image;
		
		private var rideImg:Image;
		
		private var wingImg:Image;
		
		private var payImg:Image;
		
		private var tlImg:Image;
		
		public function AreaCelebrateWnd(){
			super(LibManager.getInstance().getXML("config/ui/celebrate/xfqdWnd.xml"));
			init();
		}
		
		private function init():void{
			dayImgs = {};
			items = new Vector.<AreaCelebrateItem>();
			var day:int = 1;
			dayImgs[day] = getUIbyID("day"+(day++)+"Img") as Image;
			dayImgs[day] = getUIbyID("day"+(day++)+"Img") as Image;
			dayImgs[day] = getUIbyID("day"+(day++)+"Img") as Image;
			dayImgs[day] = getUIbyID("day"+(day++)+"Img") as Image;
			dayImgs[day] = getUIbyID("day"+(day++)+"Img") as Image;
			tlImg = getUIbyID("tlImg") as Image;
			dateLbl = getUIbyID("dateLbl") as Label;
			lvBtn = getUIbyID("lvBtn") as TabButton;
			strengBtn = getUIbyID("strengBtn") as TabButton;
			rideBtn = getUIbyID("rideBtn") as TabButton;
			wingBtn = getUIbyID("wingBtn") as TabButton;
			payBtn = getUIbyID("payBtn") as TabButton;
			lvImg = getUIbyID("lvImg") as Image;
			strengImg = getUIbyID("strengImg") as Image;
			rideImg = getUIbyID("rideImg") as Image;
			wingImg = getUIbyID("wingImg") as Image;
			payImg = getUIbyID("payImg") as Image;
			viewPanel = getUIbyID("viewPanel") as ScrollPane;
			
			lvImg = getUIbyID("lvImg") as Image;
			strengImg = getUIbyID("strengImg") as Image;
			rideImg = getUIbyID("rideImg") as Image;
			wingImg = getUIbyID("wingImg") as Image;
			payImg = getUIbyID("payImg") as Image;
			
			lvBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			strengBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			rideBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			wingBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			payBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			var type:int = DataManager.getInstance().serverData.status;
			if(1 == type){
				lvBtn.turnOn();
				tlImg.updateBmp("ui/xfqd/title_xfqd.png");
				showType = 1;
			}else if(2 == type){
				tlImg.updateBmp("ui/xfqd/title_hfyl.png");
				payBtn.y = wingBtn.y;
				wingBtn.y = rideBtn.y;
				rideBtn.y = strengBtn.y;
				strengBtn.y = lvBtn.y;
				
				payImg.y = wingImg.y;
				wingImg.y = rideImg.y;
				rideImg.y = strengImg.y;
				strengImg.y = lvImg.y;
				lvImg.visible = false;
				lvBtn.visible = false;
				showType = 2;
				strengBtn.turnOn();
			}
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "lvBtn":
					showType = 1;
					break;
				case "strengBtn":
					showType = 2;
					break;
				case "rideBtn":
					showType = 3;
					break;
				case "wingBtn":
					showType = 4;
					break;
				case "payBtn":
					showType = 5;
					break;
			}
			Cmd_KF.cm_KF_I(showType);
			if(TweenMax.isTweening(event.target)){
				TweenMax.killTweensOf(event.target);
				event.target.filters = null;	
			}
		}
		
		private function nvlViewCount(count:int):void{
			if(items.length > count){
				var l:int = items.length;
				for(var n:int = count-1; n < l; n++){
					if(viewPanel.contains(items[n])){
						viewPanel.delFromPane(items[n]);
					}
				}
				viewPanel.scrollTo(0);
				viewPanel.updateUI();
			}else{
				items.length = count;
			}
		}
		
		private function getViewItem(index:int):AreaCelebrateItem{
			var item:AreaCelebrateItem = items[index];
			if(null == item){
				item = new AreaCelebrateItem();
				items[index] = item;
			}
			item.y = index * 70/*item.height*/;
			viewPanel.addToPane(item);
			return item;
		}
		
		public function playRewardEffect(id:int):void{
			var l:int = items.length;
			for(var n:int = 0; n < l; n++){
				if(id == items[n].linkId){
					items[n].flyItem();
					break;
				}
			}
		}
		
		public function updateInfo():void{
			var data:AreaCelebrateData = DataManager.getInstance().areaCelebrate;
//			playDayEffect(data.currentDay);
			dateLbl.text = data.getActiveTime();
			var dayTask:AreaCelebrateTaskData = data.getDayTaskInfo(showType);
			if(null == dayTask) return;
			var count:int = dayTask.taskCount();
			nvlViewCount(count);
			for(var n:int = 0; n < count; n++){
				var task:AreaCelebrateTask = dayTask.getTask(n);
				var item:AreaCelebrateItem = getViewItem(n);
				item.updateInfo(task);
			}
			
			cheackReceive();
		}
		
		private function cheackReceive():void{
			var data:AreaCelebrateData = DataManager.getInstance().areaCelebrate;
			if(data.hasReceive(1) && (showType != 1)){
				setBtnEffect(lvBtn);
			}
			if(data.hasReceive(2) && (showType != 2)){
				setBtnEffect(strengBtn);
			}
			if(data.hasReceive(3) && (showType != 3)){
				setBtnEffect(rideBtn);
			}
			if(data.hasReceive(4) && (showType != 4)){
				setBtnEffect(wingBtn);
			}
			if(data.hasReceive(5) && (showType != 5)){
				setBtnEffect(payBtn);
			}
		}
		
		private function setBtnEffect(btn:DisplayObject):void{
			if(!TweenMax.isTweening(btn)){
				TweenMax.to(btn, 2, {glowFilter: {color: 0xFFD700, alpha: 1, blurX: 10, blurY: 10, strength: 2}, yoyo: true, repeat: -1});
			}
		}
		
		public function playDayEffect(currentDay:int):void{
			if(null != effectController){
				effectController.kill();
				effectController = null;
			}
			for(var key:String in dayImgs){
				dayImgs[key].visible = (int(key) <= currentDay);
				dayImgs[key].alpha = 1;
			}
			effectController = TweenMax.to(dayImgs[currentDay], 1.5, {alpha:0.3, ease:Back.easeInOut, yoyo:true, repeat:-1});
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
//			Cmd_KF.cm_KF_I(1);
//			Cmd_KF.cm_KF_I(2);
//			Cmd_KF.cm_KF_I(3);
//			Cmd_KF.cm_KF_I(4);
//			Cmd_KF.cm_KF_I(5);
			var data:AreaCelebrateData = DataManager.getInstance().areaCelebrate;
			playDayEffect(data.currentDay);
		}
		
		public override function hide():void{
			super.hide();
			if(null != effectController){
				effectController.kill();
				effectController = null;
			}
		}
		
		public function resize():void{
			this.x=(UIEnum.WIDTH - this.width) / 2;
			this.y=(UIEnum.HEIGHT - this.height) / 2;
		}
	}
}