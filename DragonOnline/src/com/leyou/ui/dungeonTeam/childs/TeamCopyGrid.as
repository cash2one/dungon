package com.leyou.ui.dungeonTeam.childs {
	import com.leyou.ui.task.child.MissionGrid;
	
	import flash.display.BitmapData;

	public class TeamCopyGrid extends MissionGrid {

		public var higtEffect:Function;
		
		public var playName:String;
		
		public function TeamCopyGrid(id:int=-1) {
			super(id);
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init();
			this.setTipsPriceIsshow(false);
			this.isEmpty=true;
		}
		
		override public function updataInfo(info:Object):void{
			this.resetGrid();
			super.updataInfo(info);
			
			this.canMove=false;
			 
		}
		
		override public function mouseUpHandler($x:Number, $y:Number):void{
 
			if(this.higtEffect!=null)
				this.higtEffect();
		}
 

		public function resetGrid():void {
			this.reset();
			this.isEmpty=true;
			this.iconBmp.bitmapData=null;
			this.playName=null;
		}
	 
		

	}
}
