package com.leyou.ui.chat.child {
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.NormalButton;
	import com.leyou.enum.ChatEnum;
	import com.leyou.ui.chat.ChatWnd;
	
	import flash.events.MouseEvent;
	
	public class ChatConfig extends AutoSprite {
		
		private var privateCheckBox:CheckBox;
		
		private var teamCheckBox:CheckBox;
		
		private var guildCheckBox:CheckBox;
		
		private var worldCheckBox:CheckBox;
		
		private var confirmBtn:NormalButton;
		
		private var cancelBtn:NormalButton;
		
		private var channelFalg:Object;
		
		private var transferFalg:Object;
		
		public var confirmFilter:Function;
		
		public function ChatConfig() {
			super(LibManager.getInstance().getXML("config/ui/chat/ChatConfig.xml"));
			init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		private function init():void{
			visible = false;
			mouseChildren = true;
			privateCheckBox = getUIbyID("privateCheckBox") as CheckBox;
			teamCheckBox = getUIbyID("teamCheckBox") as CheckBox;
			guildCheckBox = getUIbyID("guildCheckBox") as CheckBox;
			worldCheckBox = getUIbyID("worldCheckBox") as CheckBox;
			
			confirmBtn = getUIbyID("confirmBtn") as NormalButton;
			cancelBtn = getUIbyID("cancelBtn") as NormalButton;
			
			privateCheckBox.addEventListener(MouseEvent.CLICK, onCheckClick);
			teamCheckBox.addEventListener(MouseEvent.CLICK, onCheckClick);
			guildCheckBox.addEventListener(MouseEvent.CLICK, onCheckClick);
			worldCheckBox.addEventListener(MouseEvent.CLICK, onCheckClick);
			
			confirmBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			cancelBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			channelFalg = new Object();
			transferFalg = new Object();
			channelFalg[ChatEnum.CHANNEL_PRIVATE] = false;
			channelFalg[ChatEnum.CHANNEL_TEAM] = false;
			channelFalg[ChatEnum.CHANNEL_GUILD] = false;
			channelFalg[ChatEnum.CHANNEL_WORLD] = false;
		}
		
		/**
		 * <T>按钮点击监听</T>
		 * 
		 * @param event 鼠标事件
		 * 
		 */		
		protected function onButtonClick(event:MouseEvent):void{
			visible = false;
			switch(event.target.name){
				case "confirmBtn":
					channelFalg[ChatEnum.CHANNEL_PRIVATE] = transferFalg[ChatEnum.CHANNEL_PRIVATE];
					channelFalg[ChatEnum.CHANNEL_TEAM] = transferFalg[ChatEnum.CHANNEL_TEAM];
					channelFalg[ChatEnum.CHANNEL_GUILD] = transferFalg[ChatEnum.CHANNEL_GUILD];
					channelFalg[ChatEnum.CHANNEL_WORLD] = transferFalg[ChatEnum.CHANNEL_WORLD];
					break;
				case "cancelBtn":
					transferFalg[ChatEnum.CHANNEL_PRIVATE] = channelFalg[ChatEnum.CHANNEL_PRIVATE];
					transferFalg[ChatEnum.CHANNEL_TEAM] = channelFalg[ChatEnum.CHANNEL_TEAM];
					transferFalg[ChatEnum.CHANNEL_GUILD] = channelFalg[ChatEnum.CHANNEL_GUILD];
					transferFalg[ChatEnum.CHANNEL_WORLD] = channelFalg[ChatEnum.CHANNEL_WORLD];
					transferFalg[ChatEnum.CHANNEL_PRIVATE] ? privateCheckBox.turnOn() : privateCheckBox.turnOff();
					transferFalg[ChatEnum.CHANNEL_TEAM] ? teamCheckBox.turnOn() : teamCheckBox.turnOff();
					transferFalg[ChatEnum.CHANNEL_GUILD] ? guildCheckBox.turnOn() : guildCheckBox.turnOff();
					transferFalg[ChatEnum.CHANNEL_WORLD] ? worldCheckBox.turnOn() : worldCheckBox.turnOff();
					break;
			}
		}
		
		/**
		 * <T>勾选框框点击监听</T>
		 * 
		 * @param evt 鼠标
		 * 
		 */		
		private function onCheckClick(evt:MouseEvent):void{
			switch(evt.target.name){
				case "privateCheckBox":
					transferFalg[ChatEnum.CHANNEL_PRIVATE] = privateCheckBox.isOn;
					break;
				case "teamCheckBox":
					transferFalg[ChatEnum.CHANNEL_TEAM] = teamCheckBox.isOn;
					break;
				case "guildCheckBox":
					transferFalg[ChatEnum.CHANNEL_GUILD] = guildCheckBox.isOn;
					break;
				case "worldCheckBox":
					transferFalg[ChatEnum.CHANNEL_WORLD] = worldCheckBox.isOn;
					break;
			}
		}
		
		/**
		 * <T>显示和隐藏</T>
		 * 
		 */	
		public override function open():void{
			visible = !visible;
			resize();
		}
		
		/**
		 * <T>舞台尺寸被改变</T>
		 * 
		 */		
		public function resize():void{
			var chatWnd:ChatWnd = UIManager.getInstance().chatWnd;
			x = chatWnd.width;
			y = chatWnd.y + 327 - height;
		}
		
		/**
		 * <T>频道是否被限制</T>
		 * 
		 * @param type 频道类型
		 * @return     是否被限制
		 * 
		 */		
		public function getLimit(type:int):Boolean{
			return channelFalg[type];
		}
	}
}