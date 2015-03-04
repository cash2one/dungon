package com.leyou.ui.fieldBoss.chlid
{
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFieldBossInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.fieldboss.FBRankInfo;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class FieldBossTrackItem extends AutoSprite
	{
		private var nameLbl:Label;
		
		private var damLbl:Label;
		
		private var rewardImg:Image;
		
		public var rank:int = -1;
		
		public function FieldBossTrackItem(){
			super(LibManager.getInstance().getXML("config/ui/fieldBoss/dungeonBossOutList.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			nameLbl = getUIbyID("nameLbl") as Label;
			damLbl = getUIbyID("damLbl") as Label;
			rewardImg = getUIbyID("rewardImg") as Image;
			var spt:Sprite = new Sprite();
			spt.addChild(rewardImg);
			addChild(spt);
			spt.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			var content:String = TableManager.getInstance().getSystemNotice(5006).content;
			var bossId:int = DataManager.getInstance().fieldBossData.damBossId;
			var bossInfo:TFieldBossInfo = TableManager.getInstance().getFieldBossInfo(bossId);
			content = StringUtil.substitute(content, rank, bossInfo.getRewardCountByRank(rank));
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}
		
		public function updateInfo(info:FBRankInfo):void{
			nameLbl.text = info.name;
			if(info.damage >= 100000000){
				damLbl.text = int(info.damage/100000000)+"亿";
			}else if(info.damage >= 10000){
				damLbl.text = int(info.damage/10000)+"万";
			}else{
				damLbl.text = info.damage+"";
			}
		}
		
		public function clear():void{
			nameLbl.text = "";
			damLbl.text = "";
		}
	}
}