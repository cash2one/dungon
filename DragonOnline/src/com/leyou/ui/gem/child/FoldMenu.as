package com.leyou.ui.gem.child {

	import com.ace.manager.LibManager;
	import com.ace.ui.accordion.LabelButton;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.data.celebrate.AreaCelebrateData;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class FoldMenu extends Sprite {

		private var renderArr:Array=[];
		private var treeArr:Array=[];

		private var currentPosition:Array=[];

		private var deep:int=0;
		private var _y:int=0;
		private var space:Number=5;

		private var scroll:ScrollPane;

		private var _w:Number=0;
		private var _h:Number=0;

		public function FoldMenu(w:Number=200, h:Number=400) {
			super();
			this._w=w;
			this._h=h;
			this.init();
		}

		private function init():void {

			this.scroll=new ScrollPane(this._w, this._h);
			this.addChild(this.scroll);

			this.treeArr["0"]=(true);
			this.addEventListener(MouseEvent.CLICK, onClick);
		}

		public function addItem(dis:DisplayObjectContainer, pos:String):void {

			var i:int=0;

			this.scroll.addToPane(dis);

			var tpos:int=this.getTree(pos);
			var key:String=pos + "_" + tpos;
			this.renderArr[key]=dis;

			this.treeArr[key]=false;

		}

		public function updateInfo():void {
			this.updatePs();
		}

		private function updatePs():void {
			this.deep=0;
			this._y=0;
			this.updatedeep();
		}

		private function updatedeep(key:String="0"):void {

			var dis:DisplayObjectContainer;
			var str:String;
			var p:int=key.split("_").length;

			var _x:int=0;
			var _w:int=0;

			if (key != "0") {
				_x=(p - 1) * 5;
			}

			var i:int=0;

			this.deep++;

			var oarr:Array=[];
			var arr:Array=[];
			for (str in this.treeArr) {
				arr=str.split("_");
				if (str.indexOf(key) == 0 && arr.length == p + 1 && this.renderArr[key + "_" + i] != null) {

					dis=this.renderArr[key + "_" + i];

					if (this.treeArr[key]) {

						dis.visible=true;
						dis.x=_x;

						if (i == 0)
							_y+=4;

						dis.y=_y;

						_y+=dis.height - 1;

					} else {
						dis.visible=false;
					}

					this.updatedeep(key + "_" + i);

					i++;
				}


			}

		}


		public function getTree(pos:String):int {

			var i:int=0;
			var p:int=pos.split("_").length;
			var key:String;
			var arr:Array=[];
			for (key in this.renderArr) {
				arr=key.split("_");
				if (key.indexOf(pos) == 0 && arr.length == p + 1) {
					i++;
				}
			}

			return i;
		}

		private function onClick(e:MouseEvent):void {

			var key:String=this.getIndexByRender(e.target as DisplayObjectContainer);

			if (key == null)
				return;

			var str:String;
			for (str in this.treeArr) {
				if (str != "0") {
					if (str != key)
						this.treeArr[str]=false;

					if (this.renderArr[str] is LabelButton)
						LabelButton(this.renderArr[str]).turnOff();
				}
			}


			var arr:Array=key.split("_");
			str=arr[0] + "_";
			for (var i:int=1; i < arr.length; i++) {
				str+=arr[i];
				this.treeArr[str]=!this.treeArr[str];

				if (this.renderArr[str] is LabelButton) {
					if (this.treeArr[str])
						LabelButton(this.renderArr[str]).turnOn();
					else
						LabelButton(this.renderArr[str]).turnOff();
				}

				str+="_";
			}

			this.updateInfo();

		}

		private function getIndexByRender(d:DisplayObjectContainer):String {
			var str:String;
			for (str in this.renderArr) {
				if (this.renderArr[str] == d)
					return str;
			}

			return null;
		}

		public function getItem(pos:Array):Array {
			var o:Array=this.renderArr[pos[0]];

			for (var i:int=1; i < pos.length; i++) {
				o=o[pos[i]];
			}

			return o;
		}

	}
}
