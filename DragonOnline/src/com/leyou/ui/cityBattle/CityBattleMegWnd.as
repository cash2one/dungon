package com.leyou.ui.cityBattle
{
	import com.ace.enum.ItemEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCityBattleRewardInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.cityBattle.CityBattleFinalData;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	
	public class CityBattleMegWnd extends AutoWindow
	{
		private var ryLbl:Label;
		
		private var expLbl:Label;
		
		private var energyLbl:Label;
		
		private var desLbl:Label;
		
		private var rewardTitleLbl:Label;
		
		private var receiveBtn:NormalButton;
		
		private var grids:Vector.<MarketGrid>;
		
		public function CityBattleMegWnd(){
			super(LibManager.getInstance().getXML("config/ui/cityBattle/warCityMegWnd.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
			ryLbl = getUIbyID("ryLbl") as Label;
			expLbl = getUIbyID("expLbl") as Label;
			desLbl = getUIbyID("desLbl") as Label;
			desLbl.multiline = true;
			desLbl.wordWrap = true;
			energyLbl = getUIbyID("energyLbl") as Label;
			rewardTitleLbl = getUIbyID("rewardTitleLbl") as Label;
			receiveBtn = getUIbyID("receiveBtn") as NormalButton;
			clsBtn.visible = false;
			grids = new Vector.<MarketGrid>(4);
			var l:int = grids.length;
			for(var n:int = 0; n < l; n++){
				var grid:MarketGrid = grids[n];
				if(null == grid){
					grid = new MarketGrid();
					grids[n] = grid;
					pane.addChild(grid);
				}
				grid.x = 90 + n*80;
				grid.y = 173;
			}
			receiveBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, UIEnum.WND_LAYER_TOP, toCenter);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			hide();
			UILayoutManager.getInstance().show(WindowEnum.MAILL);
		}
		
		public function updateInfo():void{
			var data:CityBattleFinalData = DataManager.getInstance().cityBattleData.finalData;
			ryLbl.text = data.honour+"";
			expLbl.text = data.exp+"";
			energyLbl.text = data.energy+"";
			var rewardInfo:TCityBattleRewardInfo = TableManager.getInstance().getCityBattleRewardInfo(data.wid);
			var content:String;
			
			if(1 == rewardInfo.type){
				// 获胜奖励
				rewardTitleLbl.text = PropUtils.getStringById(1657);
				content = TableManager.getInstance().getSystemNotice(6715).content;
				content = StringUtil.substitute(content, data.winGName, data.winPName);
			}else　if(2 == rewardInfo.type){
				// 参与奖励
				rewardTitleLbl.text = PropUtils.getStringById(1658);
				content = TableManager.getInstance().getSystemNotice(6716).content;
			}
			
			desLbl.htmlText = content;
			
			var index:int = 0;
			var grid:MarketGrid = grids[index];
			if(rewardInfo.exp > 0){
				grid.updataInfo({itemId:ItemEnum.EXP_VIR_ITEM_ID, count:rewardInfo.exp});
				index++;
			}
			if(rewardInfo.money > 0){
				grid = grids[index];
				grid.updataInfo({itemId:ItemEnum.MONEY_VIR_ITEM_ID, count:rewardInfo.money});
				index++;
			}
			if(rewardInfo.energy > 0){
				grid = grids[index];
				grid.updataInfo({itemId:ItemEnum.ENERGY_VIR_ITEM_ID, count:rewardInfo.energy});
				index++;
			}
			if(rewardInfo.lp > 0){
				grid = grids[index];
				grid.updataInfo({itemId:ItemEnum.BG_VIR_ITEM_ID, count:rewardInfo.lp});
				index++;
			}
			if(rewardInfo.byb > 0){
				grid = grids[index];
				grid.updataInfo({itemId:ItemEnum.BYB_VIR_ITEM_ID, count:rewardInfo.byb});
				index++;
			}
			if(rewardInfo.honor > 0){
				grid = grids[index];
				grid.updataInfo({itemId:ItemEnum.HONOUR_VIR_ITEM_ID, count:rewardInfo.honor});
				index++;
			}
			if(rewardInfo.item1 > 0){
				grid = grids[index];
				grid.updataInfo({itemId:rewardInfo.item1, count:rewardInfo.item1Num});
				index++;
			}
			if(rewardInfo.item2 > 0){
				grid = grids[index];
				grid.updataInfo({itemId:rewardInfo.item2, count:rewardInfo.item2Num});
				index++;
			}
			if(rewardInfo.item3 > 0){
				grid = grids[index];
				grid.updataInfo({itemId:rewardInfo.item3, count:rewardInfo.item3Num});
				index++;
			}
			if(rewardInfo.item4 > 0){
				grid = grids[index];
				grid.updataInfo({itemId:rewardInfo.item4, count:rewardInfo.item4Num});
				index++;
			}
		}
		
		public override function get width():Number{
			return 530;
		}
		
		public override function get height():Number{
			return 313;
		}
	}
}