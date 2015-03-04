package com.leyou.ui.monsterInvade.child {

	import com.ace.enum.TipEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.leyou.enum.ConfigEnum;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MonsterInvadeRender1 extends AutoSprite {

		private var topVec:Vector.<MonsterInvadeList>;

		public function MonsterInvadeRender1() {
			super(LibManager.getInstance().getXML("config/ui/monsterInvade/monsterInvadeRender1.xml"));
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {

			this.topVec=new Vector.<MonsterInvadeList>();

			var monlist:MonsterInvadeList;
			for (var i:int=0; i < 10; i++) {
				monlist=new MonsterInvadeList();
				this.addChild(monlist);

//				if (i < 3) {
					monlist.addEventListener(MouseEvent.MOUSE_OVER, onTipMouseOver);
					monlist.addEventListener(MouseEvent.MOUSE_OUT, onTipMouseOut);
//				} else {
//					monlist.setIconState(false);
//				}

				monlist.x=3;
				monlist.y=i * monlist.height;

				this.topVec.push(monlist);
			}

		}

		private function onTipMouseOver(e:MouseEvent):void {
			var str:Array=["一", "二", "三","四","五","六","七","八","九","十"];
			var val:Array=[ConfigEnum.DemonInvasion9,ConfigEnum.DemonInvasion10,ConfigEnum.DemonInvasion11,ConfigEnum.DemonInvasion15,ConfigEnum.DemonInvasion16,ConfigEnum.DemonInvasion17,ConfigEnum.DemonInvasion18,ConfigEnum.DemonInvasion19,ConfigEnum.DemonInvasion20,ConfigEnum.DemonInvasion21];
			
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, "造成伤害<font size='18' color='#ffff00'>第" + str[this.topVec.indexOf(e.target as MonsterInvadeList)] + "名</font>可获取&#13;&#13;金币:"+val[this.topVec.indexOf(e.target as MonsterInvadeList)] , new Point(e.stageX, e.stageY));
		}

		private function onTipMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		override public function get height():Number {
			return 283;
		}

		public function updateInfo(o:Array):void {

			for (var i:int=0; i < 10; i++) {
				if (o == null || o.length == 0 || o[i] == null)
					this.topVec[i].updateInfo(["", ""]);
				else
					this.topVec[i].updateInfo(o[i]);
			}

		}

	}
}
