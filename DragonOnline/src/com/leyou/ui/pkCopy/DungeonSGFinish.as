package com.leyou.ui.pkCopy {

	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.monsterInvade.child.MonsterInvadeGrid;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.MouseEvent;

	public class DungeonSGFinish extends AutoSprite {

		private var accpetBtn:ImgButton;

		private var grid:MonsterInvadeGrid;
		private var descLbl:Label;

		public function DungeonSGFinish() {
			super(LibManager.getInstance().getXML("config/ui/monsterInvade/monsterInFinish.xml"));
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {

			this.descLbl=this.getUIbyID("descLbl") as Label;
			this.accpetBtn=this.getUIbyID("accpetBtn") as ImgButton;
			this.accpetBtn.addEventListener(MouseEvent.CLICK, onClick);

			grid=new MonsterInvadeGrid();
			this.addChild(grid);
			grid.x=106;
			grid.y=91;

			grid.updateHun();

			this.show();
		}

		private function onClick(e:MouseEvent):void {
			this.hide();
		}

		public function showPanel(o:Object):void {
			this.show();

//			this.grid.setNum(int(o.exp / 10000) + "万");
			
			var str:String=com.leyou.utils.StringUtil_II.getBreakLineStringByCharIndex(com.ace.utils.StringUtil.substitute(TableManager.getInstance().getSystemNotice(5502).content, [o.jf, o.exp]));

			str=str.replace(/\n/g,"");
			this.descLbl.htmlText="" +str;

		}

		override public function show():void {
			super.show();

			this.x=UIEnum.WIDTH - this.width >> 1;
			this.y=UIEnum.HEIGHT - this.height >> 1;
		}


	}
}
