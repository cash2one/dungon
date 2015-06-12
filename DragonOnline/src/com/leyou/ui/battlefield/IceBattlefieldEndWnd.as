package com.leyou.ui.battlefield
{
	import com.ace.enum.ItemEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TIcebattleReward;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.market.child.MarketGrid;
	
	import flash.events.MouseEvent;
	
	public class IceBattlefieldEndWnd extends AutoWindow
	{
		private var ryLbl:Label;
		
		private var desLbl:Label;
		
		private var rewardTitleLbl:Label;
		
		private var receiveBtn:NormalButton;
		
		private var grids:Vector.<MarketGrid>;

		private var content:String;
		
		public function IceBattlefieldEndWnd(){
			super(LibManager.getInstance().getXML("config/ui/iceBattle/warSyMegWnd.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
			ryLbl = getUIbyID("ryLbl") as Label;
			desLbl = getUIbyID("desLbl") as Label;
			desLbl.multiline = true;
			desLbl.wordWrap = true;
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
			var honour:int = DataManager.getInstance().iceBattleData.honour;
			var rank:int = DataManager.getInstance().iceBattleData.srank;
			var credit:int = DataManager.getInstance().iceBattleData.credit;
			ryLbl.text = honour+"";
			var rewardInfo:TIcebattleReward = TableManager.getInstance().getIceBattleReward(rank);
			var content:String;
			if(credit >= ConfigEnum.Opbattle26){
				content = TableManager.getInstance().getSystemNotice(21001).content;
				content = StringUtil.substitute(content, credit, rank);
			}else{
				content = TableManager.getInstance().getSystemNotice(21002).content;
				content = StringUtil.substitute(content,  ConfigEnum.Opbattle26);
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
			if(rewardInfo.bg > 0){
				grid = grids[index];
				grid.updataInfo({itemId:ItemEnum.BG_VIR_ITEM_ID, count:rewardInfo.bg});
				index++;
			}
			if(rewardInfo.byb > 0){
				grid = grids[index];
				grid.updataInfo({itemId:ItemEnum.BYB_VIR_ITEM_ID, count:rewardInfo.byb});
				index++;
			}
			if(rewardInfo.honour > 0){
				grid = grids[index];
				grid.updataInfo({itemId:ItemEnum.HONOUR_VIR_ITEM_ID, count:rewardInfo.honour});
				index++;
			}
			if(rewardInfo.credit > 0){
				grid = grids[index];
				grid.updataInfo({itemId:ItemEnum.CREDIT_VIR_ITEM_ID, count:rewardInfo.credit});
				index++;
			}
			if(rewardInfo.item1 > 0){
				grid = grids[index];
				grid.updataInfo({itemId:rewardInfo.item1, count:rewardInfo.item1Count});
				index++;
			}
			if(rewardInfo.item2 > 0){
				grid = grids[index];
				grid.updataInfo({itemId:rewardInfo.item2, count:rewardInfo.item2Count});
				index++;
			}
			if(rewardInfo.item3 > 0){
				grid = grids[index];
				grid.updataInfo({itemId:rewardInfo.item3, count:rewardInfo.item3Count});
				index++;
			}
			if(rewardInfo.item4 > 0){
				grid = grids[index];
				grid.updataInfo({itemId:rewardInfo.item4, count:rewardInfo.item4Count});
				index++;
			}
		}
		
		public override function get width():Number{
			return 530;
		}
		
		public override function get height():Number{
			return 310;
		}
	}
}