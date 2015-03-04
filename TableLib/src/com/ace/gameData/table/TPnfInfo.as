package com.ace.gameData.table {
	import com.ace.utils.StringUtil;
	
	public class TPnfInfo {
		
		public var id:int;
		public var type:int;
		public var part:int;
		public var imgId:String;
		public var px:int;
		public var py:int;
		public var radius:int;
		public var blend:Boolean;
		public var scale:Number;
		public var actId:int;
		public var width:int;
		
		public function TPnfInfo(info:XML) {
			
			this.id=info.@id;
			this.type=info.@type;
			this.part=info.@part;
			this.imgId=info.@imgId;
			this.px=info.@px;
			this.py=info.@py;
			this.radius=info.@radius;
			this.blend=StringUtil.intToBoolean(info.@blend);
			this.scale=info.@scaling;
			this.actId=info.@actId;
			this.width=info.@modelR;
		}
		
	}
}

/*

<pnf id="1" type="2" part="9" name="攻杀" imgId="1" px="-22" py="-19" blend="1" scale="1" actId="3"/>

*/