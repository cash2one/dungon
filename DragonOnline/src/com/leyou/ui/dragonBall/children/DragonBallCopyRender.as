package com.leyou.ui.dragonBall.children
{
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCopyInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.data.dargonball.DragonBallData;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class DragonBallCopyRender extends AutoSprite
	{
		private var items:Vector.<DragonBallCopyItem>;
		
		private var viewPanel:ScrollPane;
		
		private var remainCLbl:Label;
		
		private var ruleLbl:Label;
		
		public function DragonBallCopyRender(){
			super(LibManager.getInstance().getXML("config/ui/dragonBall/dragonBall2Render.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			items = new Vector.<DragonBallCopyItem>();
			viewPanel = getUIbyID("viewPanel") as ScrollPane;
			remainCLbl = getUIbyID("remainCLbl") as Label;
			ruleLbl = getUIbyID("rulerLbl") as Label;
			ruleLbl.mouseEnabled = true;
			ruleLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			var content:String = TableManager.getInstance().getSystemNotice(20007).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}
		
		public function updateInfo():void{
			var data:DragonBallData = DataManager.getInstance().dragonBallData;
			remainCLbl.text = data.remainC+"";
			var l:int = data.getCopyLength();
			items.length = l;
			for(var n:int = 0; n < l; n++){
				var copyId:int = data.getCopyID(n);
				var copyInfo:TCopyInfo = TableManager.getInstance().getCopyInfo(copyId);
				var item:DragonBallCopyItem = items[n];
				if(null == item){
					item = new DragonBallCopyItem();
					items[n] = item;
					viewPanel.addToPane(item);
					item.y = n * 98;
					viewPanel.updateUI();
				}
				item.updateInfo(copyInfo);
			}
		} 
	}
}