package com.leyou.ui.arena.childs {

	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TTitle;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ArenaAwardRender extends AutoSprite {

		private var iconImg:Image;
		private var integralLbl:Label;
		private var numTopLbl:Label;

		private var gridVec:Vector.<ArenaGrid>

		private var bgHightImg:Image;

		private var itemIcon:Image;
		private var mName:String;

		public function ArenaAwardRender() {
			super(LibManager.getInstance().getXML("config/ui/arena/arenaAwardRender.xml"));
			this.init();
		}

		private function init():void {
			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.bgHightImg=this.getUIbyID("bgHightImg") as Image;
			this.integralLbl=this.getUIbyID("integralLbl") as Label;
			this.numTopLbl=this.getUIbyID("numTopLbl") as Label;

			this.gridVec=new Vector.<ArenaGrid>();

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
			var tinfo:TTitle=TableManager.getInstance().getTitleByName(this.mName);
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(4718).content, [tinfo.name, tinfo.value3, tinfo.value2, tinfo.value1]), new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}


		public function updateInfo(xml:XML):void {

			if (xml.@MR_Level == "10") {
				this.iconImg.updateBmp("ui/arena/icon_arena_10.png");
				this.itemIcon.updateBmp("ui/arena/arena_10.png");
			} else {
				this.iconImg.updateBmp("ui/arena/icon_arena_0" + xml.@MR_Level + ".png");

				if (xml.@MR_Level == "1")
					this.itemIcon.bitmapData=null;
				else
					this.itemIcon.updateBmp("ui/arena/arena_0" + xml.@MR_Level + ".png");
			}

			this.mName=xml.@MR_Name;

			this.integralLbl.text="" + xml.@MR_Integral;
			this.numTopLbl.text="" + xml.@MR_PNum;

			var _x:Number=208;
			var _w:Number=43;

			if (xml.@MR_Level == "1") {

				var lb:Label=new Label("升级至 列兵 军衔即可获得奖励");
				this.addChild(lb);

				lb.x=_x;
				lb.y=10;

				this.numTopLbl.text="无";
			} else {

				var grid:ArenaGrid=new ArenaGrid();

				grid.x=_x + this.gridVec.length * _w;
				grid.y=8;

				grid.updateExp();
				grid.setNum(xml.@MR_Exp);
				grid.dataId=65534
				
				this.addChild(grid);
				this.gridVec.push(grid);

				grid=new ArenaGrid();
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

				var item:Object=TableManager.getInstance().getItemInfo(xml.@MR_Item1);
				if (item == null)
					item=TableManager.getInstance().getEquipInfo(xml.@MR_Item1);

				if (item == null)
					return;

				grid=new ArenaGrid();
				grid.x=_x + this.gridVec.length * _w;
				grid.y=8;

				grid.updataInfo(item);
				grid.setNum(xml.@MR_INum1);

				this.addChild(grid);
				this.gridVec.push(grid);

				if (!xml.hasOwnProperty("MR_Item2") || xml.@MR_Item2 == "")
					return;

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

		override public function get height():Number{
			return 57;
		}

	}
}
