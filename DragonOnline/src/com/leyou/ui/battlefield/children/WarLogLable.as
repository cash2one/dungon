package com.leyou.ui.battlefield.children
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.children.TextArea;
	import com.ace.utils.StringUtil;
	import com.leyou.data.iceBattle.children.BattleHistoryData;
	
	public class WarLogLable extends AutoSprite
	{
		private var msgLbl:TextArea;
		
		public function WarLogLable(){
			super(LibManager.getInstance().getXML("config/ui/iceBattle/warLogLable.xml"));
			init();
		}
		
		private function init():void{
			msgLbl = getUIbyID("msgLbl") as TextArea;
		}
		
		public function updateInfo(data:BattleHistoryData):void{
			var content:String = TableManager.getInstance().getSystemNotice(data.msgid).content;
			content = StringUtil.substitute(content, data.val);
			msgLbl.setText(content);
		}
	}
}