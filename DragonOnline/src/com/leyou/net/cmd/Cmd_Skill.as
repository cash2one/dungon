package com.leyou.net.cmd {


	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.setting.AssistWnd;
	import com.leyou.data.playerSkill.SkillInfo;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;


	public class Cmd_Skill {


		public function Cmd_Skill() {

		}

		public static function sm_skl_I(o:Object):void {

			if (o == null)
				return;

			var skill:SkillInfo=MyInfoManager.getInstance().skilldata;

			if (skill == null)
				skill=new SkillInfo();

			skill.itemId=o.itm;
			skill.num=o.num;

			var key:String;
			for (key in o) {
				if (key.length == 1 && key.charAt(0).match(/[1-9]+/g) != null)
					skill.skillItems[key]=o[key];
			}

			MyInfoManager.getInstance().skilldata=skill;
			UIManager.getInstance().skillWnd.updateInfo();
		}

		public static function sm_skl_A(o:Object):void {
			if (o == null)
				return;

			var skill:SkillInfo=MyInfoManager.getInstance().skilldata;

			var key:String;
			for (key in o)
				if (key.length == 1 && key.charAt(0).match(/[1-9]+/g) != null)
					skill.skillItems[key]=o[key];

			MyInfoManager.getInstance().skilldata=skill;
			UIManager.getInstance().skillWnd.updateInfo();
		}

		/**
		 * 获得技能
		 *
学会了新技能，新符文
下行: skl|{mk:L,"skill":skillid,"rune":[skillid,runeid]}

	 *
		  */
		public static function sm_skl_L(o:Object):void {
			if (o == null)
				return;

			UIManager.getInstance().skillWnd.showGetPanel(o);
		}

		public static function sm_skl_R(o:Object):void {
			if (o == null)
				return;

			var skill:SkillInfo=MyInfoManager.getInstance().skilldata;

			var key:String;
			for (key in o)
				if (key.length == 1 && key.charAt(0).match(/[1-9]+/g) != null)
					skill.skillItems[key]=o[key];

			MyInfoManager.getInstance().skilldata=skill;
			UIManager.getInstance().skillWnd.updateInfo();
//			AssistWnd.getInstance().updataSkill(skill);
		}

		public static function sm_skl_C(o:Object):void {
			if (o == null)
				return;

			var skill:SkillInfo=MyInfoManager.getInstance().skilldata;

			var key:String;
			for (key in o)
				if (key.length == 1 && key.charAt(0).match(/[1-9]+/g) != null)
					skill.skillItems[key]=o[key];

			MyInfoManager.getInstance().skilldata=skill;
			UIManager.getInstance().skillWnd.updateInfo();
//			AssistWnd.getInstance().updataSkill(skill);
		}

		public static function cm_sklView():void {
			NetGate.getInstance().send("skl|I");
		}

		/**
		 *激活符文
上行：skl|Asindex,runepos
下行：skl|{mk:A,"sindex":[enabled skillid level rune1,rune2,rune3]}

sindex     -- 技能面板排列的位置序号(从0开始)
runepos   -- 需要激活的符文位置(从0开始)

* @param index
* @param pos
*
	   */
		public static function cm_sklActive(index:int, pos:int):void {
			NetGate.getInstance().send("skl|A" + index + "," + pos);
		}

		/**
		 *重置符文
上行：skl|Rsindex,
下行：skl|{mk:R,"sindex":[enabled skillid level rune1,rune2,rune3]}
* @param index
*
*/
		public static function cm_sklReset(index:int):void {
			NetGate.getInstance().send("skl|R" + index);
		}

		/**
		 *切换符文
上行：skl|Csindex,runepos
下行：skl|{mk:C,"sindex":[enabled skillid level rune1,rune2,rune3]}

	 * @param index
		  * @param pos 位置
		 *
		 */
		public static function cm_sklChange(index:int, pos:int, etype:int=0):void {
			NetGate.getInstance().send("skl|C" + index + "," + pos + "," + etype);
		}
		
		/**
		 *升级人物技能
上行：skl|Usindex
 
		 * @param index
		 * 
		 */		
		public static function cm_sklUpgrade(index:int):void {
			NetGate.getInstance().send(CmdEnum.CM_SKL_U+index);
		}



	}
}
