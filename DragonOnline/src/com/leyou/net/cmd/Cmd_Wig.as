package com.leyou.net.cmd {
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.leyou.net.NetGate;


	/**
	 *协议列表
	翅膀


	lv：翅膀级别 - exp：翅膀祝福经验值
	at：翅膀进阶属性加上翅膀装备属性的表
	rs：开槽是否成功（1成功0失败）
	ib：绑定道具id - in：非绑定道具id

	0.翅膀初始化
	  命令：wig|I
	  返回：	ib,in,lv,exp

	1.翅膀升阶
	  命令：wig|U
	  返回：{["mk"]="U",["lv"]=lv,["exp"]=exp,["at"]=attri}

	2.超载
	  命令：wig|V

	3.开槽
	  命令：wig|O,slot_id -- 槽id（1-6）
	  返回：{["mk"]="O",["id"]=id,["rs"]=res} -- 1成功0失败

	4.装备卸载翅膀装备
	  命令：wig|E,equip_pos,slot_id -- 装备位置，槽id

	 * @author Administrator
	 *
	 */
	public class Cmd_Wig {


		public function Cmd_Wig() {
		}

		public static function sm_Wig_I(o:Object):void {
//			trace(o);
			if (!o.hasOwnProperty("lv"))
				return;

			//其他玩家
			if (o.hasOwnProperty("id"))
				UIManager.getInstance().otherPlayerWnd.updateWig(o);
			else
				UIManager.getInstance().roleWnd.updateWig(o);
		}

		public static function sm_Wig_U(o:Object):void {
//			trace(o);

			if (!o.hasOwnProperty("lv"))
				return;

			UIManager.getInstance().roleWnd.updateWig(o);
		}

		public static function sm_Wig_O(o:Object):void {
//			trace(o);

			if (!o.hasOwnProperty("id") || !o.hasOwnProperty("rs"))
				return;

			UIManager.getInstance().roleWnd.updateWingGrid(o);
		}

		public static function sm_Wig_E(o:Object):void {
//			trace(o);

			if (!o.hasOwnProperty("st"))
				return;

			UIManager.getInstance().roleWnd.updateWingGridList(o);

		}

		public static function sm_Wig_M(o:Object):void {
//			trace(o);

			if (!o.hasOwnProperty("st"))
				return;

			UIManager.getInstance().roleWnd.updateWingGridList(o);

		}

		public static function sm_Wig_Z(o:Object):void {

			if (!o.hasOwnProperty("rst"))
				return;

			UIManager.getInstance().wingLvUpWnd.changeState(o.rst);
		}

		/**
		 *0.翅膀初始化
	  命令：wig|I
								  返回：	ib,in,lv,exp
		 *
		 */
		public static function cm_WigInit(name:String=""):void {
			if (name != "")
				NetGate.getInstance().send("wig|I," + name);
			else
				NetGate.getInstance().send("wig|I");
		}

		/**
		 *1.翅膀升阶
	  命令：wig|U
								  返回：{["mk"]="U",["lv"]=lv,["exp"]=exp,["at"]=attri}
		 *
		 */
		public static function cm_WigUpgrade(i:int=0):void {
			NetGate.getInstance().send("wig|U," + i);
		}

		/**
		 *3.开槽
	  命令：wig|O,slot_id -- 槽id（1-6）
								  返回：{["mk"]="O",["id"]=id,["rs"]=res} -- 1成功0失败
		 * @param slot
		 *
		 */
		public static function cm_WigOpenSlot(slot:int):void {
			NetGate.getInstance().send("wig|O," + slot);
		}

		/**
		 *4.装备卸载翅膀装备
	  命令：wig|E,equip_pos,slot_id -- 装备位置，槽id
									 *
					   * type :1 背包,2槽位
					   *
		 */
		public static function cm_WigAddEquipToSlot(e_pos:int, sindex:int, type:int=1):void {
			NetGate.getInstance().send("wig|E," + e_pos + "," + sindex + "," + type);
		}

		/**
		 * 槽到槽
		 * @param spos1
		 * @param spos2
		 *
		 */
		public static function cm_WigSlotToSlot(spos1:int, spos2:int):void {
			NetGate.getInstance().send("wig|M," + spos1 + "," + spos2);
		}

		/**
		 *  2.超载
	  命令：wig|V
						 *
		 */
		public static function cm_WigOverLoad():void {
			NetGate.getInstance().send("wig|V");
		}

		/**
		 * show
		 * @param lv
		 *
		 */
		public static function cm_WigShow():void {
			NetGate.getInstance().send("wig|C");
		}

		/**
		 *
		 *
		 */
		public static function sm_Wig_N(o:Object):void {
			if (UIManager.getInstance().isCreate(WindowEnum.MARKET) && UIManager.getInstance().marketWnd.visible)
				UIManager.getInstance().marketWnd.flyMovie();
			else
				UIManager.getInstance().roleWnd.buyWingEffect();
		}

		/**
		 *翅膀飞升
上行: wig|Fetype (0普通进化 1砖石自动购买道具进化 2绑定砖石自动购买进化)
下行：wig|{"mk":"F","flyl":num, "flyv":num, "rst":num}
  rst --飞升结果 (0失败 1成功)

		 *
		 */
		public static function cm_WigFly(type:int=0):void {
			NetGate.getInstance().send("wig|F" + type);
		}


		public static function sm_Wig_F(o:Object):void {

			UIManager.getInstance().wingTradeWnd.onSuccess(o);

		}

	}
}
