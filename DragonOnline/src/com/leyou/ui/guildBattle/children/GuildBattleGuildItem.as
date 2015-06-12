package com.leyou.ui.guildBattle.children {
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.table.TGuildBattleInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;

	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.StyleSheet;

	public class GuildBattleGuildItem extends AutoSprite {
		private var bgHightImg:Image;

		private var rankLbl:Label;

		private var actLbl:Label;

		private var addLbl:Label;

		private var watchLbl:Label;

		private var style:StyleSheet;

		private var _id:int;

		private var _groupId:String;

		private var listenter:Function;

		public function GuildBattleGuildItem() {
			super(LibManager.getInstance().getXML("config/ui/guildBattle/warGuildAwardRender1.xml"));
			init();
		}

		public function get id():int {
			return _id;
		}

		public function get groupId():String {
			return _groupId;
		}

		public function register(fun:Function):void {
			listenter=fun;
		}

		public function unregister():void {
			listenter=null;
		}

		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			bgHightImg=getUIbyID("bgHightImg") as Image;
			rankLbl=getUIbyID("rankLbl") as Label;
			actLbl=getUIbyID("actLbl") as Label;
			addLbl=getUIbyID("addLbl") as Label;
			watchLbl=getUIbyID("watchLbl") as Label;
			var aHover:Object=new Object();
			aHover.color="#ff0000";
			style=new StyleSheet();
			style.setStyle("a:hover", aHover);
			watchLbl.mouseEnabled=true;
			watchLbl.styleSheet=style;
			watchLbl.htmlText=StringUtil_II.addEventString(watchLbl.text, watchLbl.text, true);
			watchLbl.addEventListener(TextEvent.LINK, linkHandler);

			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			bgHightImg.alpha=0;
		}

		public function onMouseOut(event:MouseEvent):void {
			TweenLite.to(bgHightImg, 0.5, {alpha: 0});
		}

		public function onMouseOver(event:MouseEvent):void {
			TweenLite.to(bgHightImg, 0.5, {alpha: 1});
		}

		protected function linkHandler(event:TextEvent):void {
			if (null != listenter) {
				listenter.call(this, this);
			}
		}

		public function updateTInfo(info:TGuildBattleInfo):void {
			_id=info.id;
			_groupId=info.groupId;
			var rs:String;
			var flagArr:Array=info.groupId.split("|");
			if (flagArr[2] > 0) {
				rs=StringUtil.substitute(PropUtils.getStringById(1640), flagArr[1], flagArr[2]);
			} else {
				rs=StringUtil.substitute(PropUtils.getStringById(1641), flagArr[1]);
			}

			rankLbl.text=rs;
			var rate:String="+{1}%";
			var ra:int=DataManager.getInstance().guildBattleData.getRankAdd(flagArr[1]);
			//			var content:String = ConfigEnum.GUbattle9;
			//			var ra:Array = content.split("|");
			//			for each(var str:String in ra){
			//				var subArr:Array = str.split(",");
			//				if(flagArr[1] == subArr[0]){
			rate=StringUtil.substitute(rate, ra);
			//					break;
			//				}
			//			}
			addLbl.text=rate;
			actLbl.text="+" + info.vitality;
		}
	}
}
