package com.leyou.ui.tips
{
	import com.ace.ICommon.ITip;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFarmLvInfo;
	import com.ace.gameData.table.TFarmPlantInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.ui.farm.children.FarmBlock;
	import com.leyou.util.DateUtil;
	
	import flash.events.Event;

	public class TipsFarmTip extends AutoSprite implements ITip
	{
		private var nameLbl:Label;
		
		private var earnLbl:Label;
		
		private var rEarnLbl:Label;
		
		private var ripeLbl:Label;
		
		private var timeLbl:Label;
		
//		private var remainTimeLbl:Label;
		
//		private var rateLbl:Label;
		
		private var rateImg:Image;
		
		private var growTick:Number;
		
		private var icon:Image;
		
		private var growTime:int;
		
		private var earnIconImg:Image;
		
		private var rEarnIconImg:Image;
		
		public function TipsFarmTip(){
			super(LibManager.getInstance().getXML("config/ui/tips/farmTips.xml"));
			init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		private function init():void{
			nameLbl = getUIbyID("nameLbl") as Label;
			earnLbl = getUIbyID("earnLbl") as Label;
			ripeLbl = getUIbyID("ripeLbl") as Label;
			timeLbl = getUIbyID("timeLbl") as Label;
//			remainTimeLbl = getUIbyID("remainTimeLbl") as Label;
//			rateLbl = getUIbyID("rateLbl") as Label;
			rEarnLbl = getUIbyID("rEarnLbl") as Label;
			rateImg = getUIbyID("rateImg") as Image;
			rEarnIconImg = getUIbyID("rEarnIconImg") as Image;
			earnIconImg = getUIbyID("earnIconImg") as Image;
			icon = new Image();
			icon.x = 15;
			icon.y = 15;
			addChild(icon);
			addEventListener(Event.REMOVED_FROM_STAGE, OnRemoveStage);
		}
		
		protected function OnRemoveStage(event:Event):void{
			if(TimeManager.getInstance().hasITick(onUpdata)){
				TimeManager.getInstance().removeITick(onUpdata);
			}
		}
		
		public function get isFirst():Boolean{
			return false;
		}
		
		/**
		 * <T>更新信息</T>
		 * 
		 * @param info 信息
		 * 
		 */		
		public function updateInfo(info:Object):void{
			var block:FarmBlock = info as FarmBlock;
			growTick = block.growTick;
			var plantInfo:TFarmPlantInfo = TableManager.getInstance().getPlant(block.seedId);
			nameLbl.text = plantInfo.name;
			earnLbl.text = plantInfo.plantNum+"";
			var r:Number = block.beSteal ? 0.8 : 1.0;
			var farmLvInfo:TFarmLvInfo = TableManager.getInstance().getLandLvInfo(block.level);
			rEarnLbl.text = plantInfo.plantNum * (farmLvInfo.profitRate/100 + 1) * r + "";
			growTime = plantInfo.growTime;
			icon.updateBmp("ico/items/"+plantInfo.icon);
			if(!TimeManager.getInstance().hasITick(onUpdata)){
				TimeManager.getInstance().addITick(1000, onUpdata);
			}
			var url:String = (plantInfo.plantId == 0) ? "ui/backpack/moneyIco.png" : "ui/common/hl.png";
			earnIconImg.updateBmp(url);
			rEarnIconImg.updateBmp(url);
			var remain:int = new Date().time/1000 - growTick;
			if((growTime - remain) >= 0){
				updataTime();
				ripeLbl.visible = false;
				timeLbl.visible = true;
//				remainTimeLbl.visible = true;
				var rate:Number = remain/plantInfo.growTime;
				rateImg.scaleX = Number(rate.toFixed(2));
//				rateLbl.text = int(rate*100) + "%";
			}else{
				ripeLbl.visible = true;
				timeLbl.visible = false;
//				remainTimeLbl.visible = false;
				rateImg.scaleX = 1;
//				rateLbl.text = "100%";
			}
		}
		
		protected function onUpdata():void{
			updataTime();
		}
		
		protected function updataTime():void{
			var remain:int = growTime - (new Date().time/1000 - growTick);
//			var second:int = remain%60;
//			var minute:int = remain/60%60;
//			var hour:int = remain/60/60;
			
//			var t:String = "";
//			if(hour >= 0){
//				t += hour+"小时";
//			}
//			if(minute >= 0){
//				t += minute + "分"
//			}
//			if(second >= 0){
//				t += second+"秒"
//			}
			if(remain <= 0){
				ripeLbl.visible = true;
				timeLbl.visible = false;
				rateImg.scaleX = 1;
			}
			timeLbl.text = "剩余时间：" + DateUtil.formatTime(remain*1000, 2);
		}
			
	}
}