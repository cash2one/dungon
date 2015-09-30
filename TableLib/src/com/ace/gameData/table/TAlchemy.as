package com.ace.gameData.table {

	public class TAlchemy {


		public var Al_ID:int;
		public var Al_Type:int;
		public var AlT_Nam:String;

		public var Al_second:int;
		public var Als_Nam:String;
		public var Al_Third:int;

		public var AlThird_Nam:String;
		public var Datum1:int;
		public var Datum_Num1:int;

		public var Datum2:int;
		public var Datum_Num2:int;
		public var Datum3:int;

		public var Datum_Num3:int;
		public var Datum4:int;
		public var Datum_Num4:int;

		public var Datum5:int;
		public var Datum_Num5:int;
		public var Al_Cost:int;
		
		public var Al_soul:int;
		public var Cost_byb:int;
		public var Cost_yb:int;

		public var Al_Rate:int;
		public var Al_RateFont:String;
		public var Al_Key:int;
		public var AlKey_Num:int;

		public var Al_Yb:int;
		public var Product1:int;
		public var Al_Ratio1:int;

		public var Product1_Num:int;
		public var Product2:int;
		public var Al_Ratio2:int;

		public var Product2_Num:int;
		public var Product3:int;
		public var Al_Ratio3:int;

		public var Product3_Num:int;


		public function TAlchemy(data:XML=null) {
			if (data == null)
				return;

			this.Al_ID=data.@Al_ID;
			this.Al_Type=data.@Al_Type;
			this.AlT_Nam=data.@AlT_Nam;
			this.Al_second=data.@Al_second;
			this.Als_Nam=data.@Als_Nam;
			this.Al_Third=data.@Al_Third;
			this.AlThird_Nam=data.@AlThird_Nam;
			this.Datum1=data.@Datum1;
			this.Datum_Num1=data.@Datum_Num1;
			this.Datum2=data.@Datum2;
			this.Datum_Num2=data.@Datum_Num2;
			this.Datum3=data.@Datum3;
			this.Datum_Num3=data.@Datum_Num3;
			this.Datum4=data.@Datum4;
			this.Datum_Num4=data.@Datum_Num4;
			this.Datum5=data.@Datum5;
			this.Datum_Num5=data.@Datum_Num5;
			this.Al_Cost=data.@Al_Cost;
			this.Al_soul=data.@Al_soul;
			this.Cost_byb=data.@Cost_byb;
			this.Cost_yb=data.@Cost_yb;
			this.Al_RateFont=data.@AL_RateFont;
			this.Al_Rate=data.@Al_Rate;
			this.Al_Key=data.@Al_Key;
			this.AlKey_Num=data.@AlKey_Num;
			this.Al_Yb=data.@Al_Yb;
			this.Product1=data.@Product1;
			this.Al_Ratio1=data.@Al_Ratio1;
			this.Product1_Num=data.@Product1_Num;
			this.Product2=data.@Product2;
			this.Al_Ratio2=data.@Al_Ratio2;
			this.Product2_Num=data.@Product2_Num;
			this.Product3=data.@Product3;
			this.Al_Ratio3=data.@Al_Ratio3;
			this.Product3_Num=data.@Product3_Num;

		}


	}
}
