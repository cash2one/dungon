package com.leyou.ui.dragonBall.children
{
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TDragonBallPropertyInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.component.DragProgressBar;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.PropUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class DragonBallPropertyItem extends AutoSprite
	{
		private var minusBtn:ImgButton;
		
		private var plusBtn:ImgButton;
		
//		private var propertyLbl:Label;
//		
//		private var energyLbl:Label;
		
		private var iconImg:Image;
		
		private var progressbar:DragProgressBar;
		
		private var _id:int;
		
		private var listener:Function;
		
		public function DragonBallPropertyItem(){
			super(LibManager.getInstance().getXML("config/ui/dragonBall/dragonBall3Label.xml"));
			init();
		}
		
		public function get id():int{
			return _id;
		}

		private function init():void{
			mouseChildren = true;
			minusBtn = getUIbyID("minusBtn") as ImgButton;
			plusBtn = getUIbyID("plusBtn") as ImgButton;
//			propertyLbl = getUIbyID("propertyLbl") as Label;
//			energyLbl = getUIbyID("energyLbl") as Label;
			iconImg = new Image();
			iconImg.x = 10;
			iconImg.y = 5;
			var container:Sprite = new Sprite();
			container.addChild(iconImg);
			container.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addChild(container);
			progressbar = new DragProgressBar();
			progressbar.x = 79;
			progressbar.y = 22;
			addChild(progressbar);
			minusBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			plusBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			progressbar.registerAddDegree(onAddDegree);
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			var str:String = TableManager.getInstance().getSystemNotice(9500 + int(_id)).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, str, new Point(stage.mouseX, stage.mouseY));
		}
		
		public function getUsedVlaue():int{
			var info:TDragonBallPropertyInfo = TableManager.getInstance().getDragonBallProperty(_id);
			return progressbar.addValue*info.preCost;
		}
		
		public function getPropertyValue():int{
			return progressbar.addValue;
		}
		
		public function registerListener(fun:Function):void{
			listener = fun;
		}
		
		private function onAddDegree():void{
			if(null != listener){
				listener.call(this, this);
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			switch(event.target.name){
				case "minusBtn":
					progressbar.trimmingMinus();
					break;
				case "plusBtn":
					progressbar.trimmingPlus();
					break;
			}
		}
		
		public function setLimit(num:int):void{
			var info:TDragonBallPropertyInfo = TableManager.getInstance().getDragonBallProperty(_id);
			progressbar.limit = num/info.preCost;
//			trace(StringUtil.substitute("-------------属性 = {1}, setLimit = {2}", PropUtils.getPropertyString(_id), progressbar.limit))
		}
		
		public function updateCurrentValue(num:int):void{
			progressbar.setNum(num);
		}
		
		public function updateInfo(info:TDragonBallPropertyInfo):void{
			_id = info.id;
			progressbar.setMaxNum(info.upper);
			progressbar.setDegree(0);
			iconImg.updateBmp("ui/dragonBall/"+info.pic, null, false, 40, 40);
//			propertyLbl.text = "1"+PropUtils.getPropertyString(info.id).replace(":", "");
//			energyLbl.text = info.preCost+PropUtils.getStringById(2196);
		}
	}
}