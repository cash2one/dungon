package com.leyou.data.convenient
{
	public class ConvenientData
	{
		private var convenDic:Object = {};
		
		public function ConvenientData(){
		}
		
		public function setPrompt(name:String, value:Boolean):void{
			convenDic[name] = (value ? 1 : 0);
		}
		
		public function isPrompt(name:String):Boolean{
			return !(1 == convenDic[name]);
		}
	}
}