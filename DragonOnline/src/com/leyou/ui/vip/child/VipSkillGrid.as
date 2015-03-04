package com.leyou.ui.vip.child
{
	import com.ace.config.Core;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.backpack.GridCD;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.tools.ScaleBitmap;
	import com.leyou.data.vip.TipVipSkillInfo;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class VipSkillGrid extends GridBase
	{
		private var tipInfo:TipVipSkillInfo;
		
		public function VipSkillGrid(){
			init();
		}
		
		/**
		 * <T>初始化</T>
		 *
		 * @param hasCd 是否显示CD
		 *
		 */
		protected override function init(hasCd:Boolean=false):void {
			super.init(true);
			canMove = false;
			iconBmp.x = 3;
			iconBmp.y = 3;
			isLock = true;
			mouseEnabled = true;
			mouseChildren = true;
			bgBmp.updateBmp("ui/common/common_icon_bg.png");
			tipInfo = new TipVipSkillInfo();
			cdMc
			cdMc.x=2;
			cdMc.y=2;
			cdMc.updateUI(36, 36);
			
			var select:ScaleBitmap = new ScaleBitmap(LibManager.getInstance().getImg("ui/backpack/select.png"));
			select.scale9Grid = new Rectangle(2, 2, 20, 20);
			select.setSize(41, 41);
			selectBmp.bitmapData=select.bitmapData;
		}
		
		public override function updataInfo(info:Object):void {
			if (info == null) return;
			this.dataId=int(info.id);
			var icon:String = TableManager.getInstance().getPassiveSkill(info.id).ico;
			this.iconBmp.updateBmp("ico/skills/" + icon, null, false, 36, 36);
		}
		
		/**
		 * <T>鼠标移入显示TIP</T>
		 *
		 * @param $x 事件坐标X
		 * @param $y 事件坐标Y
		 *
		 */
		public override function mouseOverHandler($x:Number, $y:Number):void {
			if(dataId <= 0){
				return;
			}
			tipInfo.skillId = dataId;
			tipInfo.isOpen = (Core.me.info.vipLv >= TableManager.getInstance().getPassiveSkill(dataId).openLv);
			ToolTipManager.getInstance().show(TipEnum.TYPE_VIP_SKILL, tipInfo, new Point(stage.mouseX, stage.mouseY));
		}
		
		public function updateValid():void{
			tipInfo.isOpen = (Core.me.info.vipLv >= TableManager.getInstance().getPassiveSkill(dataId).openLv);
			this.filters = tipInfo.isOpen ? null : [FilterEnum.enable];
		}
	}
}