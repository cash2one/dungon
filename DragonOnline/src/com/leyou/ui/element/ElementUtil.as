package com.leyou.ui.element {
	import com.leyou.utils.PropUtils;

	public class ElementUtil {
		public static function getOppositeElementry(type:int):String {
			switch (type) {
				case 1:
					return PropUtils.getStringById(1302);
				case 2:
					return PropUtils.getStringById(1304);
				case 3:
					return PropUtils.getStringById(1303);
				case 4:
					return PropUtils.getStringById(2297);
				case 5:
					return PropUtils.getStringById(2296);
			}
			return null;
		}

		public static function getBiOppositeElementry(type:int):String {
			switch (type) {
				case 1:
					return PropUtils.getStringById(1303);
				case 2:
					return PropUtils.getStringById(1302);
				case 3:
					return PropUtils.getStringById(1304);
				case 4:
					return PropUtils.getStringById(2297);
				case 5:
					return PropUtils.getStringById(2296);
			}
			return null;
		}

		// 获得被克制元素
		public static function getBiOppositeElement(type:int):int {
			switch (type) {
				case 1:
					return 2;
				case 2:
					return 3;
				case 3:
					return 1;
				case 4:
					return 5;
				case 5:
					return 4;
			}
			return -1;
		}

		public static function getHurtType(send:int, receive:int, isMe:Boolean=false):int {
			var isKZ:Boolean;
			var isBK:Boolean;

			if (isMe) { //后者是自己
				isBK=(send == ElementUtil.getBiOppositeElement(receive));
//				isBK=(receive == ElementUtil.getBiOppositeElement(send));
			} else { //前者是自己
//				2,1 	我打你（我看你-火攻)		你打我（我显示-被克）
//				3，1		我打你（我看你-克制）		你打我（我显示-木攻）
				
//				isBK=(receive == ElementUtil.getBiOppositeElement(send));
				isKZ=(send == ElementUtil.getBiOppositeElement(receive));
			}

			if (isBK) {
				return 102;
			} else if (isKZ) {
				return 101;
			} else {
				switch (send) {
					case 1:
						return 106;
					case 2:
						return 107;
					case 3:
						return 105;
					case 4:
						return 104;
					case 5:
						return 103;
				}
			}
			return 0;
		}
	}
}
