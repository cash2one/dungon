package com.ace.gameData.table
{
	
	public class TTzActiive
	{
		
		/**
		 *	id
		 */
		public var id:int;
		
		/**
		 *	serverId
		 */
		public var serverId:int;
		
		/**
		 * "场景类型
0 普通场景
1 剧情副本
2 BOSS副本
3 竞技场
4 时光龙穴
5 答题
6 入侵
7 练级
8.行会副本
9.龙穴探宝
10.保卫布雷特"

		 */		
		public var clientId:int;
		
		/**
		 *	name
		 */
		public var name:String;
		
		/**
		 *	week
		 */
		public var week:String;
		
		/**
		 *	btn
		 */
		public var btn:String;
		
		/**
		 *	nameImage
		 */
		public var nameImage:String;
		
		/**
		 *	sImage
		 */
		public var sImage:String;
		
		/**
		 *	bImage
		 */
		public var bImage:String;
		
		/**
		 *	time
		 */
		public var time:String;
		
		/**
		 *	pretime
		 */
		public var pretime:String;
		
		/**
		 *	realtime
		 */
		public var realtime:String;
		
		/**
		 *	lv
		 */
		public var lv:int;
		
		/**
		 *	des1
		 */
		public var des1:String;
		
		/**
		 *	des2
		 */
		public var des2:String;
		
		/**
		 *	des3
		 */
		public var des3:String;
		
		/**
		 *	des4
		 */
		public var des4:String;
		
		/**
		 *	item1
		 */
		public var item1:int;
		
		/**
		 *	item2
		 */
		public var item2:int;
		
		/**
		 *	item3
		 */
		public var item3:int;
		
		/**
		 *	item4
		 */
		public var item4:int;
		
		/**
		 *	item5
		 */
		public var item5:int;
		
		
		
		public function TTzActiive(data:XML=null)
		{
			if(data==null) return ;
			
			this.id=data.@id;
			this.serverId=data.@serverId;
			this.clientId=data.@clientId;
			this.name=data.@name;
			this.week=data.@week;
			this.btn=data.@btn;
			this.nameImage=data.@nameImage;
			this.sImage=data.@sImage;
			this.bImage=data.@bImage;
			this.time=data.@time;
			this.pretime=data.@pretime;
			this.realtime=data.@realtime;
			this.lv=data.@lv;
			this.des1=data.@des1;
			this.des2=data.@des2;
			this.des3=data.@des3;
			this.des4=data.@des4;
			this.item1=data.@item1;
			this.item2=data.@item2;
			this.item3=data.@item3;
			this.item4=data.@item4;
			this.item5=data.@item5;
			
			
		}
		
		
		
	}
}
