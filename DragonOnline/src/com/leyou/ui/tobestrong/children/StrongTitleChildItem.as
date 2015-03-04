package com.leyou.ui.tobestrong.children
{
	import com.ace.config.Core;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.GameFileEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TTobeStrongInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenMax;
	import com.leyou.data.tobestrong.TobeStrongData;
	import com.leyou.enum.ConfigEnum;
	
	import flash.events.MouseEvent;
	
	public class StrongTitleChildItem extends AutoSprite
	{
		private var _id:int;
		
		private var _type:int;
		
		private var iconImg:Image;
		
		private var funBtn:NormalButton;
		
		private var des1Lbl:Label;
		
		private var des2Lbl:Label;
		
		public function StrongTitleChildItem(){
			super(LibManager.getInstance().getXML("config/ui/tobeStrong/tobestrRightBar.xml"));
			init();
		}
		
		public function get type():int{
			return _type;
		}

		public function get id():int{
			return _id;
		}

		private function init():void{
			mouseChildren = true;
			iconImg = getUIbyID("iconImg") as Image;
			funBtn = getUIbyID("funBtn") as NormalButton;
			des1Lbl = getUIbyID("des1Lbl") as Label;
			des2Lbl = getUIbyID("des2Lbl") as Label;
			des2Lbl.multiline = true;
			des2Lbl.wordWrap = true;
			funBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			UIManager.getInstance().tobeStrong.hide();
			switch(_id){
				case 1: // 装备强化
					if(!UIManager.getInstance().isCreate(WindowEnum.EQUIP) || !UIManager.getInstance().equipWnd.visible){
						UILayoutManager.getInstance().show(WindowEnum.EQUIP);
					}
					UIManager.getInstance().equipWnd.changeTable(0);
					break;
				case 2: // 装备重铸
					if(!UIManager.getInstance().isCreate(WindowEnum.EQUIP) || !UIManager.getInstance().equipWnd.visible){
						UILayoutManager.getInstance().show(WindowEnum.EQUIP);
					}
					UIManager.getInstance().equipWnd.changeTable(2);
					break;
				case 3: // 紫装 寄售购买
					if(!UIManager.getInstance().isCreate(WindowEnum.AUTION) || !UIManager.getInstance().autionWnd.visible){
						UILayoutManager.getInstance().show(WindowEnum.AUTION);
					}
					break;
				case 4: // 金装 寄售购买
					if(!UIManager.getInstance().isCreate(WindowEnum.AUTION) || !UIManager.getInstance().autionWnd.visible){
						UILayoutManager.getInstance().show(WindowEnum.AUTION);
					}
					break;
				case 5: // 坐骑升级
				case 13: // 升级坐骑 精灵祝福
					if (!UIManager.getInstance().roleWnd.visible){
						UILayoutManager.getInstance().show_II(WindowEnum.ROLE);
					}
					TweenMax.delayedCall(.6, function():void {
						UIManager.getInstance().roleWnd.setTabIndex(1);
						UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.MOUTLVUP, UILayoutManager.SPACE_X);
					});
//					if(!UIManager.getInstance().isCreate(WindowEnum.ROLE) || !UIManager.getInstance().roleWnd.visible){
//						UILayoutManager.getInstance().show(WindowEnum.ROLE);
//					}
//					UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.MOUTLVUP, UILayoutManager.SPACE_X);
//					UIManager.getInstance().roleWnd.setTabIndex(1);
					break;
				case 6: // 坐骑驯养
					if(Core.me.info.level < ConfigEnum.MountTradeOpenLv){
						NoticeManager.getInstance().broadcastById(1016);
						return;
					}
					if (!UIManager.getInstance().roleWnd.visible){
						UILayoutManager.getInstance().show_II(WindowEnum.ROLE);
					}
					TweenMax.delayedCall(.6, function():void {
						UIManager.getInstance().roleWnd.setTabIndex(1);
						UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.MOUTTRADEUP, UILayoutManager.SPACE_X);
					});
//					if(!UIManager.getInstance().isCreate(WindowEnum.ROLE) || !UIManager.getInstance().roleWnd.visible){
//						UILayoutManager.getInstance().show_II(WindowEnum.ROLE);
//					}
//					UILayoutManager.getInstance().show_II(WindowEnum.ROLE, WindowEnum.MOUTTRADEUP, UILayoutManager.SPACE_X);
//					UIManager.getInstance().roleWnd.setTabIndex(1);
					break;
				case 7: // 帮会加入
					if(!UIManager.getInstance().isCreate(WindowEnum.GUILD) || !UIManager.getInstance().guildWnd.visible){
						UILayoutManager.getInstance().show_II(WindowEnum.GUILD);
					}
					break;
				case 8: // 帮会技能学习
					if(!UIManager.getInstance().isCreate(WindowEnum.GUILD) || !UIManager.getInstance().guildWnd.visible){
						UILayoutManager.getInstance().show_II(WindowEnum.GUILD);
					}
					DelayCallManager.getInstance().add(this, guildCall, "tobestrong.guild.open", 15);
					break;
				case 9: // 纹章节点开启
				case 10: // 纹章洗练
					if(!UIManager.getInstance().isCreate(WindowEnum.BADAGE) || !UIManager.getInstance().badgeWnd.visible){
						UILayoutManager.getInstance().show_II(WindowEnum.BADAGE);
					}
					break;
				case 11: // 精灵购买
				case 12: // 精灵升级
					if(!UIManager.getInstance().isCreate(WindowEnum.VIP) || !UIManager.getInstance().vipWnd.visible){
						UILayoutManager.getInstance().show(WindowEnum.VIP);
					}
					break;
				case 14: // 升级翅膀 精灵祝福
				case 16: // 升级翅膀
					if(!UIManager.getInstance().isCreate(WindowEnum.ROLE) || !UIManager.getInstance().roleWnd.visible){
						UIManager.getInstance().showWindow(WindowEnum.ROLE);
					}
					UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.WINGLVUP, UILayoutManager.SPACE_X);
					UIManager.getInstance().roleWnd.setTabIndex(6);
					break;
				case 15: // 购买翅膀
					if(!UIManager.getInstance().isCreate(WindowEnum.MARKET) || !UIManager.getInstance().marketWnd.visible){
						UIOpenBufferManager.getInstance().open(WindowEnum.MARKET);
					}
					UIManager.getInstance().marketWnd.changeTable(4);
					break;
				case 20:
					// 神秘商店 坐骑装备兑换
					if(!UIManager.getInstance().isCreate(WindowEnum.MYSTORE) || !UIManager.getInstance().myStore.visible){
						UILayoutManager.getInstance().open_II(WindowEnum.MYSTORE);
						TweenMax.delayedCall(.6, function():void {
							UIManager.getInstance().myStore.setTabIndex(1)
						});
					}
					break;
				case 17:
					// 宝石镶嵌
					if(Core.me.info.level < ConfigEnum.Gem1){
						NoticeManager.getInstance().broadcastById(1016);
						return;
					}
					if (!UIManager.getInstance().roleWnd.visible){
						UILayoutManager.getInstance().show_II(WindowEnum.ROLE);
					}
					TweenMax.delayedCall(.6, function():void {
//						UILayoutManager.getInstance().show_II(WindowEnum.ROLE, WindowEnum.GEM_LV, -20);
						UIManager.getInstance().roleWnd.setTabIndex(2);
					});

					break;
				case 18:
					// 宝石合成
					if(Core.me.info.level < ConfigEnum.Gem1){
						NoticeManager.getInstance().broadcastById(1016);
						return;
					}
					if (!UIManager.getInstance().roleWnd.visible){
						UILayoutManager.getInstance().show_II(WindowEnum.ROLE);
					}
					TweenMax.delayedCall(.6, function():void {
						UILayoutManager.getInstance().show_II(WindowEnum.ROLE, WindowEnum.GEM_LV, -20);
						UIManager.getInstance().roleWnd.setTabIndex(2);
					});
					break;
				case 19:
					// 神秘商店 宝石兑换
					if(!UIManager.getInstance().isCreate(WindowEnum.MYSTORE) || !UIManager.getInstance().myStore.visible){
						UILayoutManager.getInstance().open_II(WindowEnum.MYSTORE);
						UIManager.getInstance().creatWindow(WindowEnum.MYSTORE);
					}
					break;
			}
		}
		
		private function guildCall():void{
			UIManager.getInstance().guildWnd.setTabIndex(2);
		}
		
		public function updateInfo(tinfo:TTobeStrongInfo):void{
			var iconUrl:String = GameFileEnum.URL_ITEM_ICO + tinfo.ico + ".png";
			iconImg.updateBmp(iconUrl);
			des1Lbl.text = tinfo.des1;
			des2Lbl.setText(tinfo.des2);
			_type = tinfo.type;
			_id = tinfo.id;
		}
		
		public function updateDynamicData():void{
			var data:TobeStrongData = DataManager.getInstance().tobeStrongData;
			var tinfo:TTobeStrongInfo = TableManager.getInstance().getTobeStrongInfo(_id);
			switch(id){
				case 1:
					des1Lbl.text = StringUtil.substitute(tinfo.des1, data.qsc);
					break;
				case 2:
					des1Lbl.text = StringUtil.substitute(tinfo.des1, data.qrc);
					break;
				case 3:
					des1Lbl.text = StringUtil.substitute(tinfo.des1, 14-data.qzc);
					break;
				case 4:
					des1Lbl.text = StringUtil.substitute(tinfo.des1, 14-data.qjc);
					break;
				case 5:
					des1Lbl.text = StringUtil.substitute(tinfo.des1, data.rt+1);
					break;
				case 7:
					des1Lbl.text = StringUtil.substitute(tinfo.des1, data.guc);
					break;
				case 12:
					des1Lbl.text = StringUtil.substitute(tinfo.des1, data.vt+1);
					break;
				case 16:
					des1Lbl.text = StringUtil.substitute(tinfo.des1, data.wt+1);
					break;
			}
		}
	}
}