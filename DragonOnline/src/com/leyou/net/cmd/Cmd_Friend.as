package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;
	
	public class Cmd_Friend
	{
		public function Cmd_Friend()
		{
		}
		
		/**
		 * 查询好友回应
		 */		
		public static function sm_FriendMsg_I(o:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.FRIEND, CmdEnum.SM_FND_I);
			if(3 == o.relation){
				DataManager.getInstance().friendData.loadData_I(o);
			}
			var relation:int = o.relation;
			var list:Array = o.list;
			if(UIManager.getInstance().isCreate(WindowEnum.FRIEND)){
				UIManager.getInstance().friendWnd.InitFrendList(o);
			}
		}
		
		/**
		 * 添加好友
		 */		
		public static function sm_FriendMsg_A(o:Object):void{
			if(o.hasOwnProperty("one")){
				if(UIManager.getInstance().isCreate(WindowEnum.FRIEND)){
					UIManager.getInstance().friendWnd.addFriendItem(o.one, o.relation);
				}
			}
		}
		
		/**
		 * 删除好友
		 */
		public static function sm_FriendMsg_D(o:Object):void{
			if(o.hasOwnProperty("name")){
				if(UIManager.getInstance().isCreate(WindowEnum.FRIEND)){
					UIManager.getInstance().friendWnd.removeFriendItem(o);
				}
			}
		}
		
		/**
		 * 更新好友
		 */
		public static function sm_FriendMsg_U(o:Object):void{
			if(o.hasOwnProperty("one")){
				if(UIManager.getInstance().isCreate(WindowEnum.FRIEND)){
					UIManager.getInstance().friendWnd.updateFriendItem(o.one, o.relation);
				}
			}
		}
		
		/**
		 * 查找玩家
		 */		
		public static function sm_FriendMsg_F(o:Object):void{
			if(UIManager.getInstance().isCreate(WindowEnum.FRIEDN_ADD)){
				UIManager.getInstance().friendAddWnd.updateInfo(o);
			}
		}
		
		/**
		 * 请求查询好友 
		 */		
		public static function cm_FriendMsg_I(relation:int):void{
			NetGate.getInstance().send(CmdEnum.CM_FND_I + relation);
		}
		
		/**
		 * 请求添加好友
		 */		
		public static function cm_FriendMsg_A(relation:int, name:String):void{
			NetGate.getInstance().send(CmdEnum.CM_FND_A + relation + "," + name);
		}
		
		/**
		 * 请求删除好友
		 */		
		public static function cm_FriendMsg_D(relation:int, name:String):void{
			NetGate.getInstance().send(CmdEnum.CM_FND_D + relation + "," + name);
		}
		
		/**
		 * 查询玩家
		 * 
		 */		
		public static function cm_FriendMsg_F(name:String=""):void{
			NetGate.getInstance().send(CmdEnum.CM_FND_F +"," + name);
		}
	}
}