package com.leyou.ui.guildBattle {
	
	import com.ace.enum.UIEnum;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.net.cmd.Cmd_GuildBattle;
	import com.leyou.net.cmd.Cmd_WARC;
	import com.leyou.net.cmd.Cmd_ZC;
	import com.leyou.ui.battlefield.IceBattlefieldRender;
	import com.leyou.ui.cityBattle.CityBattleRender;
	import com.leyou.ui.guildBattle.children.GuildBattleGuildRender;

	import flash.events.Event;

	public class GuildBattleWnd extends AutoWindow {
		
		
		private var guildRender:GuildBattleGuildRender;

		private var guildBttleType:TabBar;

		private var cityBattle:CityBattleRender;

		private var iceBattle:IceBattlefieldRender;

		private var _currentIndex:int;

		public function GuildBattleWnd() {
			super(LibManager.getInstance().getXML("config/ui/guildBattle/warWnd.xml"));
			init();
		}

		private function init():void {
			guildRender=new GuildBattleGuildRender();
			cityBattle=new CityBattleRender();
			iceBattle=new IceBattlefieldRender();
			guildBttleType=getUIbyID("guildBttleType") as TabBar;
			guildBttleType.addToTab(guildRender, 0);
			guildBttleType.addToTab(cityBattle, 1);
			guildBttleType.addToTab(iceBattle, 2);
			guildBttleType.addEventListener(TabbarModel.changeTurnOnIndex, onTabClick);
		}

		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			switch (_currentIndex) {
				case 0:
					Cmd_GuildBattle.cm_UNZ_I();
					break;
				case 1:
					Cmd_WARC.cm_WARC_I();
					break;
				case 2:
					Cmd_ZC.cm_ZC_I();
					break;
			}
		}

		public function updateGuildBattleInfo():void {
			guildRender.updateInfo();
		}

		public function resize():void {
			x=(UIEnum.WIDTH - width) >> 1;
			y=(UIEnum.HEIGHT - height) >> 1;
		}

		protected function onTabClick(event:Event):void {
			if (_currentIndex == guildBttleType.turnOnIndex) {
				return;
			}
			_currentIndex=guildBttleType.turnOnIndex;
			switch (_currentIndex) {
				case 0:
					Cmd_GuildBattle.cm_UNZ_I();
					break;
				case 1:
					Cmd_WARC.cm_WARC_I();
					break;
				case 2:
					Cmd_ZC.cm_ZC_I();
					break;
			}
		}

		public function updateCityBattleInfo():void {
			cityBattle.updateInfo();
		}

		public function updateIceBattleInfo():void {
			iceBattle.updateInfo();
		}

		public override function get width():Number {
			return 778;
		}

		public override function get height():Number {
			return 482;
		}

		public function changeToIndex(index:int):void {
			guildBttleType.turnToTab(index);
		}
	}
}
