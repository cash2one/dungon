package com.ace.gameData.table {

	public class TEquipInfo {

		/**
		 *	Index
		 */
		public var id:int;

		/**
		 *	装备等级
		 */
		public var level:int;

		/**
		 *	装备名称
		 */
		public var name:String;

		/**
		 *	装备描述
		 */
		public var des:String;

		/**
		 *	装备来源
		 */
		public var desSource:String;

		/**
		 *	装备部位
		 *	1-11
		 */
		public var position:int;

		/**
		 *	声音
		 *	索引声音表
		 */
		public var sound:String;

		/**
		 *	装备图标
		 */
		public var icon:String;

		/**
		 *	掉落装备图标
		 */
		public var dropIcon:String;

		/**
		 *	装备模型
		 *	男
		 */
		public var avatar:String;

		/**
		 *	道具类型
		 *	装备为固定值1
		 */
		public var classid:int;

		/**
		 *	道具分类型
		 */
		public var subclassid:int;

		/**
		 *	职业限制
		 *	0为通用
		 *	1为战士
		 *	2为法师
		 *	3为术士
		 *	4为游侠
		 */
		public var limit:int;

		/**
		 *	装备品质
		 *	0白
		 *	1绿
		 *	2蓝
		 *	3紫
		 *	4橙
		 */
		public var quality:int;

		/**
		 *	特效
		 */
		public var effect:String;

		/**
		 *	性别限制
		 *	0不限制
		 *	1男
		 *	2女
		 */
		public var sex:int;

		/**
		 *	是否唯一
		 *	0不唯一
		 *	1唯一
		 */
		public var canunique:int;

		/**
		 *	强化最高星级
		 */
		public var maxlevel:int;

		/**
		 *	是否绑定
		 *	0不绑定
		 *	1拾取绑定
		 *	2装备绑定
		 */
		public var bind:int;

		/**
		 *	能否强化
		 *	0不能
		 *	1能
		 */
		public var canstreng:int;

		/**
		 *	能否转移
		 *	0不能
		 *	1能
		 */
		public var candistract:int;

		/**
		 *	转移消耗
		 */
		public var dc:String;

		/**
		 *	重铸花费游戏币
		 */
		public var rebudMoney:int;

		/**
		 *	重铸报价花费元宝
		 */
		public var rebudIB:int;

		/**
		 *	最大叠加数量
		 */
		public var maxgroup:int;

		/**
		 *	出售价格
		 */
		public var price:int;

		/**
		 *	最小物理攻击
		 */
		public var mina:int;

		/**
		 *	最大物理攻击
		 */
		public var maxa:int;

		/**
		 *	最小物理防御
		 */
		public var mind:int;

		/**
		 *	最大物理防御
		 */
		public var maxd:int;

		/**
		 *	最小法术攻击
		 */
		public var minm:int;

		/**
		 *	最大法术攻击
		 */
		public var maxm:int;

		/**
		 *	最小法术防御
		 */
		public var minmd:int;

		/**
		 *	最大法术防御
		 */
		public var maxmd:int;

		/**
		 *	最小生命
		 */
		public var minhp:int;

		/**
		 *	最大生命
		 */
		public var maxhp:int;

		/**
		 *	最小法力
		 */
		public var minmana:int;

		/**
		 *	最大法力
		 */
		public var maxmana:int;

		/**
		 *	附加属性随机个数
		 */
		public var adda:int;

		/**
		 *	暴击
		 */
		public var crit:int;

		/**
		 *	韧性
		 */
		public var tenacity:int;

		/**
		 *	命中
		 */
		public var hit:int;

		/**
		 *	闪避
		 */
		public var dodge:int;

		/**
		 *	必杀
		 */
		public var slay:int;

		/**
		 *	守护
		 */
		public var guard:int;

		/**
		 *	精力
		 *	（翅膀装备专用）
		 */
		public var Sp_max:int;

		/**
		 *	大特效
		 */
		public var effect1:String;

		/**
		 */
		public var limitTime:int;

		/**
		 *	物品是否广播
		 *	0不需要
		 *	1需要
		 */
		public var transmit:int;

		/**
		 *	分解产生轮回值
		 */
		public var Dec_score:int;

		/**
		 *	萃取花费金钱
		 */
		public var Ext_speed:int;

		/**
		 *	萃取石花费数
		 */
		public var Ext_INum:int;

		/**
		 *	升级后装备
		 */
		public var lvup_id:int;

		/**
		 *	升级花费金钱
		 */
		public var lvup_money:int;

		/**
		 *	升级花费道具数量
		 */
		public var lvup_itemNum:int;

		/**
		 *	满镶嵌物理攻击
		 */
		public var att_X:int;

		/**
		 *	满镶嵌物理防御
		 */
		public var attd_X:int;

		/**
		 *	满镶嵌法术攻击
		 */
		public var matt_X:int;

		/**
		 *	满镶嵌法术防御
		 */
		public var mattd_X:int;

		/**
		 *	满镶嵌生命
		 */
		public var hp_X:int;

		/**
		 *	满镶嵌法力
		 */
		public var mana_X:int;

		/**
		 *	满镶嵌暴击
		 */
		public var crit_X:int;

		/**
		 *	满镶嵌韧性
		 */
		public var tenacity_X:int;

		/**
		 *	满镶嵌命中
		 */
		public var hit_X:int;

		/**
		 *	满镶嵌闪避
		 */
		public var dodge_X:int;

		/**
		 *	满镶嵌必杀
		 */
		public var slay_X:int;

		/**
		 *	满镶嵌守护
		 */
		public var guard_X:int;

		/**
		 *	宝石合成费用
		 */
		public var StoneUp_speed:int;
		
		/**
		 * 合成所需宝石
		 */		
		public var StoneUp_Need:int;

		
		
		public function TEquipInfo(data:XML=null) {
			if (data == null)
				return;

			this.id=data.@id;
			this.level=data.@level;
			this.name=data.@name;
			this.des=data.@des;
			this.desSource=data.@desSource;
			this.position=data.@position;
			this.sound=data.@sound;
			this.icon=data.@icon;
			this.dropIcon=data.@dropIcon;
			this.avatar=data.@avatar;
			this.classid=data.@classid;
			this.subclassid=data.@subclassid;
			this.limit=data.@limit;
			this.quality=data.@quality;
			this.effect=data.@effect;
			this.sex=data.@sex;
			this.canunique=data.@canunique;
			this.maxlevel=data.@maxlevel;
			this.bind=data.@bind;
			this.canstreng=data.@canstreng;
			this.candistract=data.@candistract;
			this.dc=data.@dc;
			this.rebudMoney=data.@rebudMoney;
			this.rebudIB=data.@rebudIB;
			this.maxgroup=data.@maxgroup;
			this.price=data.@price;
			this.mina=data.@mina;
			this.maxa=data.@maxa;
			this.mind=data.@mind;
			this.maxd=data.@maxd;
			this.minm=data.@minm;
			this.maxm=data.@maxm;
			this.minmd=data.@minmd;
			this.maxmd=data.@maxmd;
			this.minhp=data.@minhp;
			this.maxhp=data.@maxhp;
			this.minmana=data.@minmana;
			this.maxmana=data.@maxmana;
			this.adda=data.@adda;
			this.crit=data.@crit;
			this.tenacity=data.@tenacity;
			this.hit=data.@hit;
			this.dodge=data.@dodge;
			this.slay=data.@slay;
			this.guard=data.@guard;
			this.Sp_max=data.@Sp_max;
			this.effect1=data.@effect1;
			this.limitTime=data.@limitTime;
			this.transmit=data.@transmit;
			this.Dec_score=data.@Dec_score;
			this.Ext_speed=data.@Ext_speed;
			this.Ext_INum=data.@Ext_INum;
			this.lvup_id=data.@lvup_id;
			this.lvup_money=data.@lvup_money;
			this.lvup_itemNum=data.@lvup_itemNum;
			this.att_X=data.@att_X;
			this.attd_X=data.@attd_X;
			this.matt_X=data.@matt_X;
			this.mattd_X=data.@mattd_X;
			this.hp_X=data.@hp_X;
			this.mana_X=data.@mana_X;
			this.crit_X=data.@crit_X;
			this.tenacity_X=data.@tenacity_X;
			this.hit_X=data.@hit_X;
			this.dodge_X=data.@dodge_X;
			this.slay_X=data.@slay_X;
			this.guard_X=data.@guard_X;
			this.StoneUp_speed=data.@StoneUp_speed;
			this.StoneUp_Need=data.@StoneUp_Need;
		}


		public function clone():TEquipInfo {
			var t:TEquipInfo=new TEquipInfo();

			t.id=this.id;
			t.level=this.level;
			t.name=this.name;
			t.des=this.des;
			t.desSource=this.desSource;
			t.position=this.position;
			t.sound=this.sound;
			t.icon=this.icon;
			t.dropIcon=this.dropIcon;
			t.avatar=this.avatar;
			t.classid=this.classid;
			t.subclassid=this.subclassid;
			t.limit=this.limit;
			t.quality=this.quality;
			t.effect=this.effect;
			t.sex=this.sex;
			t.canunique=this.canunique;
			t.maxlevel=this.maxlevel;
			t.bind=this.bind;
			t.canstreng=this.canstreng;
			t.candistract=this.candistract;
			t.dc=this.dc;
			t.rebudMoney=this.rebudMoney;
			t.rebudIB=this.rebudIB;
			t.maxgroup=this.maxgroup;
			t.price=this.price;
			t.mina=this.mina;
			t.maxa=this.maxa;
			t.mind=this.mind;
			t.maxd=this.maxd;
			t.minm=this.minm;
			t.maxm=this.maxm;
			t.minmd=this.minmd;
			t.maxmd=this.maxmd;
			t.minhp=this.minhp;
			t.maxhp=this.maxhp;
			t.minmana=this.minmana;
			t.maxmana=this.maxmana;
			t.adda=this.adda;
			t.crit=this.crit;
			t.tenacity=this.tenacity;
			t.hit=this.hit;
			t.dodge=this.dodge;
			t.slay=this.slay;
			t.guard=this.guard;
			t.Sp_max=this.Sp_max;
			t.effect1=this.effect1;
			t.limitTime=this.limitTime;
			t.transmit=this.transmit;
			t.Dec_score=this.Dec_score;
			t.Ext_speed=this.Ext_speed;
			t.Ext_INum=this.Ext_INum;
			t.lvup_id=this.lvup_id;
			t.lvup_money=this.lvup_money;
			t.lvup_itemNum=this.lvup_itemNum;
			t.att_X=this.att_X;
			t.attd_X=this.attd_X;
			t.matt_X=this.matt_X;
			t.mattd_X=this.mattd_X;
			t.hp_X=this.hp_X;
			t.mana_X=this.mana_X;
			t.crit_X=this.crit_X;
			t.tenacity_X=this.tenacity_X;
			t.hit_X=this.hit_X;
			t.dodge_X=this.dodge_X;
			t.slay_X=this.slay_X;
			t.guard_X=this.guard_X;
			t.StoneUp_speed=this.StoneUp_speed;
			t.StoneUp_Need=this.StoneUp_Need;

			return t;
		}

	}
}
