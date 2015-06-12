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
		public var number:int;

		/**
		 *	是否能够批量使用
		 *	0 不能
		 *	1 可以
		 */
		public var lotuse:String;

		/**
		 *	道具开启等级
		 */
		public var level:int;

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
		 *	道具图标
		 */
		public var icon:String;

		/**
		 *	掉落装备图标
		 */
		public var dropIcon:String;

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
		public var limit:int;

		/**
		 *	性别限制
		 *	0不限制
		 *	1男
		 *	2女
		 */
		public var sex:int;

		/**
		 *	vip等级限制
		 */
		public var viplevel:int;

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
		public var bind:int;

		/**
		 *	是否唯一
		 *	0不唯一
		 *	1唯一
		 */
		public var canunique:int;

		/**
		 *	最大叠加数量
		 */
		public var maxgroup:int;

		/**
		 *	使用引导时间(s)
		 */
		public var usetime:int;

		/**
		 *	使用道具公共CD
		 */
		public var cooltime:int;

		/**
		 *	物品存在时间（s）
		 *	0为永久道具
		 */
		public var duration:int;

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
		public var disappear:int;

		/**
		 *	对应Buff id
		 */
		public var buffId:int;

		/**
		 *	物品是否广播
		 *	0不需要
		 *	1需要
		 */
		public var transmit:int;

		/**
		 *	广播内容
		 */
		public var transmitdes:String;

		/**
		 *	限制地图id
		 *	0为不限制
		 */
		public var map:int;

		/**
		 *	限制对npc或者怪物使用
		 *	-1 友方
		 *	-2 敌方
		 */
		public var npc:int;

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
		 */
		public var useType:int;

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
		public var price:int;

		/**
		 *	独立功能数值
		 */
		public var value:int;

		/**
		 *	道具特效（大）
		 */
		public var effect1:String;

		public var pay:int=0;
		
		/**
		 */
		public var limitTime:int;

		/**
		 *	道具限定使用次数
		 *	
		 *	不填则表示可以无限次使用
		 */
		public var Item_degree:int;
		
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
			this.dropIcon=data.@dropIcon;
			this.effect=data.@effect;
			this.limit=data.@limit;
			this.sex=data.@sex;
			this.viplevel=data.@viplevel;
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
			this.pay=data.@pay;
			this.limitTime=data.@limitTime;
			this.Item_degree=data.@Item_degree;
		}



	}
}
