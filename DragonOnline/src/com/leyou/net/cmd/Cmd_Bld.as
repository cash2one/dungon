package com.leyou.net.cmd {

	import com.ace.manager.UIManager;
	import com.leyou.net.NetGate;

	public class Cmd_Bld {

		private static var isxl:Boolean=false;

		public function Cmd_Bld() {
		}

		public static function sm_bld(o:Object):void {

			if (o == null)
				return;

			if (!o.hasOwnProperty("mk"))
				return;

			Cmd_Bld["sm_bld_" + o.mk](o);
		}

		/**
		 *1 打开血脉面板: 		bld|O
	ls: 最后开启点的编号 "ls":numb				numb = layer * 100 + point
	wt: 洗练总属性数组  "wt":[{"属性编号":val,"属性编号":val,"属性编号":val}{...}{...}...]
	返回 	1. ls:最后开启点的编号  bldo|numb 2. wt:十层/三条洗练属性的类型和值
	例子：	bldo| {	   "mk":"O",
			 "ls":502,
				  "pa":val,		      //  bloodline_p_attack
				  "pd":val,		      //  bloodline_p_defense
				  "ma":val,		      //  bloodline_m_attack
				 "md":val,		      //  bloodline_m_defense
				  "hp":val,		      //  bloodline_hp_max
				  "mp":val,		      //  bloodline_mp_max
				  "cr":val,		      //  bloodline_crit
				  "te":val,		      //  bloodline_tenacity
				  "ht":val,		      //  bloodline_hit
				  "dg":val,		      //  bloodline_dodge
				  "sl":val,		      //  bloodline_slay
				  "gu":val,		      //  bloodline_guard
			"wt":[{"14":126,"12":142,"11":211},{"13":244,"16":373,"11":420},[],[],[],[],[],[],[],[]]
		}

		 * @param o
		 *
		 */
		public static function sm_bld_O(o:Object):void {
			if(o==null || !o.hasOwnProperty("ls"))
				return ;
			
			UIManager.getInstance().badgeWnd.updateList(o);
		}

		/**
		 *2 开启血脉点：		bld|P,point(101 - 1010)			point = layer * 100 + point
	返回 	开启成功后增加的人物属性
	例子：bld|{	|{"mk":"P",
			  "pa":val,
			  "pd":val,
			  "ma":val,
			 "md":val,
			  "hp":val,
			  "mp":val,
			  "cr":val,
			  "te":val,
			  "ht":val,
			  "dg":val,
			  "sl":val,
			  "gu":val,
		}
		 */
		public static function sm_bld_P(o:Object):void {
			if (o.hasOwnProperty("nx")) {
				UIManager.getInstance().badgeWnd.updateNode(o);
			}
		}

		/**
		 * 3 洗练血脉点：		bld|W,point(110 - 1010),lock1,lock2(0表示不锁定,或者写上要锁定的属性编号)
	返回 	三条属性编号和值 		bld|wash[index] = val
	例子：	bld|{"mk":"W","ws":{"14":158,"13":146,"12":400}}
		 *
		 */
		public static function sm_bld_W(o:Object):void {
			if (o == null || !o.hasOwnProperty("ws"))
				return;

			if (isxl){
				Cmd_Bld.cm_bldOpen();
				isxl=false;
			}else
				UIManager.getInstance().badgeWnd.updatePoint(o);
		}


		public static function sm_bld_L(o:Object):void {
			if (o == null && !o.hasOwnProperty("lk"))
				return;

			UIManager.getInstance().badgeRebudWnd.updateDesc(o.lk);
		}

		/**
		 * 打开ui
		 */
		public static function cm_bldOpen():void {
			NetGate.getInstance().send("bld|O");
		}

		/**
		 * bld|P,point(101 - 1010)			point = layer * 100 + point
		 * 开启血脉点
		 * @param p
		 *
		 */
		public static function cm_bldOpenToPoint(p:int):void {
			NetGate.getInstance().send("bld|P," + p);
		}

		/**
		 * 洗点
		 *
		 * bld|W,point(110 - 1010),lock1,lock2(0表示不锁定,或者写上要锁定的属性编号)
		 * @param p1
		 * @param p2
		 * @param p3
		 *
		 */
		public static function cm_bldUpgrade(p1:int, p2:int, p3:int):void {
			NetGate.getInstance().send("bld|W," + p1 + "," + p2 + "," + p3);
			isxl=true;
		}

	}
}
