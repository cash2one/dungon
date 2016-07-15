package com.leyou.ui.dragonBall.children {

	import com.ace.ICommon.ISort;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TDragonBallPropertyInfo;
	import com.ace.manager.GuideArrowDirectManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.dargonball.DragonBallData;
	import com.leyou.net.cmd.Cmd_Longz;
	import com.leyou.util.ZDLUtil;

	import flash.events.MouseEvent;

	public class DragonBallPropertyRender extends AutoSprite {

		public var allProperitys:Vector.<DragonBallPropertyItem>;
		public var attackProperitys:Vector.<DragonBallPropertyItem>;
		public var defentProperitys:Vector.<DragonBallPropertyItem>;

		private var plusImg:Image;

		private var zdlNum:RollNumWidget;

		private var addZdlNum:RollNumWidget;

		private var saveBtn:NormalButton;
		private var autoBtn:NormalButton;

//		private var shortcutBtn:NormalButton;

		private var costLbl:Label;

		private var lhLbl:Label;

		private var otherPlay:Boolean=false;

		public function DragonBallPropertyRender(other:Boolean=false) {
			super(LibManager.getInstance().getXML("config/ui/dragonBall/dragonBall3Render.xml"));
			this.otherPlay=other;
			init();
		}

		private function init():void {
			mouseChildren=true;
			costLbl=getUIbyID("costLbl") as Label;
			plusImg=getUIbyID("plusImg") as Image;
			lhLbl=getUIbyID("lhLbl") as Label;
			saveBtn=getUIbyID("saveBtn") as NormalButton;
			autoBtn=getUIbyID("autoBtn") as NormalButton;
//			shortcutBtn = getUIbyID("shortcutBtn") as NormalButton;
			plusImg.visible=false;
			zdlNum=new RollNumWidget();
			addZdlNum=new RollNumWidget();
			zdlNum.loadSource("ui/num/{num}_zdl.png");
			addZdlNum.loadSource("ui/num/{num}_zdl.png");
			zdlNum.alignRound();
			addZdlNum.alignLeft();

			addChild(zdlNum);
			addChild(addZdlNum);

			zdlNum.x=152;
			zdlNum.y=409;
			addZdlNum.y=409;
			addZdlNum.visible=false;

			var aIndex:int;
			var dIndex:int;
			attackProperitys=new Vector.<DragonBallPropertyItem>();
			defentProperitys=new Vector.<DragonBallPropertyItem>();
			allProperitys=new Vector.<DragonBallPropertyItem>();

			var properityDic:Object=TableManager.getInstance().getDragonBallPropertyDic();

			for (var key:String in properityDic) {

				var info:TDragonBallPropertyInfo=properityDic[key];
				var properityItem:DragonBallPropertyItem=new DragonBallPropertyItem();

				properityItem.registerListener(onAddDegree);
				properityItem.updateInfo(info);
				addChild(properityItem);

				if (1 == info.propertyType) {
					// 攻击属性
					attackProperitys.push(properityItem);
					properityItem.x=263;
					properityItem.y=36 + aIndex * 65;
					aIndex++;

				} else if (2 == info.propertyType) {

					// 防御属性
					defentProperitys.push(properityItem);
					properityItem.x=12;
					properityItem.y=36 + dIndex * 65;
					dIndex++;
				}
				allProperitys.push(properityItem);

			}

			lhLbl.x=385;
			saveBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			autoBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			shortcutBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			shortcutBtn.visible = false;

			this.x=3;
		}

		protected function onMouseClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "saveBtn":
					GuideArrowDirectManager.getInstance().delArrow(WindowEnum.ROLE + "");
					addProperty();
					break;
//				case "shortcutBtn":
//					Cmd_Longz.cm_Longz_Z();
//					break;
				case "autoBtn":
					this.onAutoClick();
					break;
			}
		}

		/**排序比较1*/
		private function compare(a:DragonBallPropertyItem, b:DragonBallPropertyItem):Number {
			return a.recordNum - b.recordNum;
		}

		private function onAutoClick():void {
			this.allProperitys.sort(this.compare);

//			for (var i2:int=0; i2 < this.allProperitys.length; i2++) {
//				trace(this.allProperitys[i2].recordNum);
//			}

			var lh:int=UIManager.getInstance().backpackWnd.lh;
			var render:DragonBallPropertyItem;
			var add:int;
			var j:int;
			var add2:int;
			while (lh > 0) {
				j++;
				if (j >= this.allProperitys.length) {
					add=int(lh / 9);
					if (add == 0)
						add=1;
					for (var k:int=0; k < this.allProperitys.length; k++) {
						this.allProperitys[k].preAdd(add);
						lh-=add;
					}
				} else {
//					trace("大循环");
					var currentValue:int=this.allProperitys[j].recordNum;
					if (lh < (currentValue - this.allProperitys[i].preTotal) * j) {
						add2=lh / j;
					}

					for (var i:int=0; i < j; i++) {
						render=this.allProperitys[i];
						add=add2 ? add2 : (currentValue - render.preTotal);
//						trace("小循环：", i, add);
						render.preAdd(add);
						lh-=add;
					}
				}

			}
		}


		private function onAutoClick2():void {
			var total:int=UIManager.getInstance().backpackWnd.lh;
			if (total == 0)
				return;

			var saitem:DragonBallPropertyItem;
			for each (saitem in attackProperitys) {
				total+=saitem.getPropertyValue();
			}
			for each (saitem in defentProperitys) {
				total+=saitem.getPropertyValue();
			}

			var average:int=int(total / 9);
			if (average == 0)
				average=1;


			for each (saitem in attackProperitys) {
				if (saitem.getPropertyValue() < average) {
					saitem.preAdd(average - saitem.getPropertyValue());
				}
			}
			for each (saitem in defentProperitys) {
				if (saitem.getPropertyValue() < average) {
					saitem.preAdd(average - saitem.getPropertyValue());
				}
			}
		}

		private function addProperty():void {
			var lastItem:DragonBallPropertyItem;
			for each (var saitem:DragonBallPropertyItem in attackProperitys) {
				if (0 < saitem.getPropertyValue()) {
					if (null == lastItem) {
						lastItem=saitem;
						continue;
					}
					Cmd_Longz.cm_Longz_P(saitem.id, saitem.getPropertyValue());
				}
			}
			for each (var sditem:DragonBallPropertyItem in defentProperitys) {
				if (0 < sditem.getPropertyValue()) {
					if (null == lastItem) {
						lastItem=sditem;
						continue;
					}
					Cmd_Longz.cm_Longz_P(sditem.id, sditem.getPropertyValue());
				}
			}
			if (null != lastItem) {
				Cmd_Longz.cm_Longz_P(lastItem.id, lastItem.getPropertyValue(), 1);
			}
		}

		protected function onAddDegree(item:DragonBallPropertyItem):void {
			regreshRemainProperty();
			plusImg.x=zdlNum.x + zdlNum.width / 2;
			addZdlNum.x=plusImg.x + plusImg.width;
			var zdl:int=ZDLUtil.computation(defentProperitys[0].getPropertyValue(), 0, attackProperitys[0].getPropertyValue(), defentProperitys[1].getPropertyValue(), 0, 0, attackProperitys[1].getPropertyValue(), defentProperitys[2].getPropertyValue(), attackProperitys[2].getPropertyValue(), defentProperitys[3].getPropertyValue(), attackProperitys[3].getPropertyValue(), defentProperitys[4].getPropertyValue(), 0, 0);
			addZdlNum.setNum(zdl);
			addZdlNum.visible=(zdl > 0);
			plusImg.visible=(zdl > 0);
		}

		private function regreshRemainProperty():void {
			var value:int=UIManager.getInstance().backpackWnd.lh;
			for each (var aitem:DragonBallPropertyItem in attackProperitys) {
				value-=aitem.getUsedVlaue();
			}
			for each (var ditem:DragonBallPropertyItem in defentProperitys) {
				value-=ditem.getUsedVlaue();
			}
//			trace("================================")
			for each (var saitem:DragonBallPropertyItem in attackProperitys) {
				saitem.setLimit(value + saitem.getUsedVlaue());
			}
			for each (var sditem:DragonBallPropertyItem in defentProperitys) {
				sditem.setLimit(value + sditem.getUsedVlaue());
			}
//			trace("================================")

			if (otherPlay)
				costLbl.text="???";
			else
				costLbl.text=(UIManager.getInstance().backpackWnd.lh - value) + "";
		}

		public function updateInfo():void {

			var data:DragonBallData=DataManager.getInstance().dragonBallData;

			if (otherPlay)
				data=DataManager.getInstance().dragonBallDataII;

			var properityDic:Object=TableManager.getInstance().getDragonBallPropertyDic();
			var attributes:Object=data.attributes;

			for each (var aitem:DragonBallPropertyItem in attackProperitys) {
				aitem.updateCurrentValue(attributes[aitem.id]);
			}

			for each (var ditem:DragonBallPropertyItem in defentProperitys) {
				ditem.updateCurrentValue(attributes[ditem.id]);
			}

			var zdl:int=ZDLUtil.computation(attributes[1], 0, attributes[4], attributes[5], 0, 0, attributes[8], attributes[9], attributes[10], attributes[11], attributes[12], attributes[13], 0, 0);
			zdlNum.setNum(zdl);
			regreshRemainProperty();
			costLbl.text="0";
			addZdlNum.visible=false;
			plusImg.visible=false;

			if (otherPlay) {
				lhLbl.text="???";
				costLbl.text="???";
			} else {
				lhLbl.text=UIManager.getInstance().backpackWnd.lh + "";
				costLbl.text="0";
			}
		}

		public function get costHL():int{
			return int(this.costLbl.text);
		}
		public function get resultHL():int{
			return UIManager.getInstance().backpackWnd.lh-this.costHL;
		}
		public function updateLh():void {
			if (otherPlay)
				lhLbl.text="???";
			else
				lhLbl.text=UIManager.getInstance().backpackWnd.lh + "";
		}
	}
}
