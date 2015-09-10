package com.leyou.ui.rank.child
{
	import com.ace.game.scene.ui.child.TitleRender;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TTitle;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.utils.PlayerUtil;
	
	import flash.events.MouseEvent;
	
	public class RankConsumeItemRender extends AutoSprite
	{
		private var lightImg:Image;
		
		private var roleImg:Image;
		
		private var rankLbl:Label;
		
		private var nameLbl:Label;
		
		private var titleRedner:TitleRender;
		
		private var rank:int;
		
		public var avaStr:String;
		
		public var gender:int;
		
		public var vocation:int;
		
		public var titleId:int;
		
		private var moneyLbl:Label;
		
		private var pname:String;
		
		public function RankConsumeItemRender(){
			super(LibManager.getInstance().getXML("config/ui/rank/rankConsumeBtn.xml"));
			init();
		}
		
		private function init():void{
			mouseEnabled = true;
			moneyLbl = getUIbyID("moneyLbl") as Label;
			roleImg = getUIbyID("roleImg") as Image;
			rankLbl = getUIbyID("rankLbl") as Label;
			nameLbl = getUIbyID("nameLbl") as Label;
			lightImg = getUIbyID("lightImg") as Image;
			titleRedner = new TitleRender();
			titleRedner.x = 98;
			titleRedner.y = 55;
			addChild(titleRedner);
			lightImg.alpha = 0;
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		public function getName():String{
			return pname;
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			TweenLite.to(lightImg, 0.5, {alpha: 0});
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			TweenLite.to(lightImg, 0.5, {alpha: 1});
		}
		
		public function updateInfo(data:Array):void{
			roleImg.updateBmp(PlayerUtil.getPlayerFullHeadImg(data[2], data[3]));
			nameLbl.text = data[1];
			vocation=data[2];
			gender=data[3];
			avaStr=data[4];
			moneyLbl.text = data[6];
			pname = data[1];
		}
		
		public function setDefault($rank:int):void{
			rank = $rank;
			moneyLbl.text = "0";
			var content:String = TableManager.getInstance().getSystemNotice(10093).content;
			rankLbl.text = StringUtil.substitute(content, rank); 
			nameLbl.text = TableManager.getInstance().getSystemNotice(10095).content;
			var tArr:Array = ConfigEnum.rank12.split("|");
			titleId = tArr[rank-1];
			var titleInfo:TTitle = TableManager.getInstance().getTitleByID(titleId);
			titleRedner.updateInfo(titleInfo);
			roleImg.updateBmp("ui/history/his_none.png");
		}
	}
}