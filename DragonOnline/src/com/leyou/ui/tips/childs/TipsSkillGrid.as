package com.leyou.ui.tips.childs
{
	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	
	public class TipsSkillGrid extends GridBase
	{
		public function TipsSkillGrid(id:int=-1, hasCd:Boolean=false){
			super(id, hasCd);
			init();
		}
		
		protected override function init(hasCd:Boolean=false):void {
			super.init();
			isLock=false;
			canMove=false;
			iconBmp.x = 2;
			iconBmp.y = 2;
			bgBmp.updateBmp("ui/tips/TIPS_bg_frame.png");
		}
		
		public override function updataInfo(info:Object):void {
			if(null == info){
				return;
			}
			super.updataInfo(info);
			if(ItemEnum.TYPE_GRID_RUNE == gridType) {
				iconBmp.updateBmp("ico/skills/" + info.runeIcon + ".png");
			}else{
				iconBmp.updateBmp("ico/skills/" + info.icon + ".png");
			}
			dataId = int(info.id);
		}
	}
}