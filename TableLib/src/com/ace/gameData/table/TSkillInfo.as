package com.ace.gameData.table {
	import com.ace.utils.DebugUtil;
	import com.ace.utils.StringUtil;

	/**
	 * 技能表格
	 * @author ace
	 *
	 */
	public class TSkillInfo {

//		public var id:int; //技能id
//		public var name:String; //技能名称
		public var realId:int;
		public var profession:int; //技能职业
		public var cdTime:int; //技能CD时间
		public var needTarget:Boolean; //是否需要目标
		public var targetType:int; //目标的类型。0:不需要目标 1：自己 2：友方 3：敌方
//		public var skillEffectId:int; //技能特效id
		public var des:String; //技能描述
		public var lastTime:int; //持续次数


		public var effectId_fire:int; //技能特效id
		public var effectId_wood:int; //技能特效id
		public var effectId_water:int; //技能特效id
		public var effectId_light:int; //技能特效id
		public var effectId_dark:int; //技能特效id
		public var effectId_city:int; //技能特效id
		
		public var sound:int;
		
		/**
		 *	Index
		 *	0~99通用技能
		 *	100~299 战士技能
		 *	300~499 法师技能
		 *	500~699 术士技能
		 *	700~899 游侠技能
		 *	2000~3000 道具技能
		 */
		public var id:int;

		/**
		 *	技能名称
		 */
		public var name:String;

		/**
		 *	职业限制
		 *	0为通用
		 *	1为武士
		 *	2为法师
		 *	3为术士
		 *	4为游侠
		 */
		public var limit:int;

		/**
		 *	自动获得级别
		 *	0 不会自动获得
		 */
		public var autoLv:int;

		/**
		 *	技能图标
		 */
		public var icon:String;

		/**
		 *	技能id
		 *	含符文技能专用
		 *	技能分组，同一技能不同符文为一组
		 *	0 技能无符文
		 */
		public var skillId:int;

		/**
		 *	技能描述
		 */
		public var skillDes:String;

		/**
		 *	Effect表id
		 */
		public var effectId:String;

		/**
		 *	符文名称
		 */
		public var runeName:String;

		/**
		 *	符文id
		 *	0为无符文
		 *	1为符文1
		 *	2为符文2
		 *	3为符文3
		 */
		public var rune:int;

		/**
		 *	符文描述
		 */
		public var runeDes:String;

		/**
		 *	符文图标
		 */
		public var runeIcon:String;

		/**
		 *	冷却时间（ms）
		 */
		public var CD:int;

		/**
		 *	技能分组
		 *	公共冷却专用
		 */
		public var group:int;

		/**
		 *	公共冷却时间（ms）
		 *	只对组内技能有效
		 */
		public var publicCD:int;

		/**
		 *	技能耗蓝参数1
		 */
		public var castMana1:int;

		/**
		 *	技能耗蓝参数2
		 */
		public var castMana2:int;

		/**
		 *	技能消耗buffId
		 *	不填为无此类消耗
		 */
		public var castBuffId:int;

		/**
		 *	技能消耗道具id
		 *	不填为无此类消耗
		 */
		public var castItemId:int;

		/**
		 *	技能消耗道具数量
		 */
		public var castItemNum:int;

		/**
		 *	技能类型
		 *	伤害      1
		 *	BUFF     2
		 *	治疗      3
		 *	瞬移      4
		 */
		public var skillStyle:int;

		/**
		 *	技能类型
		 *	1为瞬发
		 *	2为引导
		 *	3为被动
		 */
		public var skillType:int;

		/**
		 *	技能分类
		 *	0自身为技能发出点
		 *	1目标为技能发出点
		 *	2鼠标为技能发出点
		 */
		public var skillClass:int;

		/**
		 *	是否需要目标
		 *	0为不需要
		 *	1为需要
		 */
		public var objective:int;

		/**
		 *	作用目标
		 *	1为自己
		 *	2为友方
		 *	3为敌方
		 */
		public var target:int;

		/**
		 *	技能施放距离（像素）
		 *	技能施放最大距离
		 */
		public var range:int;

		/**
		 *	技能作用范围类型（度）
		 *	技能群攻范围
		 *	0为单体技能
		 *	1为直线区域
		 *	扇形区域填写角度
		 */
		public var areaType:int;

		/**
		 *	技能作用范围
		 *	0 单体技能
		 *	R R为半径
		 */
		public var area:int;

		/**
		 *	技能伤害类型
		 *	1为物理伤害
		 *	2为魔法伤害
		 *	决定技能伤害计算读取的属性
		 */
		public var DamageType:int;

		/**
		 *	技能作用人数
		 *	1 1个人
		 *	N N个人
		 */
		public var skillNum:int;

		/**
		 *	公式索引
		 */
		public var formula:int;

		/**
		 *	技能攻击加成参数1（%）
		 */
		public var addition1:int;

		/**
		 *	技能攻击加成参数2（%）
		 */
		public var addition2:int;

		/**
		 *	技能附带额外最小伤害
		 */
		public var addition3:int;

		/**
		 *	技能附带额外最大伤害
		 */
		public var addition4:int;

		/**
		 *	子弹速度
		 *	像素/帧
		 */
		public var buSpeed:int;

		/**
		 *	子弹是否穿透
		 *	0 不穿透
		 *	1 穿透
		 */
		public var penetrate:int;

		/**
		 *	子弹检测半径
		 *	像素
		 */
		public var buWide:int;

		/**
		 *	技能附带buffId1
		 *	对目标作用
		 */
		public var buffId1:int;

		/**
		 *	buff1几率
		 */
		public var buffRate1:int;

		/**
		 *	技能附带buffId2
		 *	对目标作用
		 */
		public var buffId2:int;

		/**
		 *	buff2几率
		 */
		public var buffRate2:int;

		/**
		 *	技能附带buffId3
		 *	对目标作用
		 */
		public var buffId3:int;

		/**
		 *	buff3几率
		 */
		public var buffRate3:int;

		/**
		 *	技能附带buffId
		 *	只对自身作用
		 */
		public var buffOwnId1:int;

		/**
		 *	buff4几率
		 */
		public var buffOwnRate1:int;

		/**
		 *	技能附带buffId
		 *	只对自身作用
		 */
		public var buffOwnId2:int;

		/**
		 *	buff5几率
		 */
		public var buffOwnRate2:int;

		/**
		 *	是否自动释放
		 *	0 不自动
		 *	1 自动
		 */
		public var auto:int;


		public function TSkillInfo(data:XML=null) {
			if (data == null)
				return;

			this.id=data.@id;
			this.realId=this.id;
			this.name=data.@name;
			this.limit=data.@limit;
			this.autoLv=data.@autoLv;
			this.icon=data.@icon;
			this.skillId=data.@skillId;
			this.skillDes=data.@skillDes;
			this.effectId=data.@effectId;
			this.runeName=data.@runeName;
			this.rune=data.@rune;
			this.runeDes=data.@runeDes;
			this.runeIcon=data.@runeIcon;
			this.CD=data.@CD;
			this.group=data.@group;
			this.publicCD=data.@publicCD;
			this.castMana1=data.@castMana1;
			this.castMana2=data.@castMana2;
			this.castBuffId=data.@castBuffId;
			this.castItemId=data.@castItemId;
			this.castItemNum=data.@castItemNum;
			this.skillStyle=data.@skillStyle;
			this.skillType=data.@skillType;
			this.skillClass=data.@skillClass;
			this.objective=data.@objective;
			this.target=data.@target;
			this.range=data.@range;
			this.areaType=data.@areaType;
			this.area=data.@area;
			this.DamageType=data.@DamageType;
			this.skillNum=data.@skillNum;
			this.formula=data.@formula;
			this.addition1=data.@addition1;
			this.addition2=data.@addition2;
			this.addition3=data.@addition3;
			this.addition4=data.@addtion4;
			this.buSpeed=data.@buSpeed;
			this.penetrate=data.@penetrate;
			this.buWide=data.@buWide;
			this.buffId1=data.@buffId1;
			this.buffRate1=data.@buffRate1;
			this.buffId2=data.@buffId2;
			this.buffRate2=data.@buffRate2;
			this.buffId3=data.@buffId3;
			this.buffRate3=data.@buffRate3;
			this.buffOwnId1=data.@buffOwnId1;
			this.buffOwnRate1=data.@buffOwnRate1;
			this.buffOwnId2=data.@buffOwnId2;
			this.buffOwnRate2=data.@buffOwnRate2;
			this.auto=data.@auto;

			/****************************************************************************************/
			this.effectId_fire=data.@effectId_fire;
			this.effectId_wood=data.@effectId_wood;
			this.effectId_water=data.@effectId_water;
			this.effectId_light=data.@effectId_light;
			this.effectId_dark=data.@effectId_dark;
			this.effectId_city=data.@effectId_city;
			this.sound=data.@sound;

//			this.id=data.@id;
//			this.name=data.@name;
			this.profession=data.@limit;
			this.cdTime=data.@CD;
			this.needTarget=StringUtil.intToBoolean(data.@objective);
			this.targetType=data.@target;
//			this.skillEffectId=String(data.@effectId).indexOf("|") == -1 ? data.@effectId : String(data.@effectId).split("|")[0];
			this.des=data.@skillDes;
			this.lastTime=data.@keepNum;

		/****************************************************************************************/

		}

		//根据元素获取
		public function getEffectId(ys:String):int {
			if (!this.hasOwnProperty(ys)) {
				DebugUtil.throwError("没有该属性");
//				ys="effectId";
			}
			return this[ys];
		}

		/**技能是否需要查找合适的位置*/
		public function get needFindPt():Boolean {
			if (this.skillId == 5 || this.skillId == 25 || this.skillId == 12)
				return true;
			return false;
		}

		public function get needMP():int {
			return this.castMana1;
		}

		//施法距离，像素为单位
		public function get distance():int {
			return this.range;
		}

		//施法角度
		public function get angle():int {
			return this.areaType;
		}

		//施法半径，像素为单位
		public function get radius():int {
			return this.area;
		}

		//影响的玩家数量
		public function get affectNum():int {
			return this.skillNum;
		}

		public function get follow():int {
			return this.skillClass;
		}

		/**
		 * <T>获得蓝量消耗</T>
		 *
		 * @param level 等级
		 * @return      消耗
		 *
		 */
		public function getMpCost(level:int):int {
			return /*(level*level**/ castMana1 /* + level*castMana2)*/;
		}
	}
}
