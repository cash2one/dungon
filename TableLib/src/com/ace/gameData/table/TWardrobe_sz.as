package com.ace.gameData.table{

	public class TWardrobe_sz {

		/**
		 *	神装ID
		 */
		public var ID:String;

		/**
		 *	神装名称
		 */
		public var Sz_Name:String;

		/**
		 *	图标ico
		 */
		public var Sz_Icon:String;

		/**
		 *	显示职业
		 *	0 通用
		 *	1 战士
		 *	2 法师
		 *	3 术士
		 *	4 游侠
		 */
		public var Sz_Occ:String;

		/**
		 *	获取条件1
		 */
		public var Sz_term1:String;

		/**
		 *	条件内容1
		 */
		public var Sz_content1:String;

		/**
		 *	获取条件2
		 */
		public var Sz_term2:String;

		/**
		 *	条件内容2
		 */
		public var Sz_content2:String;

		/**
		 *	获取条件3
		 */
		public var Sz_term3:String;

		/**
		 *	条件内容3
		 */
		public var Sz_content3:String;

		/**
		 *	获取条件4
		 */
		public var Sz_term4:String;

		/**
		 *	条件内容4
		 */
		public var Sz_content4:String;

		/**
		 *	获取条件5
		 */
		public var Sz_term5:String;

		/**
		 *	条件内容5
		 */
		public var Sz_content5:String;

		/**
		 *	时长类型
		 *
		 *	0租用
		 *	1永久
		 */
		public var Sz_type:String;

		/**
		 *	获取时长（h)
		 */
		public var Sz_time:String;

		/**
		 *	永久购买价格
		 *	钻石
		 */
		public var Sz_buy:String;

		/**
		 *	租用价格
		 *	金币/h
		 */
		public var Sz_rent:String;

		/**
		 *	套用模型1
		 */
		public var Sz_img1:String;

		/**
		 *	套用模型2
		 */
		public var Sz_img2:String;

		/**
		 *	套用模型3
		 */
		public var Sz_img3:String;

		/**
		 *	附加属性1
		 */
		public var Sz_att1:String;

		/**
		 *	属性数值1
		 */
		public var Sz_attNum1:String;

		/**
		 *	附加属性2
		 */
		public var Sz_att2:String;

		/**
		 *	属性数值2
		 */
		public var Sz_attNum2:String;

		/**
		 *	附加属性3
		 */
		public var Sz_att3:String;

		/**
		 *	属性数值3
		 */
		public var Sz_attNum3:String;

		/**
		 *	附加属性4
		 */
		public var Sz_att4:String;

		/**
		 *	属性数值4
		 */
		public var Sz_attNum4:String;

		/**
		 *	附加属性5
		 */
		public var Sz_att5:String;

		/**
		 *	属性数值5
		 */
		public var Sz_attNum5:String;



		public function TWardrobe_sz(data:XML=null) {
			if (data == null)
				return;

			this.ID=data.@ID;
			this.Sz_Name=data.@Sz_Name;
			this.Sz_Icon=data.@Sz_Icon;
			this.Sz_Occ=data.@Sz_Occ;
			this.Sz_term1=data.@Sz_term1;
			this.Sz_content1=data.@Sz_content1;
			this.Sz_term2=data.@Sz_term2;
			this.Sz_content2=data.@Sz_content2;
			this.Sz_term3=data.@Sz_term3;
			this.Sz_content3=data.@Sz_content3;
			this.Sz_term4=data.@Sz_term4;
			this.Sz_content4=data.@Sz_content4;
			this.Sz_term5=data.@Sz_term5;
			this.Sz_content5=data.@Sz_content5;
			this.Sz_type=data.@Sz_type;
			this.Sz_time=data.@Sz_time;
			this.Sz_buy=data.@Sz_buy;
			this.Sz_rent=data.@Sz_rent;
			this.Sz_img1=data.@Sz_img1;
			this.Sz_img2=data.@Sz_img2;
			this.Sz_img3=data.@Sz_img3;
			this.Sz_att1=data.@Sz_att1;
			this.Sz_attNum1=data.@Sz_attNum1;
			this.Sz_att2=data.@Sz_att2;
			this.Sz_attNum2=data.@Sz_attNum2;
			this.Sz_att3=data.@Sz_att3;
			this.Sz_attNum3=data.@Sz_attNum3;
			this.Sz_att4=data.@Sz_att4;
			this.Sz_attNum4=data.@Sz_attNum4;
			this.Sz_att5=data.@Sz_att5;
			this.Sz_attNum5=data.@Sz_attNum5;


		}



	}
}
