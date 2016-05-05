package com.ace.effect {
	import com.ace.ui.img.child.Image;
	
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class RotationBlackEffect extends Sprite {

		private var img:Image;
		private var centerPoint:Point;

		public function RotationBlackEffect(url:String) {
			super();

			img=new Image(url, okfunc, true);
			img.blendMode=BlendMode.ADD;
			this.addChild(img);
			
		}

		private function okfunc(img:Image):void {
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			if(this.img==null)
				return ;
			
			this.centerPoint=new Point(this.img.width / 2, this.img.height / 2);
			
			var m3:Matrix3D;
			if (this.img.transform.matrix3D == null) {
				m3=new Matrix3D();
			} else
				m3=this.img.transform.matrix3D;
			
			m3.prependTranslation(this.img.x, this.img.y, 0);
			m3.prependRotation(0, Vector3D.Z_AXIS, new Vector3D(this.img.width / 2, this.img.height / 2));
			
			this.img.transform.matrix3D=m3;
			
		}
		
		override public function set scaleX(value:Number):void{
			super.scaleX=value;
			
			this.centerPoint=new Point(this.img.width / 2, this.img.height / 2);
			
			var m3:Matrix3D;
			if (this.img.transform.matrix3D == null) {
				m3=new Matrix3D();
			} else
				m3=this.img.transform.matrix3D;
			
			m3.prependTranslation(this.img.x, this.img.y, 0);
			m3.prependRotation(0, Vector3D.Z_AXIS, new Vector3D(this.img.width / 2, this.img.height / 2));
			
			this.img.transform.matrix3D=m3;
		}
		
		override public function set scaleY(value:Number):void{
			super.scaleY=value;
			
			this.centerPoint=new Point(this.img.width / 2, this.img.height / 2);
			
			var m3:Matrix3D;
			if (this.img.transform.matrix3D == null) {
				m3=new Matrix3D();
			} else
				m3=this.img.transform.matrix3D;
			
			m3.prependTranslation(this.img.x, this.img.y, 0);
			m3.prependRotation(0, Vector3D.Z_AXIS, new Vector3D(this.img.width / 2, this.img.height / 2));
			
			this.img.transform.matrix3D=m3;
			
		}


		private function init():void {

		}

		private function onEnterFrame(e:Event):void {
 
			var m3:Matrix3D;
			m3=this.img.transform.matrix3D;
			m3.prependRotation(7, Vector3D.Z_AXIS, new Vector3D(this.centerPoint.x, this.centerPoint.y));
			this.img.transform.matrix3D=m3;
		}


	}
}
