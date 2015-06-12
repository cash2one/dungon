package com.ace.manager {
	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.GuideEnum;
	import com.ace.gameData.manager.SettingManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.setting.AssistInfo;
	import com.ace.gameData.table.TGuideInfo;
	import com.ace.ui.guide.GuideEffectController;
	import com.ace.ui.guide.GuidePointTip;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.MoldEnum;
	import com.leyou.net.cmd.Cmd_Guide;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.getTimer;
	
	public class GuideManager {
		
		private static const MUTEX_GUIDE:Array=[47, 50, 51, 52, 54];
		
		private static var instance:GuideManager;
		
		private static var con:DisplayObjectContainer;
		
		private static var usePointTips:Array;
		
		private static var freePointTips:Array;
		
		private static var guideQueues:Object;
		
		private var timeArr:Array;
		
		private var tick:uint;

		private var _rc:int;
		
		private var useEffectController:Vector.<GuideEffectController>;
		
		private var freeEffectController:Vector.<GuideEffectController>;
		
		public function get rc():int{
			return _rc;
		}

		public static function getInstance():GuideManager {
			if (!instance){
				instance = new GuideManager();
			}
			return instance;
		}
		
		public function GuideManager():void {
			this.setup(LayerManager.getInstance().guildeLayer);
		}
		
		private function init():void {
			guideQueues = {};
			usePointTips = [];
			usePointTips[1] = new Vector.<GuidePointTip>();
			usePointTips[2] = new Vector.<GuidePointTip>();
			usePointTips[3] = new Vector.<GuidePointTip>();
			usePointTips[4] = new Vector.<GuidePointTip>();
			
			freePointTips = [];
			freePointTips[1] = new Vector.<GuidePointTip>();
			freePointTips[2] = new Vector.<GuidePointTip>();
			freePointTips[3] = new Vector.<GuidePointTip>();
			freePointTips[4] = new Vector.<GuidePointTip>();
			
			useEffectController = new Vector.<GuideEffectController>();
			freeEffectController = new Vector.<GuideEffectController>();
			// 在线奖励计时
			if(!TimeManager.getInstance().hasITick(onTimer)){
				TimeManager.getInstance().addITick(3000, onTimer);
			}
			EventManager.getInstance().addEvent(EventEnum.SHOW_CUTSCENE, hideGuide);
			EventManager.getInstance().addEvent(EventEnum.END_CUTSCENE, resetGuide);
		}
		
		public function rewardReducing():void{
			_rc--;
			UIManager.getInstance().rightTopWnd.updateWelfare();
		}
		
		protected function onTimer():void{
			if(!Core.me || !Core.me.info || Core.me.info.level < 24){
				return;
			}
			if(null != timeArr){
				var interval:int = (getTimer() - tick)/1000;
				// 福利计时部分
				var expRT:int = timeArr[0]; // 经验奖励
				if(0 < expRT){
					if(interval >= expRT){
						timeArr[0] = 0;
					}
				}else if(0 == expRT){
					_rc++;
					timeArr[0] = -1;
					UIManager.getInstance().rightTopWnd.updateWelfare();
				}
				var moneyRT:int = timeArr[1]; // 金钱奖励
				if(0 < moneyRT){
					if(interval >= moneyRT){
						timeArr[1] = 0;
					}
				}else if(0 == moneyRT){
					_rc++;
					timeArr[1] = -1;
					UIManager.getInstance().rightTopWnd.updateWelfare();
				}
				var energyRT:int = timeArr[2]; // 魂力奖励
				if(0 < energyRT){
					if(interval >= energyRT){
						timeArr[2] = 0;
					}
				}else if(0 == energyRT){
					_rc++;
					timeArr[2] = -1;
					UIManager.getInstance().rightTopWnd.updateWelfare();
				}
				var marketRT:int = timeArr[3]; // 商城奖励
				if(0 < marketRT){
					if(interval >= marketRT){
						timeArr[3] = 0;
					}
				}else if(0 == marketRT){
					_rc++;
					timeArr[3] = -1;
					UIManager.getInstance().rightTopWnd.updateWelfare();
				}
				var bybRT:int = timeArr[4]; // 绑定元宝奖励
				if(0 < bybRT){
					if(interval >= bybRT){
						timeArr[4] = 0;
					}
				}else if(0 == bybRT){
					_rc++;
					timeArr[4] = -1;
					UIManager.getInstance().rightTopWnd.updateWelfare();
				}
			}
		}
		
		public function setup($con:DisplayObjectContainer):void {
			if (null !=  con) {
				//				throw new Error("重复");
				return;
			}
			con = $con;
			init();
		}
		
		public function recordTime(obj:Object):void{
			// 福利
			var tl:Array = obj.tl;
			if(null == timeArr){
				timeArr = [];
			}
			tick = getTimer();
			timeArr = timeArr.concat(tl);
		}
		
		/**
		 * 显示指引,若正在显示,执行并更新坐标
		 *  
		 * @param id      指引ID
		 * @param display 所属显示对象
		 * 
		 */		
		public function showGuide(id:int, display:DisplayObjectContainer, check:Boolean=false):void{
			return;
			if (null == con) {
				throw new Error("the guide layer is null.")
			}
			if(null == display){
				throw new Error("要指引的显示对象为NULL,指引ID为:"+id);
			}
			if(assistInfo.needGuide(id) && (67 != id)){
				// 是否存在两两互斥列表中
				var index:int=MUTEX_GUIDE.indexOf(id);
				if (-1 != index) {
					var length:int=MUTEX_GUIDE.length;
					for (var n:int=0; n < length; n++) {
						var cid:int = MUTEX_GUIDE[n];
						if ((cid != id) && containsGuide(cid)){
							return;
						}
					}
				}
				
				if(check){
					// 检查显示对象是否出于显示状态
					var p:DisplayObjectContainer = display;
					while(p != display.root){
						if((null == p) || !p.visible){
							return;
						}
						p = p.parent;
					}
				}
			
				// 指引
				var info:TGuideInfo = TableManager.getInstance().getGuideInfo(id);
				if(GuideEnum.GUIDE_EFFECT != info.type){
//					trace("-----------------add point guide id = " + id)
					// 箭头指引
					var point:GuidePointTip = getTip(info.type, info.id);
					point.updateInfo(info, display);
					point.addToContainer(con);
					point.setListenter(onPointTimerOver);
					point.check = check;
				}else{
//					trace("-----------------add effect guide id = " + id)
					// 发光特效指引
					var effControl:GuideEffectController = getEffController(info.id);
					effControl.updateInfo(info, display);
					effControl.setListenter(onPointTimerOver);
				}
				// 增加指引次数
				assistInfo.addGuideTime(id);
				// 通知服务器
				Cmd_Guide.cm_GUD_F(id);
			}
		}
		
		private function getEffController(id:int):GuideEffectController{
			var info:TGuideInfo = TableManager.getInstance().getGuideInfo(id);
			var l:int = useEffectController.length;
			for (var n:int = 0; n < l; n++) {
				if (useEffectController[n].guideInfo.id == id) {
					return useEffectController[n];
				}
			}
			var gec:GuideEffectController;
			if (freeEffectController.length > 0) {
				gec = freeEffectController.pop();
			} else {
				gec = new GuideEffectController();
			}
			useEffectController.push(gec);
			return gec;
		}
		
		/**
		 * 显示指引队列
		 * 
		 * @param ids      指引ID列表
		 * @param displays 所属显示对象列表
		 * 
		 */		
		public function showGuides(ids:Array, displays:Array):void{
			if (null == con) {
				throw new Error("the guide layer is null.")
			}
			
			if((null == ids) || (0 == ids.length)){
				return;
			}
			var info:TGuideInfo = TableManager.getInstance().getGuideInfo(ids[0]);
			if(!guideQueues.hasOwnProperty(info.groupId)){
				guideQueues[info.groupId] = [ids, displays];
				showGuide(ids.shift(), displays.shift());
			}
		}
		
		/**
		 * 此指引是否正在显示
		 * 
		 * @param id 指引
		 * @return   true -- 正在显示 false -- 没有显示
		 * 
		 */		
		public function containsGuide(id:int):Boolean {
			var info:TGuideInfo = TableManager.getInstance().getGuideInfo(id);
			if(GuideEnum.GUIDE_EFFECT == info.type){
				var el:int = useEffectController.length;
				for(var m:int = 0; m < el; m++){
					if (useEffectController[m].guideInfo.id == id){
						return true;
					}
				}
			}else{
				var useArr:Vector.<GuidePointTip> = usePointTips[info.type];
				var l:int = useArr.length;
				for (var n:int = 0; n < l; n++) {
					if (useArr[n].guideInfo.id == info.id) {
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * 移出指引
		 * 
		 * @param id 指引ID
		 * 
		 */		
		public function removeGuide(id:int):void {
//			trace("-----------------remove guide id = " + id)
			var info:TGuideInfo = TableManager.getInstance().getGuideInfo(id);
			if(GuideEnum.GUIDE_EFFECT == info.type){
				var effect:GuideEffectController;
				var el:int = useEffectController.length;
				for(var i:int = 0; i < el; i++){
					if (useEffectController[i].guideInfo.id == id) {
						effect = useEffectController.splice(i, 1)[0];
//						trace("-----------------remove effect guide success. id = " + id)
						break;
					}
				}
				if(null != effect){
					effect.clear();
					freeEffectController.push(effect);
				}
			}else{
				var freeArr:Vector.<GuidePointTip> = freePointTips[info.type];
				var useArr:Vector.<GuidePointTip> = usePointTips[info.type];
				var p:GuidePointTip;
				var l:int = useArr.length;
				for (var n:int = 0; n < l; n++) {
					if (useArr[n].guideInfo.id == id) {
						p = useArr.splice(n, 1)[0];
						//					trace("-----------------remove point guide success. id = " + id)
						break;
					}
				}
				if (null !=  p) {
					p.clear();
					freeArr.push(p);
				}
			}
			// 处理后续指引
			var data:Array = guideQueues[info.groupId];
			if(null != data){
				var ids:Array = data[0];
				var dis:Array = data[1];
				if(0 == ids.length){
					delete guideQueues[info.groupId];
					return;
				}
				showGuide(ids.shift(), dis.shift());
			}
			
		}
		
		/**
		 * 重置指引位置
		 * 
		 */		
		public function resize():void{
			for(var n:int = 1; n < 5; n++){
				var useArr:Vector.<GuidePointTip> = usePointTips[n];
				var l:int = useArr.length;
				for (var m:int = 0; m < l; m++) {
					useArr[m].resize();
				}
			}
		}
		
		private function get assistInfo():AssistInfo {
			return SettingManager.getInstance().assitInfo;
		}
		
		/**
		 * 获得一个指引对象
		 * 
		 * @param type 指引类型
		 * @param id   指引ID
		 * @return     指引对象
		 * 
		 */		
		private function getTip(type:int, id:int):GuidePointTip {
			// 是否在显示中的指引
			var info:TGuideInfo = TableManager.getInstance().getGuideInfo(id);
			var useArr:Vector.<GuidePointTip> = usePointTips[type];
			var l:int = useArr.length;
			for (var n:int = 0; n < l; n++) {
				if (useArr[n].guideInfo.id == id) {
					return useArr[n];
				}
			}
			// 获取一个新的指引
			var freeArr:Vector.<GuidePointTip> = freePointTips[type];
			//			var useArr:Vector.<PointTip> = usePointTips[type];
			var p:GuidePointTip;
			if (freeArr.length > 0) {
				p = freeArr.pop();
			} else {
				p = new GuidePointTip("config/ui/introduction/arrowWnd.xml", type);
			}
			useArr.push(p);
			return p;
		}
		
		/**
		 * 指引计时完成触发函数
		 * 
		 * @param evt 事件
		 * 
		 */		
		public function onPointTimerOver(target:*):void {
//			var p:GuidePointTip = evt.target as GuidePointTip;
			removeGuide(target.guideInfo.id);
		}
		
		/**
		 * 刷新所有引导,所属的显示对象被隐藏,引导也会被隐藏
		 * 
		 */		
		public function refreshGuide():void{
			var invalidIDs:Array = [];
			for(var n:int = 1; n < 5; n++){
				var useArr:Vector.<GuidePointTip> = usePointTips[n];
				var l:int = useArr.length;
				for (var m:int = 0; m < l; m++) {
					if(!useArr[m].valid()){
						invalidIDs.push(useArr[m].guideInfo.id);
					}
				}
			}
			for each(var id:int in invalidIDs){
				removeGuide(id);
			}
		}
		
		public function hideGuide():void{
			for(var n:int = 1; n < 5; n++){
				var useArr:Vector.<GuidePointTip> = usePointTips[n];
				var l:int = useArr.length;
				for (var m:int = 0; m < l; m++) {
					if(null != useArr[m]){
						useArr[m].visible = false;
					}
				}
			}
		}
		
		public function resetGuide():void{
			for(var n:int = 1; n < 5; n++){
				var useArr:Vector.<GuidePointTip> = usePointTips[n];
				var l:int = useArr.length;
				for (var m:int = 0; m < l; m++) {
					if(null != useArr[m]){
						useArr[m].visible = true;
					}
				}
			}
		}
		
		// 等级检测,显示指引
		public function checkGuideByLevel(level:int):void {
			// 福利
			if (ConfigEnum.WelfareOpenLvel == level) {
				showGuide(47, UIManager.getInstance().rightTopWnd.getWidget("welfareBtn"), true);
			}
			
			// 商城
			if (ConfigEnum.MarketOpenLevel == level) {
				showGuide(16, UIManager.getInstance().toolsWnd.getButtonByType(MoldEnum.MARKET));
			}
			
			// 剧情副本
			if (ConfigEnum.StoryCopyOpenLevel == level) {
				showGuide(28, UIManager.getInstance().rightTopWnd.getWidget("storyCopyBtn"), true);
			}
			
			// BOSS副本
			if(ConfigEnum.BossCopyOpenLevel == level){
				showGuide(64, UIManager.getInstance().rightTopWnd.getWidget("bossCopyBtn"), true);
			}
			
			// 战斗模式切换
			if (30 == level) {
				showGuide(6, UIManager.getInstance().roleHeadWnd.getUIbyID("modeBtn") as DisplayObjectContainer);
			}
			
			// 自动拾取
			if(43 == level){
				showGuide(84, UIManager.getInstance().toolsWnd);
			}
			
			// 农场
			if (ConfigEnum.FarmOpenLevel == level) {
				showGuide(24, UIManager.getInstance().rightTopWnd.getWidget("farmBtn"), true);
			}
			
			// 押镖
			if (level == ConfigEnum.delivery19) {
//				showGuide(8, UIManager.getInstance().rightTopWnd.getWidget("deliveryBtn"), true);
			}
			
			// 寄售
			if (ConfigEnum.AutionOpenLevel == level) {
				showGuide(34, UIManager.getInstance().toolsWnd.getButtonByType(MoldEnum.AUTION));
			}
			
			// 活跃度
			if (ConfigEnum.ActiveOpenLevel == level) {
				showGuide(38, UIManager.getInstance().rightTopWnd.getWidget("activityBtn"), true);
			}
			
			//坐骑
			if (level == ConfigEnum.MountOpenLv) {
				showGuide(1, UIManager.getInstance().toolsWnd.playerBtn);
			}
			
			// 竞技场
			if (level == ConfigEnum.ArenaOpenLv) {
				showGuide(31, UIManager.getInstance().rightTopWnd.getWidget("arenaBtn"), true);
			}
			
			// 答题
			if (level == ConfigEnum.question1) {
				
			}
			
			//装备
			if (level == ConfigEnum.EquipIntensifyOpenLv) {
				showGuide(21, UIManager.getInstance().toolsWnd.duanZBtn);
			}
			
			//重铸
			if (level == ConfigEnum.EquipRecastOpenLv) {
				showGuide(22, UIManager.getInstance().toolsWnd.duanZBtn);
			}
			
			//纹章
			if (level == ConfigEnum.BadgeOpenLv) {
				showGuide(12, UIManager.getInstance().toolsWnd.wenZBtn);
			}
			
			//行会
			if (level == ConfigEnum.UnionOpenLv) {
				showGuide(41, UIManager.getInstance().toolsWnd.guildBtn);
			}
			
			//翅膀
			if (level == ConfigEnum.WingOpenLv) {
				showGuide(57, UIManager.getInstance().leftTopWnd.wingBtn);
			}
			
			//称号
			if (level == ConfigEnum.NckOpenLv) {
				showGuide(58, UIManager.getInstance().toolsWnd.playerBtn);
			}
			
			//技能
			if (level == 5) {
				showGuides([35,36], [UIManager.getInstance().toolsWnd.skillBtn,UIManager.getInstance().toolsWnd]);
			}
			
			if (level == 6) {
				showGuide(63, UIManager.getInstance().toolsWnd);
			}
			
			if (level == 3) {
				showGuide(69, UIManager.getInstance().toolsWnd);
			}
			
			//日常任务
			if (level == ConfigEnum.taskDailyOpenLv) {
				showGuide(17, UIManager.getInstance().toolsWnd.missionBtn);
			}
			
			//元素
			if (level == ConfigEnum.ElementOpenLv) {
				showGuide(9, UIManager.getInstance().toolsWnd.playerBtn);
			}
			
		}
		
		//		/**
		//		 * 如果指引正在显示,则不执行任何处理
		//		 * 
		//		 * @param id      引导ID
		//		 * @param display 显示对象
		//		 * 
		//		 */		
		//		public function showGuide_II(id:int, display:DisplayObjectContainer):void{
		//			if (null == con) {
		//				throw new Error("the guide layer is null.")
		//			}
		//			if(null == display){
		//				throw new Error("要指引的显示对象为NULL,指引ID为:"+id);
		//			}
		//			// 检查显示对象是否出于显示状态
		//			var p:DisplayObjectContainer = display;
		//			while(p != display.root){
		//				if((null == p) || !p.visible){
		//					return;
		//				}
		//				p = p.parent;
		//			}
		//			if(assistInfo.needGuide(id) && !containsGuide(id)){
		//				// 指引
		//				var info:TGuideInfo = TableManager.getInstance().getGuideInfo(id);
		//				var point:PointTip = getTip(info.type, info.id);
		//				point.updateInfo(info, display);
		//				point.addToContainer(con);
		//				point.setListenter(onPointTimerOver);
		//				// 增加指引次数
		//				assistInfo.addGuideTime(id);
		//				// 通知服务器
		//				Cmd_Guide.cm_GUD_F(id);
		//			}
		//		}
		
//		/**
//		 * 重置指引位置
//		 * 
//		 * @param id 指引ID
//		 * 
//		 */		
//		public function resizeByID(id:int):void{
//			var info:TGuideInfo = TableManager.getInstance().getGuideInfo(id);
//			var useArr:Vector.<PointTip> = usePointTips[info.type];
//			var p:PointTip;
//			var l:int = useArr.length;
//			for (var n:int = 0; n < l; n++) {
//				if (useArr[n].guideInfo.id == id) {
//					p = useArr.splice(n, 1)[0];
//					break;
//				}
//			}
//			if (null != p) {
//				p.resize();
//			}
//		}
		
//		/**
//		 * 获得一个新生成指引对象
//		 * 
//		 * @param type 指引类型
//		 * @return     指引对象
//		 * 
//		 */		
//		private function getNewTip(type:int):GuidePointTip {
//			return new GuidePointTip("config/ui/introduction/arrowWnd.xml", type);
//			switch (type) {
//				case 1:
//					return new PointTip("config/ui/introduction/arrowWnd.xml", 1);
//				case 2:
//					return new PointTip("config/ui/introduction/arrowWnd.xml", 2);
//				case 3:
//					return new PointTip("config/ui/introduction/arrowWnd.xml", 3);
//				case 4:
//					return new PointTip("config/ui/introduction/arrowWnd.xml", 4);
//				default:
//					throw new Error("Get unknow type PointTip.");
//					break;
//			}
//		}
		
		// simple test
//		public function showGuideT(gid:int, gd:int, gx:int, gy:int):void {
//			var dis:DisplayObjectContainer;
//			switch (gid) {
//				case 24:
//				case 28:
//				case 4:
//					dis = UIManager.getInstance().toolsWnd;
//					break;
//				case 16:
//				case 34:
//					dis = UIManager.getInstance().toolsWnd;
//					break;
//				case 40:
//					dis = UIManager.getInstance().convenientWear;
//					break;
//				case 25:
//				case 26:
//				case 27:
//					dis = UIManager.getInstance().farmWnd;
//					break;
//				case 38:
//					dis = UIManager.getInstance().activeWnd;
//					break;
//				case 47:
//				case 48:
//				case 49:
//				case 50:
//				case 51:
//				case 52:
//				case 53:
//					dis = UIManager.getInstance().welfareWnd;
//					break;
//				case 6:
//				case 7:
//					dis = UIManager.getInstance().roleHeadWnd;
//					break;
//				case 23:
//					dis = UIManager.getInstance().onlineReward;
//					break;
//			}
//			if (null == dis || containsGuide(gid)) {
//				return;
//			}
//			// 指引
//			var info:TGuideInfo = TableManager.getInstance().getGuideInfo(gid);
//			var point:PointTip = getTip(gd, gid);
//			point.updateInfo(info, dis);
//			point.addToContainer(con);
//			point.setListenter(onPointTimerOver);
//			point.x = gx;
//			point.y = gy;
//		}
	}
}
