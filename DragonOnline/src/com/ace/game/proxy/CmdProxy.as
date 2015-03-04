package com.ace.game.proxy {
	import com.leyou.net.cmd.Cmd_Attack;

	public class CmdProxy {
		static public function cm_revive(type:int):void {
			Cmd_Attack.cm_rev(type);
		}
	}
}