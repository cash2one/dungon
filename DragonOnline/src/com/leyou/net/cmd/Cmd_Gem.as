package com.leyou.net.cmd {

	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Gem {


		public static function sm_Gem_I(o:Object):void {
//			trace(o)

			if (o.hasOwnProperty("name")) {
				UIManager.getInstance().otherPlayerWnd.updateGemInfo(o);
			} else
				UIManager.getInstance().roleWnd.updateGemInfo(o);
		}

		/**
		 *人物宝石信息
上行: gem|I
下行：gem|{"mk":"I","zdl":num,  "glist":[[gemid1,gemid2,gemid3],...]}
  zdl -- 宝石总战斗力
		  glist  -- 宝石列表数值  (14个宝石装备位置 每个位置3个槽,)
			  gemid -- 宝石道具Id (如果该位置未放宝石默认id 为0)
		 * @param name
		 *
		 */
		public static function cmGemInit(name:String=""):void {
			if (name == "")
				NetGate.getInstance().send(CmdEnum.CM_GEM_I);
			else
				NetGate.getInstance().send(CmdEnum.CM_GEM_O + name);
		}


		public static function sm_Gem_H(o:Object):void {

			UIManager.getInstance().gemLvWnd.updateInfo(o);

		}

		/**
		 * <pre>
		 * 宝石合成
上行: gem|Hgemid,htype
gemid -- 宝石道具Id
htype -- 合成类型 （0普通 1道具 2元宝）

下行：gem|{"mk":"H","rst":num}
rst  -- 合成结果(0失败 1成功)
 * 
 * 下行：gem|{"mk":"H","success":num, "lose":num}
* @param gid
   * @param type
	  * </pre>
			  *
		 */
		public static function cmGemCompound(gid:int, type:int, num:int):void {
			NetGate.getInstance().send(CmdEnum.CM_GEM_H + gid + "," + type + "," + num);
		}

		/**
		 * <pre>
		 *宝石镶嵌
上行: gem|Xbpos,gpos,cpos
bpos -- 背包位置
gpso -- 宝石装备位置 （0~13）
	  cpos -- 槽位置 (0~2)
		   * @param bpos
		 * @param gpos
		 * @param cpos
		 * </pre>
		 *
		 */
		public static function cmGemInlay(bpos:int, gpos:int, cpos:int):void {
			NetGate.getInstance().send(CmdEnum.CM_GEM_X + bpos + "," + gpos + "," + cpos);
		}

		/**
		 * <pre>
		 *宝石摘取
上行: gem|Zgpos,cpos
* @param gid
* @param type
   *</pre>
		   */
		public static function cmGemQuit(gpos:int, cpos:int):void {
			NetGate.getInstance().send(CmdEnum.CM_GEM_Z + gpos + "," + cpos);
		}


	}
}
