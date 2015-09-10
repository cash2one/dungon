/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-11-28 下午4:28:56
 */
package com.ace.ui.toolTip {
	import com.ace.ICommon.ITip;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.manager.LayerManager;
	import com.ace.manager.MouseManager;
	import com.ace.tools.SpriteNoEvt;
	import com.ace.ui.toolTip.children.ToolTip;
	import com.ace.utils.DebugUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class MToolTipManager {
		
		/**当前tip*/
		protected var dis:DisplayObject; //显示tip的对象
		protected var tipCon:SpriteNoEvt;
		protected var tipsDic:Object; //实例字典
		protected var classDic:Object; //类字典
		private var stg:Stage;
		private var _dir:int;
		
		// TIP矩形(碰撞检测用)
		private var tipRect:Rectangle;
		// 象限矩形(碰撞检测用)
		private var areaRect:Rectangle;
		
		public function MToolTipManager() {
			this.init();
		}
		
		private function init():void {
			this.tipsDic={};
			this.classDic={};
			this.addClass();
			this.tipRect=new Rectangle();
			this.areaRect=new Rectangle();
			this.tipCon=new SpriteNoEvt();
			//			this.tipCon.opaqueBackground=0xF3434;
			this.tipCon.visible=false;
			LayerManager.getInstance().clientTipLayer.addChild(this.tipCon);
		}
		
		private function onMouseOut(evt:MouseEvent):void {
			this.hide();
		}
		
		/**添加不同类型的tip*/
		protected function addClass():void {
			this.classDic[TipEnum.TYPE_DEFAULT]=ToolTip;
		}
		
		/**隐藏tip*/
		public function hide():void {
			if (this.tipCon) {
				this.tipCon.visible=false;
				this.clearTipCon();
			}
			DelayCallManager.getInstance().del(this.updatePs);
//			trace("关闭Tip")
		}
		
		/**显示tip，默认不隐藏*/
		public function showNoHide(type:int, info:*, pt:Point, $dis:DisplayObject=null):Boolean {
			var bln:Boolean=this.showII([type], [info], 1, null, pt, $dis);
			MouseManager.getInstance().removeFun(MouseEvent.MOUSE_OUT, onMouseOut);
			return bln;
		}
		
		/**
		 * 显示tip信息
		 * @param type tip类型
		 * @param info tip对应的新信息
		 * @param pt   tip显示的位置，【要显示Tip的对象】localToGlobal+自定偏移
		 *
		 */
		public function show(type:int, info:*, pt:Point, $dis:DisplayObject=null):Boolean {
			return this.showII([type], [info], 1, null, pt, $dis);
		}
		
		/**
		 *
		 * @param types tip类型数组
		 * @param infos tip的数据
		 * @param dir 方向
		 * @param tipPt 第二个tip的位置偏移
		 * @param mousePt tip的位置显示
		 * @return
		 *
		 */
		public function showII(types:Array, infos:Array, dir:int, tipPt:Point, mousePt:Point, $dis:DisplayObject=null):Boolean {
			if (!MouseManager.getInstance().hasFun(MouseEvent.MOUSE_OUT, this.onMouseOut))
				MouseManager.getInstance().addFun(MouseEvent.MOUSE_OUT, onMouseOut);
			this.clearTipCon();
			this.dis=$dis;
			_dir = dir;
			var tmpTip:ITip;
			for (var i:int=0; i < types.length; i++) {
				this.initTips(types[i]);
				tmpTip=this.tipsDic[types[i]];
				tmpTip.updateInfo(infos[i]);
				tmpTip.x=tmpTip.y=0;
				this.tipCon.addChild(tmpTip as DisplayObject);
				if (i == 1) {
					switch (dir) {
						// 上
						case 0:
							tmpTip.x=tipPt.x;
							tmpTip.y=-tmpTip.height + tipPt.y;
							break;
						// 右
						case 2:
							tmpTip.x=this.tipsDic[types[i - 1]].width + tipPt.x;
							tmpTip.y=tipPt.y;
							break;
						// 下
						case 4:
							tmpTip.x=tipPt.x;
							tmpTip.y=this.tipsDic[types[i - 1]].height + tipPt.y;
							break;
						// 左
						case 6:
							tmpTip.x=-this.tipsDic[types[i - 1]].width + tipPt.x;
							tmpTip.y=tipPt.y;
							break;
					}
				}
			}
			//			this.updatePs(mousePt);
			DelayCallManager.getInstance().add(this, this.updatePs, "updatePs", 3, mousePt);
			return false;
		}
		
		private function clearTipCon():void {
			while (this.tipCon.numChildren) {
				this.tipCon.removeChildAt(0);
			}
		}
		
		/**初始化指定类型tip*/
		protected function initTips(type:int):void {
			var tmpTip:ITip;
			if (!this.tipsDic[type]) {
				var cls:Class=this.classDic[type];
				if (!cls)
					DebugUtil.throwError("tip类型没有添加");
				tmpTip=new cls();
				this.tipsDic[type]=tmpTip;
			}
		}
		
		//		/**更新tip位置*/
		//		private function updatePsII(pt:Point):void {
		//			pt.x > (UIEnum.WIDTH - this.tipCon.width - 3) && (pt.x=UIEnum.WIDTH - this.tipCon.width - 3);
		//			pt.x < 0 && (pt.x=0);
		//			pt.y > (UIEnum.HEIGHT - this.tipCon.height) && (pt.y=UIEnum.HEIGHT - this.tipCon.height - 3);
		//			
		//			this.tipCon.x=pt.x;
		//			this.tipCon.y=pt.y;
		//			this.tipCon.visible=true;
		//		}
		
		/**更新tip位置*/
		private function updatePs(pt:Point):void {
			var wh:Point=new Point();
			
			//			if (this.dis) {
			//				wh.x=this.dis.width >> 1;
			//				wh.y=this.dis.height >> 1;
			//				pt=this.dis.parent.localToGlobal(new Point(this.dis.x + wh.x, this.dis.y + wh.y));
			//			} else {
			//				wh.x=UIEnum.MOUSE_ICO_WIDTH;
			//				wh.y=UIEnum.MOUSE_ICO_HEIGHT;
			//				pt.x=MouseManager.getInstance().stg.mouseX;
			//				pt.y=MouseManager.getInstance().stg.mouseY;
			//			}
			//			if ((pt.x + wh.x + this.tipCon.width) <= UIEnum.WIDTH && (pt.y + wh.y + this.tipCon.height) <= UIEnum.HEIGHT) {
			//				pt.x+=wh.x;
			//				pt.y+=wh.y;
			//			} else if ((pt.x - wh.x - this.tipCon.width) >= 0 && (pt.y + wh.y + this.tipCon.height) <= UIEnum.HEIGHT) {
			//				pt.x-=(this.tipCon.width + wh.x);
			//				pt.y+=wh.y;
			//			} else if ((pt.x + wh.x + this.tipCon.width) <= UIEnum.WIDTH && (pt.y - wh.y - this.tipCon.height) >= 0) {
			//				pt.x+=wh.x;
			//				pt.y-=(this.tipCon.height + wh.y);
			//			} else if ((pt.x - wh.x - this.tipCon.width) >= 0 && (pt.y - wh.y - this.tipCon.height >= 0)) {
			//				pt.x-=(this.tipCon.width + wh.x);
			//				pt.y-=(this.tipCon.height + wh.y);
			//			} else {
			//				pt.x > (UIEnum.WIDTH - this.tipCon.width) && (pt.x=UIEnum.WIDTH - this.tipCon.width - 3);
			//				pt.x < 0 && (pt.x=0);
			//				pt.y > (UIEnum.HEIGHT - this.tipCon.height) && (pt.y=UIEnum.HEIGHT - this.tipCon.height - 3);
			//			}
			
			
			// 得到起始点和偏移量
			if (this.dis) {
				wh.x=this.dis.width >> 1;
				wh.y=this.dis.height >> 1;
				pt=this.dis.parent.localToGlobal(new Point(this.dis.x + wh.x, this.dis.y + wh.y));
			} else {
				wh.x=UIEnum.MOUSE_ICO_WIDTH;
				wh.y=UIEnum.MOUSE_ICO_HEIGHT;
				pt.x=MouseManager.getInstance().stg.mouseX;
				pt.y=MouseManager.getInstance().stg.mouseY;
			}
			
			//------------------------------------------------------------------
			// WFH修改
			// TIP的宽高 -- 2015.5.29这样重写TIP的宽高不起效果改为下面一种计算方法
			//			tipRect.width=tipCon.width;
			//			tipRect.height=tipCon.height;
			
			// TIP的宽高 -- 新计算方式
			tipRect.height = 0;
			tipRect.width = tipCon.width;
			if((0 == _dir) || (4 == _dir) || (1 == _dir)){
				var cnum:int = tipCon.numChildren;
				while((0 != cnum)){
					cnum--;
					tipRect.height += tipCon.getChildAt(cnum).height;
				}
			}else{
				tipRect.height = tipCon.height;
			}
			//------------------------------------------------------------------
			
			// 矩形碰撞检测开始,从第四象限开始,初始化第四象限的矩形
			areaRect.x=pt.x + wh.x;
			areaRect.y=pt.y + wh.y;
			areaRect.width=UIEnum.WIDTH - areaRect.x;
			areaRect.height=UIEnum.HEIGHT - areaRect.y;
			// 检测第四象限是否可以容纳
			tipRect.x=areaRect.x;
			tipRect.y=areaRect.y;
			if (areaRect.containsRect(tipRect)) {
				setTipPos(tipRect);
				//				trace("--------------第四象限")
				return;
			}
			// 第二象限
			areaRect.x=pt.x + wh.x;
			areaRect.y=0;
			areaRect.width=UIEnum.WIDTH - areaRect.x;
			areaRect.height=pt.y - wh.y;
			tipRect.x=areaRect.x;
			tipRect.y=areaRect.height - tipRect.height;
			if (areaRect.containsRect(tipRect)) {
				setTipPos(tipRect);
				//				trace("--------------第二象限")
				return;
			}
			// 第一象限
			areaRect.x=0;
			areaRect.y=0;
			areaRect.width=pt.x - wh.x;
			areaRect.height=pt.y - wh.y;
			tipRect.x=areaRect.width - tipRect.width;
			tipRect.y=areaRect.height - tipRect.height;
			if (areaRect.containsRect(tipRect)) {
				setTipPos(tipRect);
				//				trace("--------------第一象限")
				return;
			}
			// 第三象限
			areaRect.x=0;
			areaRect.y=pt.y + wh.y;
			areaRect.width=pt.x - wh.x;
			areaRect.height=UIEnum.HEIGHT - areaRect.y;
			tipRect.x=areaRect.width - tipRect.width;
			tipRect.y=areaRect.y;
			if (areaRect.containsRect(tipRect)) {
				setTipPos(tipRect);
				//				trace("--------------第三象限")
				return;
			}
			// 二四象限组合
			areaRect.x=pt.x + wh.x;
			areaRect.y=0;
			areaRect.width=UIEnum.WIDTH - areaRect.x;
			areaRect.height=UIEnum.HEIGHT;
			tipRect.x=areaRect.x;
			tipRect.y=UIEnum.HEIGHT - tipRect.height;
			if (areaRect.containsRect(tipRect)) {
				setTipPos(tipRect);
				//				trace("--------------第二四象限")
				return;
			}
			// 一三象限组合
			areaRect.x=0;
			areaRect.y=0;
			areaRect.width=pt.x - wh.x;
			areaRect.height=UIEnum.HEIGHT;
			tipRect.x=areaRect.width - tipRect.width;
			tipRect.y=UIEnum.HEIGHT - tipRect.height;
			if (areaRect.containsRect(tipRect)) {
				setTipPos(tipRect);
				//				trace("--------------第一三象限")
				return;
			}
			// 三四象限
			areaRect.x=0;
			areaRect.y=pt.y + wh.y;
			areaRect.width=UIEnum.WIDTH;
			areaRect.height=UIEnum.HEIGHT - areaRect.y;
			tipRect.x=UIEnum.WIDTH - tipRect.width;
			tipRect.y=areaRect.y;
			if (areaRect.containsRect(tipRect)) {
				setTipPos(tipRect);
				//				trace("--------------第三四象限")
				return;
			}
			// 一二象限
			areaRect.x=0;
			areaRect.y=0;
			areaRect.width=UIEnum.WIDTH;
			areaRect.height=pt.y - wh.y;
			tipRect.x=UIEnum.WIDTH - tipRect.width;
			tipRect.y=UIEnum.HEIGHT - tipRect.height;
			if (areaRect.containsRect(tipRect)) {
				setTipPos(tipRect);
				//				trace("--------------第一二象限")
				return;
			}
			
			// 没有合适的象限
			tipRect.x=UIEnum.WIDTH - tipRect.width;
			tipRect.y=UIEnum.HEIGHT - tipRect.height;
			setTipPos(tipRect);
			//			trace("--------------无匹配")
		}
		
		private function setTipPos(rect:Rectangle):void {
			this.tipCon.x=rect.x;
			this.tipCon.y=rect.y;
			this.tipCon.visible=true;
//			trace("显示Tip")
		}
		
		
		public function get tipPs():Point {
			return new Point(this.tipCon.x, this.tipCon.y);
		}
		
		public function get isShow():Boolean {
			trace("是否显示Tip：",this.tipCon.visible);
			return this.tipCon.visible;
		}
		
		public function getWidth():Number {
			return this.tipCon.width;
		}
	}
}
















