package com.leyou.net.cmd {
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.leyou.net.NetGate;
	import com.leyou.utils.ChatUtil;

	public class Cmd_Chat {
		public function Cmd_Chat() {
		}
		/**
		 *say
服务器 <----> 客户端
主要用于聊天界面相关的指令
协议
---------------------------------------------------------------------
 
----------------------------------------------------------------------
下行
say|{t:"频道编号", i:"发言人名字", y:"对象名字", c:"说话内容"}
t: "频道编号"
i: "发言人名字"
y: "对象名字"  (此项只在私聊的时候会有)
c: "说话内容"
例如    张三对李四说你好s
             下行 say|{t:5, i:张三, y:李四, c:你好}
        张三在世界说你好
             下行 say|{t:2, i:张三, c:你好}
如果内容里面有链接 用msg协议中的超链接形式 
say|{t:2, i:张三, c:你好我们去<<link+3+桃花源=go|{"id"=1,"x":100,"y":200}>>玩吧}
聊天里链接一般为物品,装备，他们链接为tips信息，客户端可请求此物品装备的tips ,把服务器返回的协议字符串拼接到超链接里
		 * @param o
		 * 
		 */		
		public static function sm_Say(o:Object):void{
			UIManager.getInstance().chatWnd.onSay(o);
		}
		
		/**
		 *上行
say|Tchannel[name],content

channel -- 聊天频道 用数字表示
1 ：喇叭
2 ：世界
3 ：帮派
4 ：队伍
5 ：私聊  
6 ：普通
当聊天为私聊时会有私聊对象的名字
例如  张三对李四说你好
         say|T5李四,你好
      张三在世界说你好
         say|T2,你好
content -- 说话的内容
如果内容里面有链接 用msg协议中的超链接形式 客户端拼好链接发送给服务器
  say|T2李四,你好我们去<<link+3+桃花源=go|{"id"=1,"x":100,"y":200}>>玩吧  
		 * @param o
		 * 
		 */		
		public static function cm_say(str:String):void{
			NetGate.getInstance().send("say|"+str);
		}
		
		public static function sm_CHAT_S(obj:Object):void{
			UIManager.getInstance().chatWnd.onSysNotice_II(obj);
		}
	}
}