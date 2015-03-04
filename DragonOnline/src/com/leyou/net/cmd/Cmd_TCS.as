package com.leyou.net.cmd {
	
	import com.ace.manager.UIManager;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.TaskEnum;

	public class Cmd_TCS {
		
		public static function sm_TCS_I(obj:Object):void {
			var sp:int = obj.sp;
			var count:int = obj.count;
			var type:String = obj.tid;
			var value:int;
			var act:int;
			
			if(obj.hasOwnProperty("act")) {
				act = obj.act;
			}
			
			if(obj.hasOwnProperty("vargs")){
				value = obj.vargs;
			}
			
			UIManager.getInstance().rightTopWnd.updateNotify(type, count, act, sp, value);
			
			switch (obj.tid) {
				case "ecp":
					UIManager.getInstance().taskTrack.updateDungeon({"vars": obj.count,"cm":obj.cm});
					break;
				case "wbs":
					UIManager.getInstance().updateMonster(obj.act);
					break;
			}
		}

	}
}
