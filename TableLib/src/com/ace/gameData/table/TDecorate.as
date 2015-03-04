package com.ace.gameData.table {

	public class TDecorate {
		public var id:int; //
		public var sceneId:int; //所属于的地图id
		public var layer:uint;
		public var tileX:uint;
		public var tileY:uint;
		public var pnfId:uint;

		public function TDecorate(info:XML) {
			this.id=info.@id;
			this.sceneId=info.@sceneId;
			this.layer=info.@layer;
			this.tileX=info.@tileX;
			this.tileY=info.@tileY;
			this.pnfId=info.@pnfId;
		}
 
	/*public function get objId():String {
		return this.id.toString() + ":" + this.psX.toString() + "-" + this.psY.toString();
	}*/
	}
}