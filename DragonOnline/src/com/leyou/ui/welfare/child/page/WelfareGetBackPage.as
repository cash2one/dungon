package com.leyou.ui.welfare.child.page
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFindBackInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.leyou.ui.welfare.child.component.WelfareGetBackSourcesRender;
	import com.leyou.ui.welfare.child.component.WelfareGetBackTimesRender;
	
	import flash.events.MouseEvent;
	
	public class WelfareGetBackPage extends AutoSprite
	{
		private var timesRenderList:Vector.<WelfareGetBackTimesRender>;
		
		private var sourcesRenderList:Vector.<WelfareGetBackSourcesRender>;
		
		private var oneKeyBtn:ImgButton;
		
		private var supremacyBtn:ImgButton;
		
		private var desLbl:Label;
		
		public function WelfareGetBackPage(){
			super(LibManager.getInstance().getXML("config/ui/welfare/welfareBack.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			timesRenderList = new Vector.<WelfareGetBackTimesRender>(3);
			sourcesRenderList = new Vector.<WelfareGetBackSourcesRender>(3);
			for(var n:int = 0; n < 3; n++){
				var timesRender:WelfareGetBackTimesRender = new WelfareGetBackTimesRender();
				addChild(timesRender);
				timesRender.x = 5 + n * 274;
				timesRender.y = 27;
				timesRenderList[n] = timesRender;
			}
			for(var m:int = 0; m < 3; m++){
				var sourcesRender:WelfareGetBackSourcesRender = new WelfareGetBackSourcesRender();
				addChild(sourcesRender);
				sourcesRender.x = 5 + m * 274;
				sourcesRender.y = 214;
				sourcesRenderList[m] = sourcesRender;
			}
			desLbl = getUIbyID("desLbl") as Label;
			oneKeyBtn = getUIbyID("oneKeyBtn") as ImgButton;
			supremacyBtn = getUIbyID("supremacyBtn") as ImgButton;
			oneKeyBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			supremacyBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			desLbl.htmlText = TableManager.getInstance().getSystemNotice(10136).content;
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			UIManager.getInstance().showWindow(WindowEnum.WELFARE_FINDBACK);
			switch(event.target.name){
				case "oneKeyBtn":
					UIManager.getInstance().welfareGetBack.updateInfoOneKey(1);
					break;
				case "supremacyBtn":
					UIManager.getInstance().welfareGetBack.updateInfoOneKey(2);
					break;
			}
		}
		
		public function updateInfo(obj:Object):void{
			UIManager.getInstance().creatWindow(WindowEnum.WELFARE_FINDBACK);
			UIManager.getInstance().welfareGetBack.pushData(obj);
			var index1:int;
			var index2:int;
			var hasReward:Boolean = false;
			var flist:Array = obj.flist;
			var l:int = flist.length;
			for(var n:int = 0; n < l; n++){
				var arr:Array = flist[n];
				if(0 == int(arr[2])){
					hasReward = true;
				}
				var info:TFindBackInfo = TableManager.getInstance().getFinkBackInfo(arr[0]);
				if(1 == info.type){
					var timesRender:WelfareGetBackTimesRender = timesRenderList[index1++];
					timesRender.updateInfo(arr);
				}else if(2 == info.type){
					var sourcesRender:WelfareGetBackSourcesRender = sourcesRenderList[index2++];
					sourcesRender.updateInfo(arr);
				}
			}
			
			oneKeyBtn.setActive(hasReward, 1, true);
			supremacyBtn.setActive(hasReward, 1, true);
		}
	}
}