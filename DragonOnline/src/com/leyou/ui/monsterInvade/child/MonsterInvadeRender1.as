package com.leyou.ui.monsterInvade.child {

	import com.ace.enum.TipEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.utils.PropUtils;
	
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
			var str:Array=[PropUtils.getStringById(1659), PropUtils.getStringById(1660), PropUtils.getStringById(1661), PropUtils.getStringById(1662), PropUtils.getStringById(1663),PropUtils.getStringById(1664), PropUtils.getStringById(1796), PropUtils.getStringById(1797), PropUtils.getStringById(1798), PropUtils.getStringById(1799)];
			var val:Array=[ConfigEnum.DemonInvasion9, ConfigEnum.DemonInvasion10, ConfigEnum.DemonInvasion11, ConfigEnum.DemonInvasion15, ConfigEnum.DemonInvasion16, ConfigEnum.DemonInvasion17, ConfigEnum.DemonInvasion18, ConfigEnum.DemonInvasion19, ConfigEnum.DemonInvasion20, ConfigEnum.DemonInvasion21];

			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(PropUtils.getStringById(1800),[str[this.topVec.indexOf(e.target as MonsterInvadeList)]]) + val[this.topVec.indexOf(e.target as MonsterInvadeList)], new Point(e.stageX, e.stageY));
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
