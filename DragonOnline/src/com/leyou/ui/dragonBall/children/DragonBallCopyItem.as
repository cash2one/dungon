package com.leyou.ui.dragonBall.children
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCopyInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Longz;
	import com.leyou.ui.mail.child.MaillGrid;
	
	import flash.events.MouseEvent;
	
	public class DragonBallCopyItem extends AutoSprite
	{
		private var proEnterBtn:NormalButton;
		
		private var ybEnterBtn:NormalButton;
		
		private var grids:Vector.<MaillGrid>;
		
		private var copyId:int;
		
		public function DragonBallCopyItem(){
			super(LibManager.getInstance().getXML("config/ui/dragonBall/dragonBall2Lable.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			proEnterBtn = getUIbyID("proEnterBtn") as NormalButton;
			ybEnterBtn = getUIbyID("ybEnterBtn") as NormalButton;
			grids = new Vector.<MaillGrid>(7);
			
			for(var n:int = 0; n < 7; n++){
				var grid:MaillGrid = grids[n];
				if(null == grid){
					grid = new MaillGrid();
					grid.isShowPrice = false;
					addChild(grid);
					grids[n] = grid;
				}
				if(n < 3){
					grid.x = 4 + 43 * n;
					grid.y = 41;
				}else{
					grid.x = 277 + 48 * (n-3);
					grid.y = 29;
				}
			}
			
			proEnterBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			ybEnterBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "proEnterBtn":
					Cmd_Longz.cm_Longz_E(copyId, 1);
					break;
				case "ybEnterBtn":
					var content:String = TableManager.getInstance().getSystemNotice(20004).content;
					content = StringUtil.substitute(content, ConfigEnum.DragonBall7);
					PopupManager.showConfirm(content, enterCopy, null, false, "dragon.copy.enter");
					break;
			}
		}
		
		private function enterCopy():void{
			Cmd_Longz.cm_Longz_E(copyId, 2);
		}
		
		public function updateInfo(copyInfo:TCopyInfo):void{
			copyId = copyInfo.id;
			var index:int = 0;
			grids[index++].updateInfo(copyInfo.item1Data[0], copyInfo.item1Data[1]);
			grids[index++].updateInfo(copyInfo.item2Data[0], copyInfo.item2Data[1]);
			grids[index++].updateInfo(copyInfo.item3Data[0], copyInfo.item3Data[1]);
			
			if(copyInfo.ticket1 > 0){
				grids[index].updateInfo(copyInfo.ticket1, copyInfo.ticketC1);
			}
			grids[index].visible = (copyInfo.ticket1 > 0);
			index++;
			if(copyInfo.ticket2 > 0){
				grids[index].updateInfo(copyInfo.ticket2, copyInfo.ticketC2);
			}
			grids[index].visible = (copyInfo.ticket2 > 0);
			index++;
			if(copyInfo.ticket3 > 0){
				grids[index].updateInfo(copyInfo.ticket3, copyInfo.ticketC3);
			}
			grids[index].visible = (copyInfo.ticket3 > 0);
			index++;
			if(copyInfo.ticket4 > 0){
				grids[index].updateInfo(copyInfo.ticket4, copyInfo.ticketC4);
			}
			grids[index].visible = (copyInfo.ticket4 > 0);
		}
	}
}