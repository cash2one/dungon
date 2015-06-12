package com.leyou.ui.legendary.children
{
	import com.ace.enum.FilterEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.ui.mail.child.MaillGrid;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.StyleSheet;
	
	public class LegendaryMaterialRender extends AutoSprite
	{
		private var bgImg:Image;
		
		private var countLbl:Label;
		
		private var buyLbl:Label;
		
		private var addImg:Image;
		
		private var grid:MaillGrid;
		
		private var bagInfo:Baginfo;
		
		private var _materialId:int;
		
		public var pos:int;
		
		private var type:int;
		
		private var _hasValue:Boolean;
		
		public function LegendaryMaterialRender(){
			super(LibManager.getInstance().getXML("config/ui/legendary/sbcqItem.xml"));
			init();
		}
		
		public function get hasValue():Boolean
		{
			return _hasValue;
		}

		private function init():void{
			mouseChildren = true;
			bgImg = getUIbyID("bgImg") as Image;
			countLbl = getUIbyID("countLbl") as Label;
			buyLbl = getUIbyID("buyLbl") as Label;
			addImg = getUIbyID("addImg") as Image;
			
			buyLbl.mouseEnabled = true;
			var value:String = buyLbl.text;
			var style:StyleSheet = new StyleSheet();
			style.setStyle("a:hover", {color:"#ff0000"});
			buyLbl.styleSheet = style;
			buyLbl.htmlText = StringUtil_II.getColorStr(StringUtil_II.addEventString("adjust", value, true), "#"+buyLbl.textColor.toString(16));
			
			buyLbl.addEventListener(TextEvent.LINK, onTextClick);
			
			grid = new MaillGrid();
			addChild(grid);
			grid.x = 7;
			grid.y = 7;
			grid.hideBg();
			swapChildren(grid, countLbl);
			
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public function getBagPos():int{
			if(null != bagInfo){
				return bagInfo.pos;
			}
			return -1;
		}
		
		protected function onTextClick(event:TextEvent):void{
			var isAutoBuy:Boolean = UIManager.getInstance().quickBuyWnd.isAutoBuy(_materialId, _materialId);
			if(isAutoBuy){
				UIManager.getInstance().quickBuyWnd.getItemNotShow(_materialId, _materialId);
			}else{
				UILayoutManager.getInstance().show(WindowEnum.QUICK_BUY);
				UIManager.getInstance().quickBuyWnd.pushItem(_materialId, _materialId);
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			if(event.target is Label){
				return;
			}
			if(1 != type){
				return;
			}
			UIManager.getInstance().selectWnd.showLegendary(grid.dataId, pos, new Point(stage.mouseX, stage.mouseY), 3);
		}
		
		public function updateInfoByEquip(equipId:int):void{
			type = 1;
			countLbl.visible = false;
			buyLbl.visible = false;
			addImg.visible = true;
			var equipInfo:TEquipInfo = TableManager.getInstance().getEquipInfo(equipId);
			var rnum:int = MyInfoManager.getInstance().getBagItemNumById(equipId);
			grid.updateInfo(equipId);
			grid.filters = [FilterEnum.enable];
			_hasValue = false;
		}
		
		public function updateInfoByMaterial(materialId:int, materialNum:int):void{
			type = 0;
			addImg.visible = false;
			buyLbl.visible = true;
			countLbl.visible = true;
			_materialId = materialId;
			grid.updateInfo(materialId);
			var rnum:int = MyInfoManager.getInstance().getBagItemNumById(materialId);
			countLbl.text = rnum+"/"+materialNum;
			grid.filters = (rnum < materialNum ? [FilterEnum.enable] : null);
			_hasValue = !(rnum < materialNum);
		}
		
		public function updateInfoByBaginfo(info:Baginfo):void{
			type = 1;
			countLbl.visible = false;
			buyLbl.visible = false;
			addImg.visible = true;
			grid.uddateInfoByBag(info);
			grid.filters = null;
			bagInfo = info;
			_hasValue = true;
		}
		
		public function clear():void{
			grid.clear();
			_materialId = 0;
			bagInfo = null;
			grid.filters = null;
			addImg.visible = false;
			buyLbl.visible = false;
			countLbl.visible = false;
			_hasValue = false;
		}
	}
}