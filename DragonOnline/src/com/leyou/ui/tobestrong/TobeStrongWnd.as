package com.leyou.ui.tobestrong
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TTobeStrongInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.lable.Label;
	import com.leyou.net.cmd.Cmd_TobeStrong;
	import com.leyou.ui.tobestrong.children.StrongTitleChildItem;
	import com.leyou.ui.tobestrong.children.StrongTitleItem;
	
	import flash.events.MouseEvent;
	
	public class TobeStrongWnd extends AutoWindow
	{
		private var itemTitleLbl:Label;
		
		private var items:Vector.<StrongTitleItem>;
		
		private var childrenItems:Vector.<StrongTitleChildItem>;
		
		private var currentType:int;
		
		private var zdlNum:RollNumWidget;
		
		public function TobeStrongWnd(){
			super(LibManager.getInstance().getXML("config/ui/tobeStrong/tobestrWnd.xml"));
			init();
		}
		
		private function init():void{
			itemTitleLbl = getUIbyID("titleLbl") as Label;
			items = new Vector.<StrongTitleItem>();
			childrenItems = new Vector.<StrongTitleChildItem>();
			zdlNum = new RollNumWidget();
			zdlNum.alingRound();
			zdlNum.mouseChildren = false;
			zdlNum.mouseEnabled = false;
			zdlNum.speed = 600;
			zdlNum.x = 410;
			zdlNum.y = 422;
//			zdlNum.loadSource("ui/num/{num}_zdl.png");
			zdlNum.loadSource("ui/num/{num}_lz.png");
			addChild(zdlNum);
			initTable();
		}
		
		private function initTable():void{
			currentType = 1;
			var ctype:int;
			var mianC:int;
			for(var n:int = 0; n < 19; n++){
				var id:int = n+1;
				// 主项
				var tinfo:TTobeStrongInfo = TableManager.getInstance().getTobeStrongInfo(id);
				if(tinfo.type != ctype){
					ctype = tinfo.type;
					var item:StrongTitleItem = new StrongTitleItem();
					item.updateInfo(tinfo);
					items.push(item);
					pane.addChild(item);
					item.addEventListener(MouseEvent.CLICK, onMouseClick);
					item.x = 18;
					item.y = 99 + mianC * 39;
					mianC++;
				}
			}
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
//			Cmd_TobeStrong.cm_RISE_I();
		}
		
		private function turnToType(type:int):void{
			var infoSet:Vector.<TTobeStrongInfo> = getValidItem(type);
			var infoL:int = infoSet.length;
			if(childrenItems.length < infoL){
				childrenItems.length = infoL;
			}
			var vc:int = childrenItems.length;
			for(var n:int = 0; n < vc; n++){
				var item:StrongTitleChildItem = childrenItems[n];
				if(n < infoL){
					if(null == item){
						item = new StrongTitleChildItem();
						childrenItems[n] = item;
						pane.addChild(item);
						item.x = 354;
						item.y = 99 + n * 78;
					}
					item.updateInfo(infoSet[n]);
					item.updateDynamicData();
					item.visible = true;
				}else{
					if(null != item){
						item.visible = false;
					}
				}
			}
			itemTitleLbl.text = getTitleName(type);;
		}
		
		private function getTitleName(type:int):String{
			var infoSet:Vector.<TTobeStrongInfo> = TableManager.getInstance().getTobeStrongByType(type);
			return infoSet[0].des_title+"提升途径";
		}
		
		private function getValidItem(type:int):Vector.<TTobeStrongInfo>{
			var infoSet:Vector.<TTobeStrongInfo> = TableManager.getInstance().getTobeStrongByType(type);
			switch(type){
				case 1:
					var qzc:int = DataManager.getInstance().tobeStrongData.qzc;// 紫装数量
					var qjc:int = DataManager.getInstance().tobeStrongData.qjc;// 金装数量
					if(qzc < 14 && qjc <= 0){
						infoSet.splice(3, 1);
					}else if(qjc < 14){
						infoSet.splice(2, 1);
					}else{
						infoSet.splice(2, 2);
					}
					break;
				case 2:
					var rt:int = DataManager.getInstance().tobeStrongData.rt;// 坐骑等级
					if(rt >= 10){
						infoSet.splice(0, 1);
					}
					break;
				case 3:
					var gt:int = DataManager.getInstance().tobeStrongData.gt;// 是否有帮会
					if(0 == gt){
						infoSet.splice(1, 1);
					}else{
						infoSet.splice(0, 1);
					}
					break;
				case 4:
					var bt:int = DataManager.getInstance().tobeStrongData.bt;// 纹章节点是否全部开启
					if(1 == bt){
						infoSet.splice(0, 1);
					}
					break;
				case 5:
					var vt:int = DataManager.getInstance().tobeStrongData.vt;// VIP等级
					var vrt:int = DataManager.getInstance().tobeStrongData.rt;// 坐骑等级
					var vwt:int = DataManager.getInstance().tobeStrongData.wt;// 翅膀等级
					if(vt <= 0){
						infoSet[1] = null;
						infoSet[2] = null;
						infoSet[3] = null;
					}else if((vt > 0) && (vt < 10)){
						infoSet[0] = null;
					}else if(vt >= 10){
						infoSet[0] = null;
						infoSet[1] = null;
					}
					if(vrt >= 10){
						infoSet[2] = null;
					}
					if(vwt >= 10){
						infoSet[3] = null;
					}
					var vl:int = infoSet.length;
					for(var k:int = infoSet.length-1; k >= 0; k--){
						if(null == infoSet[k]){
							infoSet.splice(k, 1);
						}
					}
					break;
				case 6:
					var wt:int = DataManager.getInstance().tobeStrongData.wt;// 翅膀等级
					if(wt >= 10){
						infoSet.length = 0;
					}else if(wt > 0){
						infoSet.splice(0 ,1);
					}else if(wt <= 0){
						infoSet.splice(1, 1);
					}
					break;
				case 7:
					var gemz:int = DataManager.getInstance().tobeStrongData.gemz;
					break;
			}
			return infoSet;
		}
		
		private var currentItem:StrongTitleItem; 
		protected function onMouseClick(event:MouseEvent):void{
			if(null != currentItem){
				currentItem.turnOff();
			}
			var item:StrongTitleItem = event.currentTarget as StrongTitleItem;
			currentItem = item;
			currentItem.turnOn();
			if(null != item){
				turnToType(item.type);
				currentType = item.type;
			}
		}
		
		public function updateInfo():void{
			turnToType(currentType);
			var ic:int = items.length;
			for(var n:int = 0; n < ic; n++){
				if(null != items[n]){
					items[n].updateDynamicData();
				}
			}
			var icc:int = childrenItems.length;
			for(var m:int = 0 ; m < icc; m++){
				if(null != childrenItems[m]){
					childrenItems[m].updateDynamicData();
				}
			}
			zdlNum.setNum(DataManager.getInstance().tobeStrongData.tz);
		}
		
		public override function get width():Number{
			return 778;
		}
		
		public override function get height():Number{
			return 487;
		}
		
		public function resize():void{
			if(visible){
				show();
			}
		}
	}
}