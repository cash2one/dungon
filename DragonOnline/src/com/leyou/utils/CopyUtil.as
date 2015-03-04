package com.leyou.utils
{
	import com.leyou.enum.CopyEnum;

	public class CopyUtil
	{
		public static function getQualityImg(quality:int):String{
			switch(quality){
				case CopyEnum.PASTQUALITY_D:
					return "ui/dungeon/icon_d.png"; 
				case CopyEnum.PASTQUALITY_C:
					return "ui/dungeon/icon_c.png";
				case CopyEnum.PASTQUALITY_B:
					return "ui/dungeon/icon_b.png";
				case CopyEnum.PASTQUALITY_A:
					return "ui/dungeon/icon_a.png";
				case CopyEnum.PASTQUALITY_S:
					return "ui/dungeon/icon_s.png";
			}
			return null;
		}
		
		public static function getQualityBigImg(quality:int):String{
			switch(quality){
				case CopyEnum.PASTQUALITY_D:
					return "ui/dungeon/icon_d2.png"; 
				case CopyEnum.PASTQUALITY_C:
					return "ui/dungeon/icon_c2.png";
				case CopyEnum.PASTQUALITY_B:
					return "ui/dungeon/icon_b2.png";
				case CopyEnum.PASTQUALITY_A:
					return "ui/dungeon/icon_a2.png";
				case CopyEnum.PASTQUALITY_S:
					return "ui/dungeon/icon_s2.png";
			}
			return null;
		}
		
		public static function getCharCode(quality:int):String{
			switch(quality){
				case CopyEnum.PASTQUALITY_D:
					return "D"; 
				case CopyEnum.PASTQUALITY_C:
					return "C";
				case CopyEnum.PASTQUALITY_B:
					return "B";
				case CopyEnum.PASTQUALITY_A:
					return "A";
				case CopyEnum.PASTQUALITY_S:
					return "S";
			}
			return "?";
		}
	}
}