package com.leyou.ui.guildBattle.children
{
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.guildBattle.children.GuildBattleTrackItemData;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class GuildBattleRankTrackItem extends AutoSprite
	{
		private var boxImg:Image;
		
		private var nameLbl:Label;
		
		private var ryLbl:Label;
		
		private var killlbl:Label;
		
		private var deadLbl:Label;
		
		private var rank:int;
		
		private var value:int;
		
		public function GuildBattleRankTrackItem(){
			super(LibManager.getInstance().getXML("config/ui/guildBattle/warGuildTrackList.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			ryLbl = getUIbyID("ryLbl") as Label;
			boxImg = getUIbyID("boxImg") as Image;
			var spt:Sprite = new Sprite();
			spt.addChild(boxImg);
			addChild(spt);
			spt.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			nameLbl = getUIbyID("nameLbl") as Label;
			killlbl = getUIbyID("killlbl") as Label;
			deadLbl = getUIbyID("deadLbl") as Label;
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			var content:String = TableManager.getInstance().getSystemNotice(3094).content;
			content = StringUtil.substitute(content, rank, value);
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}
		
		public function updateInfo(data:GuildBattleTrackItemData):void{
			rank = data.rank;
			boxImg.visible = (data.rank <= 3) && (2 == data.type);
			if(boxImg.visible){
				value = TableManager.getInstance().getGuildBattleInfo(3+"|"+data.rank).vitality;
			}
			nameLbl.text = data.name;
			ryLbl.text = "+"+data.honour;
			killlbl.text = data.kill+"";
			deadLbl.text = data.dead+"";
		}
	}
}