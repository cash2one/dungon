package com.ace.gameData.table
{

	public class TQuestion
	{
		
		/**
		*	ID
		*/
		public var id:String;

		/**
		*	题目级别(3个级别）
		*	1.低级题
		*	2.中级题
		*	3.高级题
		*/
		public var lv:String;

		/**
		*	题目内容
		*/
		public var des:String;

		/**
		*	正确答案
		*/
		public var anw1:String;

		/**
		*	干扰答案
		*/
		public var anw2:String;


		
		public function TQuestion(data:XML=null)
		{
			if(data==null) return ;
			
			this.id=data.@id;
			this.lv=data.@lv;
			this.des=data.@des;
			this.anw1=data.@anw1;
			this.anw2=data.@anw2;

			
		}
		
		
		
	}
}
