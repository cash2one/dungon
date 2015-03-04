package com.leyou.ui.expCopy.chlid
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TExpCopyInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	
	import flash.events.MouseEvent;
	
	public class ExpCopyRender extends AutoSprite
	{
		private var bgImg:Image;
		
		private var selectImg:Image;
		
		private var _id:int;

		public function ExpCopyRender(){
			super(LibManager.getInstance().getXML("config/ui/sceneCopy/monsterScBtn.xml"));
			init();
		}
		
		private function init():void{
			mouseEnabled = true;
			bgImg = getUIbyID("bgImg") as Image;
			selectImg = getUIbyID("selectImg") as Image;
			selectImg.visible = false;
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public function set id(value:int):void{
			_id = value;
			var copyInfo:TExpCopyInfo = TableManager.getInstance().getExpCopyInfo(_id);
			bgImg.updateBmp("ui/monsterScene/"+copyInfo.preview+".jpg");
		}
		
		public function get id():int{
			return _id;
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			UIManager.getInstance().openWindow(WindowEnum.EXPCOPY_MAP);
			UIManager.getInstance().expMapWnd.loadMap(_id);
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			selectImg.visible = false;
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			selectImg.visible = true;
		}
	}
}