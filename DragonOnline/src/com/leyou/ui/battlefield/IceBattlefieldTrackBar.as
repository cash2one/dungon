package com.leyou.ui.battlefield
{
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.data.iceBattle.IceBattleData;
	import com.leyou.data.iceBattle.children.IceBattlePalyerData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_ZC;
	import com.leyou.ui.battlefield.children.IceBattlefieldTrackItem;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.PropUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class IceBattlefieldTrackBar extends AutoSprite
	{
		private static const TRACK_NUM:int = 10;
		
		private var spanRTLbl:Label;
		
		private var remainTLbl:Label;
		
		private var rankLbl:Label;
		
		private var creditLbl:Label;
		
		private var killLbl:Label;
		
		private var assistLbl:Label;
		
		private var ryLbl:Label;
		
		private var goldLbl:Label;
		
		private var buyBtn:NormalButton;
		
		private var grid:MarketGrid;
		
		private var switchBtn:ImgButton;
		
		private var itemList:Vector.<IceBattlefieldTrackItem>;
		
		private var status:Boolean = true;
		
		private var effectSwf:SwfLoader;
		
		public function IceBattlefieldTrackBar(){
			super(LibManager.getInstance().getXML("config/ui/iceBattle/warSyTrack.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			spanRTLbl = getUIbyID("spanRTLbl") as Label;
			remainTLbl = getUIbyID("remainTLbl") as Label;
			rankLbl = getUIbyID("rankLbl") as Label;
			assistLbl = getUIbyID("assistLbl") as Label;
			creditLbl = getUIbyID("creditLbl") as Label;
			ryLbl = getUIbyID("ryLbl") as Label;
			goldLbl = getUIbyID("goldLbl") as Label;
			killLbl = getUIbyID("killLbl") as Label;
			buyBtn = getUIbyID("buyBtn") as NormalButton;
			switchBtn = getUIbyID("switchBtn") as ImgButton;
			effectSwf = getUIbyID("effectSwf") as SwfLoader;
			effectSwf.visible = false;
			
			grid = new MarketGrid();
			grid.x = 24;
			grid.y = 449;
			addChild(grid);
			grid.updataById(65053);
			
			itemList = new Vector.<IceBattlefieldTrackItem>(TRACK_NUM);
			for(var n:int = 0; n < TRACK_NUM; n++){
				var item:IceBattlefieldTrackItem = itemList[n];
				if(null == item){
					item = new IceBattlefieldTrackItem();
					itemList[n] = item;
					addChild(item);
				}
				item.x = 8;
				item.y = 111 + n*28;
			}
			goldLbl.text = ConfigEnum.OpbattleBuffCost+"";
			buyBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			switchBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "buyBtn":
					Cmd_ZC.cm_ZC_B();
					break;
				case "switchBtn":
					status = !status;
					var n:int;
					while(n < numChildren){
						getChildAt(n).visible = status;
						n++;
					}
					switchBtn.visible = true;
					var btnUrl:String = status ? "ui/funForcast/btn_right.png" : "ui/funForcast/btn_left.png";
					switchBtn.updataBmd(btnUrl);
					break;
			}
		}
		
		private function playOver():void{
			effectSwf.visible = false;
			TweenLite.to(grid, 0.8, {alpha:1});
		}
		
		public override function show():void{
			super.show();
			if(!TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().addITick(1000, updateTime);
			}
			resize();
		}
		
		public function resize():void{
			x = UIEnum.WIDTH - 293; 
			y = (UIEnum.HEIGHT - 535)>>1;
		}
		
		public override function hide():void{
			super.hide();
			if(TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().removeITick(updateTime);
			}
		}
		
		public function updateTime():void{
			
			var srt:int = DataManager.getInstance().iceBattleData.getSRT();
			if(srt < 0){
				srt = 0;
			}
			
			var wrt:int = DataManager.getInstance().iceBattleData.getWRT();
			if(wrt < 0){
				wrt = 0;
			}
			
			spanRTLbl.text = StringUtil.substitute(PropUtils.getStringById(1643), StringUtil.fillTheStr(int(srt/60), 2, "0", true), StringUtil.fillTheStr(srt%60, 2, "0", true));
			remainTLbl.text = StringUtil.substitute(PropUtils.getStringById(1643), StringUtil.fillTheStr(int(wrt/60), 2, "0", true), StringUtil.fillTheStr(wrt%60, 2, "0", true));
			
		}
		
		public function updateInfo():void{
			var data:IceBattleData = DataManager.getInstance().iceBattleData;
			for(var n:int = 0; n < TRACK_NUM; n++){
				var item:IceBattlefieldTrackItem = itemList[n];
				var playerData:IceBattlePalyerData = data.getTrackData(n);
				if(null != playerData){
					item.updateInfo(playerData);
					item.alpha = 1;
				}else{
					item.alpha = 0;
				}
			}
			updateTime();
			rankLbl.text = data.selfData.rank+"";
			creditLbl.text = data.selfData.credit+"";
			killLbl.text = data.selfData.kill+"";
			assistLbl.text = data.selfData.assist+"";
			ryLbl.text = data.selfData.honour+"";
		}
		
		public function showbuff(buffID:int):void{
			grid.udpateByBuff(buffID);
			effectSwf.visible = true;
			effectSwf.playAct("stand", -1, false, playOver);
			grid.alpha = 0;
		}
	}
}