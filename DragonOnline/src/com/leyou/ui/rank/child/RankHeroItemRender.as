package com.leyou.ui.rank.child
{
	import com.ace.enum.PriorityEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.PlayerUtil;
	
	import flash.events.MouseEvent;
	
	//英雄榜render
	public class RankHeroItemRender extends AutoSprite
	{
		private var rankTitleImg:Image;
		
		private var roleImg:Image;
		
		private var contentLbl:Label;
		
		private var lightImg:Image;
		
		private var _type:int;
		
		public function RankHeroItemRender(){
			super(LibManager.getInstance().getXML("config/ui/rank/rankAllBtn.xml"));
			init();
		}
		
		public function get type():int{
			return _type;
		}

		private function init():void{
			mouseEnabled = true;
			rankTitleImg = getUIbyID("rankTitleImg") as Image;
			roleImg = getUIbyID("roleImg") as Image;
			contentLbl = getUIbyID("contentLbl") as Label;
			lightImg = getUIbyID("lightImg") as Image;
			lightImg.visible = false;
			
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			lightImg.visible = true;
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			lightImg.visible = false;
		}
		
		public function updateInfo(data:Array):void{
			contentLbl.text = data[1];
			roleImg.updateBmp(PlayerUtil.getPlayerFullHeadImg(data[2], data[3]));
		}
		
		public function setType(type:int):void{
			_type = type;
			switch(_type){
				case 1:
					rankTitleImg.updateBmp("ui/rank/font_phbzdl.png");
					break;
				case 2:
					rankTitleImg.updateBmp("ui/rank/font_phbzq.png");
					break;
				case 3:
					rankTitleImg.updateBmp("ui/rank/font_phbcb.png");
					break;
				case 4:
					rankTitleImg.updateBmp("ui/rank/font_phbzb.png");
					break;
				case 5:
					rankTitleImg.updateBmp("ui/rank/font_phbjx.png");
					break;
				case 6:
					rankTitleImg.updateBmp("ui/rank/title_djjfb.png");
					break;
				case 7:
					rankTitleImg.updateBmp("ui/rank/title_cfph.png");//xxxxxxxxxxxxx
					break;
				case 8:
					rankTitleImg.updateBmp("ui/rank/font_xfphb.png");//xxxxxxxxxxxxx
					break;
				case 9:
					rankTitleImg.updateBmp("ui/rank/font_yszlb.png");
					break;
				case 10:
					rankTitleImg.updateBmp("ui/rank/font_xzzlb.png");
					break;
			}
		}
		
		public function clearData():void{
			roleImg.updateBmp("ui/history/his_none.png");
			contentLbl.text = TableManager.getInstance().getSystemNotice(10095).content;
		}
	}
}