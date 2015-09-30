package com.ace.enum {

	public class EventEnum {

		//特效
		static public const EFFECT_FLOWER:String="flowerEffect";
		//设置完毕
		static public const FLASH_SETTING_OVER:String="settingOver";

		//场景
		static public const SCENE_TRANS:String="sceneTrans"; //场景传送
		static public const SCENE_LOADED:String="sceneLoaded"; //场景加载完毕

		//场景动画
		static public const SHOW_CUTSCENE:String="showCutscene";
		static public const END_CUTSCENE:String="endCutscene";

		//人物
		static public const LIVING_xxxxxx:String="xxxxxxxxxx";
		static public const LIVING_STAND_15S:String="stand15S";
		static public const LIVING_STOP_COLLECT:String="stopCollect";
		static public const LIVING_STOP_ATTACK:String="stopAttack";
		static public const LIVING_BE_HURT:String="beHurt";
		static public const ON_HURT_WARNING:String="onHurtWarning";//参数【living:LivingModel】
		static public const CANCEL_HURT_WARNING:String="cancelHurtWarning";
		static public const SELECT_HURT_WARNING:String="selectHurtWarning";//参数【角色名称：living.info.name】
		
		//佣兵
		static public const PET_ADD:String="addPet";
		static public const PET_DEL:String="delPet";
		static public const PET_UPDATE_HP:String="updateHp";

		//设置
		static public const SETTING_HIDE_ALL:String="hideAll";
		static public const SETTING_HIDE_OTHER:String="hideOther";
		static public const SETTING_HIDE_MONSTER:String="hideMonster";
		static public const SETTING_STOP_AUTO:String="stopAutoMonster";
		static public const SETTING_HIDE_SCENE_EFFECT:String="hideSceneEffect";
		static public const SETTING_UPDATE_LOCK_TARGET:String="updateLockTarget";
		
		//锁定
		static public const LOCK_TARGET_IN:String="lockTargetIn";
		static public const LOCK_TARGET_OUT:String="lockTargetOut";
		
		//自动挂机
		static public const SETTING_AUTO_MONSTER:String="autoMonster";

		// 引导
		static public const GUIDE_PK_ATT:String="guidePkAtt";

		
		// 小地图退出按钮点击事件
		static public const COPY_QUIT:String="copyQuit";

		// 首次进入窗口点击
		static public const FIRST_LOGIN_CLICK:String="firstLogin";

		// 玩家BUFF状态改变
		static public const BUFF_CHANGE:String="buffChange";

		// 界面缓动完成事件
		static public const UI_MOVE_OVER:String="uiMoveOver";

		// 玩家头像锁定按钮点击
		static public const LOCK_OTHER_HEAD:String="lockOtherHead";
		
		// 低帧频
		static public const LOW_FRAME:String="lowFrame";
	}
}
