/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2014-3-21 上午11:24:40
 */
package com.ace.effect {
	import flash.display.DisplayObject;

	public class ShakeEffect {
		// 振动器集合
		private static const shakeMachines:Vector.<ShakeMachine>=new Vector.<ShakeMachine>();

		// 最小数量
		private static const minCount:int=3;

		// 最大数量
		private static const maxCount:int=20;

		/**
		 * <T>震动效果</T>
		 *
		 * @param $display 目标对象
		 * @param $range   震动幅度
		 * @param $time    总震动时间
		 * @param $frequency 总震动次数
		 *
		 */
		public static function startShake($display:DisplayObject, $range:int, $time:uint, $frequency:int=1):void {
			var machine:ShakeMachine=getFreeMachine();
			machine.startShake($display, $range, $time, $frequency);
		}

		/**
		 * <T>获得可用的震动器</T>
		 *
		 * @return 震动器
		 *
		 */
		private static function getFreeMachine():ShakeMachine {
			var machine:ShakeMachine;
			var length:int=shakeMachines.length;
			for (var n:int=0; n < length; n++) {
				machine=shakeMachines[n];
				if (machine.free) {
					return machine;
				}
			}
			machine=new ShakeMachine();
			shakeMachines.push(machine);
			return machine;
		}

		/**
		 * <T>释放空闲的震动器</T>
		 *
		 */
		public static function free():void {
		}
	}
}