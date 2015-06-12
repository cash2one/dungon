package com.leyou.ui.battlefield
{
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.component.RollNumWidget;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.leyou.data.iceBattle.IceBattleData;
	import com.leyou.data.iceBattle.children.IceBattlePalyerData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.battlefield.children.IceBattlefieldPauseItem;
	
	import flash.utils.getTimer;
	
	public class IceBattlefieldPauseWnd extends AutoWindow
	{
//		private var icePanel:ScrollPane;
//		
//		private var firePanel:ScrollPane;
		
		private var iceItemList:Vector.<IceBattlefieldPauseItem>;
		
		private var fireItemList:Vector.<IceBattlefieldPauseItem>;
		
		private var exIceItemList:Vector.<IceBattlefieldPauseItem>;
		
		private var exFireItemList:Vector.<IceBattlefieldPauseItem>;
		
		private var num:RollNumWidget;
		
		private var tick:uint;
		
		public function IceBattlefieldPauseWnd(){
			super(LibManager.getInstance().getXML("config/ui/iceBattle/warSyPause.xml"));
			init();
		}
		
		private function init():void{
//			icePanel = getUIbyID("icePanel") as ScrollPane;
//			firePanel = getUIbyID("firePanel") as ScrollPane;
			hideBg();
			exIceItemList = new Vector.<IceBattlefieldPauseItem>(10);
			exFireItemList = new Vector.<IceBattlefieldPauseItem>(10);
			
			iceItemList = new Vector.<IceBattlefieldPauseItem>(10);
			fireItemList = new Vector.<IceBattlefieldPauseItem>(10);
			num = new RollNumWidget();
			num.loadSource("ui/num/{num}_zdl.png");
			num.alignRound();
			num.x = 495;
			num.y = 416;
			pane.addChild(num);
			clsBtn.visible = false;
		}
		
		private function seachFor(sn:String):IceBattlefieldPauseItem{
			var il:int = iceItemList.length;
			var fl:int = fireItemList.length;
			var item:IceBattlefieldPauseItem;
			for(var n:int = 0; n < il; n++){
				item = iceItemList[n];
				if((null != item) && (item.playerName == sn)){
					return item;
				}
			}
			for(var m:int = 0; m < fl; m++){
				item = fireItemList[m];
				if((null != item) && (item.playerName == sn)){
					return item;
				}
			}
			return item;
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, UIEnum.WND_LAYER_TOP, toCenter);
			if(!TimeManager.getInstance().hasITick(updateTime)){
				tick = getTimer();
				updateTime();
				TimeManager.getInstance().addITick(1000, updateTime);
			}
		}
		
		public override function hide():void{
			super.hide();
			if(TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().removeITick(updateTime);
			}
		}
		
		private function updateTime():void{
			var interval:int = (getTimer() - tick)/1000;
			var ret:int = ConfigEnum.Opbattle28 - interval;
			if(ret < 0){
				ret = 0;
				hide();
			}
			num.setNum(ret);
		}
		
		public function updateInfo():void{
			var data:IceBattleData = DataManager.getInstance().iceBattleData;
			var il:int = iceItemList.length;
			var fl:int = fireItemList.length;
			var palyerData:IceBattlePalyerData;
			if(1 == data.exchange){
				for(var n:int = 0; n < il; n++){
					var item:IceBattlefieldPauseItem = iceItemList[n];
					if(null == item){
						item = new IceBattlefieldPauseItem();
						iceItemList[n] = item;
						addChild(item);
					}
					item.x = 31;
					item.y = 107 + 28*n;
					palyerData = data.getIcePlayerData(n);
					if(null != palyerData){
						item.visible = true;
						item.updateInfo(palyerData);
					}else{
						item.visible = false;
					}
				}
				for(var m:int = 0; m < fl; m++){
					var fitem:IceBattlefieldPauseItem = fireItemList[m];
					if(null == fitem){
						fitem = new IceBattlefieldPauseItem();
						fireItemList[m] = fitem;
						addChild(fitem);
					}
					fitem.x = 421;
					fitem.y = 107 + 28*m;
					palyerData = data.getFirePlayerData(m);
					if(null != palyerData){
						fitem.visible = true;
						fitem.updateInfo(palyerData);
					}else{
						fitem.visible = false;
					}
				}
			}else if(2 == data.exchange){
				TweenMax.delayedCall(1.5, exchangeItem);
			}
		}
		
		private function exchangeItem():void{
			var data:IceBattleData = DataManager.getInstance().iceBattleData;
			var il:int = iceItemList.length;
			var fl:int = fireItemList.length;
			for(var k:int = 0; k < il; k++){
				var exData:IceBattlePalyerData = data.getIcePlayerData(k);
				if(null == exData){
					exIceItemList[k] = null;
					continue;
				}
				var eitem:IceBattlefieldPauseItem = seachFor(exData.name);
				if(null != eitem){
					exIceItemList[k] = eitem;
					eitem.updateInfo(exData);
					TweenLite.to(eitem, 1, {x:31, y:(107 + 28*k)});
				}
			}
			for(var l:int = 0; l < fl; l++){
				var exfData:IceBattlePalyerData = data.getFirePlayerData(l);
				if(null == exfData){
					exFireItemList[l] = null;
					continue;
				}
				var efitem:IceBattlefieldPauseItem = seachFor(exfData.name);
				if(null != efitem){
					exFireItemList[l] = efitem;
					efitem.updateInfo(exfData);
					TweenLite.to(efitem, 1, {x:421, y:(107 + 28*l)});
				}
			}
			for(var i:int = 0; i < il; i++){
				iceItemList[i] = exIceItemList[i];
			}
			for(var j:int = 0; j < fl; j++){
				fireItemList[j] = exFireItemList[j];
			}
		}
	}
}