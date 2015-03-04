package com.leyou.ui.tobestrong.children
{
	import com.ace.config.Core;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TTobeStrongInfo;
	import com.ace.gameData.table.TTobeStrongLevelInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tobestrong.TobeStrongData;
	
	public class StrongTitleItem extends AutoSprite
	{
		private var _type:int;
		
		private var bgBtn:ImgButton;
		
		private var remainImg:Image;
		
		private var progressImg:Image;
		
		private var zlLbl:Label;
		
		private var nameLbl:Label;
		
		public function StrongTitleItem(){
			super(LibManager.getInstance().getXML("config/ui/tobeStrong/tobestrLeftBar.xml"));
			init();
		}
		
		public function get type():int{
			return _type;
		}

		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			bgBtn = getUIbyID("bgBtn") as ImgButton;
			remainImg = getUIbyID("remainImg") as Image;
			progressImg = getUIbyID("progressImg") as Image;
			zlLbl = getUIbyID("zlLbl") as Label;
			nameLbl = getUIbyID("nameLbl") as Label;
		}
		
		public function updateInfo(tinfo:TTobeStrongInfo):void{
			_type = tinfo.type;
			nameLbl.text = tinfo.des_title;
		}
		
		public function updateDynamicData():void{
			var data:TobeStrongData = DataManager.getInstance().tobeStrongData;
			var strongLevelInfo:TTobeStrongLevelInfo = TableManager.getInstance().getTobeStrongLevelInfo(Core.me.info.level);
			var cz:int;
			var mz:int;
			switch(type){
				case 1:
					// 装备
					cz = data.qz;
					mz = strongLevelInfo.zdl_equip;
					break;
				case 2:
					// 坐骑
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
					// 翅膀
					cz = data.wz;
					mz = strongLevelInfo.zdl_wing;
					break;
				case 7:
					// 宝石
					cz = DataManager.getInstance().tobeStrongData.gemz;
					mz = strongLevelInfo.zdl_gem;
					break;
				default:
					break;
			}
			zlLbl.text = "+"+cz;
			var rate:Number = cz/mz;
			if(rate < 0.5){
				remainImg.updateBmp("ui/tobestr/font_01.png");
			}else if(rate >= 0.5 && rate < 1){
				remainImg.updateBmp("ui/tobestr/font_02.png");
			}else{
				remainImg.updateBmp("ui/tobestr/font_03.png");
			}
			if(rate > 1){
				rate = 1;
			}
			progressImg.scaleX = rate;
		}
		
		public function turnOff():void{
			bgBtn.turnOff(false);
		}
		
		public function turnOn():void{
			bgBtn.turnOn(false);
		}
	}
}