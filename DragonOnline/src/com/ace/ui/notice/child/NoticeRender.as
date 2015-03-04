/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-10-21 下午6:10:56
 */
package com.ace.ui.notice.child {
	import com.ace.ICommon.IUse;

	public class NoticeRender extends NoticeLable implements IUse {
		internal static var TOTAL_NUM:int=0;

		private var _isInit:Boolean;
		private var _isUsed:Boolean;
		private var _useType:int;
		private var _useKey:String;
		private var _owner:Object;

		public function NoticeRender() {
			super();
			this._useKey=TOTAL_NUM.toString();
			TOTAL_NUM++;
		}

		public function set isInit(value:Boolean):void {
			this._isInit=value;
		}

		public function get isInit():Boolean {
			return this._isInit;
		}

		public function set isUsed(value:Boolean):void {
			this._isUsed=value;
		}

		public function get isUsed():Boolean {
			return this._isUsed;
		}


		public function set useKey(value:String):void {
			this._useKey=value;
		}

		public function get useKey():String {
			return this._useKey;
		}

		public function set useType(value:int):void {
			this._useType=value;
		}

		public function get useType():int {
			return this._useType;
		}

		public function set owner(value:Object):void {
			this._owner=value;
		}

		public function get owner():Object {
			return this._owner;
		}

		override public function free():void {
			this._isUsed=false;
			super.free();
			this.alpha=1;
		}

	}
}
