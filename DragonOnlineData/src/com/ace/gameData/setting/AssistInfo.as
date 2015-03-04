/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2014-1-3 下午12:07:40
 */
package com.ace.gameData.setting {
	import com.ace.config.Core;
	import com.ace.game.core.SceneCore;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TGuideInfo;

	/**
	 * 辅助信息
	 * @author ace
	 *
	 */
	public class AssistInfo {

		// 是否开启指引
		public var GuideOpen:Boolean=true;

		/**是否自动复活*/
		public var isAutoRevive:Boolean=false; //自动复活
		public var isAutoEatHP:Boolean=false; //自动吃HP
		public var isAutoEatMP:Boolean=false; //自动吃MP
		public var isAutoBuyHP:Boolean=false; //自动买HP
		public var isAutoBuyMP:Boolean=false; //自动买MP
		public var isAutoPickupEquip:Boolean=false; //自动拾取装备
		public var isAutopickupItem:Boolean=false; //自动拾取道具

		public var isAutoTask:Boolean=false; //是否任务打怪
		private var _isAuto:Boolean=false; //是否开启自动挂机
		public var preIsAuto:Boolean; //上一次挂机状态
		public var isAutoPause:Boolean=false; //是否暂停自动挂机
		//		public var skills:Array=[700, 704, 708, 712]; //技能列表，技能id
		public var skills:Array=[]; //技能列表，技能id
//		public var minHP:int; //hp最小多少时吃药  // 修改为实时计算
		public var minHPProgress:Number=0.8;
		public var minMP:int; //mp最小多少时吃药
		private var _hpItem:int; //要买的hp药
		public var mpItem:int; //要卖的mp药

		// 声音配置
		public var closeAllSound:Boolean=false; // 是否全部关闭
		public var closeAtmosphereSound:Boolean=false; // 是否关闭背景音乐
		public var closeToneSound:Boolean=false; // 是否关闭音效
		public var closeSkillSound:Boolean=false; //关闭技能音效

		// 场景渲染屏蔽
		public var isHideAll:Boolean=false;
		public var isHideOther:Boolean=false;
		public var isHideMonster:Boolean=false;
		public var isHideSkill:Boolean=false;
		public var isHideScene:Boolean=false;
		public var isHideTitle:Boolean=false; //隐藏称号
		public var isHideGuid:Boolean=false; //隐藏同行会

		private var isInit:Boolean=false;

		// 指引信息
		public var guideInfo:Object;

		public function AssistInfo() {
		}

		public function get hpItem():int {
			return _hpItem;
		}

		public function set hpItem(value:int):void {
			if (value <= 0) {
				throw new Error("Set assist info error. Auto buy item id is 0.");
			}
			_hpItem=value;
		}

		public function get minHP():int {
			return Core.me.info.baseInfo.maxHp * minHPProgress;
		}

		public function get isAuto():Boolean {
			return _isAuto && !this.isAutoPause; //没有暂停
		}

		public function set isAuto(value:Boolean):void {
			this.preIsAuto=this._isAuto;
			_isAuto=value;
			this.isAutoPause=false;
		}

		public function clearPreIsAuto():void {
			this.preIsAuto=false;
		}

		public function get isAutoII():Boolean {
			return this._isAuto;
		}

		public function autoValue(prop:String):Boolean {
			return this[prop];
		}

		private var skillIndex:int=-1;

		//下一个可以使用的技能
		public function nextSkill():int {
			this.skillIndex++;
			if (this.skillIndex >= this.skills.length)
				this.skillIndex=0;
			return this.skills[this.skillIndex];
		}

		/**暂停挂机*/
		public function pauseAutoMonster():void {
			if (!this.isAuto)
				return;
			this.isAutoPause=true;
		}

		/**恢复自动挂机*/
		public function reAutoMonster():void {
			this.isAutoPause=false;
		}

		/**停止任务打怪*/
		public function stopAutoTask():void {
			this.isAutoTask=false;
		}

		/**开启自动任务打怪*/
		public function startAutoTask():void {
			this.isAutoTask=true;
		}

		public function loadCookie():void {
			var cookieData:Object=DataManager.getInstance().cookieData;
			closeAllSound=cookieData["allSound"];
			closeAtmosphereSound=cookieData["atmosphereSound"];
			closeToneSound=cookieData["toneSound"];
			closeSkillSound=cookieData["skillSound"];

			isHideAll=cookieData["hideAll"];
			isHideOther=cookieData["hideOther"];
			isHideMonster=cookieData["hideMonster"];
			isHideSkill=cookieData["hideSkill"];
			isHideScene=cookieData["hideScene"];
			isHideTitle = cookieData["hideTitle"];
			isHideGuid = cookieData["hideGuid"];
		}

		public function setCookie():void {
			var cookieData:Object=DataManager.getInstance().cookieData;
			cookieData["allSound"]=closeAllSound;
			cookieData["atmosphereSound"]=closeAtmosphereSound;
			cookieData["toneSound"]=closeToneSound;
			cookieData["skillSound"]=closeSkillSound;

			cookieData["hideTitle"]=isHideTitle;
			cookieData["hideGuid"]=isHideGuid;
			cookieData["hideAll"]=isHideAll;
			cookieData["hideOther"]=isHideOther;
			cookieData["hideMonster"]=isHideMonster;
			cookieData["hideSkill"]=isHideSkill;
			cookieData["hideScene"]=isHideScene;
		}

		// 加载指引信息
		public function loadGuideInfo(obj:Object):void {
			if (null == guideInfo) {
				guideInfo={};
			}
			var gl:Object=obj.glist;
			for (var key:String in gl) {
				guideInfo[key]=gl[key];
			}
		}

		// 是否需要引导
		public function needGuide(id:int):Boolean {
			if (!GuideOpen) {
				return false;
			}
			if (null == guideInfo) {
				return false;
//				throw new Error("The guide info does not init");
			}
			var info:TGuideInfo=TableManager.getInstance().getGuideInfo(id);
			if (null == info) {
				throw new Error("Can not find guide info by this id. id=" + id);
			}
			// 检查前置ID
			if (info.fr_id > 0) {
				if (!guideInfo.hasOwnProperty(info.fr_id) || (guideInfo[info.fr_id] <= 0)) {
					return false;
				}
			}
			// 检查限制等级
			if (!Core.me || !Core.me.info) {
				return false;
			}
			if (Core.me.info.level < info.level) {
				return false;
			}
			// 检查是否满足指引条件
			if (guideInfo.hasOwnProperty(id)) {
				return (guideInfo[id] < info.act_num) || (-1 == info.act_num);
			}
			return true;
		}

		// 增加指引次数
		public function addGuideTime(id:int):void {
			if (null == guideInfo) {
				trace("guide info not exist");
				return;
			}
			if (guideInfo.hasOwnProperty(id)) {
				guideInfo[id]=++guideInfo[id];
			} else {
				guideInfo[id]=1;
			}
		}

		/**
		 * <T>将数据序列化成字符串</T>
		 *
		 */
		public function serialize():String {
			if (!isInit) {
				throw new Error("要保存挂机配置时,挂机配置尚未被初始化");
			}
			var data:Vector.<Number>=new Vector.<Number>();
			var value:Number=0.0;
			value=isAutoRevive ? 2 : 1;
			data.push(value);
			value=isAutoEatHP ? 2 : 1;
			data.push(value);
//			value=Number((minHP / SceneCore.me.info.baseInfo.maxHp).toFixed(2));
			value=minHPProgress;
			data.push(value);
			value=isAutoEatMP ? 2 : 1;
			data.push(value);
			value=Number((minMP / SceneCore.me.info.baseInfo.maxMp).toFixed(2));
			data.push(value);
			value=isAutoBuyHP ? 2 : 1;
			data.push(value);
			if (hpItem <= 0) {
				throw new Error("Save assist info error. Auto buy item id is 0");
			}
			data.push(hpItem);
			value=isAutoBuyMP ? 2 : 1;
			data.push(value);
			data.push(mpItem);
			value=isAutoPickupEquip ? 2 : 1;
			data.push(value);
			value=isAutopickupItem ? 2 : 1;
			data.push(value);
			var length:int=skills.length
			for (var n:int=0; n < length; n++) {
				var skId:int=skills[n];
				value=(0 == skId) ? -1 : skId;
				data.push(value);
				skills[n]=value;
			}
			return data.join(",");
		}

		/**
		 * <T>读取配置数据</T>
		 *
		 */
		public function unserialize(data:Array):void {
			isInit=true;
			var index:int=0;
			isAutoRevive=(2 == data[index++]);
			isAutoEatHP=(2 == data[index++]);
			minHPProgress=data[index++];
//			minHP=data[index++] * SceneCore.me.info.baseInfo.maxHp;
			isAutoEatMP=(2 == data[index++]);
			minMP=data[index++] * SceneCore.me.info.baseInfo.maxMp;
			isAutoBuyHP=(2 == data[index++]);
			hpItem=data[index++];
			// 异常情况,修正ID为默认值
			if (hpItem <= 0) {
				hpItem=20101;
			}
			isAutoBuyMP=(2 == data[index++]);
			mpItem=data[index++];
			isAutoPickupEquip=(2 == data[index++]);
			isAutopickupItem=(2 == data[index++]);
			skills.length=0;
			var length:int=data.length;
			for (var n:int=index; n < length; n++) {
				skills.push(data[n]);
			}
			//			skills[0]=data[index++];
			//			skills[1]=data[index++];
			//			skills[2]=data[index++];
			//			skills[3]=data[index++];
		}
	}
}
