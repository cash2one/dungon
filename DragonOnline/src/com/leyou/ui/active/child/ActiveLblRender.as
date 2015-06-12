package com.leyou.ui.active.child
{
	import com.ace.config.Core;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TActiveInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.TextEvent;
	import flash.text.StyleSheet;
	
	public class ActiveLblRender extends AutoSprite
	{
		public var id:int;
		
		private var nameLbl:Label;
		
		private var rateLbl:Label;
		
		private var activeLbl:Label;
		
		private var finishLbl:Label;
		
		private var style:StyleSheet;
		
		private var linkUI:int;
		
		private var activeInfo:TActiveInfo;
		
		private var _complete:Boolean;
		
		private var text:String;
		
		public function ActiveLblRender(){
			super(LibManager.getInstance().getXML("config/ui/active/activeListBar.xml"));
			init();
		}
		
		public function get complete():Boolean
		{
			return _complete;
		}

		private function init():void{
			mouseChildren = true;
			nameLbl = getUIbyID("nameLbl") as Label;
			rateLbl = getUIbyID("rateLbl") as Label;
			activeLbl = getUIbyID("activeLbl") as Label;
			finishLbl = getUIbyID("finishLbl") as Label;
			
			finishLbl.mouseEnabled = true;
			style = new StyleSheet()
			var aHover:Object = new Object();
			aHover.color = "#ff0000";
			style.setStyle("a:hover", aHover);
			text = finishLbl.text;
		}
		
		protected function linkHandler(event:TextEvent):void{
			switch(activeInfo.openId){
				case 0:
					break;
				case 1:
					UIOpenBufferManager.getInstance().open(WindowEnum.WELFARE);
					UIManager.getInstance().creatWindow(WindowEnum.WELFARE);
					UIManager.getInstance().welfareWnd.changeTable(0);
					break;
				case 2:
					UILayoutManager.getInstance().show_II(WindowEnum.TASK);
					UIManager.getInstance().taskWnd.changeTab(1);
					break;
				case 3:
					UIOpenBufferManager.getInstance().open(WindowEnum.FARM);
					break;
				case 4:
					UIOpenBufferManager.getInstance().open(WindowEnum.BOSS);
					break;
				case 5:
					UILayoutManager.getInstance().open_II(WindowEnum.DUNGEON_TEAM);
					break;
				case 6:
					UILayoutManager.getInstance().open_II(WindowEnum.PKCOPY);
					break;
				case 7:
					UILayoutManager.getInstance().open_II(WindowEnum.ARENA);
					break;
				case 9:
					UIOpenBufferManager.getInstance().open(WindowEnum.WORSHIP);
					break;
				case 10:
					UIOpenBufferManager.getInstance().open(WindowEnum.RANK);
					break;
				default:
					Cmd_Go.cmGo(activeInfo.openId);
					break;
			}
			UIManager.getInstance().hideWindow(WindowEnum.ACTIVE);
		}
		
		public function updateInfo($id:int, cc:int):void{
			id = $id;
			activeInfo = TableManager.getInstance().getActiveInfo($id);
			nameLbl.text = activeInfo.des;
			rateLbl.text = cc + "/" + activeInfo.value;
			activeLbl.text = PropUtils.getStringById(1582)+activeInfo.reward;
			finishLbl.visible = (activeInfo.openId > 0);
			_complete = (cc >= activeInfo.value);
			filters = _complete ? [FilterEnum.enable] : null;
			
			if(activeInfo.level > Core.me.info.level){
				finishLbl.htmlText = StringUtil_II.getColorStr(activeInfo.level+PropUtils.getStringById(1583), "#FF0000");
				return;
			}
			
			if(!_complete){
				finishLbl.styleSheet = style;
				finishLbl.htmlText = StringUtil_II.addEventString(text, text, true);
				finishLbl.addEventListener(TextEvent.LINK, linkHandler);
			}else{
				finishLbl.styleSheet = null;
				finishLbl.htmlText = StringUtil_II.getColorStr(PropUtils.getStringById(1584), "#8B8989");
			}
		}
	}
}