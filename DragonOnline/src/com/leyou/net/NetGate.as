package com.leyou.net {

	import com.ace.enum.UIEnum;
	import com.ace.game.manager.LogManager;
	import com.ace.game.net.NetGateModel;
	import com.ace.game.scene.ui.ReConnectionWnd;
	import com.ace.manager.UIManager;
	import com.ace.ui.window.children.PopWindow;
	import com.ace.ui.window.children.WindInfo;
	import com.ace.utils.HexUtil;
	import com.adobe.serialization.json.JSON;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.cmd.Cmd_Login;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class NetGate extends NetGateModel {
		static public const DEBUG:Boolean=false;
		private static var instance:NetGate;

		public static function getInstance():NetGate {
			if (!instance)
				instance=new NetGate();
			return instance;
		}

		private var pid:int; //发送协议次数 从0开始

		public function NetGate() {
			super();
		}

		override protected function conned(e:Event):void {
			this.heartTimer.start();
			this.onSend(NetEncode.password());
			this.countPid();
		}

		private function countPid():void {
			if (++pid > 127)
				this.pid=0;
		}

		//心跳
		override protected function heartSend(e:TimerEvent):void {
//			NetGate.DEBUG && trace("发送心跳");
//			trace("发送心跳");
			NetGate.getInstance().send(CmdEnum.SYS_CLK);
		}

		override protected function onErr(e:IOErrorEvent):void {
			var t:WindInfo=WindInfo.getAlertInfo("服务器维护中！请稍后再试");
			t.allowDrag=false;
			t.isModal=true;
			PopWindow.showWnd(UIEnum.WND_TYPE_ALERT, t, "onNetAlertWnd");
		}

		override protected function disConn(e:Event):void {
			ReConnectionWnd.getInstance().show();
			return;
			super.disConn(e);
		}

		//发送
		public function send(obj:Object):void {
			var enBr:ByteArray;
			if (obj is String) {
				CONFIG::debug {
					LogManager.getInstance().showLog("+密前数据：" + obj);
				}
				var br:ByteArray=new ByteArray;
				br.writeMultiByte(obj as String, "utf-8");
				br.position=0;
				enBr=NetEncode.enCode(br, this.pid);
			} else if (obj is ByteArray) {
				CONFIG::debug {
					LogManager.getInstance().showLog(HexUtil.toHexDump("+密前数据：", obj as ByteArray, 0, (obj as ByteArray).length));
				}
				enBr=NetEncode.enCode(obj as ByteArray, this.pid);
			}
			this.onSend(enBr);
			this.countPid();
		}

		//发送
		public function sendII(obj:Object):void {
			if (obj is String) {
				var br:ByteArray=new ByteArray;
				br.writeMultiByte(obj as String, "utf-8");
				br.position=0;
				this.onSend(NetEncode.enCode(br, this.pid));
			} else if (obj is ByteArray) {
				//				var tmpBr:ByteArray=NetEncode.enCode(obj as ByteArray, this.pid);
				//				HexUtil.toHexDump("加密后协议", tmpBr, 0, tmpBr.length);
				//				this.onSend(tmpBr);
				this.onSend(NetEncode.enCode(obj as ByteArray, this.pid));
			}
			this.countPid();
		}


		private var inbuf:ByteArray=new ByteArray();

		//接受
		override protected function readData():void {
			if (sk.bytesAvailable <= 4)
				return;

			var header:ByteArray;
			var temp:int=0;
			var length:int=0;
			var dataPackage:ByteArray;
			var i:int=0;
			var newbuf:ByteArray;

			this.sk.readBytes(this.inbuf, this.inbuf.length);

			while (this.inbuf.length >= 4) {
				header=new ByteArray();
				header.writeBytes(this.inbuf, 0, 4);

				temp=header[3];
				header[0]=(header[0] ^ 0xA5);
				header[3]=(header[3] ^ header[2]);
				header[2]=(header[2] ^ header[1]);
				header[1]=(header[1] ^ header[0]);
				length=((header[2] & 0xFF) + ((header[3] & 0xFF) * 0x0100));
				this.inbuf.position=4;
				if ((this.inbuf.length - this.inbuf.position) >= length) {
					//					this.pid_server2client=header[1];
					dataPackage=new ByteArray();
					dataPackage.length=length;
					dataPackage[0]=(this.inbuf[this.inbuf.position] ^ temp);
					i=1;
					while (i < length) {
						dataPackage[i]=(this.inbuf[(this.inbuf.position + i)] ^ this.inbuf[((this.inbuf.position + i) - 1)]);
						i++;
					}
					dataPackage.position=0;
					this.splitData(dataPackage);
					newbuf=new ByteArray();
					newbuf.writeBytes(this.inbuf, (this.inbuf.position + length));
					this.inbuf=newbuf;
				} else {
					break;
				}
			}
		}

		private function splitData(br:ByteArray):void {
			var cmd:ByteArray;
			var len:int;

			while (br.position < br.length) {
				len=(br.readUnsignedByte() & 0xFF);
				if (len >= 128) {
					len=(len - 128) * 0x0100 + (br.readByte() & 0xFF);
				}
				cmd=new ByteArray();
				if ((br.length - br.position) >= len) {
					br.readBytes(cmd, 0, len);
				} else {
					br.position=br.length;
				}
				cmd.position=0;
				cmd.bytesAvailable && this.execteData(cmd);
			}
		}

		//解密后开始派发协议
		public function execteData(br:ByteArray):void {
			CONFIG::debug {
				LogManager.getInstance().showLog(HexUtil.toHexDump("解密后数据：", br, 0, br.length));
			}

//			trace(HexUtil.toHexDump("解密后数据：", br, 0, br.length));

			var cmd1017:int=br.readShort();
			if (cmd1017 == 0x1710) {
				ServerFunDic.executeCmd(CmdEnum.SM_1017, null);
				return;
			}
			br.position=0;
			var isBinCmd:Boolean=br.readUnsignedByte() == 0xFF;
			var obj:Object;
			var cmd:String;
			var cmdIndex:int;
			if (isBinCmd) { //2进制协议
				br.endian=Endian.LITTLE_ENDIAN;
				cmd=br.readShort().toString(16);
				obj=br;
			} else {
				for (var i:int=0; i < 5; i++) {
					if (br[i] < 32 || br[i] > 127) {
						trace("协议异常", i, br[i]);
						return;
					}
				}
				br.position=0;
				var str:String=br.readMultiByte(br.length, "utf-8");
				cmdIndex=str.indexOf("|");
				if (str.indexOf("{") != -1 && str.indexOf("}") != -1) { //json协议
					obj=com.adobe.serialization.json.JSON.decode(str.substr(cmdIndex + 1));
					cmd=str.substring(0, cmdIndex) + (obj["mk"] == null ? "" : "_" + obj["mk"]);
				} else { //字符串协议
					obj=str;
					cmd=str.substring(0, cmdIndex);
				}
			}

			ServerFunDic.executeCmd(cmd.toLocaleLowerCase(), obj);
		}

	}
}
