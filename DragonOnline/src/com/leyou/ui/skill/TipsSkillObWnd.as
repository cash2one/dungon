package com.leyou.ui.skill {

	import com.ace.enum.ItemEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.leyou.net.cmd.Cmd_Link;
	import com.leyou.ui.skill.childs.SkillGrid;
	import com.leyou.ui.tools.child.ShortcutsGrid;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class TipsSkillObWnd extends AutoSprite {

		private var descLbl:Label;
		private var nameLbl:Label;
		private var runeLbl:Label;
		private var titleNameLbl:Label;

		private var grid:SkillGrid;

		private var closeBtn:ImgButton;

		private var icon:Image;

		private var rune:Boolean=false;

		private var skillid:int=0;

		private var i:int=0;
		public var toolsEffectIndex:int=-1;

		public function TipsSkillObWnd() {
			super(LibManager.getInstance().getXML("config/ui/skill/TipsSkillObWnd.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.titleNameLbl=this.getUIbyID("titleNameLbl") as Label;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.descLbl=this.getUIbyID("descLbl") as Label;
			this.runeLbl=this.getUIbyID("runeLbl") as Label;

			this.addEventListener(MouseEvent.CLICK, onClick);

//			this.clsBtn.visible=false;

			this.grid=new SkillGrid();
			this.addChild(this.grid);

			this.grid.x=14;
			this.grid.y=14;
			this.grid.setSize(60, 60);

			this.icon=new Image();
			LayerManager.getInstance().clientTipLayer.addChild(this.icon);

//			this.allowDrag=false;
		}

		private function onClick(e:MouseEvent):void {
			this.complete();
		}

		private function complete():void {
			if (this.parent == LayerManager.getInstance().windowLayer)
				LayerManager.getInstance().windowLayer.removeChild(this);
			else
				return;

			var sk:Array=TableManager.getInstance().getSkillArr(this.skillid);
			var p:Point;

			if (this.rune) {

				this.icon.bitmapData=this.grid.itemBmp;

				p=this.localToGlobal(new Point(this.grid.x, this.grid.y));
				p=LayerManager.getInstance().clientTipLayer.globalToLocal(p);

				this.icon.x=p.x;
				this.icon.y=p.y;

				var btn:ImgButton=UIManager.getInstance().toolsWnd.getSkillBtn();

				p=btn.parent.localToGlobal(new Point(btn.x, btn.y));
				p=LayerManager.getInstance().clientTipLayer.globalToLocal(p);

			} else {

				if (i == -1)
					return;

				this.icon.bitmapData=this.grid.itemBmp; //updateBmp("ico\\skills\\" + sk[0].icon + ".png");

				p=this.localToGlobal(new Point(this.grid.x, this.grid.y));
				p=LayerManager.getInstance().clientTipLayer.globalToLocal(p);
				this.icon.x=p.x;
				this.icon.y=p.y;

				var sgrid:ShortcutsGrid=UIManager.getInstance().toolsWnd.shortCutGrid[i];

				p=sgrid.parent.localToGlobal(new Point(sgrid.x, sgrid.y));
				p=LayerManager.getInstance().clientTipLayer.globalToLocal(p);
			}

			this.icon.visible=true;
			TweenLite.to(this.icon, 3, {x: p.x, y: p.y, width: 40, height: 40, visible: false, ease: Elastic.easeInOut, onComplete: dcomplete});

			function dcomplete():void {
				if (sgrid != null)
					sgrid.icon.alpha=1;
			}
		}

		private function onCloseCLick(e:MouseEvent):void {
			this.hide();
		}

		public function showPanel(o:Object):void {
			this.show();
			this.alpha=1;

			this.x=UIEnum.WIDTH - this.width >> 1;
			this.y=UIEnum.HEIGHT - 300;

			var skiArr:Array=[];

			if (o.hasOwnProperty("skill")) {

				skiArr=TableManager.getInstance().getSkillArr(o.skill);
				skiArr.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);

				this.titleNameLbl.text=PropUtils.getStringById(1881)+"";
				this.descLbl.text=PropUtils.getStringById(1882)+"";
				this.runeLbl.text="";

				this.grid.gridType=ItemEnum.TYPE_GRID_SKILL;
				this.grid.updataInfo(skiArr[0]);

				this.skillid=o.skill;
				this.rune=false;

			} else if (o.hasOwnProperty("rune")) {

				skiArr=TableManager.getInstance().getSkillArr(o.rune[0]);
				skiArr.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);

				this.titleNameLbl.text=PropUtils.getStringById(1883)+"";
				this.descLbl.text=PropUtils.getStringById(1884)+"";
				this.runeLbl.text="" + skiArr[o.rune[1]].runeName;
				this.rune=true;

				this.grid.gridType=ItemEnum.TYPE_GRID_RUNE;
				this.grid.updataInfo(skiArr[o.rune[1]]);

				this.skillid=o.rune[0];

			}

			this.nameLbl.text="" + skiArr[0].name;
			this.grid.setSize(60, 60);

			TweenLite.delayedCall(10, complete);

			if (this.rune)
				return;

			i=UIManager.getInstance().toolsWnd.searchEmptyIndex((int(skiArr[0].id) % 100 == 4));
			if (i == -1)
				return;
			
			this.toolsEffectIndex=i;
			UIManager.getInstance().toolsWnd.shortCutGrid[i].icon.alpha=.3;

			Cmd_Link.cm_linkSet(i, 1, this.skillid);
		}
		
	}
}
