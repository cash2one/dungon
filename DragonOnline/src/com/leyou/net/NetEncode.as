package com.leyou.net {
	import flash.utils.ByteArray;

	public class NetEncode {

		//第一次登陆需要的口令
		static public function password():ByteArray {
			var br:ByteArray=new ByteArray();
			br.writeByte(Math.random() % 256);
			br.writeByte(0);
			br.writeByte(29);
			br.writeByte(0);
			br.writeByte(0x1c);
			br.writeByte(0xff);
			br.writeByte(0x00);
			br.writeByte(0x07);
			br.writeByte(0x18);
			br.writeByte(0x02);
			br.position=0;

			for (var i:int=1; i < 33; i++) {
				br[i]=br[i] ^ br[i - 1];
			}

			br[0]=br[0] ^ 0xA5;
//			HexUtil.toHexDump("发送的头信息",br,0,br.bytesAvailable);
			return br;
		}

		//协议加密
		static public function enCode(br:ByteArray, pid:int):ByteArray {
			var byArr:Array=[];
			byArr[0]=Math.random() % 256;
			byArr[1]=pid;

			var strlen:int=br.length;
			var sublen:int=0;

			if (strlen < 128) {
				byArr[4]=strlen;
				sublen=1;
			} else {
				byArr[4]=strlen / 256 + 128;
				byArr[5]=strlen & 0xff;
				sublen=2;
			}

			byArr[2]=(strlen + sublen) & 0xff;
			byArr[3]=(strlen + sublen) / 256;

			var i:int=0;
			for (i=0; i < strlen; i++) {
				byArr[sublen + 4 + i]=br.readByte()
			}

			//加密
			for (i=1; i < strlen + sublen + 4; i++) {
				byArr[i]=byArr[i] ^ byArr[i - 1];
			}

			byArr[0]=byArr[0] ^ 0xA5;

			var by:ByteArray=new ByteArray();
			for (var k:int=0; k < strlen + sublen + 4; k++) {
				by.writeByte(byArr[k]);
			}

			return by;
		}

		//协议解密   没用xxxxxxxx
		static public function deCode(pbuff:ByteArray):ByteArray {
			var lpBuf:ByteArray=new ByteArray();
			var nByte:int=pbuff.bytesAvailable;


			var i:int=0;
			while (nByte > 4) {
				var header:ByteArray=new ByteArray();
				header.writeBytes(pbuff, 0, 4);

				var temp:int=header[3]; //解密用的变量，存储heade[3]的密文
				header[0]^=0xA5;
				header[3]^=header[2];
				header[2]^=header[1];
				header[1]^=header[0];

				var length:int=(header[2] & 0xff) + (header[3] & 0xff) * 256;
				lpBuf[0]=pbuff[4] ^ temp;

				if (nByte - 4 >= length) { //包含完整的数据包
					for (i=1; i < length; i++) {
						lpBuf[i]=pbuff[4 + i] ^ pbuff[4 + i - 1];
					}

					//分割指令
					var cur:int=0;
					while (cur < length) {

						var len:int=lpBuf[cur] & 0xFF;
						if (len >= 128) {
							len=(len - 128) * 256 + (lpBuf[cur + 1] & 0xFF);
							cur+=1;
						}

						var cmd:ByteArray=new ByteArray();

						for (i=0; i < len; i++) {
							cmd[i]=lpBuf[cur + 1 + i] & 0xff;
						}

						cmd[len]=0;
						cur+=len + 1;

						return cmd;
					}

					pbuff.length+=(length + 4);
					nByte-=(length + 4);

				} else {
					break;
				}
			}
			return null;
		}

	}
}
