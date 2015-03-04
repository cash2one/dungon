package com.leyou.ui.cityBattle
{
	import com.ace.config.Core;
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.game.scene.player.part.LivingModel;
	import com.ace.game.utils.SceneUtil;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.data.cityBattle.CityBattleTrackData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.cityBattle.children.CityBattleTrackReward;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.StyleSheet;
	
	public class CityBattleTrack extends AutoSprite
	{
		private var ruleLbl:Label;
		
		private var timeLbl:Label;
		
		private var expLbl:Label;
		
		private var energyLbl:Label;
		
		private var ryLbl:Label;
		
		private var gotNameLbl:Label;
		
		private var gotTimeLbl:Label;
		
		private var timeTitleLbl:Label;
		
		private var gotGuildLbl:Label;
		
		private var buffs:Vector.<CityBattleTrackReward>;
		
		public function CityBattleTrack(){
			super(LibManager.getInstance().getXML("config/ui/cityBattle/warCityTrack.xml"));
			init();
		}
		
		private function init():void{
			mouseEnabled = false;
			mouseChildren = true;
			ruleLbl = getUIbyID("ruleLbl") as Label;
			timeLbl = getUIbyID("timeLbl") as Label;
			timeTitleLbl = getUIbyID("timeTitleLbl") as Label;
			expLbl = getUIbyID("expLbl") as Label;
			energyLbl = getUIbyID("energyLbl") as Label;
			ryLbl = getUIbyID("ryLbl") as Label;
			gotNameLbl = getUIbyID("gotNameLbl") as Label;
			gotTimeLbl = getUIbyID("gotTimeLbl") as Label;
			gotGuildLbl = getUIbyID("gotGuildLbl") as Label;
			buffs = new Vector.<CityBattleTrackReward>(3);
			for(var n:int = 0; n < 3; n++){
				var buff:CityBattleTrackReward = buffs[n];
				if(null == buff){
					buff = new CityBattleTrackReward();
					addChild(buff);
				}
				buff.x = 15 + n*90;
				buff.y = 178;
				var price:int = ConfigEnum["warCity"+(11 + n*2)];
				var buffId:int = ConfigEnum["warCity"+(10 + n*2)];
				buff.setPrice(price);
				buff.setBuffId(buffId);
			}
			
			ruleLbl.mouseEnabled = true;
			ruleLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			
			gotNameLbl.mouseEnabled = true;
			gotNameLbl.addEventListener(MouseEvent.CLICK, onMouseClick);
			var style:StyleSheet = new StyleSheet();
			style.setStyle("a:hover", {color:"#ff0000"});
			gotNameLbl.styleSheet = style;
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			var data:CityBattleTrackData = DataManager.getInstance().cityBattleData.trackData;
			var sendLiving:LivingModel=UIManager.getInstance().gameScene.getPlayer(data.stag);
//			var screenPoint:Point = UIManager.getInstance().gameScene.globalToLocal(new Point(sendLiving.x, sendLiving.y));
			var targetPoint:Point = SceneUtil.screenToTile(sendLiving.x, sendLiving.y);
			Core.me.gotoMap(targetPoint, ""+ConfigEnum.warCity21, true);
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			var content:String = TableManager.getInstance().getSystemNotice(6722).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}
		
		public override function show():void{
			super.show();
			if(!TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().addITick(1000, updateTime);
			}
			resize();
		}
		
		public override function hide():void{
			super.hide();
			if(TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().removeITick(updateTime);
			}
		}
		
		public function updateTime():void{
			var tt:uint = DataManager.getInstance().cityBattleData.trackData.getRemainTime();
			var hour:int = tt/3600;
			var minutes:int = tt/60%60;
			var scends:int = tt%60;
			hour = (hour < 0) ? 0 : hour;
			minutes = (minutes < 0) ? 0 : minutes;
			scends = (scends < 0) ? 0 : scends;
			timeLbl.text = StringUtil_II.lpad(hour+"", 2, "0") + ":" + StringUtil_II.lpad(minutes+"", 2, "0") + ":" + StringUtil_II.lpad(scends+"", 2, "0");
			
			var rot:int = DataManager.getInstance().cityBattleData.trackData.getRemainOpenTime();
			if(rot > 0){
				hour = rot/3600;
				minutes = rot/60%60;
				scends = rot%60;
				hour = (hour < 0) ? 0 : hour;
				minutes = (minutes < 0) ? 0 : minutes;
				scends = (scends < 0) ? 0 : scends;
				gotTimeLbl.text = StringUtil_II.lpad(hour+"", 2, "0") + ":" + StringUtil_II.lpad(minutes+"", 2, "0") + ":" + StringUtil_II.lpad(scends+"", 2, "0");
			}else{
				var got:int = DataManager.getInstance().cityBattleData.trackData.getHoldTime();
				hour = got/3600;
				minutes = got/60%60;
				scends = got%60;
				hour = (hour < 0) ? 0 : hour;
				minutes = (minutes < 0) ? 0 : minutes;
				scends = (scends < 0) ? 0 : scends;
				gotTimeLbl.text = StringUtil_II.lpad(hour+"", 2, "0") + ":" + StringUtil_II.lpad(minutes+"", 2, "0") + ":" + StringUtil_II.lpad(scends+"", 2, "0");
			}
		}
		
		public function resize():void{
			x = UIEnum.WIDTH - 274;
			y = (UIEnum.HEIGHT - 324) >> 1;
		}
		
		public function updateInfo():void{
			updateTime();
			var data:CityBattleTrackData = DataManager.getInstance().cityBattleData.trackData;
			gotGuildLbl.text = data.guildName;
			expLbl.text = data.exp+"";
			energyLbl.text = data.energy+"";
			ryLbl.text = data.honour+"";
			gotNameLbl.htmlText = StringUtil_II.getColorStr(StringUtil_II.addEventString("city.battle.find", data.name, true), "#"+gotNameLbl.textColor.toString(16));;
			if(data.openTime > 0){
				var content:String = TableManager.getInstance().getSystemNotice(6721).content;
				timeTitleLbl.text = content;
			}else{
				timeTitleLbl.text = "持有时间";
			}
		}
	}
}