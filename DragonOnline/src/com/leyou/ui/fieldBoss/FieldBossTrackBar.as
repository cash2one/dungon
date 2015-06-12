package com.leyou.ui.fieldBoss
{
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.leyou.data.fieldboss.FBRankInfo;
	import com.leyou.data.fieldboss.FieldBossData;
	import com.leyou.ui.fieldBoss.chlid.FieldBossTrackItem;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class FieldBossTrackBar extends AutoSprite
	{
		private var damLbl:Label;
		
		private var rankLbl:Label;
		
		private var items:Vector.<FieldBossTrackItem>;
		
		private var hideBtn:ImgButton;
		
		private var pane:Sprite;
		
		public function FieldBossTrackBar(){
			super(LibManager.getInstance().getXML("config/ui/fieldBoss/dungeonBossOutTrack.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			pane = new Sprite();
			while(0 != numChildren){
				pane.addChild(getChildAt(0));
			}
			addChild(pane);
			damLbl = getUIbyID("damLbl") as Label;
			rankLbl = getUIbyID("rankLbl") as Label;
			hideBtn = getUIbyID("hideBtn") as ImgButton;
			hideBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			items = new Vector.<FieldBossTrackItem>();
			for(var n:int = 0; n < 10; n++){
				var item:FieldBossTrackItem = new FieldBossTrackItem();
				item.rank = n+1;
				items.push(item);
				pane.addChild(item);
				item.y = 28 + 28 * n;
			}
			addChild(hideBtn);
			resize();
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "hideBtn":
					pane.visible = !pane.visible;
					var url:String = pane.visible ? "ui/funForcast/btn_left.png" : "ui/funForcast/btn_right.png";
					hideBtn.updataBmd(url);
					break;
			}
		}
		
		public function resize():void{
			y = ((UIEnum.HEIGHT - 354) >> 1);
		}
		
		public function updateInfo():void{
			var data:FieldBossData = DataManager.getInstance().fieldBossData;
			damLbl.text = data.myDamage+"";
			rankLbl.text = data.myRank+"";
			for(var n:int = 0; n < 10; n++){
				var item:FieldBossTrackItem = items[n];
				var riData:FBRankInfo = data.getRankInfo(n);
				if(null != riData){
					item.updateInfo(riData);
				}else{
					item.clear();
				}
			}
		}
	}
}