package com.leyou.ui.farm
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.leyou.net.cmd.Cmd_Farm;
	import com.leyou.ui.farm.children.FarmLogLabel;
	
	import flash.events.MouseEvent;
	
	public class FarmLogWnd extends AutoWindow
	{
		private var items:Vector.<FarmLogLabel>;
		
		public function FarmLogWnd(){
			super(LibManager.getInstance().getXML("config/ui/farm/farmlog.xml"));
			init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		private function init():void{
			items = new Vector.<FarmLogLabel>();
			mouseChildren = true;
			mouseEnabled = true;
			addEventListener(MouseEvent.CLICK, onMouseClick);
			clsBtn.x -= 6;
			clsBtn.y -= 14;
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			
		}
		
		/**
		 * <T>放入一条日志项</T>
		 * 
		 * @param item 日志项
		 * 
		 */		
		public function pushItem(item:FarmLogLabel):void{
			item.x = 20;
			item.y = 40 + items.length * 31;
			items.push(item);
			addChild(item);
		}
		
		/**
		 * <T>加载日志信息</T>
		 * 
		 * @param obj 日志数据
		 * 
		 */		
		public function initLog(obj:Object):void{
			clear();
			var dataArr:Array = obj.log;
			var length:int = dataArr.length;
			for(var n:int = 0; n < length; n++){
				var item:FarmLogLabel = new FarmLogLabel();
				item.updataInfo(dataArr[n]);
				pushItem(item);
			}
		}
		
		/**
		 * <T>显示窗体并发送日志查询协议</T>
		 * 
		 */		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			Cmd_Farm.cm_FAM_L();
		}
		
		/**
		 * <T>清理</T>
		 * 
		 */		
		protected function clear():void{
			var length:int = items.length;
			for(var n:int = 0; n < length; n++){
				var item:FarmLogLabel = items[n];
				if(contains(item)){
					removeChild(item);
				}
			}
			items.length = 0;
		}
	}
}