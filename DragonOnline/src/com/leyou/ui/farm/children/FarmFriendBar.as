package com.leyou.ui.farm.children
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	
	public class FarmFriendBar extends AutoSprite
	{
		private var areaLbl:Label;
		
		private var nameLbl:Label;
		
		private var reapImg:Image;
		
		private var irrigationImg:Image;
		
		private var bgImg:Image;
		
		private var _select:Boolean;
		
		public function FarmFriendBar(){
			super(LibManager.getInstance().getXML("config/ui/farm/friendBar.xml"));
			init();
		}
		
		public function set select(value:Boolean):void{
			_select = value;
			if(value){
				bgImg.updateBmp("ui/farm/list_bar_o.jpg");
			}else{
				bgImg.updateBmp("ui/farm/list_bar_u.jpg");
			}
		}

		/**
		 * <T>初始化</T>
		 * 
		 */
		private function init():void{
			mouseEnabled = true;
			bgImg = getUIbyID("bgImg") as Image;
			areaLbl = getUIbyID("areaLbl") as Label;
			nameLbl = getUIbyID("nameLbl") as Label;
			reapImg = getUIbyID("reapImg") as Image;
			irrigationImg = getUIbyID("irrigationImg") as Image;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
//			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		/**
		 * <T>获得完整的玩家名</T>
		 * 
		 * @return 玩家名
		 * 
		 */		
		public function get friendName():String{
			return areaLbl.text.replace(PropUtils.getStringById(1699),"")+nameLbl.text;
		}
		
		/**
		 * <T>设置玩家名</T>
		 * 
		 * @param n 玩家名称
		 * 
		 */		
		public function set friendName(n:String):void{
			var index:int = n.indexOf("]");
			if(-1 != index){
				areaLbl.text = n.substr(0, index+1) + PropUtils.getStringById(1699);
				nameLbl.text = n.substr(index+1);
			}
		}
		
		/**
		 * <T>设置是否可偷取</T>
		 * 
		 * @param value 是否可偷
		 * 
		 */		
		public function set reap(value:Boolean):void{
			reapImg.visible = value;
		}
		
		/**
		 * <T>设置是否可浇灌</T>
		 * 
		 * @param value 是否可浇灌
		 * 
		 */		
		public function set irrigation(value:Boolean):void{
			irrigationImg.visible = value;
		}
		
//		/**
//		 * <T>鼠标点击</T>
//		 * 
//		 * @param event 事件
//		 * 
//		 */		
//		protected function onMouseClick(event:MouseEvent):void{
//			Cmd_Farm.cm_FAM_I(areaLbl.text+nameLbl.text);
//		}
		
		/**
		 * <T>鼠标移出</T>
		 * 
		 */
		protected function onMouseOut(event:MouseEvent):void{
			if(!_select){
				bgImg.updateBmp("ui/farm/list_bar_u.jpg");
			}
		}
		
		/**
		 * <T>鼠标移入</T>
		 * 
		 */
		protected function onMouseOver(event:MouseEvent):void{
			bgImg.updateBmp("ui/farm/list_bar_o.jpg");
		}
	}
}