package com.leyou.ui.active
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TActiveRewardInfo;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Active;
	import com.leyou.ui.active.child.ActiveLblRender;
	import com.leyou.ui.active.child.ActivePoint;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class ActiveWnd extends AutoWindow
	{
		private var itemList:ScrollPane;
		
		private var receiveBtn:NormalButton;
		
		private var rewards:Vector.<ActivePoint>;
		
		private var activeItems:Vector.<ActiveLblRender>;
		
		private var progressImg:Image;
		
		private var numWdiget:RollNumWidget;
		
		//		private var receive:Boolean;
		
		private var flyIds:Array;
		
		private var starts:Array;
		
		public function ActiveWnd(){
			super(LibManager.getInstance().getXML("config/ui/activeWnd.xml"));
			init();
		}
		
		private function init():void{
			flyIds = [];
			starts = [];
			mouseChildren = true;
			rewards = new Vector.<ActivePoint>();
			itemList = getUIbyID("itemList") as ScrollPane;
			receiveBtn = getUIbyID("receiveBtn") as NormalButton;
			progressImg = getUIbyID("progressImg") as Image;
			activeItems = new Vector.<ActiveLblRender>();
			rewards = new Vector.<ActivePoint>();
			
			numWdiget = new RollNumWidget();
			numWdiget.x = 68;
			numWdiget.y = 366;
			numWdiget.loadSource("ui/num/{num}_zdl.png");
			addChild(numWdiget);
			
			receiveBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public override function get height():Number{
			return 544;
		}
		
		public function flyItem():void{
			if(0 != flyIds.length){
				FlyManager.getInstance().flyBags(flyIds, starts);
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			var length:int = rewards.length;
			for(var n:int = 0; n < length; n++){
				var reward:ActivePoint = rewards[n];
				if(reward && reward.receive){
					Cmd_Active.cm_HYD_J(reward.level);
					//					GuideManager.getInstance().removeGuide(39);
					flyIds.length = 0;
					starts.length = 0;
					var p:Point = reward.localToGlobal(new Point(0, 0)); 
					var reardInfo:TActiveRewardInfo = TableManager.getInstance().getActiveRewardInfo(reward.level);
					if(0 != reardInfo.exp){
						flyIds.push(65534);
						starts.push(p);
					}
					if(0 != reardInfo.money){
						flyIds.push(65535);
						starts.push(p);
					}
					if(0 != reardInfo.energy){
						flyIds.push(65533);
						starts.push(p);
					}
					if(0 != reardInfo.contribution){
						flyIds.push(65531);
						starts.push(p);
					}
					if(0 != reardInfo.byb){
						flyIds.push(65532);
						starts.push(p);
					}
					if(0 != reardInfo.item1){
						flyIds.push(reardInfo.item1);
						starts.push(p);
					}
					if(0 != reardInfo.item2){
						flyIds.push(reardInfo.item2);
						starts.push(p);
					}
					return;
				}
			}
		}
		
		
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
//			Cmd_Active.cm_HYD_I();
			GuideManager.getInstance().removeGuide(38);
			GuideManager.getInstance().removeGuide(39);
		}
		
		//		public override function hide():void{
		//			super.hide();
		//		}
		
		public function updateInfo(obj:Object):void{
			// 初始化列表项
			var list:Array = obj.hydl;
			var length:int = list.length;
			syncActiveCount(length);
			for(var n:int = 0; n < length; n++){
				var hid:int = list[n][0];
				var cc:int = list[n][1];
				var activeItem:ActiveLblRender = activeItems[n];
				if(null == activeItem){
					activeItem = new ActiveLblRender();
					itemList.addToPane(activeItem);
					//					activeItem.y = n * 30;
					activeItems[n] = activeItem;
				}
				activeItem.updateInfo(hid, cc);
			}
			activeItems.sort(compareById);
			function compareById(a:ActiveLblRender, b:ActiveLblRender):int{
				if(a.id > b.id){
					return 1;
				}else if(a.id < b.id){
					return -1;
				}
				return 0;
			}
			
			var tmpArr:Vector.<ActiveLblRender> = new Vector.<ActiveLblRender>();
			// 将已完成项置于列表末尾
			for(var m:int = activeItems.length - 1; m >= 0; m--){
				var a:ActiveLblRender = activeItems[m];
				if(a.complete){
					activeItems.splice(m, 1);
					tmpArr.push(a);
				}
			}
			activeItems = activeItems.concat(tmpArr);
			// 调整位置
			for(var l:int = 0; l < length; l++){
				var act:ActiveLblRender = activeItems[l];
				act.y = l * 30;
			}
		}
		
		public function syncActiveCount(c:int):void{
			if(activeItems.length > c){
				var cc:int = activeItems.length;
				for(var n:int = c; n < cc; n++){
					var activeItem:ActiveLblRender = activeItems[n];
					if(null != activeItem){
						itemList.delFromPane(activeItem);
					}
				}
			}
			activeItems.length = c;
		}
		
		public function updateRewardLevel(obj:Object):void{
			var receive:Boolean = false;
			var ca:int = obj.myhavl;
			var rewardArr:Array = obj.hjl;
			var length:int = rewardArr.length;
			rewards.length = length;
			for(var n:int = 0; n < length; n++){
				var level:int = rewardArr[n][0];
				var st:int = rewardArr[n][1];
				var rewardPoint:ActivePoint = rewards[n];
				if(null == rewardPoint){
					rewardPoint = new ActivePoint();
					rewards[n] = rewardPoint;
					addChild(rewardPoint);
				}
				rewardPoint.updateInfo(level, st, ca);
				if(rewardPoint.receiveAble()){
					receive = true;
				}
			}
			var sx:Number = ca/ConfigEnum.activeMaxCount;
			sx = (sx > 1) ? 1 : sx;
			progressImg.scaleX = sx;
			numWdiget.setNum(ca);
			receiveBtn.setActive(receive, 1, true);
		}
		
	}
}