package com.leyou.ui.message.child {
	import com.ace.enum.GuideEnum;
	import com.ace.gameData.table.TGuideInfo;
	import com.ace.gameData.table.TSeGuild;
	import com.ace.ui.guide.GuidePointTip;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;

	public class GuidePointExt extends GuidePointTip {

		private var info:TSeGuild;

		public function GuidePointExt($url:String, $type:int) {
			super($url, $type);
		}

		override public function valid():Boolean {
			if (!check) {
				return true;
			}
			if ((null != dis) && (null != info) && (null != parent)) {
				var p:DisplayObject=dis;
				while (p != root) {
					if ((null == p) || !p.visible) {
						return false;
					}
					p=p.parent;
				}
				return true;
			}
			return false;
		}


		override public function addToContainer(con:DisplayObjectContainer):Boolean {
			if ((null == dis) || (null == info)) {
				return false;
			}
			con.addChild(this);
//			var gPt:Point=dis.localToGlobal(new Point(int(info.arrowX), int(info.arrowY)));
//			this.x=gPt.x;
//			this.y=gPt.y;
			var ps:Point;
			if (dis) {

//				if (con != dis.parent) {
				ps=dis.parent.localToGlobal(new Point(dis.x, dis.y));
				ps=con.globalToLocal(ps);
//				} else {
//					ps=new Point(dis.x, dis.y);
//				}

				switch (int(info.arrowType)) {
					case GuideEnum.GUIDE_POINT_UP: //↑
						this.x=ps.x + dis.width / 2;
						this.y=ps.y + dis.height;
						break;
					case GuideEnum.GUIDE_POINT_DOWN: //↓
						this.x=ps.x - this.width / 2 + 32;
						this.y=ps.y - this.height;
						break;
					case GuideEnum.GUIDE_POINT_LEFT: //←
						this.x=ps.x + dis.width;
						this.y=ps.y - 10; // + dis.height / 2;
						break;
					case GuideEnum.GUIDE_POINT_RIGHT: //→
						this.x=ps.x;
						this.y=ps.y + dis.height / 2;
						break;
				}

				this.x+=int(info.arrowX);
				this.y+=int(info.arrowY);
			}
			return true;
		}

		override public function resize():void {
			if ((null != dis) && (null != info) && (null != parent)) {
//				var gPt:Point=dis.localToGlobal(new Point(int(info.arrowX), int(info.arrowY)));
//				this.x=gPt.x;
//				this.y=gPt.y;




			}
		}

		/**
		 *
		 * @param info
		 * @param $dis
		 *
		 */
		public function updateInfoExt(info:TSeGuild, $dis:DisplayObject):void {

			if (null == $dis) {
				throw new Error("要指引的显示对象为NULL,指引ID为:" + info.id);
			}

			dis=$dis;
			this.info=info;
			pointSwf.update(99916);
			desLbl.htmlText=info.arrowDes;
//			setTimer(info.time);
			updateDesPostion();
			//			dis.addChild(this);
//			this.x=dis.x;
//			this.y=dis.y;

		}

	}
}
