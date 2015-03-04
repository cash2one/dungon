package com.leyou.ui.friend
{
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.ui.friend.child.FriendAddBar;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class FriendAddWnd extends AutoWindow
	{
//		private var title:Label;
		
		private var inputNameTxt:TextInput;
		
//		private var numLbl:TextInput;
		
//		private var areaLbl:Label;
		
		private var addFriendBtn:NormalButton;
		
		private var addBlackBtn:NormalButton;
		
		private var addEnemyBtn:NormalButton;
		
		private var checkPlayerBtn:NormalButton;
		
		private var searchPlayList:ScrollPane;
		
		private var searchBtn:ImgButton;
		
		private var items:Vector.<FriendAddBar>;
		
		private var selectItem:FriendAddBar;
		
		public function FriendAddWnd(){
			super(LibManager.getInstance().getXML("config/ui/friends/FriendAddWnd.xml"));
			init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */	
		private function init():void {
			mouseChildren = true;
			mouseEnabled = true;
			inputNameTxt = getUIbyID("inputNameTxt") as TextInput;
			addFriendBtn = getUIbyID("addFriendBtn") as NormalButton;
			addBlackBtn = getUIbyID("addBlackBtn") as NormalButton;
			addEnemyBtn = getUIbyID("addEnemyBtn") as NormalButton;
			checkPlayerBtn = getUIbyID("checkPlayerBtn") as NormalButton;
			searchBtn = getUIbyID("searchBtn") as ImgButton;
			searchPlayList = getUIbyID("searchPlayList") as ScrollPane;
//			addFriend.addEventListener(MouseEvent.CLICK, onMouseClick);
//			cancel.addEventListener(MouseEvent.CLICK, onMouseClick);
//			nameLbl.text = "";
//			numLbl.text = "1";
			items = new Vector.<FriendAddBar>();
//			inputNameTxt.restrict = StringUtil.unusualCharRestrict();
			inputNameTxt.addEventListener(Event.CHANGE, onTextInput);
//			addFriendBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			addBlackBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			addEnemyBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			checkPlayerBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			searchBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			addEventListener(MouseEvent.CLICK, onMouseClick);
			this.hideBg();
			clsBtn.x -= 6;
			clsBtn.y -= 14;
		}
		
		protected function onTextInput(event:Event):void{
			if(StringUtil_II.lengthOf(inputNameTxt.text) > 14){
				var str:String = inputNameTxt.text;
				inputNameTxt.text = StringUtil_II.substr(str, 14);
			}
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			Cmd_Friend.cm_FriendMsg_F(inputNameTxt.text);
		}
		
		/**
		 * <T>按钮点击事件</T>
		 * 
		 */
		protected function onMouseClick(event:MouseEvent):void{
			if(event.target is FriendAddBar){
				var item:FriendAddBar = event.target as FriendAddBar;
				if(null != selectItem){
					selectItem.select = false;
					selectItem.onMouseOut(null);
				}
				item.select = true;
				item.onMouseOver(null);
				selectItem = item;
			}
			var btnName:String = event.target.name;
			switch(btnName){
				case "addFriendBtn":
					if(selectItem){
						Cmd_Friend.cm_FriendMsg_A(1, selectItem.playerName);
					}
					break;
				case "addBlackBtn":
					if(selectItem){
						Cmd_Friend.cm_FriendMsg_A(3, selectItem.playerName);
					}
					break;
				case "addEnemyBtn":
					if(selectItem){
						Cmd_Friend.cm_FriendMsg_A(2, selectItem.playerName);
					}
					break;
				case "checkPlayerBtn":
					if(selectItem){
						UIManager.getInstance().otherPlayerWnd.showPanel(selectItem.playerName);
					}
					break;
				case "searchBtn":
					Cmd_Friend.cm_FriendMsg_F(inputNameTxt.text);
					break;
			}
		}		
		
		public function updateInfo(obj:Object):void{
			clearViewList();
			var pl:Array = obj.pl;
			var length:int = pl.length;
			for(var n:int = 0; n < length; n++){
				var friendItem:FriendAddBar = new FriendAddBar();
				friendItem.setBackGround(n);
				friendItem.updateInfo(pl[n]);
				searchPlayList.addToPane(friendItem);
//				friendItem.x = 19;
				friendItem.y = items.length * 30;
				items.push(friendItem);
			}
		}
		
		private function clearViewList():void{
			var l:int = items.length;
			for(var n:int = 0; n < l; n++){
				var item:FriendAddBar = items[n];
				searchPlayList.delFromPane(item);
//				if(searchPlayList.contains(item)){
//					removeChild(item);
//				}
			}
			items.length = 0;
		}
	}
}