/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-10-23 下午5:05:49
 */
package com.test {
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TNoticeInfo;
	import com.ace.manager.KeysManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.enum.QualityEnum;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	public class TestMessageWnd extends AutoWindow {
		private static var instance:TestMessageWnd;

		public static function getInstance():TestMessageWnd {
			if (!instance)
				instance=new TestMessageWnd();
			return instance;
		}

		private var messageInput:TextInput;
		private var valuesInput:TextInput;
		private var sendBtn:NormalButton;


		public function TestMessageWnd() {
			super(LibManager.getInstance().getXML("config/ui/test/TestMessageWnd.xml"));
			this.init();
			KeysManager.getInstance().addKeyFun(Keyboard.M, this.open);
			LayerManager.getInstance().windowLayer.addChild(this);
		}

		private function init():void {
			this.messageInput=this.getUIbyID("messageInput") as TextInput;
			this.valuesInput=this.getUIbyID("valuesInput") as TextInput;
			this.sendBtn=this.getUIbyID("sendBtn") as NormalButton;

			this.sendBtn.addEventListener(MouseEvent.CLICK, onCLick);
		}

		private function onCLick(evt:Event):void {
			switch (evt.target.name) {
				case "sendBtn":
					NoticeManager.getInstance().broadcast( //
						TableManager.getInstance().getSystemNotice(int(this.messageInput.text)), replaceItem(this.valuesInput.text.split(",")));
//					var notice:TNoticeInfo = new TNoticeInfo();
//					notice.screenId1 = 8;
//					notice.screenId2 = -1;
//					notice.screenId3 = -1;
//					notice.id = 111;
//					notice.content = "1|ui/icon/icon_hp.png,这是个测试用的TIP"
//					NoticeManager.getInstance().broadcast(notice);
					break;
			}
		}
		
		/**
		 * <T>将道具ID替换为带颜色的HTML名称</T>
		 * 
		 * @param values 源数组
		 * @return       替换后数组
		 * 
		 */		
		public static function replaceItem(values:Array):Array{
			var copy:Array = new Array();
			var count:int = values.length;
			for(var n:int = 0; n < count; n++){
				var value:Object = values[n];
				var index:int = value.toString().indexOf("#");
				if(-1 != index){
					var itemId:uint = uint(value.substr(index+1));
					var itemInfo:TItemInfo = TableManager.getInstance().getItemInfo(itemId);
					var equipInfo:TEquipInfo = TableManager.getInstance().getEquipInfo(itemId);
					var qulity:uint;
					var itemName:String;
					if(null != itemInfo){
						qulity = uint(itemInfo.quality);
						itemName = itemInfo.name;
					}
					if(null != equipInfo){
						qulity = uint(equipInfo.quality);
						itemName = equipInfo.name;
					}
					var color:String = "#" + getColorByQuality(qulity).toString(16).replace("0x");
					var reName:String = getColorStr(itemName, color);
					copy[n] = reName;
				}else{
					copy[n] = value;
				}
			}
			return copy;
		}
		
		public static function getColorByQuality(i:int):uint{
			switch(i){
				case QualityEnum.QUA_COMMON:
					return 0xffffff;
				case QualityEnum.QUA_EXCELLENT:
					return 0x69e053;
				case QualityEnum.QUA_TERRIFIC:
					return 0x3fa6ed;
				case QualityEnum.QUA_INCREDIBLE:
					return 0xcc54ea;
				case QualityEnum.QUA_LEGEND:
					return 0xf6d654;
			}
			return 0xffffff;
		}
		
		public static function getColorStr(str:String, color:String,size:int=12):String {
			if("" != str){
				str="<font color='" + color + "' size='"+size+"'>" + str + "</font>";
			}
			return str;
		}
	}
}