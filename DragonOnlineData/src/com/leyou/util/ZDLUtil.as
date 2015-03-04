package com.leyou.util
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TZdlElement;

	public class ZDLUtil
	{
		// blood:生命上限 magic:法力上限 phyAtt:物理攻击 phyDef:物理防御 
		// magicAtt:法术攻击 magicDef:法术防御 crit:暴击 tenacity:韧性 
		// hit:命中 dodge:闪避 slay:必杀 guard:守护 lv:强化等级
		public static function computation(blood:int, magic:int, phyAtt:int, phyDef:int, magicAtt:int, magicDef:int, crit:int, tenacity:int, hit:int, dodge:int, slay:int, guard:int, lv:int=0):int{
			var zdl:Number = (phyAtt*zdlElement(4) + magicAtt*zdlElement(6) + phyDef*zdlElement(5) + magicDef*zdlElement(7) + blood*zdlElement(1) + magic*zdlElement(2)) * Math.pow(1.09, lv) + dodge*zdlElement(11) + hit*zdlElement(10) + crit*zdlElement(8) + tenacity*zdlElement(9) + slay*zdlElement(12) + guard*zdlElement(13);
			return int(zdl);
		}
		
		private static function zdlElement(id:int):Number{
			return TableManager.getInstance().getZdlElement(id).rate;
		}
	}
}