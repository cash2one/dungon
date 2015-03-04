package com.leyou.ui.monsterInvade.child {

	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.MouseEvent;

	public class MonsterInFinish extends AutoSprite {

		private var accpetBtn:ImgButton;

		private var grid:MonsterInvadeGrid;
		private var descLbl:Label;

		public function MonsterInFinish() {
			super(LibManager.getInstance().getXML("config/ui/monsterInvade/monsterInFinish.xml"));
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {

			this.descLbl=this.getUIbyID("descLbl") as Label;
			this.accpetBtn=this.getUIbyID("accpetBtn") as ImgButton;
			this.accpetBtn.addEventListener(MouseEvent.CLICK, onClick);
			
//			this.descLbl.multiline=true;
//			this.descLbl.wordWrap=true;
//			this.descLbl.autoLine(true);

			grid=new MonsterInvadeGrid();
			this.addChild(grid);

//			grid.x=103;
//			grid.y=88;

			grid.x=106;
			grid.y=91;

			grid.updateMoney();

//			this.showPanel({"jtype": 1, rank: 2});
		}

		private function onClick(e:MouseEvent):void {
			this.hide();

			if (this.parent != null)
				this.parent.removeChild(this);
		}

		public function showPanel(o:Object):void {
			this.show();
			this.descLbl.width=262;
			
			var str:String="";
			if (o.jtype == 2) {

				var rank:int=ConfigEnum["DemonInvasion" + (8 + int(o.rank))];
				this.grid.setNum(int(rank / 10000) + "万");
				str=com.leyou.utils.StringUtil_II.getBreakLineStringByCharIndex(com.ace.utils.StringUtil.substitute(TableManager.getInstance().getSystemNotice(5605).content, [o.rank, int(rank / 10000) + "万"])) + "";

			} else if (o.jtype == 1) {

				this.grid.setNum(int(ConfigEnum.DemonInvasion8 / 10000) + "万");
				str=com.leyou.utils.StringUtil_II.getBreakLineStringByCharIndex(com.ace.utils.StringUtil.substitute(TableManager.getInstance().getSystemNotice(5604).content, [TableManager.getInstance().getLivingInfo(ConfigEnum.DemonInvasion3).name, int(ConfigEnum.DemonInvasion8 / 10000) + "万"]));

			}
			
			str=str.replace("&#13;","\r").replace("\n","");
			
			this.descLbl.text=""+str;
			this.descLbl.wordWrap=true;
		}

		override public function show():void {
			super.show();

			this.x=UIEnum.WIDTH - this.width >> 1;
			this.y=UIEnum.HEIGHT - this.height >> 1;
		}


	}
}
