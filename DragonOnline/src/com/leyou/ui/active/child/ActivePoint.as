package com.leyou.ui.active.child
{
	import com.ace.enum.FilterEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TActiveRewardInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.ConfigEnum;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class ActivePoint extends AutoSprite
	{
//		public static const FULL_NUM:int = 200;
		
		private var rewardID:int;
		
		private var receivedLbL:Label;
		
		private var receiveAbleLbl:Label;
		
		private var numLbl:Label;
		
		private var _level:int;
		
		public var receive:Boolean;
		
		public function ActivePoint(){
			super(LibManager.getInstance().getXML("config/ui/active/activePoint.xml"));
			init();
		}
		
		public function get level():int{
			return _level;
		}

		private function init():void{
			mouseEnabled = true;
			receivedLbL = getUIbyID("receivedLbl") as Label;
			receiveAbleLbl = getUIbyID("receiveAbleLbl") as Label;
			numLbl = getUIbyID("numLbl") as Label;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			ToolTipManager.getInstance().show(TipEnum.TYPE_ACTIVE, _level, new Point(stage.mouseX, stage.mouseY));
		}
		
		public function receiveAble():Boolean{
			return receiveAbleLbl.visible;
		}
		
		public function updateInfo(lv:int, st:int, hd:int):void{
			_level = lv;
			receive = false;
			var reardInfo:TActiveRewardInfo = TableManager.getInstance().getActiveRewardInfo(lv);
			numLbl.text = reardInfo.threshold+"";
			x = (73 + (reardInfo.threshold / ConfigEnum.activeMaxCount) * 406) - 28;
			y = 392;
			if(1 == st){
				receivedLbL.visible = true;
				filters = [FilterEnum.enable];
				receiveAbleLbl.visible = false;
				numLbl.visible = false;
			}else{
				if(hd >= reardInfo.threshold){
					receivedLbL.visible = false;
					receiveAbleLbl.visible = true;
					numLbl.visible = false;
					receive = true;
				}else{
					receivedLbL.visible = false;
					receiveAbleLbl.visible = false;
					numLbl.visible = true;
				}
			}
		}
	}
}