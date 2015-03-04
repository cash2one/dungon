package com.leyou.ui.die
{
	import com.ace.config.Core;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.GameFileEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TTobeStrongLevelInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.leyou.data.tobestrong.TobeStrongData;
	
	import flash.events.MouseEvent;
	
	public class DieTobeStrongStar extends AutoSprite
	{
		private var stars:Vector.<Image>;
		
		private var icon:Image;
		
		private var type:int;
		
		public function DieTobeStrongStar(){
			super(LibManager.getInstance().getXML("config/ui/die/reviveMeg.xml"));
			init();
		}
		
		private function init():void{
			stars = new Vector.<Image>();
			stars.push(getUIbyID("star1"));
			stars.push(getUIbyID("star2"));
			stars.push(getUIbyID("star3"));
			stars.push(getUIbyID("star4"));
			stars.push(getUIbyID("star5"));
			
			icon = new Image();
			addChild(icon);
			icon.x = 7;
			mouseEnabled = true;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		protected function getRate():int{
			var data:TobeStrongData = DataManager.getInstance().tobeStrongData;
			var strongLevelInfo:TTobeStrongLevelInfo = TableManager.getInstance().getTobeStrongLevelInfo(Core.me.info.level);
			var cz:int;
			var mz:int;
			switch(type){
				case 1:
					// 装备 强化
					cz = data.qz;
					mz = strongLevelInfo.zdl_equip;
					break;
				case 2:
					// 坐骑 进阶
					cz = data.rz;
					mz = strongLevelInfo.zdl_horse;
					break;
				case 3:
					// 帮会技能
					cz = data.gz;
					mz = strongLevelInfo.zdl_skill;
					break;
				case 4:
					// 纹章 
					cz = data.bz;
					mz = strongLevelInfo.zdl_badge;
					break;
				case 5:
					// 精灵
					cz = data.sz;
					mz = strongLevelInfo.zdl_vip;
					break;
				case 6:
					// 翅膀 进阶
					cz = data.wz;
					mz = strongLevelInfo.zdl_wing;
					break;
				default:
					break;
			}
			return int(cz/mz*100);
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			UIOpenBufferManager.getInstance().open(WindowEnum.TOBE_STRONG);
			switch(type){
				case 1:
					break;
				case 2:
					break;
				case 3:
					break;
				case 4:
					break;
				case 5:
					break;
				case 6:
					break;
			}
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			icon.filters = null;
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			icon.filters = [FilterEnum.yellow_glow];
		}
		
		public function setType($type:int):void{
			type = $type;
			switch(type){
				case 1:
					icon.updateBmp(GameFileEnum.URL_ITEM_ICO + "hdxgn_bar_qh.png");
					break;
				case 2:
					icon.updateBmp(GameFileEnum.URL_ITEM_ICO + "hdxgn_bar_zq.png");
					break;
				case 3:
					icon.updateBmp(GameFileEnum.URL_ITEM_ICO + "hdxgn_bar_hangh.png");
					break;
				case 4:
					icon.updateBmp(GameFileEnum.URL_ITEM_ICO + "hdxgn_bar_wz.png");
					break;
				case 5:
					icon.updateBmp(GameFileEnum.URL_ITEM_ICO + "hdxgn_bar_jl.png");
					break;
				case 6:
					icon.updateBmp(GameFileEnum.URL_ITEM_ICO + "hdxgn_bar_cb.png");
					break;
			}
		}
		
		public function updateStars():void{
			var s:int = Math.ceil(getRate()/20);
			for(var n:int = 0; n < 5; n++){
				var url:String = (s <= n) ? "ui/equip/equip_star2.png" : "ui/equip/equip_star.png";
				stars[n].updateBmp(url);
			}
		}
	}
}