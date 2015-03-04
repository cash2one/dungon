package com.ace.gameData.table {
	
	import flash.utils.Dictionary;
	
	public class TActsInfo {
		public var id:int;
		public var totalFrame:int;
		public var actDic:Dictionary;
		
		public function TActsInfo(info:XML) {
			this.id=info.@id;
			
			this.actDic=new Dictionary();
			for each (var render:XML in info.children()) {
				this.actDic[String(render.@name)]=new TActInfo(render);
			}
			
			this.totalFrame=pnfTotalFrame(this);
		}
		
		//计算动作总帧数 
		static internal function pnfTotalFrame(info:TActsInfo):int {
			var totalFrame:int;
			
			for each (var render:TActInfo in info.actDic) {
				if (render.noDir) {
					totalFrame+=render.preFrame;
				} else {
					totalFrame+=render.preFrame * 5;
				}
			}
			return totalFrame;
		}
		
		
		public function actInfo(actName:String="defaultAct"):TActInfo {
			var info:TActInfo;
			info=(this.actDic[actName]) ? this.actDic[actName] : this.actDic["defaultAct"];
			return info;
		}
	}
}
