package com.leyou.ui.legendary.children
{
	import com.ace.config.Core;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TLegendaryWeaponInfo;
	import com.ace.gameData.table.TSuit;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.PnfUtil;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.net.cmd.Cmd_SQ;
	import com.leyou.utils.PropUtils;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class LegendaryPageRender extends AutoSprite
	{
		private var attLbl:Label;
		
		private var defLbl:Label;
		
		private var uniformDesLbl:Label;
		
		private var weaponEffectImg:Image;
		
		private var magicImg:Image;
		
		private var weaponImg:Image;
		
		private var jbLbl:Label;
		
		private var ryLbl:Label;
		
		private var confirmBtn:NormalButton;
		
		private var weaponList:Vector.<LegendaryEquipGrid>;
		
		private var materialList:Vector.<LegendaryMaterialRender>;
		
		private var currentInfo:Array;
		
		private var magicContainer:Sprite;
		
//		private var zdlNum:RollNumWidget;
		
		private var currentEquip:LegendaryEquipGrid;
		
		private var lineImg:Image;
		
		private var tplBmp:BitmapData;
		
		private var lineRect:Vector.<Rectangle>;

		private var filterRect:Vector.<Rectangle>;
		
		private var jbIconImg:Image;
		
		private var hnIconImg:Image;
		
		protected var playerMovie:BigAvatar;
		
		private var fInfo:FeatureInfo;
		
		public function LegendaryPageRender(){
			super(LibManager.getInstance().getXML("config/ui/legendary/sbcqRender.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			attLbl = getUIbyID("attLbl") as Label;
			defLbl = getUIbyID("defLbl") as Label;
			lineImg = getUIbyID("lineImg") as Image;
			uniformDesLbl = getUIbyID("uniformDesLbl") as Label;
			weaponEffectImg = getUIbyID("weaponEffectImg") as Image;
			magicImg = getUIbyID("magicImg") as Image;
			weaponImg = getUIbyID("weaponImg") as Image;
			jbLbl = getUIbyID("jbLbl") as Label;
			ryLbl = getUIbyID("ryLbl") as Label;
			confirmBtn = getUIbyID("confirmBtn") as NormalButton;
			confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			
			playerMovie=new BigAvatar();
			playerMovie.x=547;
			playerMovie.y=355;
			addChild(playerMovie);
			
			jbIconImg = getUIbyID("jbIconImg") as Image;
			hnIconImg = getUIbyID("hnIconImg") as Image;
			packContainer(jbIconImg);
			packContainer(hnIconImg);
			
			lineImg.updateBmp("ui/sbcq/sqcs_bg_hc.png", onLoadOver);
			
			weaponList = new Vector.<LegendaryEquipGrid>(4, true);
			var length:int = weaponList.length;
			for(var n:int = 0; n < length; n++){
				var grid:LegendaryEquipGrid = new LegendaryEquipGrid();
				weaponList[n] = grid;
				addChild(grid);
				grid.y = 7 + 107*n;
				grid.addEventListener(MouseEvent.CLICK, onSelectClick);
			}
			
			materialList = new Vector.<LegendaryMaterialRender>(5, true);
			length = materialList.length;
			for(var m:int = 0; m < length; m++){
				var material:LegendaryMaterialRender = new LegendaryMaterialRender();
				material.pos = m;
				materialList[m] = material;
				addChild(material);
				material.x = 797;
				material.y = 34 + m*78;
			}
			
			magicContainer = new Sprite();
			addChildAt(magicContainer, getChildIndex(magicImg));
			magicContainer.addChild(magicImg);
			magicImg.x = -189;
			magicImg.y = -189;
			magicContainer.x = 370 + 189;
			magicContainer.y = 189;
			
//			zdlNum = new RollNumWidget();
//			zdlNum.x = 380;
//			zdlNum.y = 7;
//			zdlNum.loadSource("ui/num/{num}_zdl.png");
//			addChild(zdlNum);
			
			uniformDesLbl.multiline = true;
			uniformDesLbl.wordWrap = true;
			
			filterRect = new Vector.<Rectangle>();
			lineRect = new Vector.<Rectangle>();
			lineRect.push(new Rectangle(55, 1+80*0, 50, 18));
			lineRect.push(new Rectangle(55, 1+80*1, 50, 18));
			lineRect.push(new Rectangle(55, 1+80*2, 50, 18));
			lineRect.push(new Rectangle(55, 1+80*3, 50, 18));
			lineRect.push(new Rectangle(55, 1+80*4, 50, 18));
			
			lineRect.push(new Rectangle(40, 2+80*0, 18, 80));
			lineRect.push(new Rectangle(40, 2+80*1, 18, 80));
			lineRect.push(new Rectangle(40, 2+80*2+17, 18, 80));
			lineRect.push(new Rectangle(40, 2+80*3+17, 18, 80));
		}
		
		private function packContainer(img:Image):void{
			var container:Sprite = new Sprite();
			container.name = img.name;
			container.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			img.parent.addChild(container);
			container.addChild(img);
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			var id:int;
			var content:String;
			switch(event.target.name){
				case "jbIconImg":
					content = TableManager.getInstance().getSystemNotice(9555).content;
					break;
				case "hnIconImg":
					content = TableManager.getInstance().getSystemNotice(9608).content;
					break;
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}
		
		private function onLoadOver():void{
			tplBmp = lineImg.bitmapData.clone();
			
//			var rect:Rectangle = lineRect[index++];
//			lineImg.bitmapData.applyFilter(tplBmp, rect, new Point(rect.x, rect.y), FilterEnum.enable);
		}
		
		protected function turnToEquip(equip:LegendaryEquipGrid):void{
			if(null != currentEquip){
				currentEquip.turnToStatus(false);
			}
			currentEquip = equip;
			currentEquip.turnToStatus(true);
			selectWeapon(currentEquip.info);
		}
		
		protected function onSelectClick(event:MouseEvent):void{
			turnToEquip(event.currentTarget as LegendaryEquipGrid);
		}
		
		public function startEffect():void{
			if(!hasEventListener(Event.ENTER_FRAME)){
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
//				TweenMax.to(weaponEffectImg, 1.5, {alpha:0.3, yoyo:true, repeat:-1, ease:Linear.easeOut});
			}
		}
		
		protected function onEnterFrame(event:Event):void{
			magicContainer.rotation += 1;
			if(magicContainer.rotation >= 360){
				magicContainer.rotation = 0;
			}
		}
		
		public function stopEffect():void{
			if(hasEventListener(Event.ENTER_FRAME)){
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
//				TweenMax.killTweensOf(weaponEffectImg);
			}
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			var posArr:Array = [];
			var length:int = materialList.length;
			for(var m:int = 0; m < length; m++){
				var material:LegendaryMaterialRender = materialList[m];
				var pos:int = material.getBagPos();
				if(-1 != pos){
					posArr.push(pos);
				}else{
					break;
				}
			}
			Cmd_SQ.cm_SQ_M(currentEquip.info.id, posArr);
		}
		
		protected function selectWeapon(info:TLegendaryWeaponInfo):void{
//			weaponImg.updateBmp("ui/sbcq/"+info.productImg);
//			weaponEffectImg.updateBmp("ui/sbcq/"+info.produceEImg);
			weaponImg.visible = false;
			weaponEffectImg.visible = false;
			var item:TEquipInfo = TableManager.getInstance().getEquipInfo(info.productId);
			attLbl.text = "+"+item.fixed_attack;
			defLbl.text = "+"+item.fixed_defense;
			var des:String = "";
			var suitArr:Array = TableManager.getInstance().getSuitByGroup(item.Suit_Group);
			for each(var suitInfo:TSuit in suitArr){
				if((null != suitInfo.SA_txt) && ("" != suitInfo.SA_txt)){
					des += (suitInfo.SA_txt+"<br/>");
				}else{
					var attributeDes:String = TableManager.getInstance().getAttributeInfo(suitInfo.Suit_Att).attibuteDes;
					des += (attributeDes+"+"+suitInfo.SA_Num+"<br/>");
				}
			}
			uniformDesLbl.htmlText = des;
			jbLbl.text = info.money+"";
			ryLbl.text = info.honor+"";
			var tColor:int;
			if(info.money > UIManager.getInstance().backpackWnd.jb){
				tColor = 0xff0000;
			}else{
				tColor = 0xcdb97c;
			}
			jbLbl.textColor = tColor;
			if(info.honor > UIManager.getInstance().backpackWnd.honour){
				tColor = 0xff0000;
			}else{
				tColor = 0xcdb97c;
			}
			ryLbl.textColor = tColor;
			clearMaterial();
			var bagData:Array = MyInfoManager.getInstance().bagItems;
			var index:int;
			var l:int = info.mixtrueEquipLength;
			for(var n:int = 0; n < l; n++){
				var equipId:int = info.getMixtrueEquip(n);
				var equipArr:Array = bagData.filter(filterFun);
				var binfo:Baginfo = equipArr[0];
				var el:int = equipArr.length;
				for(var k:int = 0; k < el; k++){
					var cbinfo:Baginfo = equipArr[k];
					if(n > 0){
						if(cbinfo.tips.qh < cbinfo.tips.qh){
							binfo = cbinfo;
						}
					}else{
						if(cbinfo.tips.qh > cbinfo.tips.qh){
							binfo = cbinfo;
						}
					}
				}
				if(null != binfo){
					materialList[index].updateInfoByBaginfo(binfo);
				}else{
					materialList[index].updateInfoByEquip(equipId);
				}
				
				function filterFun(item:Object, index:int, array:Array):Boolean{
					return ((null != item) && (equipId == item.info.id))
				}
				index++;
			}
			l = info.materialLength;
			for(var m:int = 0; m < l; m++){
				var materialId:int = info.getMaterial(m);
				var materialNum:int = info.getMaterialNum(m);
				materialList[index].updateInfoByMaterial(materialId, materialNum);
				index++;
			}
			var zdl:int = PropUtils.getWhiteFighting(item);
			uddateLineStatus();
			showAvatar(info.weaponId, info.suit, Core.me.info.sex, Core.me.info.profession);
		}
		
		public function showAvatar(weapon:int, suit:int, sex:int, pro:int):void {
			if (null == fInfo) {
				fInfo=new FeatureInfo();
			}
			fInfo.clear();
			fInfo.weapon = PnfUtil.realAvtId(weapon, false, sex);
			fInfo.suit = PnfUtil.realAvtId(suit, false, sex);
			playerMovie.show(fInfo);
			playerMovie.playAct(PlayerEnum.ACT_STAND, 4);
		}
		
		private function uddateLineStatus():void{
			// 获得无效位置
			var validPos:Array = [];
			var length:int = materialList.length;
			for(var n:int = 0; n < length; n++){
				if(!materialList[n].hasValue){
					validPos.push(n);
				}
			}
			
			// 获得位置对应的矩形区域
			filterRect.length = 0;
			for(var m:int = 0; m < 5; m++){
				if(-1 != validPos.indexOf(m)){
					filterRect.push(lineRect[m]);
				}
			}
			if(-1 != validPos.indexOf(0)){
				filterRect.push(lineRect[5]);
			}
			if((-1 != validPos.indexOf(1)) && (-1 != validPos.indexOf(0))){
				filterRect.push(lineRect[6]);
			}
			if((-1 != validPos.indexOf(3)) && (-1 != validPos.indexOf(4))){
				filterRect.push(lineRect[7]);
			}
			if(-1 != validPos.indexOf(4)){
				filterRect.push(lineRect[8]);
			}
			
			if(null != tplBmp){
				lineImg.bitmapData = tplBmp.clone();
				if(filterRect.length >= lineRect.length){
					lineImg.filters = [FilterEnum.enable];
				}else{
					lineImg.filters = null;
					// 置灰矩形区域
					for each(var rect:Rectangle in filterRect){
						lineImg.bitmapData.applyFilter(tplBmp, rect, new Point(rect.x, rect.y), FilterEnum.enable);
					}
				}
			}
		}
		
		public function updateSelect():void{
			if(null != weaponList[0].info){
				turnToEquip(currentEquip);
			}
		}
		
		private function clearMaterial():void{
			for each(var material:LegendaryMaterialRender in materialList){
				if(null != material){
					material.clear();
				}
			}
		}
		
		public function flyToBag():void{
			currentEquip.flyToBag();
		}
		
		public function updateByType(type:int):void{
			var pro:int = Core.me.info.profession;
			currentInfo = TableManager.getInstance().getLegendaryInfo(pro, type);
			var l:int = currentInfo.length;
			for(var n:int = 0; n < l; n++){
				var legendaryInfo:TLegendaryWeaponInfo = currentInfo[n];
				var weaponRender:LegendaryEquipGrid = weaponList[n];
				weaponRender.updateInfo(legendaryInfo);
			}
			turnToEquip(weaponList[0]);
		}
		
		public function setMaterialEquip(destPos:int, bagInfo:Object):void{
			var binfo:Baginfo = bagInfo as Baginfo;
			var material:LegendaryMaterialRender = materialList[destPos];
			material.updateInfoByBaginfo(binfo);
			uddateLineStatus();
		}
	}
}