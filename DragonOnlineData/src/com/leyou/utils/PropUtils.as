package com.leyou.utils {


	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;

	/**
	 * <pre>
	 *1	生命上限
2	法力上限
3	精力上限
4	物理攻击
5	物理防御
6	法术攻击
7	法术防御
8	暴击
9	韧性
10	命中
11	闪避
12	必杀
13	守护
14	技能附加额外最小伤害
15	技能附加额外最大伤害
16	pk值
17	祝福
18	幸运
19	财运
20	经验
21	移动速度
22	生命
23	法力
24	精力
25	职业
26	元素
27	经验上限
28	等级
29	魂力
30	最大魂力
31	行会贡献
32	金币
33	绑定钻石
34	行会公告
35	行会宣言
36	会长
37	副会长
38	长老
39	行会成员
40	钻石
41	绝对攻击
42	绝对防御


	 * @author Administrator
	 *</pre>
	 */
	public class PropUtils {

		public static var propArr:Array=["生命", "法力", "精力上限", "物攻", "物防", "法攻", "法防", "暴击", "韧性", "命中", "闪避", "必杀", "守护", "技能附加额外最小伤害", "技能附加额外最大伤害", "pk值", "祝福", "幸运", "财运", "exp", "移动速度", "hp", "mp", "精力", "职业", "元素", "经验上限", "等级", "魂力", "最大魂力"];

		propArr[30]="行会贡献";
		propArr[31]="金币";
		propArr[32]="绑定钻石";
		propArr[33]="行会公告";
		propArr[34]="行会宣言";
		propArr[35]="会长";
		propArr[36]="副会长";
		propArr[37]="长老";
		propArr[38]="行会成员";
		propArr[39]="钻石";
		propArr[40]="绝对攻击";
		propArr[41]="绝对防御";

		/**
		 *长字
		 */
		public static var prop2Arr:Array=["生命上限", "法力上限", "精力上限", "物理攻击", "物理防御", "法术攻击", "法术防御", "暴击等级", "韧性等级", "命中等级", "闪避等级", "必杀等级", "守护等级", "技能附加额外最小伤害", "技能附加额外最大伤害", "pk值", "祝福", "幸运", "财运", "exp", "移动速度", "hp", "mp", "精力", "职业", "元素", "经验上限", "等级", "魂力", "最大魂力"];

		prop2Arr[30]="行会贡献";
		prop2Arr[31]="金币";
		prop2Arr[32]="绑定钻石";
		prop2Arr[33]="行会公告";
		prop2Arr[34]="行会宣言";
		prop2Arr[35]="会长";
		prop2Arr[36]="副会长";
		prop2Arr[37]="长老";
		prop2Arr[38]="行会成员";
		prop2Arr[39]="钻石";
		prop2Arr[40]="绝对攻击";
		prop2Arr[41]="绝对防御";

		/**
		 *装备表基础字段
		 */
		public static var EquipTableBaseColumn:Array=[["mina", "maxa"], ["mind", "maxd"], ["minm", "maxm"], ["minmd", "maxmd"], ["minhp", "maxhp"], ["minmana", "maxmana"]];

		/**
		 *装备表基础字段 index
		 */
		public static var EquipTableBaseColumnIndex:Array=[3, 4, 5, 6, 0, 1];

		/**
		 *
		 *生命值
		hp:int;
		 *魔法值
		mp:int;
		 *物理攻击
		phAtt:int;
		 *物理防禦
		phDef:int;
		 *魔法攻擊
		magicAtt:int;
		 *魔法防禦
		magicDef:int;
		 * adda:String;

		 *	暴击
		crit:String;

		 *	韧性
		tenacity:String;

		 *	命中
		hit:String;

		 *	闪避
		dodge:String;

		 *	必杀
		slay:String;

		 *	守护
		guard:String;

		 *	精力
		 *	（翅膀装备专用）
		Energy:String;
		 *装备表基础字段
		 */
		public static var EquipTableAddColumn:Array=["hp", "mp", "", "phAtt", "phDef", "magicAtt", "magicDef", "crit", "tenacity", "hit", "dodge", "slay", "guard", "Energy"];

		/**
		 *元素属性
		 */
		public static var elementArr:Array=["金", "木", "水", "火", "土"];
		public static var elementKeyArr:Array=[];

		elementKeyArr[0]=1;
		elementKeyArr[1]=4;
		elementKeyArr[2]=3;
		elementKeyArr[3]=0;
		elementKeyArr[4]=2;

		/**
		 * 宝石
		 */
		public static var GemEquipTableColumn:Array=["maxa", "maxd", "maxm", "maxmd", "maxhp", "maxmana", "crit", "tenacity", "hit", "dodge", "slay", "guard"];

		/**
		 * 8	暴击
9	韧性
10	命中
11	闪避
12	必杀
13	守护
*/
		public static var GemEquipTableColumnIndex:Array=[3, 4, 5, 6, 0, 1, 7, 8, 9, 10, 11, 12];

		public function PropUtils() {



		}

		public static function setPropsArr(xml:XML):void {
			propArr[int(xml.@id) - 1]=xml.@des_s + "";
			prop2Arr[int(xml.@id) - 1]=xml.@des + "";
		}

		/**
		 * 获取字符串 
		 * @param id
		 * @return 
		 * 
		 */		
		public static function getStringById(id:int):String {
			return prop2Arr[id-1];
		}
		
		/**
		 * 简化 
		 * @param id
		 * @return 
		 * 
		 */		
		public static function getStringEasyById(id:int):String {
			return propArr[id-1];
		}

		/**
		 *
		 * @param str
		 * @return
		 *
		 */
		public static function getIndexByStr(str:String):int {

			var i:int=propArr.indexOf(str);
			if (i > -1)
				return i;
			else {

				if (str.indexOf("HP上限") > -1 || str.indexOf("生命上限") > -1)
					return 0;

				if (str.indexOf("MP上限") > -1 || str.indexOf("法力上限") > -1)
					return 1;

				if (str.indexOf("物理攻击") > -1)
					return 3;

				if (str.indexOf("物理防御") > -1)
					return 4;

				if (str.indexOf("法术攻击") > -1)
					return 5;

				if (str.indexOf("法术防御") > -1)
					return 6;

				//"暴击", "韧性", "命中", "闪避", "必杀", "守护"
				if (str.indexOf("暴击等级") > -1)
					return 7;

				if (str.indexOf("韧性等级") > -1)
					return 8;

				if (str.indexOf("命中等级") > -1)
					return 9;

				if (str.indexOf("闪避等级") > -1)
					return 10;

				if (str.indexOf("必杀等级") > -1)
					return 11;

				if (str.indexOf("守护等级") > -1)
					return 12;

				if (str.indexOf("精力上限") > -1)
					return 2;

			}

			return -1;
		}

		/**
		 *<pre>
		 mina

		 maxa

		 mind

		 maxd

		 minm

		 maxm

		 minmd

		 maxmd

		 minhp

		 maxhp

		 minmana

		 maxmana
		 * @param i
		 * @return
		 *</pre>
		 */
		public static function getEquipColumnByIndex(i:int):Array {

			switch (i) {
				case 3:
					return EquipTableBaseColumn[0];
				case 4:
					return EquipTableBaseColumn[1];
				case 5:
					return EquipTableBaseColumn[2];
				case 6:
					return EquipTableBaseColumn[3];
				case 0:
					return EquipTableBaseColumn[4];
				case 1:
					return EquipTableBaseColumn[5];
			}

			return [];
		}


		/**
		 *
		 * 	/**
		 *	附加属性随机个数

		adda:String;


		 *	暴击

		crit:String;


		 *	韧性

		tenacity:String;

		 *	命中
		hit:String;

		 *	闪避
		dodge:String;

		 *	必杀
		slay:String;

		 *	守护
		guard:String;

		 *	精力
		 *	（翅膀装备专用）
		Energy:String;

		 * @param i
		 * @return
		 *
		 */
		public static function getEquipColumnAddByIndex(i:int):Array {

			switch (i) {
				case 3:
					return EquipTableBaseColumn[0];
				case 4:
					return EquipTableBaseColumn[1];
				case 5:
					return EquipTableBaseColumn[2];
				case 6:
					return EquipTableBaseColumn[3];
				case 0:
					return EquipTableBaseColumn[4];
				case 1:
					return EquipTableBaseColumn[5];
			}

			return [];
		}

		/**
		 *	物攻*1+法攻*1+物防*0.5+法防*0.5+HP*1+MP*100+闪避*0.3+命中*0.3+暴击*0.3+韧性*0.3+必杀*0.6+守护*0.3
		 * @param e
		 */
		public static function getFighting(e:TEquipInfo):Number {
			return (getBaseFighting(e) + getFightingHpAndMp(e) + getExtendFighting(e));
		}

		/**
		 *  白装属性
		 * @param e
		 * @return
		 */
		public static function getWhiteFighting(e:TEquipInfo):Number {
			return Math.floor(getBaseFighting(e) + getFightingHpAndMp(e));
		}

		/**
		 * 基础属性    物攻*1+法攻*1+物防*0.5+法防*0.5
		 * @param e
		 * @return
		 *
		 */
		public static function getBaseFighting(e:TEquipInfo):Number {
			return Number(e.mina) * TableManager.getInstance().getZdlElement(4).rate + Number(e.minm) * TableManager.getInstance().getZdlElement(6).rate + Number(e.mind) * TableManager.getInstance().getZdlElement(5).rate + Number(e.minmd) * TableManager.getInstance().getZdlElement(7).rate;
		}

		/**
		 *扩展                  闪避*0.3+命中*0.3+暴击*0.3+韧性*0.3+必杀*0.6+守护*0.3
		 * @param e
		 * @return
		 *
		 */
		private static function getExtendFighting(e:TEquipInfo):Number {
			return Number(e.dodge) * TableManager.getInstance().getZdlElement(11).rate + Number(e.hit) * TableManager.getInstance().getZdlElement(10).rate + Number(e.crit) * TableManager.getInstance().getZdlElement(8).rate + Number(e.tenacity) * TableManager.getInstance().getZdlElement(9).rate + Number(e.slay) * TableManager.getInstance().getZdlElement(12).rate + Number(e.guard) * TableManager.getInstance().getZdlElement(13).rate;
		}

		/**
		 *-------------HP*0.5+MP*1
		 * @param e
		 * @return
		 *
		 */
		public static function getFightingHpAndMp(e:TEquipInfo):Number {
			return Number(e.minhp) * TableManager.getInstance().getZdlElement(1).rate + Number(e.minmana) * TableManager.getInstance().getZdlElement(2).rate;
		}

	}
}
