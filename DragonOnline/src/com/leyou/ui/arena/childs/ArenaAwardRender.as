package com.leyou.ui.arena.childs {

	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TTitle;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.utils.PropUtils;

	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ArenaAwardRender extends AutoSprite {

		private var iconImg:Image;
		private var integralLbl:Label;
		private var numTopLbl:Label;
		private var nameLbl:Label;

		private var gridVec:Vector.<ArenaGrid>

		private var bgHightImg:Image;

		private var itemIcon:Image;
		private var mName:String;
		private var mtitleid:int;

		private var effSwf:SwfLoader;

		public function ArenaAwardRender() {
			super(LibManager.getInstance().getXML("config/ui/arena/arenaAwardRender.xml"));
			this.init();
		}

		private function init():void {
			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.bgHightImg=this.getUIbyID("bgHightImg") as Image;
			this.integralLbl=this.getUIbyID("integralLbl") as Label;
			this.numTopLbl=this.getUIbyID("numTopLbl") as Label;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;

			this.gridVec=new Vector.<ArenaGrid>();

			this.effSwf=new SwfLoader(99989);
			this.addChild(this.effSwf);
			this.effSwf.y=this.iconImg.y + 7;
			this.effSwf.x=337;


			this.itemIcon=new Image();
			this.addChild(this.itemIcon);
			this.itemIcon.y=this.iconImg.y + 7;
			this.itemIcon.x=337;

			this.mouseChildren=true;

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.itemIcon, einfo);
		}

		private function onTipsMouseOver(e:DisplayObject):void {
			var tinfo:TTitle=TableManager.getInstance().getTitleByID(this.mtitleid);
			if (tinfo == null)
				return;

			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(4718).content, [tinfo.name, tinfo.value1, tinfo.value2]), new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}


		public function updateInfo(xml:XML):void {

//			if (xml.@MR_Level == "10") {
//				this.iconImg.updateBmp("ui/arena/icon_arena_10.png");
//				this.itemIcon.updateBmp("ui/arena/arena_10.png");
//			} else {
//				this.iconImg.updateBmp("ui/arena/icon_arena_0" + xml.@MR_Level + ".png");

//				if (xml.@MR_Level == "1")
//					this.iconImg.bitmapData=null;
//				else
			this.iconImg.updateBmp("ui/arena/arena_0" + xml.@MR_Level + ".png");
//			}

			this.mName=xml.@MR_Name;
			this.mtitleid=xml.@MR_Title;

			this.nameLbl.text="" + xml.@MR_Name;

			if (xml.@MR_Level == "1")
				this.integralLbl.text="" + PropUtils.getStringEasyById(2383) + String(xml.@MR_PNum).split("|")[0];
			else if (xml.@MR_Level == "7")
				this.integralLbl.text="" + StringUtil.substitute(PropUtils.getStringEasyById(1641), [1]);
			else
				this.integralLbl.text="" + StringUtil.substitute(PropUtils.getStringEasyById(1641), [String(xml.@MR_PNum).replace("|", "-")]);

//			this.numTopLbl.text="" + xml.@MR_PNum;

			var _x:Number=238;
			var _w:Number=49;

			if (xml.@MR_Level == "1") {

				var lb:Label=new Label(PropUtils.getStringById(1593));
//				this.addChild(lb);

				lb.x=_x;
				lb.y=20;

//				this.numTopLbl.text=PropUtils.getStringById(1594);
				this.effSwf.visible=false;
			} else {
				this.effSwf.visible=false;
				var grid:ArenaGrid;
				/**
								var grid:ArenaGrid=new ArenaGrid();

								grid.x=_x + this.gridVec.length * _w;
								grid.y=8;

								grid.updateMoney()
								grid.setNum(xml.@MR_Money);

								this.addChild(grid);
								this.gridVec.push(grid);

								grid=new ArenaGrid();
								grid.x=_x + this.gridVec.length * _w;
								grid.y=8;

								grid.updateHun();
								grid.setNum(xml.@MR_Energy);

								this.addChild(grid);
								this.gridVec.push(grid);

								grid=new ArenaGrid();
								grid.x=_x + this.gridVec.length * _w;
								grid.y=8;

								grid.updateHounur();
								grid.setNum(xml.@MR_Honor);
								grid.dataId=65526

								this.addChild(grid);
								this.gridVec.push(grid);
				*/
				var item:Object=TableManager.getInstance().getItemInfo(xml.@MR_Item1);
				if (item == null)
					item=TableManager.getInstance().getEquipInfo(xml.@MR_Item1);

//				if (item == null)
//					return;

				grid=new ArenaGrid();
				grid.x=_x + this.gridVec.length * _w;
				grid.y=8;

				grid.updataInfo(item);
				grid.setNum(xml.@MR_INum1);

				this.addChild(grid);
				this.gridVec.push(grid);

//				if (!xml.hasOwnProperty("MR_Item2") || xml.@MR_Item2 == "")
//					return;

				item=TableManager.getInstance().getItemInfo(xml.@MR_Item2);
				if (item == null)
					item=TableManager.getInstance().getEquipInfo(xml.@MR_Item2);

				grid=new ArenaGrid();
				grid.x=_x + this.gridVec.length * _w;
				grid.y=8;

				grid.updataInfo(item);
				grid.setNum(xml.@MR_INum2);

				this.addChild(grid);
				this.gridVec.push(grid);


//				if (!xml.hasOwnProperty("MR_Item3") || xml.@MR_Item3 == "")
//					return;

				item=TableManager.getInstance().getItemInfo(xml.@MR_Item3);
				if (item == null)
					item=TableManager.getInstance().getEquipInfo(xml.@MR_Item3);

				grid=new ArenaGrid();
				grid.x=_x + this.gridVec.length * _w;
				grid.y=8;

				grid.updataInfo(item);
				grid.setNum(xml.@MR_INum3);

				this.addChild(grid);
				this.gridVec.push(grid);
			}


//			this.scrollRect=new Rectangle(0,0,386,57);
		}

		public function flyBag():void {

			var flyArr:Array=[[], []];
			for (var i:int=0; i < this.gridVec.length; i++) {
				flyArr[0].push(this.gridVec[i].dataId);
				flyArr[1].push(this.gridVec[i].parent.localToGlobal(new Point(this.gridVec[i].x, this.gridVec[i].y)));
			}

			FlyManager.getInstance().flyBags(flyArr[0], flyArr[1]);
		}


		public function setHight(v:Boolean):void {
			this.bgHightImg.visible=v;
		}

		override public function get height():Number {
			return 57;
		}

	}
}
