package com.leyou.ui.friend.child
{
	import com.ace.enum.PlayerEnum;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	
	import flash.events.MouseEvent;
	
	public class FriendAddBar extends AutoSprite
	{
		private var playNameLbl:Label;
		
		private var proLbl:Label;
		
		private var lvLbl:Label;
		
		private var attLbl:Label;
		
		private var bgImg:Image;
		
		private var id:int;
		
		public var select:Boolean;
		
		public function FriendAddBar(){
			super(LibManager.getInstance().getXML("config/ui/friends/FriendAddBar.xml"));
			init();
		}
		
		private function init():void{
			mouseEnabled = true;
			playNameLbl = getUIbyID("playNameLbl") as Label;
			proLbl = getUIbyID("proLbl") as Label;
			lvLbl = getUIbyID("lvLbl") as Label;
			attLbl = getUIbyID("attLbl") as Label;
			bgImg = getUIbyID("bgImg") as Image;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		public function onMouseOut(event:MouseEvent):void{
			if(!select){
				setBackGround(id);
			}
		}
		
		public function onMouseOver(event:MouseEvent):void{
			bgImg.updateBmp("ui/team/team_list_bg_3.png");
		}
		
		public function get playerName():String{
			return playNameLbl.text;
		}
		
		public function setBackGround($id:int):void{
			id = $id
			var path:String = ((id&1) == 0) ? "ui/team/team_list_bg_1.png" : "ui/team/team_list_bg_2.png";
			bgImg.updateBmp(path);
		}
		
		public function updateInfo(info:Array):void{
			playNameLbl.text = info[0];
			var content:String;
			if(PlayerEnum.PRO_MASTER == info[1]){
				content = "法师";
			}else if(PlayerEnum.PRO_RANGER == info[1]){
				content = "游侠";
			}else if(PlayerEnum.PRO_SOLDIER == info[1]){
				content = "战士";
			}else if(PlayerEnum.PRO_WARLOCK == info[1]){
				content = "术士";
			}
			proLbl.text = content;
			lvLbl.text = info[2];
			attLbl.text = info[3];
		}
	}
}