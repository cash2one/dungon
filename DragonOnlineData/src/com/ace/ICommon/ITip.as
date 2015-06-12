package com.ace.ICommon {

	public interface ITip extends IDisplayObject {
		/**更新tip信息*/
		function updateInfo(info:Object):void;
		/**是否是主要的，主要的靠鼠标显示*/
		function get isFirst():Boolean;
		
	}
}
