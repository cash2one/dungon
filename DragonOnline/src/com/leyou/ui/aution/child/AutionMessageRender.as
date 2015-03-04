package com.leyou.ui.aution.child {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.data.aution.AutionItemData;
	import com.leyou.enum.ConfigEnum;

	public class AutionMessageRender extends AutoSprite {

		private var itemList:ScrollPane;

		private var items:Vector.<AutionMessageLable>;
		
		private var datas:Vector.<AutionItemData>;

		public function AutionMessageRender() {
			super(LibManager.getInstance().getXML("config/ui/aution/autionMessageRender.xml"));
			this.init();
		}

		/**
		 * <T>初始化</T>
		 * 
		 */		
		private function init():void {
			this.mouseEnabled = true;
			this.mouseChildren = true;
			this.itemList = this.getUIbyID("itemList") as ScrollPane;
			this.items = new Vector.<AutionMessageLable>(ConfigEnum.AutionLogItemMax);
			this.datas = new Vector.<AutionItemData>();
//			updateInfo(null);
		}

//		/**
//		 * <T>更新信息</T>
//		 * 
//		 * @param info 信息
//		 * 
//		 */		
//		public function updateInfo(info:Object):void {
//			var msgitem:AutionMessageLable;
//			for (var i:int=0; i < 20; i++) {
//				msgitem=new AutionMessageLable();
//				this.itemList.addToPane(msgitem);
//				msgitem.x=10;
//				msgitem.y=10 + i * (msgitem.height+2);
//			}
//		}

		/**
		 * <T>加载显示数据</T>
		 * 
		 * @param lb 数据数组
		 * 
		 */		
		public function loadInfo(lb:Array):void{
			var length:int = lb.length;
			datas.length = length;
			for(var n:int = 0; n < length; n++){
				var autionData:AutionItemData = datas[n];
				if(null == autionData){
					autionData = new AutionItemData();
					datas[n] = autionData;
				}
				autionData.updateLog(lb[n]);
			}
			renderAll();
		}
		
		/**
		 * <T>显示数据到界面</T>
		 * 
		 */		
		private function renderAll():void{
			var rl:int = items.length;
			var length:int = datas.length;
			for (var i:int = 0; i < rl; i++) {
				var render:AutionMessageLable = items[i];
				if(i < length){
					if(null == render){
						render = new AutionMessageLable();
						render.x = 3;
						render.y = 5 + i * (render.height+1);
						render.setBackGround(i);
						items[i] = render;
					}
					itemList.addToPane(render);
					render.updateInfo(datas[i]);
				}else{
					if(null != render){
						itemList.delFromPane(render);
						render.clear();
					}
				}
			}
			itemList.updateUI();
		}
	}
}
