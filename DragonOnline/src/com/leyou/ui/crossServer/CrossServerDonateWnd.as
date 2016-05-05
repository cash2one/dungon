package com.leyou.ui.crossServer
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.net.cmd.Cmd_Across;
	import com.leyou.ui.market.child.MarketGrid;
	
	import flash.events.MouseEvent;
	
	public class CrossServerDonateWnd extends AutoWindow
	{
		private var nameLbl:Label;
		
		private var bindLbl:Label;
		
		private var unbindLbl:Label;
		
		private var numLbl:TextInput;
		
		private var confirmBtn:NormalButton;
		
		private var cancelBtn:NormalButton;
		
		private var grid:MarketGrid;
		
		private var type:int;
		private var ownCount:int;
		
		public function CrossServerDonateWnd(){
			super(LibManager.getInstance().getXML("config/ui/crossServer/donateMessage.xml"));
			init();
		}
		
		private function init():void{
			nameLbl = getUIbyID("nameLbl") as Label;
			bindLbl = getUIbyID("bindLbl") as Label;
			unbindLbl = getUIbyID("unbindLbl") as Label;
			numLbl = getUIbyID("numLbl") as TextInput;
			confirmBtn = getUIbyID("confirmBtn") as NormalButton;
			cancelBtn = getUIbyID("cancelBtn") as NormalButton;
			grid = new MarketGrid();
			grid.x = 26;
			grid.y = 55;
			pane.addChild(grid);
			
			confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			cancelBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			numLbl.input.restrict="0-9";
			numLbl.input.maxChars=8;
			
//			clsBtn.x -= 6;
//			clsBtn.y -= 14;
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "confirmBtn":
					if(ownCount < int(int(numLbl.text))){
						var id:int;
						if(6 == type){
							id = 11016;
						}else if(7 == type){
							id = 11017;
						}else if(8 == type){
							id = 11020;
						}
						NoticeManager.getInstance().broadcastById(id);
						return;
					}
					Cmd_Across.cm_ACROSS_D(type, int(numLbl.text));
					break;
				case "cancelBtn":
					hide();
					break;
			}
			hide();
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			stage.focus = numLbl.input;
		}
		
		public function updateInfo($type:int, itemId:int, ownItem:int, ownBItem:int):void{
			type = $type;
			ownCount = ownItem+ownBItem;
			var item:TItemInfo = TableManager.getInstance().getItemInfo(itemId);
			grid.updataById(itemId);
			nameLbl.text = item.name;
			bindLbl.text = ownBItem+"";
			unbindLbl.text = ownItem+"";
		}
	}
}