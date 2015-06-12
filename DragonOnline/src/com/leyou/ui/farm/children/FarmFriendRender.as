package com.leyou.ui.farm.children
{
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.net.cmd.Cmd_Farm;
	import com.leyou.utils.PropUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class FarmFriendRender extends AutoSprite
	{
		private static const MAX_PAGE_COUNT:int = 8;
		
		private var guildPane:Sprite;
		
		private var friendPane:Sprite;
		
		private var guildList:Vector.<FarmFriendBar>;
		
		private var friendList:Vector.<FarmFriendBar>
		
		private var tabBar:TabBar;
		
		private var _currentTableIdx:int;
		
		private var flagImg:Image;
		
		private var batchReapBtn:ImgButton;
		
		private var pageLbl:Label;
		
		// 当前显示的农场是否自己的
		private var _ownFarm:Boolean;

		private var currentItem:FarmFriendBar;
		
		private var _currentFIndex:int = 0;
		
		private var _currentGIndex:int = 0;
		
		private var prevBtn:ImgButton;
		
		private var nextBtn:ImgButton;
		
		private var pageIndex:int;
		
		private var ftc:int; // 好友总数量用于计算总页数
		
		private var utc:int; // 帮会总数量用于计算总页数
		
		public function FarmFriendRender(){
			super(LibManager.getInstance().getXML("config/ui/farm/friendRender.xml"));
			init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */
		private function init():void{
//			mouseEnabled = true;
			mouseChildren = true;
			
			guildList = new Vector.<FarmFriendBar>(MAX_PAGE_COUNT);
			friendList = new Vector.<FarmFriendBar>(MAX_PAGE_COUNT);
			
			tabBar = getUIbyID("friendBar") as TabBar;
			prevBtn = getUIbyID("prevBtn") as ImgButton;
			nextBtn = getUIbyID("nextBtn") as ImgButton;
			flagImg = getUIbyID("flagImg") as Image;
			pageLbl = getUIbyID("pageLbl") as Label;
			batchReapBtn = getUIbyID("batchReapBtn") as ImgButton;
			prevBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			nextBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			batchReapBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			friendPane = new Sprite();
			tabBar.addToTab(friendPane, 0);
			guildPane = new Sprite();
			tabBar.addToTab(guildPane, 1);
			
			tabBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabBarChangeIndex);
			addEventListener(MouseEvent.CLICK, onFriendClick);
		}
		
		/**
		 * <T>鼠标点击响应</T>
		 * 
		 */
		protected function onMouseClick(event:MouseEvent):void{
			switch(event.target.name){
				case "batchReapBtn":
					if(_ownFarm){
						// 批量收获
						Cmd_Farm.cm_FAM_A();
					}else{
						ownFarm = true;
						UIManager.getInstance().farmWnd.setOwner(PropUtils.getStringById(1700));
						Cmd_Farm.cm_FAM_I();
					}
					break;
				case "prevBtn":
					if(0 == _currentTableIdx){
						if(_currentFIndex > 0){
							_currentFIndex--;
							Cmd_Farm.cm_FAM_P(1, _currentFIndex);
						}
					}else{
						if(_currentGIndex > 0){
							_currentGIndex--;
							Cmd_Farm.cm_FAM_P(2, _currentGIndex);
						}
					}
					break;
				case "nextBtn":
					if(0 == _currentTableIdx){
						if(_currentFIndex < ftc-1){
							_currentFIndex++;
							Cmd_Farm.cm_FAM_P(1, _currentFIndex);
						}
					}else{
						if(_currentGIndex < utc-1){
							_currentGIndex++;
							Cmd_Farm.cm_FAM_P(2, _currentGIndex);
						}
					}
					break;
			}
		}
		
		/**
		 * <T>设置是否为自己农场</T>
		 * 
		 */
		public function set ownFarm(vlaue:Boolean):void{
			_ownFarm = vlaue;
			if(_ownFarm){
				flagImg.updateBmp("ui/farm/font_plsh.png");
			}else{
				flagImg.updateBmp("ui/farm/font_wdnc.png");
			}
		}
		
		/**
		 * <T>标签页点击监听</T>
		 * 
		 */
		protected function onTabBarChangeIndex(event:Event):void{
			if (_currentTableIdx == tabBar.turnOnIndex){
				return;
			}
			_currentTableIdx = tabBar.turnOnIndex;
			if(0 == _currentTableIdx){
				pageLbl.text = (_currentFIndex+1) + "/" + ftc;
			}else{
				pageLbl.text = (_currentGIndex+1) + "/" + utc;
			}
		}
		
		/**
		 * <T>放入好友列表项</T>
		 * 
		 */
//		public function pushItemInFriend(item:FarmFriendBar):void{
//			item.x = 2;
//			item.y = friendList.length * 38;
//			friendList.push(item);
//			friendPane.addToPane(item);
//			item.addEventListener(MouseEvent.CLICK, onFriendClick);
//		}
		
		/**
		 * <T>放入帮会列表项</T>
		 * 
		 */
//		public function pushItemInGuild(item:FarmFriendBar):void{
//			item.x = 2;
//			item.y = guildList.length * 38;
//			guildList.push(item);
//			guildPane.addToPane(item);
//			item.addEventListener(MouseEvent.CLICK, onFriendClick);
//		}
		
		/**
		 * <T>更新好友列表</T>
		 * 
		 * @param obj 好友列表信息
		 * 
		 */		
		public function updataFriendInfo(arr:Array, $ftc:int):void{
			var index:int = 0;
			var l:int = arr.length;
			for(var n:int = 0; n < l; n++){
				if(index >= MAX_PAGE_COUNT){
					return;
				}
				var info:Object = arr[n];
				var item:FarmFriendBar = friendList[index];
				if(null == item){
					item = new FarmFriendBar();
					item.x = 2;
					item.y = 3 + index * 39;
					friendList[index] = item;
					friendPane.addChild(item);
				}
				item.visible = true;
				item.friendName = info.name;
				item.reap = info.c;
				item.irrigation = info.t;
				item.select = false;
				index++;
			}
			for(var m:int = index; m < MAX_PAGE_COUNT; m++){
				var ci:FarmFriendBar = friendList[m];
				if(null != ci){
					ci.visible = false;
				}
			}
			ftc = Math.ceil($ftc/MAX_PAGE_COUNT);
			if(ftc <= 0){
				ftc = 1;
			}
			if(0 == _currentTableIdx){
				pageLbl.text = (_currentFIndex+1) + "/" + ftc;
			}else{
				pageLbl.text = (_currentGIndex+1) + "/" + utc;
			}
		}
		
		/**
		 * <T>更新帮会列表</T>
		 * 
		 * @param obj 帮会列表信息
		 * 
		 */		
		public function updataGuildInfo(arr:Array, $utc:int):void{
			var index:int = 0;
			var l:int = arr.length;
			for(var n:int = 0; n < l; n++){
				if(index >= MAX_PAGE_COUNT){
					return;
				}
				var info:Object = arr[n];
				var item:FarmFriendBar = guildList[index];
				if(null == item){
					item = new FarmFriendBar();
					item.x = 2;
					item.y = 3 + index * 39;
					guildList[index] = item;
					guildPane.addChild(item);
				}
				item.visible = true;
				item.friendName = info.name;
				item.reap = info.c;
				item.irrigation = info.t;
				item.select = false;
				index++;
			}
			for(var m:int = index; m < MAX_PAGE_COUNT; m++){
				var ci:FarmFriendBar = guildList[m];
				if(null != ci){
					ci.visible = false;
				}
			}
			utc = Math.ceil($utc/MAX_PAGE_COUNT);
			if(utc <= 0){
				utc = 1;
			}
			if(0 == _currentTableIdx){
				pageLbl.text = (_currentFIndex+1) + "/" + ftc;
			}else{
				pageLbl.text = (_currentGIndex+1) + "/" + utc;
			}
		}
		
		/**
		 * <T>点击列表项</T>
		 * 
		 */
		public function onFriendClick(event:MouseEvent):void{
			var item:FarmFriendBar = event.target as FarmFriendBar;
			if(null != item){
				if(null != currentItem){
					currentItem.select = false;
				}
				currentItem = item;
				currentItem.select = true;
				Cmd_Farm.cm_FAM_I(currentItem.friendName);
				UIManager.getInstance().farmWnd.setOwner(currentItem.friendName);
				ownFarm = false;
			}
		}
		
		/**
		 * <T>清理</T>
		 * 
		 */
		public function clear():void{
			_currentFIndex = 0;
			_currentGIndex = 0;
//			var c:int = friendList.length;
//			for(var n:int = 0; n < c; n++){
////				friendPane.delFromPane(friendList[n]);
////				friendList[n].removeEventListener(MouseEvent.CLICK, onFriendClick);
//			}
////			friendPane.updateUI();
//			friendList.length = 0;
//			
//			var length:int = guildList.length;
//			for(var m:int = 0; m < length; m++){
////				guildPane.addToPane(guildList[m]);
////				guildList[m].removeEventListener(MouseEvent.CLICK, onFriendClick);
//			}
////			guildPane.updateUI();
//			guildList.length = 0;
		}
		
		public function updataFriend(obj:Object):void{
			var l:int = friendList.length;
			for(var n:int = 0; n < l; n++){
				var item:FarmFriendBar = friendList[n];
				if((null != item) && (obj.name == item.friendName)){
					item.reap = obj.c;
					item.irrigation = obj.t; 
					break;
				}
			}
		}
		
		public function updataGuild(obj:Object):void{
			var l:int = guildList.length;
			for(var n:int = 0; n < l; n++){
				var item:FarmFriendBar = guildList[n];
				if((null != item) && (obj.name == item.friendName)){
					item.reap = obj.c;
					item.irrigation = obj.t;
					break;
				}
			}
		}
	}
}