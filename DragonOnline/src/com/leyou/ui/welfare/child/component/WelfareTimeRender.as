package com.leyou.ui.welfare.child.component
{
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.continuous.child.RollIcon;
	import com.leyou.utils.PropUtils;
	
	import flash.debugger.enterDebugger;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class WelfareTimeRender extends AutoSprite
	{
		private var receivedImg:Image;
		
		private var lightImg:Image;
		
		private var timeLbl:Label;
		
		private var _timeID:int;
		
		private var grid:RollIcon;
		
		private var _received:Boolean;
		
		private var tips:TipsInfo;
		
		private var flagLbl:Label;
		
		private var light:Boolean;

		private var spt:Sprite;
		
		public function WelfareTimeRender(){
			super(LibManager.getInstance().getXML("config/ui/welfare/welfareTimeRender.xml"));
			init();
		}
		
		public function get timeID():int{
			return _timeID;
		}

		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			timeLbl = getUIbyID("timeLbl") as Label;
			flagLbl = getUIbyID("flagLbl") as Label;
			lightImg = getUIbyID("lightImg") as Image;
			receivedImg = getUIbyID("receivedImg") as Image;
			grid = new RollIcon();
			addChild(grid);
			grid.x = 33;
			grid.y = 33;
			swapChildren(grid, receivedImg);
			
			grid.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			grid.registerOverListener(onRollOver);
			tips = new TipsInfo();
			tips.isShowPrice = false;
			
			spt = new Sprite();
			addChildAt(spt, getChildIndex(lightImg));
			spt.addChild(lightImg);
			spt.x = lightImg.x + 60;
			spt.y = lightImg.y + 60;
			lightImg.x = -60;
			lightImg.y = -60;
			lightImg.visible = false;
		}
		
		private function onRollOver():void{
			_received = true;
			FlyManager.getInstance().flyBags([grid.showId], [grid.localToGlobal(new Point(0, 0))]);
			var item:TItemInfo = TableManager.getInstance().getItemInfo(grid.showId);
			timeLbl.text = item.name;
			timeLbl.textColor = 0xff00;
			flagLbl.visible = !_received;
			receivedImg.visible = _received;
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			tips.itemid = grid.showId;
			ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tips, new Point(stage.mouseX, stage.mouseY));
		}
		
		public function updateInfo(obj:Object, key:int):void{
			_timeID = key;
			_received = (1 == int(obj[2]));
			flagLbl.visible = !_received;
			receivedImg.visible = _received;
			var rewardArr:Array = ConfigEnum.GiftLot4.split("|");
			var index:int = 0;
			var length:int = rewardArr.length;
			for(var n:int = 0; n < length; n++){
				var arr:Array = rewardArr[n].split(",");
				if(_timeID == int(arr[0])){
					index = n;
					break;
				}
			}
			var itemArr:Array = ConfigEnum.GiftLot5.split("|")[index].split(",");
			grid.loadResourceByArray(itemArr);
			if(_received){
				var item:TItemInfo = TableManager.getInstance().getItemInfo(obj[0]);
				grid.setShowItem(obj[0]);
				timeLbl.text = item.name;
				timeLbl.textColor = 0xff00;
			}else{
				grid.setShowItem(itemArr[0]);
				timeLbl.text = StringUtil.substitute(PropUtils.getStringById(2306), key);
				timeLbl.textColor = 0xffd200;
			}
		}
		
		public function receiveable(time:uint):Boolean{
			return (!_received && (time >= _timeID));
		}
		
		public function updateReceiveStatus(time:uint):void{
			if(receiveable(time)){
				timeLbl.text = PropUtils.getStringById(2307);
				timeLbl.textColor = 0xff00;
				if(!light){
					spinLight();
					light = true;
				}
			}else{
				if(light){
					stopLight();
					light = false;
				}
			}
		}
		
		private function spinLight():void{
			lightImg.visible = true;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void{
			spt.rotation += 1;
		}
		
		private function stopLight():void{
			lightImg.visible = false;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function rollToItem(itemId:int):void{
			grid.rollToImg(itemId);
		}
	}
}