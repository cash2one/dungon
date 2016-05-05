package com.leyou.ui.farm {
	import com.ace.config.Core;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.TweenManager;
	import com.ace.manager.UIManager;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.FarmEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Farm;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TimeUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;


	public class FarmWnd extends FarmView {
		protected var treeStatus:int;

		protected var tickCD:uint;

		public function FarmWnd() {
			super();
		}

		/**
		 * <T>加载农场信息</T>
		 *
		 * @param obj 农场数据
		 *
		 */
		public function onFamInit(obj:Object):void {
			if (Core.me.info.name != obj.na) {
				// 如果不是自己的农场则只加载土地信息和神树信息
				farmLand.updataLandInfo(obj.ltb);
				ownerName=obj.na;
				updataTree(obj);
				removeGuide();
				return;
			}
			ownerName=Core.me.info.name;
			farmLand.updataLandInfo(obj.ltb);
			friendRender.clear();
			friendRender.updataGuildInfo(obj.utb, obj.utc);
			friendRender.updataFriendInfo(obj.ftb, obj.ftc);
			friendRender.ownFarm=true;
			UIManager.getInstance().farmShopWnd.updataInfo(obj.ntb);
			UIManager.getInstance().farmShopWnd.updataVipInfo(obj.ytb);
			UIManager.getInstance().farmShopWnd.updataTime(obj.rt);
//			checkGuide();
			if (farmLand.hasBuy()) {
				GuideManager.getInstance().showGuide(25, this);
			}
			if (farmLand.hasRipe()) {
				GuideManager.getInstance().showGuide(27, this);
			}
//			GuideManager.getInstance().showGuide(26, this);
		}

		/**
		 * <T>刷新好友列表</T>
		 *
		 * @param obj 数据
		 *
		 */
		public function updateFriends(obj:Object):void {
//			friendRender.clear();
			if (obj.hasOwnProperty("ftb")) {
				friendRender.updataFriendInfo(obj.ftb, obj.ftc);
			}
			if (obj.hasOwnProperty("utb")) {
				friendRender.updataGuildInfo(obj.utb, obj.utc);
			}
		}

		public function updateFriend(obj:Object):void {
			if (1 == obj.type) {
				friendRender.updataFriend(obj);
			} else if (2 == obj.type) {
				friendRender.updataGuild(obj);
			}
		}

		/**
		 * <T>加载神树信息</T>
		 *
		 * @param obj 神树数据
		 *
		 */
		public function updataT(obj:Object):void {
			updataTree(obj);
			irrigationLbl.text=obj.wc + "/" + obj.wm;
			irrigationFriendLbl.text=obj.wfc + "/" + obj.wfm;
			stealLbl.text=obj.sc + "/" + obj.sm;
		}

		/**
		 * <T>更新神树数据信息</T>
		 *
		 * @param obj 神树数据
		 *
		 */
		protected function updataTree(obj:Object):void {
			accelerateBtn.visible=false;
			treeStatus=obj.ts;
			switch (treeStatus) {
				case FarmEnum.TREE_GROWING:
					// 成长态
					rateLbl.text=obj.tg + "/" + ConfigEnum.FarmGrowMax;
					rateImg.visible=true;
					rateImg.setWH(146 * (obj.tg / ConfigEnum.FarmGrowMax), 12);
					cdImg.visible=false;
					blessingLbl.visible=true;
					irrigationBtn.setActive(true, 1, true);
					irrigationBtn.updataBmd("ui/farm/btn_gg.png");
					if (hasEventListener(Event.ENTER_FRAME)) {
						removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					}
					break;
				case FarmEnum.TREE_RIPE:
					// 成熟态
					rateLbl.text="10/10";
					rateImg.visible=true;
					rateImg.setWH(146, 12);
					cdImg.visible=false;
					blessingLbl.visible=true;
					irrigationBtn.setActive(true, 1, true);
					irrigationBtn.updataBmd("ui/farm/btn_bx.png");
					if (hasEventListener(Event.ENTER_FRAME)) {
						removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					}
					break;
				case FarmEnum.TREE_WATER_CD:
					// 浇水冷却
					accelerateBtn.visible=(ownerName == Core.me.info.name); // 不是自己农场隐藏神树冷却加速按钮
					tickCD=new Date().time / 1000 - (ConfigEnum.FarmCDTime - obj.wct);
					var interval:int=new Date().time / 1000 - tickCD;
					var remain:int=ConfigEnum.FarmCDTime - interval;
					var minute:int=remain / 60;
					var second:int=remain % 60;
					rateLbl.text=StringUtil.substitute(PropUtils.getStringById(1707), [minute, second]);
					rateImg.visible=false;
					cdImg.visible=true;
					blessingLbl.visible=false;
					irrigationBtn.updataBmd("ui/farm/btn_gg.png");
					irrigationBtn.setActive(false, 1, true);
					addEventListener(Event.ENTER_FRAME, onEnterFrame);
					break;
				case FarmEnum.TREE_RIPE_CD:
					// 摘取冷却
					accelerateBtn.visible=(ownerName == Core.me.info.name);
					tickCD=new Date().time / 1000 - (ConfigEnum.FarmCDTime - obj.bct);
					var itl:int=new Date().time / 1000 - tickCD;
					var ren:int=ConfigEnum.FarmCDTime - itl;
					var min:int=ren / 60;
					var sec:int=ren % 60;
					rateLbl.text=StringUtil.substitute(PropUtils.getStringById(1707), [min, sec]);
					rateImg.visible=false;
					cdImg.visible=true;
					blessingLbl.visible=false;
					irrigationBtn.updataBmd("ui/farm/btn_gg.png");
					irrigationBtn.setActive(false, 1, true);
					addEventListener(Event.ENTER_FRAME, onEnterFrame);
					break;
			}
		}

		public function onSystemNotice(obj:Object):void {
			farmLand.onSystemNotice(obj);
		}

		/**
		 * <T>帧监听,刷新冷却时间显示</T>
		 *
		 * @param event 帧事件
		 *
		 */
		protected function onEnterFrame(event:Event):void {
			var interval:int=new Date().time / 1000 - tickCD;
			var remain:int=ConfigEnum.FarmCDTime - interval;
			rateLbl.text=TimeUtil.getIntToDateTime(remain);
			if (remain <= 0) {
				rateLbl.text=0 + "/" + ConfigEnum.FarmGrowMax;
				rateImg.visible=true;
				rateImg.setWH(0, 12);
				cdImg.visible=false;
				blessingLbl.visible=true;
				irrigationBtn.setActive(true, 1, true);
				irrigationBtn.updataBmd("ui/farm/btn_gg.png");
				if (hasEventListener(Event.ENTER_FRAME)) {
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
//			var minute:int = remain/60;
//			var second:int = remain%60;
//			if(minute < 0 || second < 0){
//				rateLbl.text = "剩余0分0秒";
//			}else{
//				rateLbl.text = "剩余"+minute+"分"+second+"秒";
//			}
		}

		/**
		 * <T>更新农场土地信息</T>
		 *
		 * @param obj 土地数据
		 *
		 */
		public function updateFarmLand(obj:Object):void {
			farmLand.updataLandInfo(obj.ltb);
			UIManager.getInstance().farmShopWnd.updateLand();
			if (farmLand.hasBuy()) {
				GuideManager.getInstance().showGuide(25, this);
			}
			if (farmLand.hasRipe()) {
				GuideManager.getInstance().showGuide(27, this);
			}
//			GuideManager.getInstance().showGuide(26, this);
		}

		/**
		 * <T>设置当前农场归属人</T>
		 *
		 * @param n 玩家名称
		 *
		 */
		public function setOwner(n:String):void {
			var index:int=n.indexOf("】");
			if (-1 != index) {
				n=n.substr(index + 1);
			}
			ownerLbl.text=n + PropUtils.getStringById(1708);
		}

		/**
		 * <T>鼠标点击</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		protected override function onMouseClick(event:MouseEvent):void {
			var name:String=event.target.name;
			switch (name) {
				case "logBtn":
					// 农场日志
					UIManager.getInstance().farmLogWnd.open();
					break;
				case "irrigationBtn":
					// 神树浇灌
					if (PropUtils.getStringById(1709) == ownerLbl.text) {
						if (FarmEnum.TREE_RIPE == treeStatus) {
							Cmd_Farm.cm_FAM_R();
						} else {
							Cmd_Farm.cm_FAM_W();
						}
					} else {
						if (FarmEnum.TREE_RIPE == treeStatus) {
						} else {
							Cmd_Farm.cm_FAM_W(ownerName);
						}
					}
					break;
				case "accelerateBtn":
					// 神树加速
					var ybv:int = 0;
					var bybv:int = 0;
					var interval:int=new Date().time/1000 - tickCD;
					var remain:int=ConfigEnum.FarmCDTime - interval;
					var content:String=TableManager.getInstance().getSystemNotice(2716).content;
					if (FarmEnum.TREE_RIPE_CD == treeStatus) {
						ybv = ConfigEnum.FarmCatalyticBoxCDCost.split("|")[0];
						bybv = ConfigEnum.FarmCatalyticBoxCDCost.split("|")[1];
					} else if (FarmEnum.TREE_WATER_CD == treeStatus) {
						ybv = Math.ceil(remain/60/5)*int(ConfigEnum.FarmCatalyticCDCost.split("|")[0]);
						bybv = Math.ceil(remain/60/5)*int(ConfigEnum.FarmCatalyticCDCost.split("|")[1]);
					}
//					content=StringUtil.substitute(content, value);
					PopupManager.showRadioConfirm(content, ybv+"", bybv+"", treeAccelerate, null, false, "farm.tree.accelerate");
					break;
			}
		}

		/**
		 * <T>神树冷却加速回调</T>
		 *
		 */
		public function treeAccelerate(type:int):void {
			var ctype:int = ((0 == type) ? 2 : 1);
			Cmd_Farm.cm_FAM_S(0, ctype);
		}

		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			setOwner(PropUtils.getStringById(1700));
//			Cmd_Farm.cm_FAM_I();
			GuideManager.getInstance().removeGuide(24);
		}

		public override function hide():void {
			super.hide();
			removeGuide();
			TweenManager.getInstance().lightingCompnent(UIManager.getInstance().toolsWnd.getUIbyID("framBtn"));
		}
		
		public override function get height():Number{
			return 544;
		}

		/**
		 * <T>是否为自己的农场</T>
		 *
		 */
		public function isOwner():Boolean {
			return (PropUtils.getStringById(1709) == ownerLbl.text);
		}

//		public function moveOver():void{
//		}

//		public function startHide():void{
//			removeGuide();
//		}

		public function removeGuide():void {
			GuideManager.getInstance().removeGuide(25);
//			GuideManager.getInstance().removeGuide(26);
			GuideManager.getInstance().removeGuide(27);
		}

		// 指引
//		public function checkGuide():void{
//			if(farmLand.hasBuy()){
//				GuideManager.getInstance().showGuide(25, this);
//			}
//			if(farmLand.hasRipe()){
//				GuideManager.getInstance().showGuide(27, this);
//			}
//			GuideManager.getInstance().showGuide(26, this);
//		}
	}
}
