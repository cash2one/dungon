package com.ace.gameData.table {

	public class TItemInfo {

		/**
		 *	Index
		 */
		public var id:int;

		/**
		 *	道具名称
		 */
		public var name:String;

		/**
		 *	道具类型
		 *	（对应不同功能）
		 *	1 装备
		 *	2 药剂
		 *	3 道具
		 *	4 任务
		 *	6.虚拟道具
		 */
		public var classid:int;

		/**
		 *	道具分类型
		 */
		public var subclassid:int;

		/**
		 *	道具使用次数
		 */
		public var number:String;

		/**
		 *	是否能够批量使用
		 *	0 不能
		 *	1 可以
		 */
		public var lotuse:String;

		/**
		 *	道具开启等级
		 */
		public var level:String;

		/**
		 *	道具
		 *	0白
		 *	1绿
		 *	2蓝
		 *	3紫
		 *	4橙
		 */
		public var quality:int;

		/**
		 *	道具图示
		 */
		public var icon:String;

		/**
		 *	道具动画
		 */
		public var effect:String;

		/**
		 *	职业限制
		 *	0不限制
		 *	1武士
		 *	2法师
		 *	3道士
		 *	4游侠
		 */
		public var limit:String;

		/**
		 *	性别限制
		 *	0不限制
		 *	1男
		 *	2女
		 */
		public var sex:String;

		/**
		 *	vip等级限制
		 */
		public var viplevel:String;

		/**
		 *	使用花费钻石
		 */
		public var pay:String;

		/**
		 *	道具描述
		 */
		public var des:String;

		/**
		 *	道具来源
		 */
		public var desSource:String;

		/**
		 *	是否绑定
		 *	0不绑定
		 *	1拾取绑定
		 */
		public var bind:String;

		/**
		 *	是否唯一
		 *	0不唯一
		 *	1唯一
		 */
		public var canunique:String;

		/**
		 *	最大迭加数量
		 */
		public var maxgroup:int;

		/**
		 *	使用引导时间(s)
		 */
		public var usetime:String;

		/**
		 *	使用道具公共CD
		 */
		public var cooltime:String;

		/**
		 *	物品存在时间（s）
		 *	0为永久道具
		 */
		public var duration:String;

		/**
		 *	物品到期时间
		 *	例如2013-3-14
		 */
		public var expires:String;

		/**
		 *	有效期过后是否消失
		 *	0不消失
		 *	1消失
		 */
		public var disappear:String;

		/**
		 *	对应Buff id
		 */
		public var buffId:String;

		/**
		 *	物品是否广播
		 *	0不需要
		 *	1需要
		 */
		public var transmit:String;

		/**
		 *	广播内容
		 */
		public var transmitdes:String;

		/**
		 *	限制地图id
		 *	0为不限制
		 */
		public var map:String;

		/**
		 *	限制对npc或者怪物使用
		 *	-1 友方
		 *	-2 敌方
		 */
		public var npc:String;

		/**
		 *	使用道具类型
		 *	1.HP(万分比）
		 *	2.MP
		 *	3.精力
		 *	4.金币
		 *	5.绑定钻石
		 *	6.魂力
		 *	7.经验
		 *	8.等级
		 *	9.传送
		 *	10.宝箱
		 *	11.钻石
		 *	12.当前级别百分比经验
		 *	13 PK值减少
		 *	14 龙魂
		 *	15 贡献
		 *	20 替身道具
		 *	21 定位道具
		 *	22 召集道具
		 *	23 永久增加属性道具
		 *	24 增加荣誉
		 *	25 送VIP
		 *	26 获得翅膀
		 *	27 抽奖
		 *	28 美满都
		 */
		public var useType:String;

		/**
		 *	使用道具获得数量
		 */
		public var useValue:int;

		/**
		 *	使用音效
		 */
		public var sound:String;

		/**
		 *	出售价格
		 */
		public var price:String;

		/**
		 *	独立功能数值
		 *	属性ID
		 *	1 生命上限
		 *	2 法力上限
		 *	4 物理攻击
		 *	5 物理防御
		 *	6 法术攻击
		 *	7 法术防御
		 *	8 暴击
		 *	9 韧性
		 *	10 命中
		 *	11 闪避
		 *	12 必杀
		 *	13 守护
		 */
		public var value:int;

		/**
		 *	道具特效（大）
		 */
		public var effect1:String;

		/**
		 *	掉落道具图示
		 */
		public var dropIcon:String;

		/**
		 *
		 */
		public var limitTime:int;

		/**
		 *	道具限定使用次数
		 *
		 *	不填则表示可以无限次使用
		 */
		public var Item_degree:int;

		/**
		 *	自动使用
		 */
		public var autoUse:String;

		/**
		 *	索引模型表
		 */
		public var pnfId:String;

		/**
		 *	快捷使用
		 *	1 快捷使用
		 */
		public var quickUse:String;



		public function TItemInfo(data:XML=null) {
			if (data == null)
				return;

			this.id=data.@id;
			this.name=data.@name;
			this.classid=data.@classid;
			this.subclassid=data.@subclassid;
			this.number=data.@number;
			this.lotuse=data.@lotuse;
			this.level=data.@level;
			this.quality=data.@quality;
			this.icon=data.@icon;
			this.effect=data.@effect;
			this.limit=data.@limit;
			this.sex=data.@sex;
			this.viplevel=data.@viplevel;
			this.pay=data.@pay;
			this.des=data.@des;
			this.desSource=data.@desSource;
			this.bind=data.@bind;
			this.canunique=data.@canunique;
			this.maxgroup=data.@maxgroup;
			this.usetime=data.@usetime;
			this.cooltime=data.@cooltime;
			this.duration=data.@duration;
			this.expires=data.@expires;
			this.disappear=data.@disappear;
			this.buffId=data.@buffId;
			this.transmit=data.@transmit;
			this.transmitdes=data.@transmitdes;
			this.map=data.@map;
			this.npc=data.@npc;
			this.useType=data.@useType;
			this.useValue=data.@useValue;
			this.sound=data.@sound;
			this.price=data.@price;
			this.value=data.@value;
			this.effect1=data.@effect1;
			this.dropIcon=data.@dropIcon;
			this.limitTime=data.@limitTime;
			this.Item_degree=data.@Item_degree;
			this.autoUse=data.@autoUse;
			this.pnfId=data.@pnfId;
			this.quickUse=data.@quickUse;


		}



	}
}
