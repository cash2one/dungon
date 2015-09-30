package com.leyou.ui.copyRank
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCopyInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.TabButton;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.data.copyRank.CopyRankData;
	import com.leyou.data.copyRank.children.CopyRankItemData;
	import com.leyou.net.cmd.Cmd_CPRAK;
	import com.leyou.ui.copyRank.children.CopyRankItemRender;
	
	import flash.events.MouseEvent;
	
	public class CopyRankWnd extends AutoWindow
	{
		private var storyBtn:TabButton;
		
		private var bossBtn:TabButton;
		
		private var towerBtn:TabButton;
		
		private var scrollPanel:ScrollPane;
		
		private var ctype:int;
		
		private var itemRenderList:Array;
		
		public function CopyRankWnd(){
			super(LibManager.getInstance().getXML("config/ui/copyRank/rank2Wnd.xml"));
			init();
		}
		
		public function init():void{
			storyBtn = getUIbyID("storyBtn") as TabButton;
			bossBtn = getUIbyID("bossBtn") as TabButton;
			towerBtn = getUIbyID("towerBtn") as TabButton;
			scrollPanel = getUIbyID("scrollPanel") as ScrollPane;
			scrollPanel.mouseChildren = true;
			
			storyBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			bossBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			towerBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			itemRenderList = [];
			storyBtn.turnOn(false);
			ctype = 1;
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			ctype = 1;
			storyBtn.turnOn(false);
			turnToTab(ctype);
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			switch(event.target.name){
				case "storyBtn":
					ctype = 1;
					break;
				case "bossBtn":
					ctype = 2;
					break;
				case "towerBtn":
					ctype = 12;
					break;
			}
			Cmd_CPRAK.cm_CPRAK_I(ctype);
			turnToTab(ctype);
		}
		
		public function clearPanel():void{
			for each(var item:CopyRankItemRender in itemRenderList){
				if(scrollPanel.contains(item)){
					scrollPanel.delFromPane(item);
				}
			}
		}
		
		protected function turnToTab(type:int):void{
			clearPanel();
			var sortArr:Array = [];
			var copyDic:Object = TableManager.getInstance().getCopyDic();
			var data:CopyRankData = DataManager.getInstance().copyRankData;
			for(var key:String in copyDic){
				var tcopyInfo:TCopyInfo = copyDic[key];
				if(tcopyInfo.fastTop && (type == tcopyInfo.type)){
					sortArr.push(tcopyInfo);
				}
			}
			sortArr.sort(sortFun);
			var length:int = sortArr.length;
			for(var n:int = 0; n < length; n++){
				var ttcopyInfo:TCopyInfo = sortArr[n];
				var itemRender:CopyRankItemRender = itemRenderList[n];
				if(null == itemRender){
					itemRender = new CopyRankItemRender();
					itemRenderList[n] = itemRender;
				}
				itemRender.updateTInfo(ttcopyInfo);
				var itemData:CopyRankItemData = data.getCopyById(ttcopyInfo.id);
				if(null != itemData){
					itemRender.updateDInfo(itemData);
				}
				scrollPanel.addToPane(itemRender);
				itemRender.y = n*103;
			}
			scrollPanel.scrollTo(0);
			scrollPanel.updateUI();
			
			function sortFun(r1:TCopyInfo, r2:TCopyInfo):int{
				if(r1.id > r2.id){
					return 1;
				}else if(r2.id > r1.id){
					return -1;
				}
				return 0;
			}
		}
		
		public function updateInfo():void{
			turnToTab(ctype);
		}
	}
}