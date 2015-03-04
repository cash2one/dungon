package com.ace.gameData.table {

	public class TAd {

		/**
		*/
		public var Id:int;

		/**
		*	前置ID
		*/
		public var frId:int;

		/**
		*	引用图片
		*/
		public var image:String;

		/**
		*	引用动画
		*/
		public var pnc:int;

		/**
		*	开启级别
		*/
		public var lv:int;

		/**
		*	切换间隔(s)
		*/
		public var time:int;


		public var openId:String;



		public function TAd(data:XML=null) {
			if (data == null)
				return;

			this.Id=data.@Id;
			this.frId=data.@frId;
			this.image=data.@image;
			this.pnc=data.@pnc;
			this.lv=data.@lv;
			this.time=data.@time;
			this.openId=data.@openId;
		}



	}
}
