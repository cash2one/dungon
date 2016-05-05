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
	import com.leyou.data.crossServer.CrossServerData;
	import com.leyou.data.crossServer.children.CrossServerLvData;
	import com.leyou.enum.TipsEnum;
	import com.leyou.net.cmd.Cmd_Across;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class CrossServerLvRender extends AutoSprite
	{
		private var serverLbl:Label;
		
		private var serverNameLbl:Label;
		
		private var ruleLbl:Label;
		
		private var prosperousLbl:Label;
		
		private var serverLvBtn:ImgButton;
		
		private var replaceNameBtn:NormalButton;
		
		private var serverNameELbl:TextInput;
		
		private var replaceLbl:Label;
		
		private var panel:ScrollPane;
		
		private var itemList:Vector.<CrossServerLvItemRender>;
		
		private var serverNameSt:int; // 0-普通状态 1-更名状态
		
		private var progressImg:Image;
		
		private var bg:Image;
		
		public function CrossServerLvRender(){
			super(LibManager.getInstance().getXML("config/ui/crossServer/kfdtLvRender.xml"));
			init();
		}
		
		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			serverLbl = getUIbyID("serverLbl") as Label;
			serverNameLbl = getUIbyID("serverNameLbl") as Label;
			serverNameELbl = getUIbyID("serverENameLbl") as TextInput;
			ruleLbl = getUIbyID("ruleLbl") as Label;
			prosperousLbl = getUIbyID("prosperousLbl") as Label;
			serverLvBtn = getUIbyID("serverLvBtn") as ImgButton;
			replaceNameBtn = getUIbyID("replaceNameBtn") as NormalButton;
			replaceLbl = getUIbyID("replaceLbl") as Label;
			panel = getUIbyID("panel") as ScrollPane;
			progressImg = getUIbyID("progressImg") as Image;
			bg = getUIbyID("bg") as Image;
			
			replaceNameBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			serverLvBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			itemList = new Vector.<CrossServerLvItemRender>();
			serverNameELbl.visible = false;
			
			ruleLbl.mouseEnabled = true;
			ruleLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			
			var spt:Sprite = new Sprite();
			addChild(spt);
			swapChildren(spt, bg);
			spt.addChild(bg);
			spt.name = "progressImg";
			spt.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			var content:String;
			switch(event.target.name){
				case "progressImg":
					content = TableManager.getInstance().getSystemNotice(11012).content;
					break;
				case "ruleLbl":
					content = TableManager.getInstance().getSystemNotice(11000).content;
					break;
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY))
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "serverLvBtn":
					Cmd_Across.cm_ACROSS_U();
					break;
				case "replaceNameBtn":
					if(1 == serverNameSt){
						serverNameSt = 0;
						replaceNameBtn.text = PropUtils.getStringById(2271);
						serverNameLbl.visible = true;
						serverNameELbl.visible = false;
						Cmd_Across.cm_ACROSS_N(serverNameELbl.text);
					}else if(0 == serverNameSt){
						serverNameSt = 1;
						replaceNameBtn.text = PropUtils.getStringById(2272);
						serverNameLbl.visible = false;
						serverNameELbl.visible = true;
						stage.focus = serverNameELbl.input;
						serverNameELbl.input.setSelection(serverNameELbl.text.length, serverNameELbl.text.length);
					}
					break;
			}
		}
		
		public function updateInfo():void{
			// 我的数据
			var data:CrossServerData = DataManager.getInstance().crossServerData;
			if(data.myServerData.lv <= 0){
				return;
			}
			var serverLv:TCSLvInfo = TableManager.getInstance().getCrossServerInfo(data.myServerData.lv);
			serverLbl.text = PropUtils.getStringById(2243)+data.myServerData.lv;
			serverNameLbl.text = data.myServerData.serverName;
			prosperousLbl.text = data.myServerData.boomValue+"/"+serverLv.legacyLimit;
			serverNameELbl.text = data.myServerData.serverName;
			replaceNameBtn.visible = (data.myServerData.masterName == Core.me.info.name);
			if(data.myServerData.boomValue/serverLv.legacyLimit >= 1){
				progressImg.scaleX = 1;
			}else{
				progressImg.scaleX = data.myServerData.boomValue/serverLv.legacyLimit;
			}
			
			// 国家列表数据
			var itemCount:int = itemList.length;
			for(var n:int = 0; n < itemCount; n++){
				var item:CrossServerLvItemRender = itemList[n];
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
			for(var m:int = 0; m < sl; m++){
				var serverData:CrossServerLvData = serverList[m];
				var serverItem:CrossServerLvItemRender = itemList[m];
				if(null == serverItem){
					serverItem = new CrossServerLvItemRender();
					itemList[m] = serverItem;
				}
				serverItem.updateInfo(serverData);
				panel.addToPane(serverItem);
				serverItem.x = 1;
				serverItem.y = m * 42;
			}
			panel.updateUI();
		}
	}
}