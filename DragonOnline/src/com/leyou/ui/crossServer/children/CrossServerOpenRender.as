package com.leyou.ui.crossServer.children
{
	import com.ace.config.Core;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCSLvInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.window.children.PopWindow;
	import com.ace.utils.StringUtil;
	import com.leyou.data.crossServer.CrossServerData;
	import com.leyou.data.crossServer.children.CrossServerLvData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Across;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.PropUtils;
	
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class CrossServerOpenRender extends AutoSprite
	{
		private var serverNameLbl:Label;
		
		private var ruleLbl:Label;
		
		private var prosperousLbl:Label;
		
		private var progressImg:Image;
		
		private var serverLvBtn:ImgButton;
		
		private var donateCLbl:Label;
		
		private var gxLbl:Label;
		
		private var remaincLbl:Label;
		
		private var donatePBtn:NormalButton;
		
		private var moneyCLbl:Label;
		
		private var gxmLbl:Label;
		
		private var donateMBtn:NormalButton;
		
		private var panel:ScrollPane;
		
		private var itemList:Vector.<CrossServerOpenItem>;
		
		private var bg:Image;
		
		private var serverNameSt:int;
		
		private var grid:MarketGrid;
		
		private var myRankItem:CrossServerOpenItem;
		
		public function CrossServerOpenRender(){
			super(LibManager.getInstance().getXML("config/ui/crossServer/kfdtOpenRender.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			serverNameLbl = getUIbyID("serverNameLbl") as Label;
			ruleLbl = getUIbyID("ruleLbl") as Label;
			prosperousLbl = getUIbyID("prosperousLbl") as Label;
			progressImg = getUIbyID("progressImg") as Image;
			serverLvBtn = getUIbyID("serverLvBtn") as ImgButton;
			donateCLbl = getUIbyID("donateCLbl") as Label;
			gxLbl = getUIbyID("gxLbl") as Label;
			remaincLbl = getUIbyID("remaincLbl") as Label;
			donatePBtn = getUIbyID("donatePBtn") as NormalButton;
			moneyCLbl = getUIbyID("moneyCLbl") as Label;
			gxmLbl = getUIbyID("gxmLbl") as Label;
			donateMBtn = getUIbyID("donateMBtn") as NormalButton;
			panel = getUIbyID("panel") as ScrollPane;
			bg = getUIbyID("bg") as Image;
			grid = new MarketGrid();
			grid.x = 15;
			grid.y = 224;
			addChild(grid);
			
			donatePBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			donateMBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			serverLvBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			itemList = new Vector.<CrossServerOpenItem>();
			
			ruleLbl.mouseEnabled = true;
			ruleLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			
			var spt:Sprite = new Sprite();
			addChild(spt);
			swapChildren(spt, bg);
			spt.addChild(bg);
			spt.name = "progressImg";
			spt.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			
			donateCLbl.text = ConfigEnum.multiple22+"";
			gxLbl.text = ConfigEnum.multiple20*ConfigEnum.multiple22+"";
			grid.updataById(ConfigEnum.multiple18);
			
			moneyCLbl.text = ConfigEnum.multiple21+"";
			gxmLbl.text = ConfigEnum.multiple17*ConfigEnum.multiple21+"";
			myRankItem = new CrossServerOpenItem();
			addChild(myRankItem);
			myRankItem.x = 360;
			myRankItem.y = 384;
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			var content:String;
			switch(event.target.name){
				case "progressImg":
					content = TableManager.getInstance().getSystemNotice(11012).content;
					break;
				case "ruleLbl":
					content = TableManager.getInstance().getSystemNotice(11031).content;
					break;
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY))
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "serverLvBtn":
					Cmd_Across.cm_ACROSS_A();
					break;
				case "donatePBtn":
					Cmd_Across.cm_ACROSS_J(1, ConfigEnum.multiple22);
					break;
				case "donateMBtn":
					var content:String = TableManager.getInstance().getSystemNotice(11033).content;
					content = StringUtil.substitute(content, ConfigEnum.multiple21);
					PopupManager.showConfirm(content, OK, null, false, "crossserver.confirm.donate");
					break;
			}
			
			function OK():void{
				Cmd_Across.cm_ACROSS_J(2, ConfigEnum.multiple21);
			}
		}
		
		public function updateInfo():void{
			// 我的数据
			var data:CrossServerData = DataManager.getInstance().crossServerData;
			var serverLv:TCSLvInfo = TableManager.getInstance().getCrossServerInfo(data.myServerData.lv);
			serverNameLbl.text = data.myServerData.serverName;
			prosperousLbl.text = data.myServerData.boomValue+"/"+serverLv.legacyLimit;
			remaincLbl.text = data.remainCount+"";
			if(data.myServerData.boomValue/serverLv.legacyLimit >= 1){
				progressImg.scaleX = 1;
			}else{
				progressImg.scaleX = data.myServerData.boomValue/serverLv.legacyLimit;
			}
			
			// 国家列表数据
			var itemCount:int = itemList.length;
			for(var n:int = 0; n < itemCount; n++){
				var item:CrossServerOpenItem = itemList[n];
				if((null != item) && panel.contains(item)){
					panel.delFromPane(item);
				}
			}
			panel.updateUI();
			
			var serverList:Vector.<CrossServerLvData> = data.serverList;
			if(itemList.length < serverList.length){
				itemList.length = serverList.length;
			}
			var sl:int = serverList.length;
			for(var m:int = 0; m < sl-1; m++){
				var serverData:CrossServerLvData = serverList[m];
				var serverItem:CrossServerOpenItem = itemList[m];
				if(null == serverItem){
					serverItem = new CrossServerOpenItem();
					itemList[m] = serverItem;
				}
				serverItem.updateInfo(serverData);
				panel.addToPane(serverItem);
				serverItem.x = 1;
				serverItem.y = m * 42;
			}
			myRankItem.updateInfo(serverList[sl-1]);
			panel.updateUI();
		}
	}
}