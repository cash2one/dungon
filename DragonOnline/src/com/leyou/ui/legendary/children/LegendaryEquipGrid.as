package com.leyou.ui.legendary.children
{
	import com.ace.enum.GameFileEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TLegendaryWeaponInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.utils.ItemUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class LegendaryEquipGrid extends AutoSprite
	{
		private var iconImg:Image;
		
		private var namelbl:Label;
		
		private var bgBtn:ImgButton;
		
		private var iconContainer:Sprite;
		
		private var dataId:int;
		
		private var tipsInfo:TipsInfo;
		
		private var _info:TLegendaryWeaponInfo;
		
		private var _isSelect:Boolean;
		
		private var lvLbl:Label;

		public function LegendaryEquipGrid(){
			super(LibManager.getInstance().getXML("config/ui/legendary/sbcqBtn.xml"));
			init();
		}
		
		public function get info():TLegendaryWeaponInfo{
			return _info;
		}

		private function init():void{
			mouseChildren = true;
			lvLbl = getUIbyID("lvLbl") as Label;
			iconImg = getUIbyID("iconImg") as Image;
			namelbl = getUIbyID("namelbl") as Label;
			bgBtn = getUIbyID("bgBtn") as ImgButton;
			
//			bgBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			
			tipsInfo = new TipsInfo();
			iconContainer = new Sprite();
			iconContainer.addChild(iconImg);
			addChild(iconContainer);
			iconContainer.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			bgBtn.turnOff(false);
			bgBtn.addEventListener(MouseEvent.MOUSE_OVER, onBgOver);
			bgBtn.addEventListener(MouseEvent.MOUSE_OUT, onBgOut);
		}
		
		public function turnToStatus(v:Boolean):void{
			_isSelect = v;
			if(v){
				bgBtn.turnOn(false);
			}else{
				bgBtn.turnOff(false);
			}
		}
		
		protected function onBgOut(event:MouseEvent):void{
			if(_isSelect){
				return;
			}
			bgBtn.turnOff(false);
		}
		
		protected function onBgOver(event:MouseEvent):void{
			if(_isSelect){
				return;
			}
			bgBtn.turnOn(false);
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			tipsInfo.itemid = dataId;
			tipsInfo.isdiff = false;
			bgBtn.turnOn(false);
			var tipType:int = tipsInfo.hasOwner() ? TipEnum.TYPE_EQUIP_ITEM : TipEnum.TYPE_EMPTY_ITEM;
			var wear:Boolean = ItemUtil.showDiffTips(tipType, tipsInfo, new Point(stage.mouseX, stage.mouseY));
			if(!wear){
				if(tipsInfo.hasOwner()){
					ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tipsInfo, new Point(stage.mouseX, stage.mouseY));							
				}else{
					ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tipsInfo, new Point(stage.mouseX, stage.mouseY));
				}
			}
//			ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tipsInfo, new Point(stage.mouseX, stage.mouseY));
		}
		
//		protected function onBtnClick(event:MouseEvent):void{
//			
//		}
		
		public function updateInfo(legendaryInfo:TLegendaryWeaponInfo):void{
			_info = legendaryInfo;
			dataId = legendaryInfo.productId;
			var sourceName:String;
			var itemName:String;
			var itemInfo:Object = TableManager.getInstance().getItemInfo(dataId);
			if(null != itemInfo){
				sourceName = itemInfo.icon + ".png";
				itemName = itemInfo.name;
				lvLbl.text = StringUtil.substitute("LV {1}", itemInfo.level);
			}else{
				itemInfo = TableManager.getInstance().getEquipInfo(dataId);
				itemName = itemInfo.name;
				sourceName = itemInfo.icon + ".png";
				lvLbl.text = StringUtil.substitute("LV {1}", itemInfo.level);
			}
			var iconUrl:String = GameFileEnum.URL_ITEM_ICO + sourceName;
			iconImg.updateBmp(iconUrl);
			namelbl.text = itemName;
		}
		
		public function flyToBag():void{
			FlyManager.getInstance().flyBags([dataId],[iconImg.localToGlobal(new Point(0,0))]);
		}
	}
}