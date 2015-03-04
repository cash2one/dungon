/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-9-28 上午10:35:01
 */
package com.leyou.net.cmd {
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_GM {

		public static function setup():void {
		}

		static public function sendGMCmd(str:String):void {
			var cmd:String=str.split("|")[0];
			NetGate.getInstance().send(str);
		}

		static private function gm_attack(cmd:String):void {
			NetGate.getInstance().send(cmd);
		}

	}
}

/*


@attack|num 设置人物攻击数值
@exp|num  增加人物经验



*/