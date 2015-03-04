package com.ace.ui.accordion{
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.button.GroupButton;
	import com.ace.ui.lable.Label;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class LabelButton extends GroupButton {

		private var _titleLbl:Label;
		private var _numLbl:Label;

		public function LabelButton(bd:BitmapData, rect:Rectangle, w:int, h:int, $gpName:String=null, selfClose:Boolean=false) {

			var scal:ScaleBitmap=new ScaleBitmap(bd);
			scal.scale9Grid=rect;
			scal.setSize(w, h * 3);

			super(scal.bitmapData, $gpName, selfClose);

			_titleLbl=new Label("");
			_titleLbl.height=20;
			_titleLbl.width=40;
	
			_titleLbl.x=(this.width - _titleLbl.width) / 2;
			_titleLbl.y=(this.height - _titleLbl.height) / 2;
			this.addChild(_titleLbl);

			_numLbl=new Label("");
			_numLbl.height=20;
			_numLbl.x=_titleLbl.x + _titleLbl.width + 10;
			_numLbl.y=_titleLbl.y;
			this.addChild(_numLbl);

		}

		override protected function mouseOver(e:MouseEvent):void {
			super.mouseOver(e);
		}

		override protected function mouseOut(e:MouseEvent):void {
			super.mouseOut(e);
		}

		override protected function mouseClick(e:Event):void {
			super.mouseClick(e);
			 
		}

		public function setTitleTxt(v:String):void {
			this._titleLbl.text=v;
			
			_titleLbl.x=(this.width - _titleLbl.width) / 2;
			_titleLbl.y=(this.height - _titleLbl.height) / 2;
		}

		public function setTitleX(x:Number):void {
			this._titleLbl.x=x;
		}

		public function setTitleY(y:Number):void {
			this._titleLbl.y=y;
		}

		public function getTitleLbl():Label {
			return this._titleLbl;
		}

		public function setNumTxt(v:String):void {
			this._numLbl.text=v;
			
			_numLbl.x=_titleLbl.x + _titleLbl.width + 10;
			_numLbl.y=_titleLbl.y;
		}
		
		public function setNumX(x:Number):void {
			this._numLbl.x=x;
		}
		
		public function setNumY(y:Number):void {
			this._numLbl.y=y;
		}
		
		public function getNumLbl():Label {
			return this._numLbl;
		}

		public function set selfclose(v:Boolean):void{
			this.selfClose=v;
		}
		

	}
}
