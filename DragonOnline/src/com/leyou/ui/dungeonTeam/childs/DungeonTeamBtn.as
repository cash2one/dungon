package com.leyou.ui.dungeonTeam.childs {


	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class DungeonTeamBtn extends AutoSprite {

		private var numLbl:Label;

		private var teamName:String;
		private var num:int;


		public function DungeonTeamBtn() {
			super(LibManager.getInstance().getXML("config/ui/dungeonTeam/dungeonTeamBtn.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;

//			this.scrollRect=new Rectangle(0, 0, 456, 446);
		}

		private function init():void {

			this.numLbl=this.getUIbyID("numLbl") as Label;

			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}

		private function onMouseOver(e:MouseEvent):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(6608).content, [this.teamName, this.num]), new Point(e.stageX, e.stageY));
		}

		private function onMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		public function setParams(n:String, i:int):void {
			this.teamName=n;
			this.num=i;

			this.numLbl.text="" + i;
		}


	}
}
