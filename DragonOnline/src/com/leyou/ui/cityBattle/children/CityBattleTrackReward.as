package com.leyou.ui.cityBattle.children
{
	import com.ace.enum.GameFileEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TBuffInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.net.cmd.Cmd_WARC;
	
	import flash.events.MouseEvent;
	
	public class CityBattleTrackReward extends AutoSprite
	{
//		private var nameLbl:Label;
		
		private var goldLbl:Label;
		
		private var buyBtn:NormalButton;
		
		private var buffId:int;
		
		private var icon:Image;
		
		public function CityBattleTrackReward(){
			super(LibManager.getInstance().getXML("config/ui/cityBattle/warCityTrackRender.xml"));
			init();
		}
		
		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
//			nameLbl = getUIbyID("nameLbl") as Label;
			goldLbl = getUIbyID("goldLbl") as Label;
			buyBtn = getUIbyID("buyBtn") as NormalButton;
			
			icon = new Image();
			icon.x = 1;
			icon.y = 21;
			addChild(icon);
			buyBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			Cmd_WARC.cm_WARC_B(buffId);
		}
		
		public function setBuffId($buffId:int):void{
			buffId = $buffId;
			var buffInfo:TBuffInfo = TableManager.getInstance().getBuffInfo(buffId);
//			nameLbl.text = buffInfo.name;
			var iconUrl:String = GameFileEnum.URL_SKILL_ICO + buffInfo.icon+".png";
			icon.updateBmp(iconUrl);
			
		}
		
		public function setPrice(price:int):void{
			goldLbl.text = price+"";
		}
	}
}