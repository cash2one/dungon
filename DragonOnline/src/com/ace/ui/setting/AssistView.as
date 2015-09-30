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
	import com.ace.ui.scrollBar.event.ScrollBarEvent;
	import com.ace.ui.slider.children.HSlider;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.QualityEnum;
	import com.leyou.net.cmd.Cmd_Assist;
	import com.leyou.utils.PropUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AssistView extends AutoWindow {
		// 技能格子数量
		private static const GRID_COUNT:int=4;

		// 挂机可用技能ID
		private static const SKILLS:Array=[100, 104, 108, 112, 300, 304, 308, 312, 500, 504, 508, 512, 700, 704, 708, 712];

		// 默认挂机配置
		private static var DEFAULT_CONFIG:Array=[1, 2, 0.5, 2, 0.5, 2, 20101, 1, 20401, 1, 1, 4, -1, -1, -1, -1, 2, 1, QualityEnum.QUA_COMMON];

		public var reliveCheckBox:CheckBox;

		private var hpCheckBox:CheckBox;

		private var mpCheckBox:CheckBox;

		private var buyHpCheckBox:CheckBox;

		private var buyMpCheckBox:CheckBox;

		private var pickEquipCheckBox:CheckBox;

		private var pickItemCheckBox:CheckBox;

		public var hpHslider:HSlider;

		public var mpHslider:HSlider;

		private var hpCbox:ComboBox;

		private var mpCbox:ComboBox;

		private var autoBtn:ImgButton;

		//		private var grids:Vector.<AssistSkillGrid>;

		private var btnImg:Image;

		private var hpItemArr:Array;
		
		private var pickRBtn:RadioButton;
		private var fightRBtn:RadioButton;
		private var pickQuality:ComboBox;

		public function AssistView() {
			//			AutoUtil.autoBuyHp()
			super(LibManager.getInstance().getXML("config/ui/setting/assistWnd.xml"));
			this.init();
			LayerManager.getInstance().windowLayer.addChild(this);
		}

		/**
		 * <T>初始化</T>
		 *
		 */
		protected function init():void {
			autoBtn=getUIbyID("autoBtn") as ImgButton;
			reliveCheckBox=getUIbyID("reliveCheckBox") as CheckBox;
			hpCheckBox=getUIbyID("hpCheckBox") as CheckBox;
			mpCheckBox=getUIbyID("mpCheckBox") as CheckBox;
			buyHpCheckBox=getUIbyID("buyHpCheckBox") as CheckBox;
			buyMpCheckBox=getUIbyID("buyMpCheckBox") as CheckBox;
			pickEquipCheckBox=getUIbyID("pickEquipCheckBox") as CheckBox;
			pickItemCheckBox=getUIbyID("pickItemCheckBox") as CheckBox;
			hpHslider=getUIbyID("hpHslider") as HSlider;
			mpHslider=getUIbyID("mpHslider") as HSlider;
			hpCbox=getUIbyID("hpCbox") as ComboBox;
			mpCbox=getUIbyID("mpCbox") as ComboBox;
			btnImg=getUIbyID("btnImg") as Image;
			pickRBtn = getUIbyID("pickRBtn") as RadioButton;
			fightRBtn = getUIbyID("fightRBtn") as RadioButton;
			pickQuality = getUIbyID("pickQuality") as ComboBox;

			pickRBtn.addEventListener(MouseEvent.CLICK, onRadioButton);
			fightRBtn.addEventListener(MouseEvent.CLICK, onRadioButton);
			pickQuality.addEventListener(DropMenuEvent.Item_Selected, onComboBoxClick);
			//			autoBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			autoBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			reliveCheckBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			hpCheckBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			//			mpCheckBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			buyHpCheckBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			//			buyMpCheckBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			pickEquipCheckBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			pickItemCheckBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			hpHslider.addEventListener(ScrollBarEvent.Progress_Update, onSliderScroll);
			//			mpHslider.addEventListener(ScrollBarEvent.Progress_Update, onSliderScroll);
			hpCbox.addEventListener(DropMenuEvent.Item_Selected, onComboBoxClick);
			//			mpCbox.addEventListener(DropMenuEvent.Item_Selected, onComboBoxClick);
			//			grids = new Vector.<AssistSkillGrid>(GRID_COUNT);
			//			for (var n:int = 0; n < GRID_COUNT; n++) {
			//				var grid:AssistSkillGrid = new AssistSkillGrid();
			//				grid.name = n + "";
			//				grid.x = 66 + n*41;
			//				grid.y = 157;
			//				grid.switchListener = onSkillSwitch;
			//				addChild(grid);
			//				grids[n] = grid;
			//			}

//			hpCbox.list.addRends([{label: "轻微治疗药剂", uid: 20101}, {label: "轻型治疗药剂", uid: 20103}, {label: "治疗药剂   ", uid: 20105}, {label: "中型治疗药剂", uid: 20107}]);

			var content:String = TableManager.getInstance().getSystemNotice(10034).content;
			var qarray:Array = [{label:content, uid:QualityEnum.QUA_COMMON}];
			content = TableManager.getInstance().getSystemNotice(10035).content;
			qarray.push({label:content, uid:QualityEnum.QUA_EXCELLENT});
			content = TableManager.getInstance().getSystemNotice(10036).content;
			qarray.push({label:content, uid:QualityEnum.QUA_TERRIFIC});
			content = TableManager.getInstance().getSystemNotice(10037).content;
			qarray.push({label:content, uid:QualityEnum.QUA_INCREDIBLE});
			pickQuality.list.addRends(qarray);


			EventManager.getInstance().addEvent(EventEnum.SETTING_AUTO_MONSTER, this.onButtonClick);
		}
		
		protected function onRadioButton(event:MouseEvent):void{
			switch(event.target.name){
				case "pickRBtn":
				case "fightRBtn":
					info.isAutoPickupFirst = pickRBtn.isOn;
					info.isAutoAttackFirst = fightRBtn.isOn;
					break;
			}
		}		
		
		public function refreshHpItem():void{
			var tmpArr:Array = [{label: PropUtils.getStringById(1540), uid: 20101},
						{label:PropUtils.getStringById(1541), uid: 20103}, 
						{label: PropUtils.getStringById(1542), uid: 20105}, 
						{label: PropUtils.getStringById(1543), uid: 20107},
						{label: PropUtils.getStringById(1548), uid: 20109}];
			for(var n:int = tmpArr.length-1; n >= 0; n--){
				var itemInfo:TItemInfo = TableManager.getInstance().getItemInfo(tmpArr[n].uid);
				if(Core.me.info.level < int(itemInfo.level)){
					tmpArr.splice(n, 1);
				}
			}
			var hpId:int = (0 == info.hpItem) ? 20101 : info.hpItem;
			if(null == hpItemArr){
				hpItemArr = tmpArr;
			}
			if(tmpArr.length != hpItemArr.length){
				hpId = tmpArr[tmpArr.length-1].uid;
				hpItemArr = tmpArr;
			}
			hpCbox.list.addRends(hpItemArr);
			hpCbox.list.selectByUid(hpId + "");
//			info.hpItem = hpId;
		}

		/**
		 * <T>技能拖动交换施放顺序</T>
		 *
		 */
		//		public function onSkillSwitch():void{
		//			var useSkills:Array = info.skills;
		//			for (var n:int = 0; n < GRID_COUNT; n++) {
		//				var grid:AssistSkillGrid = grids[n];
		//				useSkills[n] = grid.dataId;
		//			}
		//		}

		/**
		 * <T>加载配置</T>
		 *
		 */
		public function initConfig(config:Array):void {
			info.unserialize(config);
			var configInfo:AssistInfo=info;
			configInfo.isAutoRevive ? reliveCheckBox.turnOn() : reliveCheckBox.turnOff();
			configInfo.isAutoEatHP ? hpCheckBox.turnOn() : hpCheckBox.turnOff();
			//			configInfo.isAutoEatMP ? mpCheckBox.turnOn() : mpCheckBox.turnOff();
			configInfo.isAutoBuyHP ? buyHpCheckBox.turnOn() : buyHpCheckBox.turnOff();
			//			configInfo.isAutoBuyMP ? buyMpCheckBox.turnOn() : buyMpCheckBox.turnOff();
			configInfo.isAutoPickupEquip ? pickEquipCheckBox.turnOn() : pickEquipCheckBox.turnOff();
			configInfo.isAutopickupItem ? pickItemCheckBox.turnOn() : pickItemCheckBox.turnOff();
			configInfo.isAutoPickupFirst ? pickRBtn.turnOn() : pickRBtn.turnOff();
			configInfo.isAutoAttackFirst ? fightRBtn.turnOn() : fightRBtn.turnOff();
			hpHslider.progress=configInfo.minHP / Core.me.info.baseInfo.maxHp;
			//			mpHslider.progress = configInfo.minMP/Core.me.info.baseInfo.maxMp;
			hpCbox.list.selectByUid(configInfo.hpItem + "");
			pickQuality.list.selectByUid(configInfo.autoPickQuality+"");
			//			mpCbox.list.selectByUid(configInfo.mpItem+"");

			UIManager.getInstance().toolsWnd.updateAutoMagicList();
			// 设置头像处阀值显示
			UIManager.getInstance().toolsWnd.updateSlider(hpHslider.progress);
			//			UIManager.getInstance().roleHeadWnd.setThreshold(hpHslider.progress, mpHslider.progress);
			var reviveCkBox:CheckBox=ReviveWnd.getInstance().autoCKBox;
			configInfo.isAutoRevive ? reviveCkBox.turnOn() : reviveCkBox.turnOff();
			addTimer();
		}

//		/**
//		 * <T>面板打开</T>
//		 *
//		 */
//		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
//			super.show(toTop, $layer, toCenter);
//			if(!hpCheckBox.isOn){
//				GuideManager.getInstance().showGuide(46, this);
//			}
//		}
		
		public override function set visible(value:Boolean):void{
			super.visible = value;
			if(value){
				if(!buyHpCheckBox.isOn){
					GuideManager.getInstance().showGuide(46, buyHpCheckBox);
				}
				if(!pickEquipCheckBox.isOn){
					GuideManager.getInstance().showGuide(85, pickEquipCheckBox);
				}
				GuideManager.getInstance().removeGuide(45);
				GuideManager.getInstance().removeGuide(42);
				GuideManager.getInstance().removeGuide(84);
			}else{
				GuideManager.getInstance().removeGuide(46);
				GuideManager.getInstance().removeGuide(85);
			}
		}
		
		/**
		 * <T>面板关闭</T>
		 *
		 */
		public override function hide():void {
			super.hide();
			Cmd_Assist.cm_Ass_S(info.serialize());
			TweenManager.getInstance().lightingCompnent(UIManager.getInstance().toolsWnd.getUIbyID("guaJBtn"));
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
				config[1] = (1 == ConfigEnum.auto1) ? 2 : 1;
				config[2] = ConfigEnum.auto2;
				config[5] = (1 == ConfigEnum.auto3) ? 2 : 1;
				config[6] = ConfigEnum.auto4;
				config[9] = (1 == ConfigEnum.auto6) ? 2 : 1;
				config[10] = (1 == ConfigEnum.auto7) ? 2 : 1;
				config[16] = (0 == ConfigEnum.auto8) ? 2 : 1;
				config[17] = (1 == ConfigEnum.auto8) ? 2 : 1;
				config[18] = ConfigEnum.auto9;
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
//			hpCbox.list.selectByInd(0);
			switch (n) {
				case "hpCbox":
//					var itemId:int = hpCbox.value.uid;
//					var info:TItemInfo = TableManager.getInstance().getItemInfo(itemId);
//					if(int(info.level) > Core.me.info.level){
//						
//					}
					info.hpItem=hpCbox.value.uid;
					break;
				case "pickQuality":
					info.autoPickQuality = pickQuality.value.uid;
					break;
//				case "mpCbox":
//					info.mpItem=mpCbox.value.uid;
//					break;
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
		}

		/**
		 * <T>滚动条更新事件处理</T>
		 *
		 * @param event 滚动事件
		 *
		 */
		protected function onSliderScroll(event:Event):void {
			var n:String=event.target.name;
			switch (n) {
				case "hpHslider":
//					info.minHP = Core.me.info.baseInfo.maxHp*hpHslider.progress;
					info.minHPProgress=hpHslider.progress;
					break;
				case "mpHslider":
					info.minMP=Core.me.info.baseInfo.maxMp * mpHslider.progress;
					break;
			}
			// 同步头像处阀值
			//			UIManager.getInstance().roleHeadWnd.setThreshold(hpHslider.progress, mpHslider.progress);
			UIManager.getInstance().toolsWnd.updateSlider(hpHslider.progress);
			//			autoEat();
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
				hpHslider.progress=hp;
				info.minHPProgress=hpHslider.progress;
//				info.minHP = Core.me.info.baseInfo.maxHp*hpHslider.progress;
			}
			if (-1 != mp) {
				mpHslider.progress=mp;
				info.minMP=Core.me.info.baseInfo.maxMp * mpHslider.progress;
			}
			//			autoEat();
			hpCheckBox.turnOn();
			info.isAutoEatHP=hpCheckBox.isOn;
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
				case "hpCheckBox":
					info.isAutoEatHP=hpCheckBox.isOn;
					break;
				case "mpCheckBox":
					info.isAutoEatMP=mpCheckBox.isOn;
					break;
				case "buyHpCheckBox":
					info.isAutoBuyHP=buyHpCheckBox.isOn;
					GuideManager.getInstance().removeGuide(46);
					break;
				case "buyMpCheckBox":
					info.isAutoBuyMP=buyMpCheckBox.isOn;
					break;
				case "pickEquipCheckBox":
					info.isAutoPickupEquip=pickEquipCheckBox.isOn;
					GuideManager.getInstance().removeGuide(85);
					break;
				case "pickItemCheckBox":
					info.isAutopickupItem=pickItemCheckBox.isOn;
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

		//		/**
		//		 * <T>获得技能所在索引</T>
		//		 * 
		//		 * @param skillId 技能编号
		//		 * @return        所在索引,-1为不存在
		//		 * 
		//		 */		
		//		public function indexOfSkill(skillId:int):int{
		//			var skills:Array = info.skills;
		//			for(var n:int = 0; n < GRID_COUNT; n++){
		//				var skid:int = grids[n].dataId;
		//				if(-1 != skid && 0 != skid){
		//					var skill:TSkillInfo = TableManager.getInstance().getSkillById(skid);
		//					if(skill.skillId == skillId){
		//						return n;
		//					}
		//				}
		//			}
		//			return -1;
		//		}
		//		
		//		/**
		//		 * <T>获得索引</T>
		//		 * 
		//		 * @param skillData 技能数据
		//		 * @return          索引
		//		 * 
		//		 */		
		//		public function getIndex(skillData:Array):int{
		//			var index:int = 0;
		//			if (2 == skillData[3]){
		//				index = 1;
		//			}else if(2 == skillData[4]){
		//				index = 2;
		//			}else if(2 == skillData[5]){
		//				index = 3;
		//			}
		//			return index;
		//		}
		//		
		//		/**
		//		 * <T>更新挂机技能</T>
		//		 * 
		//		 * @param data 技能数据
		//		 * 
		//		 */		
		//		public function updataSkill(data:SkillInfo):void{
		//			var currGIdx:int = 0;
		//			var useSkills:Array = info.skills;
		//			var skillDatas:Array = data.skillItems;
		//			var count:int = skillDatas.length;
		//			for(var n:int = 1; n < count; n++){
		//				var skillData:Array = skillDatas[n];
		//				var index:int = getIndex(skillData);
		//				var skillInfo:TSkillInfo = TableManager.getInstance().getSkillByIdAndRune(skillData[1], index);
		//				// 是否可用
		//				var canUse:Boolean = (-1 != SKILLS.indexOf(int(skillInfo.id)-index));
		//				// 是否已学会
		//				var has:Boolean = (1 == skillData[0]);
		//				if((currGIdx < GRID_COUNT) && canUse && has){
		//					// 是否已存在
		//					var i:int = indexOfSkill(skillInfo.skillId);
		//					if(-1 != i){
		//						useSkills[i] = skillInfo.id;
		//						currGIdx = i+1;
		//					}else{
		//						useSkills[currGIdx] = skillInfo.id;
		//						grids[currGIdx++].updataInfo(skillInfo);
		//					}
		//				}
		//			}
		//		}
	}
}
