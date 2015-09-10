package com.leyou.ui.pet.children
{
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPetInfo;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.ui.button.children.ImgButton;
	import com.leyou.net.cmd.Cmd_Pet;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class PetIconGird extends GridBase
	{
		public function PetIconGird(){
		}
		
		protected override function init(hasCd:Boolean=false):void {
			mouseEnabled = true;
			super.init(true);
			cdMc.x=2;
			cdMc.y=2;
			cdMc.updateUI(36, 36);
			
			iconBmp.x = 1;
			iconBmp.y = 1;
			bgBmp.updateBmp("ui/common/common_icon_bg.png");
		}
		
		public function isCDOver():Boolean{
			return cdMc.isOver();
		}
		
		public override function mouseOverHandler($x:Number, $y:Number):void {
			if(0 >= dataId){
				return;
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_PET, dataId, new Point(stage.mouseX, stage.mouseY));
		}
		
		public function updatePet(petId:int):void{
			dataId = petId;
			var petTInfo:TPetInfo = TableManager.getInstance().getPetInfo(petId);
			iconBmp.updateBmp("ui/servent/" + petTInfo.headUrl, null, false, 40, 40);
		}
		
		public function clearGrid():void{
			iconBmp.fillEmptyBmd();
			cdMc.play(0, 0);
			dataId = 0;
		}
		
		public function iconDown():void{
			iconBmp.y += 2;
			cdMc.y += 2;
		}
		
		public function iconUp():void{
			iconBmp.y -= 2;
			cdMc.y -= 2;
		}
	}
}