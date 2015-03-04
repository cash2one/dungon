package com.ace.game.scene.ui.child
{
	import com.ace.ICommon.ILivingUI;
	import com.ace.enum.FontEnum;
	import com.ace.game.scene.player.part.LivingBase;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.tools.SpriteNoEvt;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.PkMode;
	import com.leyou.utils.StringUtil_II;
	
	import flash.text.TextFieldAutoSize;
	
	public class BaseLiving extends SpriteNoEvt implements ILivingUI
	{
		
		protected var nameLbl:Label; //玩家名称
		protected var vipImg:Image;    //VIP标识
		protected var elementImg:Image;//元素标识
		
		public function BaseLiving(){
			init();
		}
		
		protected function init():void{
			nameLbl = new Label("", FontEnum.getTextFormat("White12Center"));
			nameLbl.autoSize = TextFieldAutoSize.LEFT;
			nameLbl.x = 14;
			nameLbl.y = 33;
			vipImg = new Image();
			elementImg = new Image();
			addChild(vipImg);
			addChild(elementImg);
			addChild(nameLbl);
		}
		
		public function updataHp(info:LivingInfo):void{
		}
		
		protected function getColor(color:int):String {
			switch (color) {
				case PkMode.PK_COLOR_WHITE:
					return "#ffffff";
				case PkMode.PK_COLOR_YELLOW:
					return "#ffd200";
				case PkMode.PK_COLOR_ORANGE:
					return "#fa7603";
				case PkMode.PK_COLOR_GREY:
					return "#ee8298";
				case PkMode.PK_COLOR_RED:
					return "#ee0d0d";
			}
			return "#ffffff";
		}
		
		public function showName(info:*):void{
			var str:String=info.name + "[lv" + info.level + "]"
			nameLbl.htmlText=com.leyou.utils.StringUtil_II.getColorStr(str, getColor(info.color));
			// 更新元素状态
			elementImg.visible=true;
			switch (info.baseInfo.yuanS) {
				case 0:
					elementImg.visible=false;
					break;
				//0无元素 1金 2木 3水 4火 5土
				case 1:
					elementImg.updateBmp("ui/name/el_gold.png");
					break;
				case 2:
					elementImg.updateBmp("ui/name/el_wood.png");
					break;
				case 3:
					elementImg.updateBmp("ui/name/el_water.png");
					break;
				case 4:
					elementImg.updateBmp("ui/name/el_fire.png");
					break;
				case 5:
					elementImg.updateBmp("ui/name/el_dirt.png");
					break;
				default:
					trace("error")
					break;
			}
			// 更新vip
			vipImg.visible=true;
			switch (info.vipLv) {
				case 0:
					vipImg.visible=false;
					break;
				default:
					vipImg.updateBmp("ui/name/VIP" + info.vipLv + ".png");
					break;
			}
		}
		
		/**
		 * 调整各个位置
		 *
		 */
		protected function adjustLocation():void {
			var maxW:Number=nameLbl.width;
			if (vipImg.visible) {
				vipImg.x=nameLbl.x - /*vipImg.width*/ 34;
				elementImg.x=vipImg.x - /*elementImg.width*/ 16;
			} else {
				elementImg.x=nameLbl.x - /*elementImg.width*/ 16;
			}
		}
		
		public function showTitles(info:LivingInfo):void{
		}
		
		public function showPs(str:String):void{
		}
		
		public function updataPs(livingBase:LivingBase):void{
		}
		
		public function die():void{
		}
		
		public function get livingName():String{
			return null;
		}
		
		public function switchVisible($visible:Boolean):void{
		}
	}
}