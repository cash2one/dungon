package com.leyou.ui.battlefield {
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TIcebattleReward;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.StringUtil;
	import com.leyou.data.iceBattle.IceBattleData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_ZC;
	import com.leyou.ui.battlefield.children.IceBattlefieldRewadItem;
	import com.leyou.ui.battlefield.children.IceBattlefieldRewardDetail;

	public class IceBattlefieldRewardWnd extends AutoWindow {
		private static const ITEM_HEIGHT:int=63;

		private var members:Vector.<IceBattlefieldRewadItem>;

		private var detailItems:Vector.<IceBattlefieldRewardDetail>;

		private var detailPanl:ScrollPane;

		private var scrollPanel:ScrollPane;

		private var chItem:IceBattlefieldRewadItem;

		private var desLbl:Label;

		public function IceBattlefieldRewardWnd() {
			super(LibManager.getInstance().getXML("config/ui/iceBattle/warSyAward.xml"));
			init();
		}

		private function init():void {
			mouseChildren=true;
			desLbl=getUIbyID("desLbl") as Label;
			members=new Vector.<IceBattlefieldRewadItem>();
			detailItems=new Vector.<IceBattlefieldRewardDetail>();
			scrollPanel=new ScrollPane(404, 377);
			scrollPanel.x=10;
			scrollPanel.y=83;
			pane.addChild(scrollPanel);
			detailPanl=new ScrollPane(1, 1);
			pane.addChild(detailPanl);
			initTableInfo();
			clsBtn.x+=15;
//			clsBtn.y -= 14;

			var content:String=TableManager.getInstance().getSystemNotice(21011).content;
			content=StringUtil.substitute(content, ConfigEnum.Opbattle26);
			desLbl.text=content;
		}

		private function initTableInfo():void {
			var count:int=0;
			var rewardDic:Object=TableManager.getInstance().getIceBattleDic();
			for (var key:String in rewardDic) {
				var info:TIcebattleReward=rewardDic[key];
				var idArr:Array=key.split("|");
				if (idArr.length > 1) {
					var item:IceBattlefieldRewadItem=allocItem(count);
					scrollPanel.addToPane(item);
					item.y=count * ITEM_HEIGHT;
					item.updateTInfo(info);
					count++;
				}
			}
			scrollPanel.updateUI();
			adjustItemPostion();
		}

		private function allocItem(index:int):IceBattlefieldRewadItem {
			if (members.length < index + 1) {
				members.length=index + 1;
			}
			var item:IceBattlefieldRewadItem=members[index];
			if (null == item) {
				item=new IceBattlefieldRewadItem();
				members[index]=item;
				item.register(onDetailClick);
			}
			return item;
		}

		private function onDetailClick(item:IceBattlefieldRewadItem):void {
			chItem=item;
			var groupId:String=item.groupId;
			var flagArr:Array=groupId.split("|");
			if (int(flagArr[1]) < 0) {
				Cmd_ZC.cm_ZC_L(flagArr[0], flagArr[0]);
			} else {
				Cmd_ZC.cm_ZC_L(flagArr[0], flagArr[1]);
			}
		}

		private function adjustItemPostion():void {
			members.sort(sortFun);
			var count:int=members.length;
			for (var n:int=0; n < count; n++) {
				var item:IceBattlefieldRewadItem=members[n];
				item.y=n * ITEM_HEIGHT;
			}
			function sortFun(pi:IceBattlefieldRewadItem, ni:IceBattlefieldRewadItem):int {
				if (pi.id >= ni.id) {
					return 1;
				}
				return -1;
			}
		}

		public function updateInfo():void {
			adjustItemPostion();
			var data:IceBattleData=DataManager.getInstance().iceBattleData;
			var count:int=data.getHistoryCL();
			if (count > 0) {
				nvlDetail(count);
				for (var n:int=0; n < count; n++) {
					var item:IceBattlefieldRewardDetail=detailItems[n];
					item.updateInfo(data.getHistoryData(n));
				}
				viewDetail(count);
			} else {
				if (scrollPanel.contains(detailPanl)) {
					scrollPanel.delFromPane(detailPanl);
				}
			}
		}

		private function viewDetail(count:int):void {
			if (!scrollPanel.contains(detailPanl)) {
				scrollPanel.addToPane(detailPanl);
			}
			detailPanl.y=chItem.y + 56;
			var length:int=members.length;
			var index:int=members.indexOf(chItem);
			for (var n:int=0; n < length; n++) {
				if (n > index) {
					members[n].y=detailPanl.y + count * 20 + (n - index - 1) * 59;
				} else {
					members[n].y=ITEM_HEIGHT * n;
				}
			}
		}

		private function nvlDetail(count:int):void {
			if (count > detailItems.length) {
				detailItems.length=count;
			} else if (count < detailItems.length) {
				var ll:int=length;
				for (var n:int=count; n < ll; n++) {
					var gi:IceBattlefieldRewardDetail=detailItems[n];
					if (detailPanl.contains(gi)) {
						detailPanl.delFromPane(gi);
					}
				}
			}
			detailPanl.resize(404, 20 * count);
			for (var m:int=0; m < count; m++) {
				var item:IceBattlefieldRewardDetail=detailItems[m];
				if (null == item) {
					item=new IceBattlefieldRewardDetail();
					detailItems[m]=item;
				}
				item.y=m * 20;
				if (!detailPanl.contains(item)) {
					detailPanl.addToPane(item);
				}
			}
			detailPanl.updateUI();
		}

		public override function get width():Number {
			return 442;
		}

		public override function get height():Number {
			return 456;
		}
	}
}
