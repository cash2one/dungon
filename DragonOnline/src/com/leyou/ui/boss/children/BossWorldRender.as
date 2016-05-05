package com.leyou.ui.boss.children {
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
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.fieldboss.FieldBossData;
	import com.leyou.data.fieldboss.FieldBossInfo;
	import com.leyou.data.fieldboss.FieldBossTipInfo;
	import com.leyou.enum.TaskEnum;
	import com.leyou.net.cmd.Cmd_YBS;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class BossWorldRender extends AutoSprite {
		private static const GRID_COUNT:int=8;

		private static const PAGE_MAX_COUNT:int=4;

		private var refreshTLbl:Label;

		private var desLbl:Label;

		private var pageLbl:Label;

		private var preBtn:ImgButton;

		private var nextBtn:ImgButton;

		private var nameLbl:Label;

		private var big:SwfLoader;

		private var grids:Vector.<CopyRewardGrid>;

		private var items:Vector.<BossWorldLableRender>;

		private var tipInfo:FieldBossTipInfo;

		private var currentItem:BossWorldLableRender;

		private var currentPage:int=1;

		private var maxPage:int;

		private var reBossItem:BossWorldLableRender;

		public function BossWorldRender() {
			super(LibManager.getInstance().getXML("config/ui/boss/bossWorldRender.xml"));
			init();
		}

		private function init():void {
			mouseChildren=true;
			refreshTLbl=getUIbyID("refreshTLbl") as Label;
			desLbl=getUIbyID("desLbl") as Label;
			pageLbl=getUIbyID("pageLbl") as Label;
			nameLbl=getUIbyID("nameLbl") as Label;
			preBtn=getUIbyID("preBtn") as ImgButton;
			nextBtn=getUIbyID("nextBtn") as ImgButton;
			preBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			nextBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			refreshTLbl.text=TableManager.getInstance().getSystemNotice(5004).content;
			desLbl.text=TableManager.getInstance().getSystemNotice(5007).content;

			tipInfo=new FieldBossTipInfo();
			big=new SwfLoader();
			big.x=730;
			big.y=250;
			addChild(big);
			big.mouseEnabled=true;
			big.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);

			grids=new Vector.<CopyRewardGrid>(GRID_COUNT);
			for (var m:int=0; m < GRID_COUNT; m++) {
				var grid:CopyRewardGrid=new CopyRewardGrid();
				grid.x=637 + m % 4 * 50;
				grid.y=314 + int(m / 4) * 50;
				addChild(grid);
				grids[m]=grid;
			}

			items=new Vector.<BossWorldLableRender>(PAGE_MAX_COUNT);
			for (var n:int=0; n < PAGE_MAX_COUNT; n++) {
				var item:BossWorldLableRender=items[n];
				if (null == item) {
					item=new BossWorldLableRender();
					items[n]=item;
					item.setRemindListener(onRemindClick);
				}
				item.addEventListener(MouseEvent.CLICK, onItemClick);
				addChild(item);
				item.y=30 + 78 * n;
			}
		}

		protected function onItemClick(event:MouseEvent):void {
			var item:BossWorldLableRender=event.target as BossWorldLableRender;
			if (null == item) {
				return;
			}
			showBoss(item);
		}

		protected function onMouseOver(event:MouseEvent):void {
			var info:FieldBossInfo=DataManager.getInstance().fieldBossData.getBossInfo(currentItem.bossId);
			if (null == info)
				return;
			tipInfo.bossId=currentItem.bossId;
			if ((null == info.killName) || ("" == info.killName)) {
				tipInfo.killName=PropUtils.getStringById(1652);
			} else {
				tipInfo.killName=info.killName;
			}
			if (0 == info.status) {
				// 未刷新
				tipInfo.status=getCurrentRT() + PropUtils.getStringById(1653);
			} else if (1 == info.status) {
				// 已刷新
				tipInfo.status=PropUtils.getStringById(1650);
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_FIELD_BOSS, tipInfo, new Point(stage.mouseX, stage.mouseY));
		}

		private function getCurrentRT():String {
			var bossInfo:TFieldBossInfo=TableManager.getInstance().getFieldBossInfo(currentItem.bossId);
			var timeArr:Array=bossInfo.refreshTimes;
			var tl:int=timeArr.length;
			var date:Date=new Date();
			var ct:int=date.hours * 60 * 60 + date.minutes * 60 + date.seconds;
			for (var n:int=0; n < tl; n++) {
				var tArr:Array=timeArr[n].split(",");
				var rt:int=int(tArr[0]) * 60 * 60 + int(tArr[1]) * 60 + int(tArr[2]);
				if (ct < rt) {
					return tArr.join(":");
				}
			}
			var pa:RegExp=/,/g;
			return timeArr[0].replace(pa, ":");
		}

		protected function onBtnClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "preBtn":
					if (currentPage > 1) {
						showPage(currentPage - 1);
					}
					break;
				case "nextBtn":
					if (currentPage < maxPage) {
						showPage(currentPage + 1);
					}
					break;
			}
		}

		public function showPage(pIndex:int):void {
			currentPage=pIndex;
			pageLbl.text=currentPage + "/" + maxPage;
			var data:FieldBossData=DataManager.getInstance().fieldBossData;
			for (var n:int=0; n < PAGE_MAX_COUNT; n++) {
				var item:BossWorldLableRender=items[n];
				var didx:int=(pIndex - 1) * PAGE_MAX_COUNT + n;
				var bData:FieldBossInfo=data.getBossInfoByIdx(didx);
				if (null == bData) {
					item.visible=false;
				} else {
					if (!item.visible) {
						item.visible=true;
					}
					item.updateInfo(bData);
				}
			}
			refreshBossOpenStatus();
		}

		private function onRemindClick(bossRender:BossWorldLableRender, v:Boolean):void {
			var data:FieldBossData=DataManager.getInstance().fieldBossData;
			if (v) {
				if (null != reBossItem) {
					reBossItem.setRemind(false);
				}
				bossRender.setRemind(true);
				reBossItem=bossRender;
				data.setRemind(bossRender.bossId);
				var bossInfo:TFieldBossInfo=TableManager.getInstance().getFieldBossInfo(bossRender.bossId);
				var monsterInfo:TLivingInfo=TableManager.getInstance().getLivingInfo(bossInfo.monsterId);
				var fbInfo:FieldBossInfo=DataManager.getInstance().fieldBossData.getBossInfo(bossRender.bossId);
				var content:String="        {1}<font color='#ff00'><u><a href='event:other_ycp--{2}'>" + PropUtils.getStringById(1570) + "</a></u></font>";
				content=StringUtil.substitute(PropUtils.getStringById(2452),DataManager.getInstance().fieldBossData.lastCount);
				if (0 == fbInfo.status) {
					content="        {1}<font color='#ff0000'><u><a href='event:other_ycp--{2}'>" + PropUtils.getStringById(1572) + "</a></u></font>";
					content=PropUtils.getStringById(2454);
				}
//				content=StringUtil.substitute(content, monsterInfo.name, bossRender.bossId);
				var arr:Array=[PropUtils.getStringById(2423),"<a href='event:other_ycp--"+monsterInfo.name+"'>" + PropUtils.getStringById(2439) + "</a>", content, "", Cmd_YBS.callBack, "", onBtnClick];
				UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_fieldbossCopyLine, arr);
			} else {
				reBossItem=null;
				data.setRemind(0);
				UIManager.getInstance().taskTrack.delOtherTrack(TaskEnum.taskLevel_fieldbossCopyLine);
			}
		}

		public function showBoss(item:BossWorldLableRender):void {
			if (null != currentItem) {
				currentItem.select=false;
			}
			currentItem=item;
			currentItem.select=true;
			var bossInfo:TFieldBossInfo=TableManager.getInstance().getFieldBossInfo(item.bossId);
			var monsterInfo:TLivingInfo=TableManager.getInstance().getLivingInfo(bossInfo.monsterId);
			nameLbl.text=monsterInfo.name + "[lv" + monsterInfo.level + "]";
			big.update(monsterInfo.pnfId);
			big.playAct(PlayerEnum.ACT_STAND, PlayerEnum.DIR_S);
			var rc:int=grids.length;
			for (var n:int=0; n < rc; n++) {
				grids[n].clear();
			}
			var index:int=0;
			if (bossInfo.showItem1[0] > 0) {
				grids[index++].updataInfo({itemId: bossInfo.showItem1[0], count: bossInfo.showItem1[1]});
			}
			if (bossInfo.showItem2[0] > 0) {
				grids[index++].updataInfo({itemId: bossInfo.showItem2[0], count: bossInfo.showItem2[1]});
			}
			if (bossInfo.showItem3[0] > 0) {
				grids[index++].updataInfo({itemId: bossInfo.showItem3[0], count: bossInfo.showItem3[1]});
			}
			if (bossInfo.showItem4[0] > 0) {
				grids[index++].updataInfo({itemId: bossInfo.showItem4[0], count: bossInfo.showItem4[1]});
			}
			if (bossInfo.showItem5[0] > 0) {
				grids[index++].updataInfo({itemId: bossInfo.showItem5[0], count: bossInfo.showItem5[1]});
			}
			if (bossInfo.showItem6[0] > 0) {
				grids[index++].updataInfo({itemId: bossInfo.showItem6[0], count: bossInfo.showItem6[1]});
			}
			if (bossInfo.showItem7[0] > 0) {
				grids[index++].updataInfo({itemId: bossInfo.showItem7[0], count: bossInfo.showItem7[1]});
			}
			if (bossInfo.showItem8[0] > 0) {
				grids[index++].updataInfo({itemId: bossInfo.showItem8[0], count: bossInfo.showItem8[1]});
			}
		}

		public function updateView():void {
			var data:FieldBossData=DataManager.getInstance().fieldBossData;
			maxPage=Math.ceil(PAGE_MAX_COUNT / data.getBossCount() + 1);
			showPage(1);
			showBoss(items[0]);

			// 设置提醒boss
			var rbid:int=data.getRemindId();
			for each (var fitem:BossWorldLableRender in items) {
				if (null != fitem) {
					if (rbid == fitem.bossId) {
						reBossItem=fitem;
						fitem.setRemind(true);
					} else {
						fitem.setRemind(false);
					}
				}
			}
		}

		public function refreshBossOpenStatus():void {

			DataManager.getInstance().fieldBossData.lastCount=0;

			for each (var item:BossWorldLableRender in items) {
				if (null != item) {
					var tbInfo:TFieldBossInfo=TableManager.getInstance().getFieldBossInfo(item.bossId);
					if (null == tbInfo) {
						continue;
					}
					if (tbInfo.openLv > Core.me.info.level) {
						item.mouseEnabled=false;
						item.mouseChildren=false;
						item.filters=[FilterEnum.enable];
					} else {
						item.mouseEnabled=true;
						item.mouseChildren=true;
						item.filters=null;

						DataManager.getInstance().fieldBossData.lastCount++;
					}
				}
			}
		}
	}
}
