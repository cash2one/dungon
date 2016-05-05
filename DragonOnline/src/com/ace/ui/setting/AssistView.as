/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2014-1-3 上午9:57:12
 */
package com.ace.ui.setting {
	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.game.proxy.ModuleProxy;
	import com.ace.game.scene.ui.ReviveWnd;
	import com.ace.game.utils.AutoUtil;
	import com.ace.gameData.manager.SettingManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.setting.AssistInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.EventManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.manager.TweenManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.dropMenu.children.ComboBox;
	import com.ace.ui.dropMenu.event.DropMenuEvent;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.QualityEnum;
	import com.leyou.net.cmd.Cmd_Assist;
	import com.leyou.utils.PropUtils;

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AssistView extends AutoWindow {

		// 默认挂机配置
		private static var DEFAULT_CONFIG:Array=[1, 2, 0.5, 2, 0.5, 2, 20101, 1, 20401, 1, 1, 4, -1, -1, -1, -1, 2, 1, QualityEnum.QUA_COMMON, //拾取道具品质18
			QualityEnum.QUA_COMMON, //拾取装备品质19
			2, //战斗范围当前屏幕20
			1, //战斗范围定点21
			1, //VIP自动萃取22
			QualityEnum.QUA_TERRIFIC]; //VIP自动萃取品质23

		// 保护设置
		private var autoEatCBox:CheckBox;

		private var autoBuyCBox:CheckBox;

		private var hpThresholdLbl:TextInput;

		// 挂机设置
		private var autoPickItemCBox:CheckBox;

		private var autoPickEquipCBox:CheckBox;

		private var pickIQuality:ComboBox;

		private var pickEQuality:ComboBox;

		private var pickRBtn:RadioButton;

		private var fightRBtn:RadioButton;

		private var rangeRBtn:RadioButton;

		private var positionRBtn:RadioButton;

		public var reliveCheckBox:CheckBox;

		// VIP3特权
		private var autoExtractCBox:CheckBox;

		private var extractionQuality:ComboBox;

		private var autoBtn:ImgButton;

		private var btnImg:Image;

		private var hpItemArr:Array;

		public function AssistView() {
			super(LibManager.getInstance().getXML("config/ui/setting/assistWnd.xml"));
			this.init();
			LayerManager.getInstance().windowLayer.addChild(this);
		}

		/**
		 * <T>初始化</T>
		 *
		 */
		protected function init():void {
			// 保护设置
			autoEatCBox=getUIbyID("autoEatCBox") as CheckBox;
			autoBuyCBox=getUIbyID("autoBuyCBox") as CheckBox;
			hpThresholdLbl=getUIbyID("hpThresholdLbl") as TextInput;
			autoEatCBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			autoBuyCBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			hpThresholdLbl.addEventListener(Event.CHANGE, onTextChange);
			hpThresholdLbl.restrict="0-9";
			hpThresholdLbl.input.maxChars=2;
			// 挂机设置
			autoPickItemCBox=getUIbyID("autoPickItemCBox") as CheckBox;
			autoPickEquipCBox=getUIbyID("autoPickEquipCBox") as CheckBox;
			pickIQuality=getUIbyID("pickIQuality") as ComboBox;
			pickEQuality=getUIbyID("pickEQuality") as ComboBox;
			pickRBtn=getUIbyID("pickRBtn") as RadioButton;
			fightRBtn=getUIbyID("fightRBtn") as RadioButton;
			rangeRBtn=getUIbyID("rangeRBtn") as RadioButton;
			positionRBtn=getUIbyID("positionRBtn") as RadioButton;
			reliveCheckBox=getUIbyID("reliveCheckBox") as CheckBox;
			autoPickItemCBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			autoPickEquipCBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			pickIQuality.addEventListener(DropMenuEvent.Item_Selected, onComboBoxClick);
			pickEQuality.addEventListener(DropMenuEvent.Item_Selected, onComboBoxClick);
			pickRBtn.addEventListener(MouseEvent.CLICK, onRadioButton);
			fightRBtn.addEventListener(MouseEvent.CLICK, onRadioButton);
			rangeRBtn.addEventListener(MouseEvent.CLICK, onRadioButton);
			positionRBtn.addEventListener(MouseEvent.CLICK, onRadioButton);
			reliveCheckBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			// VIP特权
			autoExtractCBox=getUIbyID("autoExtractCBox") as CheckBox;
			extractionQuality=getUIbyID("extractionQuality") as ComboBox;
			autoBtn=getUIbyID("autoBtn") as ImgButton;
			btnImg=getUIbyID("btnImg") as Image;
			autoExtractCBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			extractionQuality.addEventListener(DropMenuEvent.Item_Selected, onComboBoxClick);
			autoBtn.addEventListener(MouseEvent.CLICK, onButtonClick);

			var content:String=TableManager.getInstance().getSystemNotice(10034).content;
			var qarray:Array=[{label: content, uid: QualityEnum.QUA_COMMON}];
			content=TableManager.getInstance().getSystemNotice(10035).content;
			qarray.push({label: content, uid: QualityEnum.QUA_EXCELLENT});
			content=TableManager.getInstance().getSystemNotice(10036).content;
			qarray.push({label: content, uid: QualityEnum.QUA_TERRIFIC});
			content=TableManager.getInstance().getSystemNotice(10037).content;
			qarray.push({label: content, uid: QualityEnum.QUA_INCREDIBLE});
			pickIQuality.list.addRends(qarray);
			pickEQuality.list.addRends(qarray);

			content=PropUtils.getStringById(2332);
			var exarray:Array=[{label: content, uid: QualityEnum.QUA_TERRIFIC}];
			content=PropUtils.getStringById(2331);
			exarray.push({label: content, uid: QualityEnum.QUA_INCREDIBLE});
			content=PropUtils.getStringById(2330);
			exarray.push({label: content, uid: QualityEnum.QUA_LEGEND});
			extractionQuality.list.addRends(exarray);

			EventManager.getInstance().addEvent(EventEnum.SETTING_AUTO_MONSTER, onButtonClick);
		}

		protected function onTextChange(event:Event):void {
			var value:Number=int(hpThresholdLbl.text) / 100;
			info.minHPProgress=value;
			UIManager.getInstance().toolsWnd.updateSlider(value);
		}

		protected function onRadioButton(event:MouseEvent):void {
			switch (event.target.name) {
				case "pickRBtn":
				case "fightRBtn":
					info.isAutoPickupFirst=pickRBtn.isOn;
					info.isAutoAttackFirst=fightRBtn.isOn;
					break;
				case "rangeRBtn":
				case "positionRBtn":
					info.autoRangeScreen=rangeRBtn.isOn;
					info.autoRangePosition=positionRBtn.isOn;
					break;
			}
		}

		public function refreshHpItem():void {
			var tmpArr:Array=[{label: PropUtils.getStringById(1540), uid: 20101}, {label: PropUtils.getStringById(1541), uid: 20103}, {label: PropUtils.getStringById(1542), uid: 20105}, {label: PropUtils.getStringById(1543), uid: 20107}, {label: PropUtils.getStringById(1548), uid: 20109}];
			for (var n:int=tmpArr.length - 1; n >= 0; n--) {
				var itemInfo:TItemInfo=TableManager.getInstance().getItemInfo(tmpArr[n].uid);
				if (Core.me.info.level < int(itemInfo.level)) {
					tmpArr.splice(n, 1);
				}
			}
			var hpId:int=(0 == info.hpItem) ? 20101 : info.hpItem;
//			if(null == hpItemArr){
//				hpItemArr = tmpArr;
//			}
//			if(tmpArr.length != hpItemArr.length){
			hpId=tmpArr[tmpArr.length - 1].uid;
//				hpItemArr = tmpArr;
//			}
//			hpCbox.list.addRends(hpItemArr);
//			hpCbox.list.selectByUid(hpId + "");
			info.hpItem=hpId;
		}

		/**
		 * <T>加载配置</T>
		 *
		 */
		public function initConfig(config:Array):void {
			info.unserialize(config);
			var configInfo:AssistInfo=info;
			// 保护设置
			configInfo.isAutoEatHP ? autoEatCBox.turnOn() : autoEatCBox.turnOff();
			configInfo.isAutoBuyHP ? autoBuyCBox.turnOn() : autoBuyCBox.turnOff();
			hpThresholdLbl.text=int(configInfo.minHPProgress * 100) + "";
			// 挂机设置
			configInfo.isAutopickupItem ? autoPickItemCBox.turnOn() : autoPickItemCBox.turnOff();
			configInfo.isAutoPickupEquip ? autoPickEquipCBox.turnOn() : autoPickEquipCBox.turnOff();
			configInfo.isAutoRevive ? reliveCheckBox.turnOn() : reliveCheckBox.turnOff();
			configInfo.isAutoPickupFirst ? pickRBtn.turnOn() : pickRBtn.turnOff();
			configInfo.isAutoAttackFirst ? fightRBtn.turnOn() : fightRBtn.turnOff();
			configInfo.autoRangeScreen ? rangeRBtn.turnOn() : rangeRBtn.turnOff();
			configInfo.autoRangePosition ? positionRBtn.turnOn() : positionRBtn.turnOff();
			pickIQuality.list.selectByUid(configInfo.autoPickItemQuality + "");
			pickEQuality.list.selectByUid(configInfo.autoPickEquipQuality + "");
			// VIP特权
			configInfo.isAutoExtract ? autoExtractCBox.turnOn() : autoExtractCBox.turnOff();
			extractionQuality.list.selectByUid(configInfo.extractionQuality + "");
			// 设置头像处阀值显示
			UIManager.getInstance().toolsWnd.updateSlider(configInfo.minHPProgress);
			var reviveCkBox:CheckBox=ReviveWnd.getInstance().autoCKBox;
			configInfo.isAutoRevive ? reviveCkBox.turnOn() : reviveCkBox.turnOff();
			UIManager.getInstance().toolsWnd.updateAutoMagicList();
			addTimer();
		}

		public override function set visible(value:Boolean):void {
			super.visible=value;
			if (value) {
				if (!autoBuyCBox.isOn) {
					GuideManager.getInstance().showGuide(46, autoBuyCBox);
				}
				if (!autoPickEquipCBox.isOn) {
					GuideManager.getInstance().showGuide(85, autoPickEquipCBox);
				}

//				if (43 == Core.me.info.level) {
				GuideManager.getInstance().showGuide(122, this);
//				}

				GuideManager.getInstance().removeGuide(45);
				GuideManager.getInstance().removeGuide(42);
				GuideManager.getInstance().removeGuide(84);

			} else {

				GuideManager.getInstance().removeGuide(46);
				GuideManager.getInstance().removeGuide(85);
				GuideManager.getInstance().removeGuide(122);

			}
		}

		/**
		 * <T>面板关闭</T>
		 *
		 */
		public override function hide():void {
			super.hide();
			Cmd_Assist.cm_Ass_S(info.serialize());
//			TweenManager.getInstance().lightingCompnent(UIManager.getInstance().toolsWnd.getUIbyID("guaJBtn"));
		}

		/**
		 * <T>解析挂机配置</T>
		 *
		 * @param obj 配置数据
		 *
		 */
		public function unserialize(obj:Object):void {
			var value:String=obj.config;
			var config:Array=value.split(",");
			if ("" == value) {
				config=DEFAULT_CONFIG;
				config[1]=(1 == ConfigEnum.auto1) ? 2 : 1;
				config[2]=ConfigEnum.auto2;
				config[5]=(1 == ConfigEnum.auto3) ? 2 : 1;
				config[6]=ConfigEnum.auto4;
				config[9]=(1 == ConfigEnum.auto6) ? 2 : 1;
				config[10]=(1 == ConfigEnum.auto7) ? 2 : 1;
				config[16]=(0 == ConfigEnum.auto8) ? 2 : 1;
				config[17]=(1 == ConfigEnum.auto8) ? 2 : 1;
				config[18]=ConfigEnum.auto9;
			}
			initConfig(config);
		}

		/**
		 * <T>下拉框选择</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		protected function onComboBoxClick(event:Event):void {
			var n:String=event.target.name;
			switch (n) {
				case "extractionQuality":
					info.extractionQuality=extractionQuality.value.uid;
					break;
				case "pickIQuality":
					info.autoPickItemQuality=pickIQuality.value.uid;
					break;
				case "pickEQuality":
					info.autoPickEquipQuality=pickEQuality.value.uid;
					break;
			}
		}

		/**
		 * <T>获取配置信息对象</T>
		 *
		 * @return 信息对象
		 *
		 */
		public function get info():AssistInfo {
			return SettingManager.getInstance().assitInfo;
		}

		/**
		 * <T>鼠标点击事件</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		public function onButtonClick(event:MouseEvent=null):void {
			//			Core.me.gotoMap(new Point(22, 33), "100");
			//			return;
			if (Core.me.pInfo.isLockAttackTarget) {
				ModuleProxy.broadcastMsg(9992);
				return;
			}
			GuideManager.getInstance().removeGuide(42);
			Core.me.onAutoMonster();
			var imgUrl:String=info.isAuto ? "ui/assist/assist_stop.png" : "ui/assist/assist_guaji.png";
			btnImg.updateBmp(imgUrl);
			hide();
			//			info.isAuto ? SceneTipUI.getInstance().addMc(PlayerEnum.FILE_AUTO_ATTACK) // 
			//				: SceneTipUI.getInstance().removeMc(PlayerEnum.FILE_AUTO_ATTACK);
		}

		protected function autoEat():void {
			AutoUtil.autoEat();
		}

		/**
		 * <T>设置血量和蓝量阀值</T>
		 *
		 * @param hp 血量
		 * @param mp 蓝量
		 *
		 */
		public function setProgress(hp:Number, mp:Number):void {
			if (-1 != hp) {
				hpThresholdLbl.text=int(hp * 100) + "";
				info.minHPProgress=hp;
			}
			autoEatCBox.turnOn();
			info.isAutoEatHP=autoEatCBox.isOn;
			// 自动补血
			addTimer();
		}

		/**
		 * <T>保存配置</T>
		 *
		 */
		public function saveConfig():void {
			Cmd_Assist.cm_Ass_S(info.serialize());
		}

		/**
		 * <T>选择框点击处理</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		protected function onCheckBoxClick(event:MouseEvent):void {
			var n:String=event.target.name;
			switch (n) {
				case "reliveCheckBox":
					info.isAutoRevive=reliveCheckBox.isOn;
					var reviveCkBox:CheckBox=ReviveWnd.getInstance().autoCKBox;
					info.isAutoRevive ? reviveCkBox.turnOn() : reviveCkBox.turnOff();
					break;
				case "autoEatCBox":
					info.isAutoEatHP=autoEatCBox.isOn;
					break;
				case "autoBuyCBox":
					info.isAutoBuyHP=autoBuyCBox.isOn;
					GuideManager.getInstance().removeGuide(46);
					break;
				case "autoPickEquipCBox":
					info.isAutoPickupEquip=autoPickEquipCBox.isOn;
					break;
				case "autoPickItemCBox":
					info.isAutopickupItem=autoPickItemCBox.isOn;
					break;
				case "autoExtractCBox":
					if (Core.me.info.vipLv >= 3) {
						info.isAutoExtract=autoExtractCBox.isOn;
					} else {
						NoticeManager.getInstance().broadcastById(10137);
					}
					break;
			}
			addTimer();
		}

		private function addTimer():void {
			// 自动补血
			if (info.isAutoEatHP || info.isAutoEatMP) {
				if (!TimeManager.getInstance().hasITick(autoEat)) {
					TimeManager.getInstance().addITick(5100, autoEat);
				}
			} else {
				TimeManager.getInstance().removeITick(autoEat);
			}
		}

		public override function get height():Number {
			return 544;
		}

	}
}
