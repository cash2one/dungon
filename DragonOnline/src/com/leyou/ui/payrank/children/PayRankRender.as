package com.leyou.ui.payrank.children
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.leyou.data.payrank.PayRankChildData;
	import com.leyou.data.payrank.PayRankData;
	import com.leyou.net.cmd.Cmd_PayRank;
	
	import flash.events.MouseEvent;
	
	public class PayRankRender extends AutoSprite
	{
		private var pageLbl:Label;
		
		private var pBtn:ImgButton;
		
		private var nBtn:ImgButton;
		
		private var itemLbl:Label;
		
		private var items:Vector.<PayRankItem>;
		
		private var cp:int = 1;
		
		private var tp:int;
		
		private var ctype:int;
		
		public function PayRankRender(){
			super(LibManager.getInstance().getXML("config/ui/payRank/yrcbRank.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			pageLbl = getUIbyID("pageLbl") as Label;
			pBtn = getUIbyID("pBtn") as ImgButton;
			nBtn = getUIbyID("nBtn") as ImgButton;
			itemLbl = getUIbyID("itemLbl") as Label;
			pBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			nBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			items = new Vector.<PayRankItem>(PayRankData.RANK_MAX_NUM);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "pBtn":
					if(cp > 1){
						cp--;
						Cmd_PayRank.cm_PayRank_I(ctype, (cp-1)*PayRankData.RANK_MAX_NUM+1, (cp+1)*PayRankData.RANK_MAX_NUM);
					}
					break;
				case "nBtn":
					if(cp < tp){
						cp++;
						Cmd_PayRank.cm_PayRank_I(ctype, (cp-1)*PayRankData.RANK_MAX_NUM+1, (cp+1)*PayRankData.RANK_MAX_NUM);
					}
					break;
			}
		}
		
		public function updateInfo(data:PayRankChildData, pageC:int, type:int):void{
			ctype = type;
			tp = pageC;
			if(tp < 1){
				tp = 1;
			}
			pageLbl.text = cp +"/"+ tp;
			itemLbl.text = getTypeName(type);
			var rl:int = data.count;
			var length:int = PayRankData.RANK_MAX_NUM;
			for(var n:int = 0; n < length; n++){
				var item:PayRankItem = items[n];
				if(null != item){
					item.visible = (n < rl);
				}
				if(n < rl){
					if(null == item){
						item = new PayRankItem();
						addChild(item);
						items[n] = item;
						item.y = 33 + n*21;
					}
					item.updateInfo(data.getData(n));
				}
			}
		}
		
		private function getTypeName(type:int):String{
			switch(type){
				case 1:
					return "充值钻石";
				case 2:
					return "等级";
				case 3:
					return "战力";
			}
			return null;
		}
		
		public function reset():void{
			cp = 1;
		}
	}
}