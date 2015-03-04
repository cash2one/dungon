package com.leyou.ui.friend {
	import com.leyou.data.friend.FriendInfo;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.ui.friend.child.FriendDateBar;
	
	public class FriendWnd extends FriendView {
		
//		private var black:Vector.<String>;
		
		public function FriendWnd() {
			super();
		}
		
		/**
		 * <T>加载好友列表</T>
		 * 
		 */	
		public function InitFrendList(ol:Object):void{
			var relation:int = ol.relation;
			acc.clear(relation);
			var list:Object = ol.list;
			for each(var o:Object in list){
				addFriendItem(o, relation);
			}
//			 保存黑名单列表
//			if(3 == relation){
//				if(null == black){
//					black = new Vector.<String>();
//				}
//				black.length = 0;
//				var lt:Object = ol.list;
//				for each(var obj:Object in lt){
//					black.push(obj[0]);
//				}
//			}
		}
		
		/**
		 * <T>社交角色加入黑名单</T>
		 * 
		 */	
		protected override function addBlackRequest(info:FriendInfo):void{
			Cmd_Friend.cm_FriendMsg_A(3, info.name);
		}
		
		/**
		 * <T>请求添加社交角色</T>
		 * 
		 */	
		protected override function addFriendRequest(info:FriendInfo):void{
			Cmd_Friend.cm_FriendMsg_A(1, info.name);
		}
		
		/**
		 * <T>请求删除社交角色</T>
		 * 
		 */	
		protected override function removeFriendRequest(info:FriendInfo):void{
			//			var friendItem:FriendDateBar = null;
			//			var sai:int = acc.selectIndex;
			//			var selectAccordItem:AccordionItem = acc.getItem(sai);
			//			if(null != selectAccordItem){
			//				var fi:int = selectAccordItem.selectIndex;
			//				friendItem = selectAccordItem.getItem(fi) as FriendDateBar;
			//			}
			//			if(null != friendItem){
			Cmd_Friend.cm_FriendMsg_D(info.relation, info.name);
			//			}
		}
		
		/**
		 * <T>删除社交角色</T>
		 * 
		 */	
		public function removeFriendItem(o:Object):void{
			var relation:int = o.relation;
			var name:String = o.name;
			acc.removedFriendItemByName(name, relation);
//			if(3 == relation && null != black){
//				var index:int = black.indexOf(o.name);
//				if(-1 != index){
//					black.splice(index, 1);
//				}
//			}
		}
		
		/**
		 * <T>添加社交角色</T>
		 * 
		 */
		public function addFriendItem(o:Object, relation:int):void{
			var fd:FriendDateBar = new FriendDateBar();
			fd.updateInfo(o, relation);
			acc.addFriendItem(fd, relation);
		}
		
		/**
		 * <T>更新社交角色</T>
		 * 
		 */
		public function updateFriendItem(o:Object, relation:int):void{
			acc.updateFriendItem(o, relation);
		}
		
		/**
		 * 是否在黑名单
		 * 
		 * @param n 要检测的名字
		 * @return  是否存在黑名单中
		 * 
		 */		
//		public function testInBlack(n:String):Boolean{
//			if(null == black){
//				return false;
//			}
//			var index:int = black.indexOf(n);
//			return (-1 != index);
//		}
	}
}