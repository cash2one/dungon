package com.ace.game.scene.ui
{
	import com.ace.enum.UIEnum;
	import com.ace.game.proxy.CmdProxy;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ChatEnum;
	import com.leyou.net.cmd.Cmd_EXPC;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CopyReviveWnd extends AutoWindow
	{
		private static var instance:CopyReviveWnd;
		
		public static function getInstance():CopyReviveWnd {
			if (!instance)
				instance = new CopyReviveWnd();
			return instance;
		}
		
		private var exitBtn:NormalButton;
		
		private var timeLbl:Label;
		
		private var desLbl:Label;
		
		private var numWidget:RollNumWidget;
		private var item:Object;
		private var bItem:Object;
		private var killName:Object;
		private var reviveWaitTime:int;
		private var tick:Number;
		
		public function CopyReviveWnd(){
			super(LibManager.getInstance().getXML("config/ui/scene/reviveWnd1.xml"));
			init();
			LayerManager.getInstance().windowLayer.addChild(this);
		}
		
		private function init():void{
			timeLbl = getUIbyID("timeLbl") as Label;
			desLbl = getUIbyID("desLbl") as Label;
			exitBtn = getUIbyID("exitBtn") as NormalButton;
			exitBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			hideBg();
			clsBtn.visible = false;
			desLbl.multiline = true;
			desLbl.wordWrap = true;
			
			numWidget = new RollNumWidget();
			numWidget.loadSource("ui/num/{num}_lz.png");
			numWidget.x = 65;
			numWidget.y = 208;
			numWidget.alignRound();
			addChild(numWidget);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			CmdProxy.cm_revive(0);
			Cmd_EXPC.cm_Exp_L();
			if(TimeManager.getInstance().hasITick(onTick)){
				TimeManager.getInstance().removeITick(onTick);
			}
			hide();
		}
		
		/**
		 * <T>显示</T>
		 * 
		 * @param toTop    是否置顶
		 * @param $layer   所在层
		 * @param toCenter 是否置中
		 * 
		 */		
		override public function show(toTop:Boolean=true, $layer:int=UIEnum.WND_LAYER_NORMAL, toCenter:Boolean=true):void {
			super.show(toTop, UIEnum.WND_LAYER_TOP, toCenter); //显示在顶层
		}
		
		public function serv_show(obj:Object):void{
			LayerManager.getInstance().windowLayer.hideAllWnd();
			show();
			item = obj.item;
			bItem = obj.bitem;
			killName = obj.name;
//			reviveWaitTime = obj.dt*1000;
			reviveWaitTime = 11000;
			timeLbl.text = DateUtil.formatDate(new Date(obj.tick*1000), "YYYY-MM-DD HH24:MI:SS");
			var des:String = "";
//			des += "您在"+obj.mn+"地图被"+ StringUtil_II.getColorStr(StringUtil_II.addEventString(obj.name, "["+obj.name+"]", true), ChatEnum.COLOR_USER) +"击败了";
			des += StringUtil.substitute(PropUtils.getStringById(1515),[obj.mn,StringUtil_II.getColorStr(StringUtil_II.addEventString(obj.name, "["+obj.name+"]", true), ChatEnum.COLOR_USER)]);
			var pl:Array = obj.pl;
			if(pl.length > 0){
				des+=PropUtils.getStringById(1516);
				var l:int = pl.length;
				for(var n:int = 0; n < l; n++){
					var itemId:int = pl[n][0];
					var itemInfo:TItemInfo = TableManager.getInstance().getItemInfo(itemId);
					var equipInfo:TEquipInfo = TableManager.getInstance().getEquipInfo(itemId);
					var qulity:uint;
					var itemName:String;
					if (null != itemInfo) {
						qulity=uint(itemInfo.quality);
						itemName=itemInfo.name;
					}
					if (null != equipInfo) {
						qulity=uint(equipInfo.quality);
						itemName=equipInfo.name;
					}
					var color:String="#" + ItemUtil.getColorByQuality(qulity).toString(16).replace("0x");
					var reName:String=com.leyou.utils.StringUtil_II.getColorStrByFace(itemName, color, "微软雅黑", 14);
					if(pl[n][1] > 1){
						des += (reName+"×"+pl[n][1])+",";
					}else{
						des += reName+",";
					}
				}
				des+="."
			}else{
				des+=","+PropUtils.getStringById(1517)
			}
			desLbl.htmlText = des;
			startCount();
		}
		
		private function startCount():void{
			tick = new Date().time;
			if(!TimeManager.getInstance().hasITick(onTick)){
				TimeManager.getInstance().addITick(1000, onTick);
			}
			onTick();
		}
		
		/**
		 * <T>监听,计时作用</T>
		 * 
		 * @param event 事件
		 * 
		 */		
		protected function onTick():void{
			var t:uint = new Date().time - tick;
			var interval:int = reviveWaitTime - t;
			numWidget.setNum(interval/1000);
			if(interval <= 0){
				CmdProxy.cm_revive(0);
				if(TimeManager.getInstance().hasITick(onTick)){
					TimeManager.getInstance().removeITick(onTick);
				}
				hide();
				return;
			}	
		}
	}
}