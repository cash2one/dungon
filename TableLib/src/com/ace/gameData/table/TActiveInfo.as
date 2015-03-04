package com.ace.gameData.table
{
	public class TActiveInfo
	{
		public var id:int;
		
		public var type:int;
		
		public var value:int;
		
		public var openId:int;
		
		public var des:String;
		
		public var reward:int;
		
		public var level:int;
		
		public function TActiveInfo(xml:XML){
			id = xml.@Activity_ID;
			type = xml.@Act_Obj;
			value = xml.@Act_Num;
			if(26 == type){
				value = 1;
			}
			openId = xml.@A_OpenWindow;
			des = xml.@Act_TP;
			reward = xml.@A_Reward;
			level = xml.@Act_OpenLevel;
		}
		
		public function getOpenWnd():int{
			return 0;
		}
	}
}