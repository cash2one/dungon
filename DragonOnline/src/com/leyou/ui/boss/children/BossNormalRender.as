package com.leyou.ui.boss.children
{
	import com.ace.config.Core;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFieldBossInfo;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.leyou.data.fieldboss.FieldBossData;
	import com.leyou.data.fieldboss.FieldBossInfo;
	import com.leyou.data.fieldboss.FieldBossTipInfo;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class BossNormalRender extends AutoSprite
	{
		private static const BOSS_COUNT:int = 8;
		
		private static const GRID_COUNT:int = 8;
		
		private var items:Vector.<BossNormalLableRender>;
		
		private var desLbl:Label;
		
		private var nameLbl:Label;
		
		private var big:SwfLoader;
		
		private var grids:Vector.<CopyRewardGrid>;
		
		private var tipInfo:FieldBossTipInfo;
		
		private var currentItem:BossNormalLableRender;
		
		public function BossNormalRender(){
			super(LibManager.getInstance().getXML("config/ui/boss/bossNormalRender.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			desLbl = getUIbyID("desLbl") as Label;
			nameLbl = getUIbyID("nameLbl") as Label;
			items = new Vector.<BossNormalLableRender>(BOSS_COUNT);
			for(var n:int = 0; n < BOSS_COUNT; n++){
				var item:BossNormalLableRender = items[n];
				if(null == item){
					item = new BossNormalLableRender();
					item.addEventListener(MouseEvent.CLICK, onMouseClick);
					items[n] = item;
				}
				item.y = 30 + n * 42;
				addChild(item);
			}
			desLbl.text = TableManager.getInstance().getSystemNotice(5008).content;
			
			tipInfo = new FieldBossTipInfo();
			big = new SwfLoader();
			big.x = 730;
			big.y = 230;
			addChild(big);
			big.mouseEnabled = true;
//			big.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			
			grids = new Vector.<CopyRewardGrid>(GRID_COUNT);
			for(var m:int = 0; m < GRID_COUNT; m++){
				var grid:CopyRewardGrid = new CopyRewardGrid();
				grid.x = 637 + m%4*50;
				grid.y = 314 + int(m/4)*50;
				addChild(grid);
				grids[m] = grid;
			}
		}
		
//		protected function onMouseOver(event:MouseEvent):void{
//			var info:FieldBossInfo = DataManager.getInstance().fieldBossData.getLowBossInfoByID(currentItem.bossId);
//			if(null == info) return;
//			tipInfo.bossId = currentItem.bossId;
//			if((null == info.killName) || ("" == info.killName)){
//				tipInfo.killName = "未被击杀";
//			}else{
//				tipInfo.killName = info.killName;
//			}
//			if(0 == info.status){
//				// 未刷新
//				tipInfo.status = "已击杀";
//			}else if(1 == info.status){
//				// 已刷新
//				tipInfo.status = "已刷新";
//			}
//			ToolTipManager.getInstance().show(TipEnum.TYPE_FIELD_BOSS, tipInfo, new Point(stage.mouseX, stage.mouseY));
//		}
		
		protected function onMouseClick(event:MouseEvent):void{
			var item:BossNormalLableRender = event.target as BossNormalLableRender;
			if(null == item){
				return;
			}
			showBoss(item);
		}
		
		public function updateView():void{
			var data:FieldBossData = DataManager.getInstance().fieldBossData;
			for(var n:int = 0; n < BOSS_COUNT; n++){
				var item:BossNormalLableRender = items[n];
				var fdata:FieldBossInfo = data.getLowBossInfo(n);
				if(null != item){
					item.updateInfo(fdata);
				}
			}
			refreshBossOpenStatus();
			showBoss(items[0]);
		}
		
		public function showBoss(item:BossNormalLableRender):void{
			if(null != currentItem){
				currentItem.select = false;
			}
			currentItem = item;
			currentItem.select = true;
			var bossInfo:TFieldBossInfo = TableManager.getInstance().getFieldBossInfo(item.bossId);
			var monsterInfo:TLivingInfo = TableManager.getInstance().getLivingInfo(bossInfo.monsterId);
			nameLbl.text = monsterInfo.name +"[lv"+monsterInfo.level+"]";
			big.update(monsterInfo.pnfId);
			big.playAct(PlayerEnum.ACT_STAND, PlayerEnum.DIR_S);
			var rc:int = grids.length;
			for(var n:int = 0; n < rc; n++){
				grids[n].clear();
			}
			var index:int = 0;
			if(bossInfo.showItem1[0] > 0){
				grids[index++].updataInfo({itemId:bossInfo.showItem1[0], count:bossInfo.showItem1[1]});
			}
			if(bossInfo.showItem2[0] > 0){
				grids[index++].updataInfo({itemId:bossInfo.showItem2[0], count:bossInfo.showItem2[1]});
			}
			if(bossInfo.showItem3[0] > 0){
				grids[index++].updataInfo({itemId:bossInfo.showItem3[0], count:bossInfo.showItem3[1]});
			}
			if(bossInfo.showItem4[0] > 0){
				grids[index++].updataInfo({itemId:bossInfo.showItem4[0], count:bossInfo.showItem4[1]});
			}
			if(bossInfo.showItem5[0] > 0){
				grids[index++].updataInfo({itemId:bossInfo.showItem5[0], count:bossInfo.showItem5[1]});
			}
			if(bossInfo.showItem6[0] > 0){
				grids[index++].updataInfo({itemId:bossInfo.showItem6[0], count:bossInfo.showItem6[1]});
			}
			if(bossInfo.showItem7[0] > 0){
				grids[index++].updataInfo({itemId:bossInfo.showItem7[0], count:bossInfo.showItem7[1]});
			}
			if(bossInfo.showItem8[0] > 0){
				grids[index++].updataInfo({itemId:bossInfo.showItem8[0], count:bossInfo.showItem8[1]});
			}
		}
		
		public function refreshBossOpenStatus():void{
			for each(var item:BossNormalLableRender in items){
				if(null != item){
					var tbInfo:TFieldBossInfo = TableManager.getInstance().getFieldBossInfo(item.bossId);
					if(tbInfo.openLv > Core.me.info.level){
						item.mouseEnabled = false;
						item.mouseChildren = false;
						item.filters = [FilterEnum.enable];
					}else{
						item.mouseEnabled = true;
						item.mouseChildren = true;
						item.filters = null;
					}
				}
			}
		}
	}
}