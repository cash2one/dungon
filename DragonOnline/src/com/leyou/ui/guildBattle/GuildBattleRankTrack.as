package com.leyou.ui.guildBattle {
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.ace.utils.StringUtil;
	import com.leyou.data.guildBattle.GuildBattleData;
	import com.leyou.data.guildBattle.GuildBattleTrackData;
	import com.leyou.data.guildBattle.children.GuildBattleTrackItemData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_GuildBattle;
	import com.leyou.ui.guildBattle.children.GuildBattleRankTrackItem;
	import com.leyou.utils.PropUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class GuildBattleRankTrack extends AutoSprite {
		private var items:Vector.<GuildBattleRankTrackItem>;

//		private var killEditLbl:Label;

//		private var ryEditLbl:Label;

		private var rankEditLbl:Label;

//		private var expEditLbl:Label;
//		
//		private var energyEditLbl:Label;

		private var ryLbl:Label;

		private var expLbl:Label;

		private var killLbl:Label;

		private var deadLbl:Label;

		private var energyLbl:Label;

		private var rankLbl:Label;

		private var delLbl:Label;

		private var remianTLbl:Label;

		private var hideBtn:ImgButton;

		private var guildBattleTrack:TabBar;

		private var _currentIdx:int=0;

		private var pane:Sprite;
		
		private var regulationLbl:Label;

		public function GuildBattleRankTrack() {
			super(LibManager.getInstance().getXML("config/ui/guildBattle/warGuildTrack.xml"));
			init();
		}

		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			pane=new Sprite();
			while (0 != numChildren) {
				pane.addChild(getChildAt(0));
			}
			addChild(pane);
			items=new Vector.<GuildBattleRankTrackItem>(GuildBattleData.TRACK_MAX_COUNT);
			guildBattleTrack=getUIbyID("guildBattleTrack") as TabBar;
			rankEditLbl=getUIbyID("rankEditLbl") as Label;
			ryLbl=getUIbyID("ryLbl") as Label;
			expLbl=getUIbyID("expLbl") as Label;
			killLbl=getUIbyID("killLbl") as Label;
			deadLbl=getUIbyID("deadLbl") as Label;
			energyLbl=getUIbyID("energyLbl") as Label;
			rankLbl=getUIbyID("rankLbl") as Label;
			delLbl=getUIbyID("delLbl") as Label;
			hideBtn=getUIbyID("hideBtn") as ImgButton;
			remianTLbl=getUIbyID("remianTLbl") as Label;
			regulationLbl = getUIbyID("regulationLbl") as Label;
			delLbl.multiline=true;
			delLbl.wordWrap=true;
			addChild(hideBtn);
			guildBattleTrack.setTabVisible(2, false);
			hideBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			guildBattleTrack.addEventListener(TabbarModel.changeTurnOnIndex, onTabChange);
			changeDes(DataManager.getInstance().guildBattleData.ctype);
			guildBattleTrack.turnToTab(1);
			
			regulationLbl.mouseEnabled = true;
			regulationLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			var content:String = TableManager.getInstance().getSystemNotice(10162).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}
		
		protected function onTabChange(event:Event):void {
			if (_currentIdx == guildBattleTrack.turnOnIndex) {
				return;
			}
			_currentIdx=guildBattleTrack.turnOnIndex;
			var type:int;
			if (0 == _currentIdx) {
				type=2;
			} else if (1 == _currentIdx) {
				type=1;
			} else if (2 == _currentIdx) {
				type=3;
			}
			DataManager.getInstance().guildBattleData.ctype=type;
			Cmd_GuildBattle.cm_UNZ_U(type, 1, GuildBattleData.TRACK_MAX_COUNT);
			changeDes(type);
		}

		private function changeDes(type:int):void {
			var content:String;
			switch (type) {
				case 1:
					content=TableManager.getInstance().getSystemNotice(3088).content;
					content=StringUtil.substitute(content, ConfigEnum.GUbattle2);
					break;
				case 2:
					content=TableManager.getInstance().getSystemNotice(3089).content;
					break;
				case 3:
					content=TableManager.getInstance().getSystemNotice(3090).content;
					break;
			}
			delLbl.text=content;
		}

		protected function onBtnClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "hideBtn":
					pane.visible=!pane.visible;
					var url:String=pane.visible ? "ui/funForcast/btn_right.png" : "ui/funForcast/btn_left.png";
					hideBtn.updataBmd(url);
					break;
			}
		}

		public override function show():void {
			super.show();
			if (!TimeManager.getInstance().hasITick(updateTime)) {
				TimeManager.getInstance().addITick(1000, updateTime);
			}
			resize();
		}

		public override function hide():void {
			super.hide();
			if (TimeManager.getInstance().hasITick(updateTime)) {
				TimeManager.getInstance().removeITick(updateTime);
			}
		}

		public function updateTime():void {
			var remain:int=DataManager.getInstance().guildBattleData.trackData.remainTime;
			var hh:int=remain / 60;
			var mi:int=remain % 60;
			remianTLbl.text=StringUtil.substitute("{1}:{2}", hh, mi);
		}

		public function updateInfo():void {
			var data:GuildBattleTrackData=DataManager.getInstance().guildBattleData.trackData;
			var count:int=data.getCount();
			for (var n:int=0; n < GuildBattleData.TRACK_MAX_COUNT; n++) {
				var itemData:GuildBattleTrackItemData=data.getItemData(n);
				var itemRender:GuildBattleRankTrackItem=getItem(n);
				if (null != itemData) {
					itemRender.visible=true;
					itemRender.updateInfo(itemData);
				} else {
					itemRender.visible=false;
				}
			}
			if (2 == data.type) {
				rankEditLbl.text=PropUtils.getStringById(1765);
			} else {
				rankEditLbl.text=PropUtils.getStringById(1766);
			}
			rankLbl.x=rankEditLbl.x + rankEditLbl.width;
			var selfData:GuildBattleTrackItemData=data.selfData;
			rankLbl.text=selfData.rank + "";
			ryLbl.text="+" + selfData.honour;
			expLbl.text="+" + selfData.exp + "";
			energyLbl.text="+" + selfData.energy;
			killLbl.text=selfData.kill + "";
			deadLbl.text=selfData.dead + "";
		}

		private function getItem(n:int):GuildBattleRankTrackItem {
			var item:GuildBattleRankTrackItem=items[n];
			if (null == item) {
				item=new GuildBattleRankTrackItem();
				items[n]=item;
				pane.addChild(item);
			}
			item.y=110 + n * 28;
			return item;
		}

		public function resize():void {
			x=UIEnum.WIDTH - 293;
			y=((UIEnum.HEIGHT - 354) >> 1);
		}
	}
}
