package com.leyou.ui.rank.child
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Rank;
	
	import flash.events.MouseEvent;
	
	//消费榜列表
	public class RankConsumeRender extends AutoSprite
	{
		private static const ITEM_COUNT:int = 3;
		
		private var spendLbl:Label;
		
		private var itemList:Vector.<RankConsumeItemRender>;
		
		private var _isLock:Boolean;
		
		public function RankConsumeRender(){
			super(LibManager.getInstance().getXML("config/ui/rank/rankConsume.xml"));
			init();
		}
		
		public function init():void{
			mouseChildren = true;
			spendLbl = getUIbyID("spendLbl") as Label;
			itemList = new Vector.<RankConsumeItemRender>();
			for(var n:int = 0; n < ITEM_COUNT; n++){
				var item:RankConsumeItemRender = new RankConsumeItemRender();
				item.x = 10;
				item.y = 24 + n * 128;
				addChild(item);
				itemList.push(item);
				item.setDefault(n+1);
				item.addEventListener(MouseEvent.CLICK, onMouseClick);
			}
			var content:String = TableManager.getInstance().getSystemNotice(10094).content;
			spendLbl.text = StringUtil.substitute(content, ConfigEnum.rank11);
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			var srender:RankConsumeItemRender = event.target as RankConsumeItemRender; 
			UIManager.getInstance().rankWnd.showAvatar(srender.avaStr, srender.gender, srender.vocation, srender.titleId);
			UIManager.getInstance().rankWnd.playerName = srender.getName();
			Cmd_Rank.cm_RAK_A(0, srender.getName());
		}
		
		public function requestInfo():void{
			Cmd_Rank.cm_RAK_C();
		}
		
		public function updateInfo(obj:Object):void{
			var rankArr:Array = obj.crankl;
			var length:int = itemList.length;
			_isLock = (length > 0);
			for(var n:int = 0; n < length; n++){
				var data:Array = rankArr[n];
				var render:RankConsumeItemRender = itemList[n];
				if(null != data){
					render.updateInfo(data);
				}else{
					render.setDefault(n+1);
				}
			}
			var srender:RankConsumeItemRender = itemList[0];
			UIManager.getInstance().rankWnd.showAvatar(srender.avaStr, srender.gender, srender.vocation, srender.titleId);
			UIManager.getInstance().rankWnd.playerName = srender.getName();
			Cmd_Rank.cm_RAK_A(0, srender.getName());
		}
	}
}