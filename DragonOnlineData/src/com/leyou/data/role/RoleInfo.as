package com.leyou.data.role {

	public class RoleInfo extends ProperInfo{
		
		
		
		public function RoleInfo() {
		}
		/**
		 *名字 
		 */
		public var n:String;
		/**
		 *称号 
		 */		
		public var title:String;
		/**
		 *性别 
		 */	
		public var sex:int;
		/**
		 *职业 种族 
		 */		
		public var race:int;
		/**
		 *等级 
		 */		
		public var lv:int;
		/**
		 *最大生命值 
		 */		
		public var mHp:int;
		
		/**
		 *最大魔法值 
		 */		
		public var mMp:int;
		/**
		 *魂魄力 
		 */		
		public var soul:int;
		/**
		 *最大魂魄力 
		 */		
		public var mSoul:int;
		/**
		 *pk 
		 */		
		public var pk:int;
		/**
		 *当前的元素 
		 */		
		public var currentElement:int;
		/**
		 *元素 
		 */		
		public var elementArr:Array;
		
		/**
		 *avt 
		 */		
		public var avt:String;
		
		/**
		 * 行会名字 
		 */		
		public var guildName:String;
		
		/**
		 * vip lv 
		 */		
		public var vipLv:int=0;
		
		/**
		 * 绝对攻击
		 */		
		public var absAttLbl:int=0;
		
		/**
		 * 绝对防御
		 */		
		public var absDefLbl:int=0;
	}
}