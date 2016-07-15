package com.ace.gameData.table {

	public class TRed_package {

		/**
		 *	红包ID
		 */
		public var Red_ID:String;

		/**
		 *	红包名称
		 */
		public var Red_Name:String;

		/**
		 *	红包类型
		 *	(触发类型)
		 *
		 *	1.VIP等级提升至
		 *	2.指定怪物被杀死
		 */
		public var Red_Type:String;

		/**
		 *	类型条件
		 *	(对应触发类型)
		 *
		 *	VIP等级
		 *	怪物ID
		 */
		public var Red_Term:String;

		/**
		 *	内容类型
		 *
		 *	1.钻石
		 */
		public var Content_Type:String;

		/**
		 *	红包额度
		 */
		public var Red_Quota:String;

		/**
		 *	可领取次数
		 */
		public var Red_Num:String;



		public function TRed_package(data:XML=null) {
			if (data == null)
				return;

			this.Red_ID=data.@Red_ID;
			this.Red_Name=data.@Red_Name;
			this.Red_Type=data.@Red_Type;
			this.Red_Term=data.@Red_Term;
			this.Content_Type=data.@Content_Type;
			this.Red_Quota=data.@Red_Quota;
			this.Red_Num=data.@Red_Num;


		}



	}
}
