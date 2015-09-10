package com.leyou.ui.chat.child {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.dropMenu.children.ComboBox;
	import com.ace.ui.dropMenu.event.DropMenuEvent;
	import com.ace.ui.input.children.TextInput;
	import com.leyou.enum.ChatEnum;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class PrivateBar extends AutoSprite {
		
		// 私聊玩家姓名输入框
		private var nameInput:TextInput;
		
		// 最近私聊玩家姓名
		private var playerNames:Vector.<String>;
		
		// 最近私聊玩家姓名下拉列表
		private var nameBox:ComboBox;

		private var cycUid:int = 1;
		
		public function PrivateBar() {
			super(LibManager.getInstance().getXML("config/ui/chat/ChatSecret.xml"));
			init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		private function init():void {
			visible = false;
			mouseChildren = true;
			nameBox = getUIbyID("nameBox") as ComboBox;
			nameInput = getUIbyID("nameInput") as TextInput;
			
			nameInput.input.textColor = ChatEnum.COLOR_VAL_PRIVATE;
			playerNames = new Vector.<String>();
			nameInput.addEventListener(MouseEvent.CLICK, onTextClick);
			nameBox.addEventListener(DropMenuEvent.Item_Selected, onNameBoxClick);
		}
		
		/**
		 * <T>放入名称</T>
		 * 
		 * @param name 名称
		 * 
		 */		
		public function pushNmae(name:String):void{
			if(-1 != playerNames.indexOf(name)){
				return;
			}
			while(playerNames.length >= ChatEnum.PALYER_NAME_REMAIN){
				var rid:String = (cycUid-ChatEnum.PALYER_NAME_REMAIN)+"";
				playerNames.shift();
				nameBox.list.removeRender(rid);
			}
			playerNames.push(name);
			nameBox.list.addRender({label:name, uid:cycUid++});
		}
		
		/**
		 * <T>文本选中</T>
		 * 
		 * @param event 鼠标事件
		 * 
		 */		
		protected function onTextClick(event:MouseEvent):void{
			nameInput.input.setSelection(0, nameInput.text.length);
		}
		
		/**
		 * <T>点击玩家名处理</T>
		 * 
		 * @param event 点击事件
		 * 
		 */		
		protected function onNameBoxClick(event:Event):void{
			nameInput.text = StringUtil_II.trim(nameBox.value.label);
		}
		
		/**
		 * <T>返回要私聊玩家的名字</T>
		 *  
		 * @return 玩家名 
		 * 
		 */		
		public function playerName():String {
			var name:String = nameInput.text;
			return StringUtil_II.trim(name);
		}
		
		/**
		 * <T>设置私聊角色名称</T>
		 * 
		 * @param name 名称
		 * 
		 */		
		public function setPlayerName(name:String):void{
			nameInput.text = name;
			pushNmae(name);
		}
		
		/**
		 * <T>玩家名是否有效</T>
		 * 
		 * @return 是否有效 
		 * 
		 */		
		public function playerNameValid():Boolean{
			return (0 != playerName().length);
		}
		
		/**
		 * <T>设置焦点</T>
		 * 
		 */		
		public function setFocus():void{
			stage.focus = nameInput.input;
		}
	}
}