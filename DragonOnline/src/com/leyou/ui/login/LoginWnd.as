package com.leyou.ui.login {

	import com.ace.ICommon.IResize;
	import com.ace.config.Core;
	import com.ace.enum.UIEnum;
	import com.ace.game.manager.LogManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ResizeManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.LinkButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.HideInput;
	import com.leyou.net.NetGate;
	import com.leyou.net.cmd.Cmd_Login;

	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class LoginWnd extends AutoSprite implements IResize {

		private var userNameTinput:HideInput;
		private var userPwdTinput:HideInput;
		private var loginBtn:NormalButton;

		private var signBtn:LinkButton;
		private var forgetPassWorldBtn:LinkButton;
		private var saveNameCheckBox:CheckBox;

		public function LoginWnd() {
			super(LibManager.getInstance().getXML("config/ui/LoginWnd.xml"));
			this.mouseChildren=true;
			this.init();
		}

		private function init():void {
			this.onResize();
			ResizeManager.getInstance().addToOnResize(this);
			this.userNameTinput=this.getUIbyID("userNameTinput") as HideInput;
			this.userPwdTinput=this.getUIbyID("userPwdTinput") as HideInput;
			this.loginBtn=this.getUIbyID("loginBtn") as NormalButton;

			this.signBtn=this.getUIbyID("signBtn") as LinkButton;
			this.forgetPassWorldBtn=this.getUIbyID("forgetPassWorldBtn") as LinkButton;
			this.saveNameCheckBox=this.getUIbyID("saveNameCheckBox") as CheckBox;

			this.loginBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.signBtn.addEventListener(MouseEvent.CLICK, this.onClick);
			this.forgetPassWorldBtn.addEventListener(MouseEvent.CLICK, this.onClick);
			this.saveNameCheckBox.addEventListener(MouseEvent.CLICK, this.onClick);

			this.userNameTinput.text="http://192.168.10.16/dragon/game/?ip=192.168.10.88?port=9932?lgn=lgn|Puserid=1307,svrid=lx001,fcm=0,timestamp=1395994411,sign=221fb9a63d8f1fe72400e14dbb504fc9"; //法师
			this.userNameTinput.text="http://192.168.10.16/dragon/game/?ip=192.168.10.88?port=9932?lgn=lgn|Puserid=1324,svrid=lx001,fcm=0,timestamp=1396236196,sign=cd93c52dcea9f4042fbccbac71ec809f";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?ip=192.168.10.88?port=9932?lgn=lgn|Puserid=1400,svrid=lx001,fcm=0,timestamp=1396490589,sign=50319a1f68d39874e372aeda37f2b30c"
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?ip=192.168.10.88?port=9932?lgn=lgn|Puserid=858,svrid=lx001,fcm=0,timestamp=1396319834,sign=92d74853ce18cb15d1d56b97067d48ff";
			//http://192.168.10.16/dragon/game/?ip=192.168.10.88?port=9932?lgn=lgn|Puserid=1362,svrid=lx001,fcm=0,timestamp=1396337940,sign=cc76cfce9b5d518ee0320065e8c11259
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?ip=192.168.10.88?port=9932?lgn=lgn|Puserid=1423,svrid=lx001,fcm=0,timestamp=1396519419,sign=246ba3b7c83603a07c59141e21361f23"
			this.userNameTinput.text="http://192.168.10.16/dragon/game/?ip=192.168.10.88?port=9932?lgn=lgn|Puserid=1483,svrid=lx001,fcm=0,timestamp=1397011055,sign=743c151fcbfec8fff63b69b8d05cd7f5";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?ip=192.168.10.88?port=9932?lgn=lgn|Puserid=1543,svrid=lx001,fcm=0,timestamp=1397120495,sign=da500a7537b645272d67e70697133e2e";
			this.userNameTinput.text="http://192.168.10.16/dragon/game/?ip=192.168.10.88?port=9932?lgn=lgn|Puserid=1578,svrid=lx001,fcm=0,timestamp=1397529973,sign=e8376cdff311d5d72ae3769e8e75247a";
			this.userNameTinput.text="http://192.168.10.16/dragon/game/?ip=192.168.10.88?port=9932?lgn=lgn|Puserid=1583,svrid=lx001,fcm=0,timestamp=1397551933,sign=ff219cba4e8e914580d4f672cbcf14d0"
			this.userNameTinput.text="http://192.168.10.16/dragon/game/?ip=192.168.10.88?port=9932?lgn=lgn|Puserid=1617,svrid=lx001,fcm=0,timestamp=1397721572,sign=ab01b08e620c31d9f4b0202cd397415d"

			this.userNameTinput.text="lgn|Puserid=2532,svrid=dev1,fcm=1,timestamp=1403168725,sign=5aaddc90dfd384c44b685cd2ad47b5ef";
//			this.userNameTinput.text="lgn|Puserid=2566,svrid=dev1,fcm=1,timestamp=1403236076,sign=d9dd5a1d30b3b1eeacc634315543ca63"
//			this.userNameTinput.text="lgn|Puserid=2562,svrid=dev1,fcm=1,timestamp=1403247020,sign=1b113355f7e5aad92fab92e77eb5a0d0";
//			this.userNameTinput.text="lgn|Puserid=2574,svrid=dev1,fcm=1,timestamp=1403243662,sign=b64b9fa44d80cb9d0e18dfdf5be09702"
			this.userNameTinput.text="lgn|Puserid=2640,svrid=dev1,fcm=1,timestamp=1403603311,sign=7bfaed231ed964ac7b110930ea172101"
//			this.userNameTinput.text="lgn|Puserid=2669,svrid=dev1,fcm=1,timestamp=1403681554,sign=be8165f4cdee4cc5b2fd48ab9bd610fa"
			this.userNameTinput.text="lgn|Puserid=2273,svrid=dev1,fcm=0,timestamp=1403747771,sign=eab25f536f125a4e5c53d1e8400ea8ae"
//			this.userNameTinput.text="lgn|Puserid=2688,svrid=dev1,fcm=1,timestamp=1403768075,sign=4a07ebd87063d85a726c72b16323fbb1"
//			this.userNameTinput.text="lgn|Puserid=2710,svrid=dev1,fcm=1,timestamp=1403841272,sign=d6900f8d3658c1a94c12f603ddd7fe5d"
			this.userNameTinput.text="lgn|Puserid=2726,svrid=dev1,fcm=1,timestamp=1404099748,sign=375417980b7d690e6a341dd16686a73e"
//			this.userNameTinput.text="lgn|Puserid=2774,svrid=dev1,fcm=1,timestamp=1404286788,sign=cae7d1122e5530b73b9d07b02a8af843"
			this.userNameTinput.text="lgn|Puserid=2772,svrid=dev1,fcm=1,timestamp=1404283924,sign=d83e5fb3ad14ed3ba167aa9046813271"
//			this.userNameTinput.text="lgn|Puserid=2862,svrid=dev1,fcm=1,timestamp=1404455837,sign=d9c9330a96e8a5fe26498b69bc7bd3c2"
//			this.userNameTinput.text="lgn|Puserid=2944,svrid=dev1,fcm=1,timestamp=1404803559,sign=5f8989e1899639cf92a9876be6a7015e"
//			this.userNameTinput.text="lgn|Puserid=2090,svrid=dev1,fcm=1,timestamp=1404807346,sign=f804262dc307ce0e25bad8a6ebe3481d";
//			this.userNameTinput.text="lgn|Puserid=3023,svrid=dev1,fcm=1,timestamp=1404900196,sign=7aa11a09c743ba1dab4740a3c9e19958";
//			this.userNameTinput.text="lgn|Puserid=3029,svrid=dev1,fcm=1,timestamp=1404904652,sign=5a4160d5b036d51b33fda0750a6cb103"

			this.userNameTinput.text="lgn|Puserid=3097,svrid=dev1,fcm=1,timestamp=1405049359,sign=36269f6d7e30265d31fc8f450fe0234d"
//			this.userNameTinput.text="lgn|Puserid=3111,svrid=dev1,fcm=1,timestamp=1405062535,sign=1f0df5ae0fa75fc27d91938f0f07dec5";
			this.userNameTinput.text="lgn|Puserid=2269,svrid=dev1,fcm=0,timestamp=1405050782,sign=18575d7598cc03f32291c138e8cb5fd2"
//			this.userNameTinput.text="lgn|Puserid=3112,svrid=dev1,fcm=1,timestamp=1405062897,sign=30fe5b6f7f7d29c5d231ceb175d1b5f8";
//			this.userNameTinput.text="lgn|Puserid=3267,svrid=dev1,fcm=1,timestamp=1405591120,sign=2113ff663479d28369d375a9a425b2e5";
//			this.userNameTinput.text="lgn|Puserid=3277,svrid=dev1,fcm=1,timestamp=1405649655,sign=8e16237f25b93f0134c8fefda8cc1511";
//			this.userNameTinput.text="lgn|Puserid=3281,svrid=dev1,fcm=1,timestamp=1405650134,sign=2358a531b6067e79accc8f50c50126c5"
//			this.userNameTinput.text="lgn|Puserid=3284,svrid=dev1,fcm=1,timestamp=1405650429,sign=df3892d80f10afd93af98ddd829f47c8";
//			this.userNameTinput.text="lgn|Puserid=3286,svrid=dev1,fcm=1,timestamp=1405650627,sign=b31d58a302d71ac6cb3af0982603a387";
//			this.userNameTinput.text="lgn|Puserid=3346,svrid=dev1,fcm=1,timestamp=1405919578,sign=068304e7a4c533747cbd8b186c8c733d";
//			this.userNameTinput.text="lgn|Puserid=3347,svrid=dev1,fcm=1,timestamp=1405920574,sign=a589f7da7a9bf908a33623e8688041be"
//			this.userNameTinput.text="lgn|Puserid=3367,svrid=dev1,fcm=1,timestamp=1405931084,sign=17f3ed499c08976350d549b29df1acfc"


//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=3359&server_id=dev1&time=1405928456&sign=a5b31d78196b85e28b0205829b7e1d7a&isAdult=1&lgn|Puserid=3359,svrid=dev1,fcm=1,timestamp=1405928456,sign=17b5c59c8e2567474f56bf94eb21dca7";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=1999&server_id=dev1&time=1404185251&sign=d27d2e9bd0707498d129e24679456bc5&isAdult=0&lgn|Puserid=1999,svrid=dev1,fcm=0,timestamp=1404185251,sign=aaa1d051897c46c620063f24ccfd6a91";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=2912&server_id=dev1&time=1406168059&sign=c99ddc25d8e7becffce8d7796c66299e&isAdult=1&lgn|Puserid=2912,svrid=dev1,fcm=1,timestamp=1406168059,sign=e03e34a1ff8636f60c181392af0667c1";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=2034&server_id=dev1&time=1406255123&sign=bc787c04546db6c0c550c0865d227ecc&isAdult=0&lgn|Puserid=2034,svrid=dev1,fcm=0,timestamp=1406255123,sign=88bf3494aa066376ba7e9782cfbc8366"; 
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=3531&server_id=dev1&time=1406297056&sign=7b9eb36651f2357434b1a62253fa3c0c&isAdult=1&lgn|Puserid=3531,svrid=dev1,fcm=1,timestamp=1406297056,sign=fc32b4e6c713f3a3e4866cf8af931121";

//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=3618&server_id=dev1&time=1406537086&sign=405bee1bf7d67e61760a067dc9cb8a62&isAdult=1&lgn|Puserid=3618,svrid=dev1,fcm=1,timestamp=1406537086,sign=713c7f995588875ffd236700b5800068";

//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=3620&server_id=dev1&time=1406537613&sign=b2b40f2f61cfe1f85608c3d0ac3aff4b&isAdult=1&lgn|Puserid=3620,svrid=dev1,fcm=1,timestamp=1406537613,sign=4b1bbabae8dd177e3ab087aef93f8ffc";

			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=3625&server_id=dev1&time=1406543039&sign=360f6162ff4338a2ed6e56a648c73aa8&isAdult=1&lgn|Puserid=3625,svrid=dev1,fcm=1,timestamp=1406543039,sign=4044291a58fc3e5cd5e949dac8f3e3c7";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=3701&server_id=dev1&time=1406685515&sign=0867042a22d298a72bf2531651c7ad96&isAdult=1&lgn|Puserid=3701,svrid=dev1,fcm=1,timestamp=1406685515,sign=4a0aa26098fea7ada82e8866247106d2";

//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=3708&server_id=dev1&time=1406686846&sign=8f99d81feeb20bb844e0dfe3763925c9&isAdult=1&lgn|Puserid=3708,svrid=dev1,fcm=1,timestamp=1406686846,sign=f7ae94a74063c37a81c184123f3d099b";

//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=3710&server_id=dev1&time=1406688831&sign=7ae829f0331596b73453baf26c0d0688&isAdult=1&lgn|Puserid=3710,svrid=dev1,fcm=1,timestamp=1406688831,sign=0d30997efe4f44176f5329a481f62b9f";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=3711&server_id=dev1&time=1406689128&sign=1321281fc155fb516e2cfdce04b445dd&isAdult=1&lgn|Puserid=3711,svrid=dev1,fcm=1,timestamp=1406689128,sign=a521947c76dfda6dbb96ce0197f6b945"
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=3714&server_id=dev1&time=1406689542&sign=fb0f26c2d2dce86e8a280ec7ac7c6481&isAdult=1&lgn|Puserid=3714,svrid=dev1,fcm=1,timestamp=1406689542,sign=c6f159beea5bafeca2f4f0c68ed7596a";

//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=3715&server_id=dev1&time=1406689933&sign=5c62b0748cca0f3827e9daf809a0270d&isAdult=1&lgn|Puserid=3715,svrid=dev1,fcm=1,timestamp=1406689933,sign=ee3bda54b560bfe8cdce6407246e1194";

			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=2978&server_id=dev1&time=1406977952&sign=79edbe514a3353e4f06bcac55e4a297f&isAdult=1&lgn|Puserid=2978,svrid=dev1,fcm=1,timestamp=1406977952,sign=c9a22e68dd46392225c0ee4b28aca1da";


			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=2033&server_id=dev1&time=1408675693&sign=8158932f06f53401b6cc4255c10df2fc&isAdult=0&lgn|Puserid=2033,svrid=dev1,fcm=0,timestamp=1408675693,sign=080e4da15665382ea54b434da4b3d205";
			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=2273&server_id=dev1&time=1408933335&sign=a82bae3120f6aa12b6661428a6074f50&isAdult=0&lgn|Puserid=2273,svrid=dev1,fcm=0,timestamp=1408933335,sign=c425f7f88277a38117f7129dd9fd7cb8"

//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=2831&server_id=dev1&time=1409912240&sign=bf201d0f696ca42d44ebab3ef7526eec&isAdult=1&lgn|Puserid=2831,svrid=dev1,fcm=1,timestamp=1409912240,sign=49ce26054f83d6bb248d07b95134d2f7";
//			this.userNameTinput.text="lgn|Puserid=4476,svrid=dev1,fcm=1,timestamp=1410332141,sign=af6beeca0994fdac5f6c32aaa865c07f";

//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=4462&server_id=dev1&time=1410401808&sign=e68724f463b7f3da810ed2a2b28f7851&isAdult=1&lgn|Puserid=4462,svrid=dev1,fcm=1,timestamp=1410401808,sign=6ed2656c78f2a4eb4e25422141eb3441"

//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=4521&server_id=dev1&time=1410491229&sign=325b52e72dc01063c66e399063d2114b&isAdult=1&lgn|Puserid=4521,svrid=dev1,fcm=1,timestamp=1410491229,sign=36545a1c443dd22f96adaadf644016eb";

//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=4523&server_id=dev1&time=1410507394&sign=076b954012229a8272adb71eb9636cbb&isAdult=1&lgn|Puserid=4523,svrid=dev1,fcm=1,timestamp=1410507394,sign=e12f4fed11419e458c6ea871d445c623"
//			this.userNameTinput.text="/http://192.168.10.16/dragon/game/?qid=4541&server_id=dev1&time=1410750169&sign=d2480250bb5d4185125a5f8e67d85ec7&isAdult=1&lgn|Puserid=4541,svrid=dev1,fcm=1,timestamp=1410750169,sign=afb1e72345d9130dad4e734b805c7a6e"
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=2283&server_id=dev1&time=1410753682&sign=beddba5d7aea61b1f7f580ae153c7bbd&isAdult=1&lgn|Puserid=2283,svrid=dev1,fcm=1,timestamp=1410753682,sign=b5e2e379f461582f3893e1180eaed329"

//			this.userNameTinput.text="lgn|Puserid=4434,svrid=dev1,fcm=1,timestamp=1409992498,sign=2ed6a10880c5373953e53892768841b2";//战士
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=2287&server_id=dev1&time=1411196523&sign=a627655a3e503ee10b20d45fa0fb2969&isAdult=2&lgn|Puserid=2287,svrid=dev1,fcm=2,timestamp=1411196523,sign=e05f3eec2492865bf9ac636e660aafb6"
			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=2036&server_id=dev1&time=1411541333&sign=92c01aaba066058e00c4d197aa23615e&isAdult=1&lgn|Puserid=2036,svrid=dev1,fcm=1,timestamp=1411541333,sign=44827445cac040556d7d4a6bedcf9467";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=4653&server_id=dev1&time=1411609096&sign=86aa8a5a37acb72d43d5fc67f49c7377&isAdult=1&lgn|Puserid=4653,svrid=dev1,fcm=1,timestamp=1411609096,sign=596656a2f7c019debe4501df4ce42f4a"
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=4658&server_id=dev1&time=1411610990&sign=232a7901184ccbf2aaec5edceb99f9bf&isAdult=1&lgn|Puserid=4658,svrid=dev1,fcm=1,timestamp=1411610990,sign=0b23c6df5e9f0f176a85485fb79c5cba"

			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=4785&server_id=dev1&time=1412752843&sign=d82a34fe952c190c5a73a08cab20f6fb&isAdult=1&lgn|Puserid=4785,svrid=dev1,fcm=1,timestamp=1412752843,sign=ee859e4aa3b68af36f1c918db5fe15e3";

//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=4792&server_id=dev1&time=1412754058&sign=01c42db3846de4f3dc7dbbe7c4199bd4&isAdult=1&lgn|Puserid=4792,svrid=dev1,fcm=1,timestamp=1412754058,sign=f976779c043e46eee3711a1f1524464b";

//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=2244&server_id=dev1&time=1413010840&sign=839ebf2f437455062afdf0109c54d6af&isAdult=1&lgn|Puserid=2244,svrid=dev1,fcm=1,timestamp=1413010840,sign=ec2146d30dbead53dd982aa78b017eff"

//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=2320&server_id=dev1&time=1413015997&sign=e260694d6ad94ec725fb9eb402189cbb&isAdult=2&lgn|Puserid=2320,svrid=dev1,fcm=2,timestamp=1413015997,sign=7797127e0f72e4b66036fcba594de525"

//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=4892&server_id=dev1&time=1413269866&sign=43a11eddd22b3340eae104525365fab9&isAdult=1&lgn|Puserid=4892,svrid=dev1,fcm=1,timestamp=1413269866,sign=59d816c4aa5b69661c961afc8334e1f2"

			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=4906&server_id=dev1&time=1413257566&sign=cce24d7ec1d0c54e5ed3448b8ed793ad&isAdult=1&lgn|Puserid=4906,svrid=dev1,fcm=1,timestamp=1413257566,sign=ef1e0df23be2d0a523884f916f01dd9d"

//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=41&server_id=dev1&time=1413434044&sign=214f1a645dbbdda1dc0f966f3c75c1c7&isAdult=1&lgn|Puserid=41,svrid=dev1,fcm=1,timestamp=1413434044,sign=3b52760af1a8b4826a005e8d50c7bdd6"
				
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=38&server_id=dev1&time=1413430995&sign=23169b477be7a0b41e2f6eb158c367ec&isAdult=1&lgn|Puserid=38,svrid=dev1,fcm=1,timestamp=1413430995,sign=810f32d917f0186685dd7ad150d3246a"
				
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=101&server_id=dev1&time=1413538732&sign=07cb82ad1f25ea13bb610e11551e79b4&isAdult=1&lgn|Puserid=101,svrid=dev1,fcm=1,timestamp=1413538732,sign=67fbbecb0831cde18e104d2a64ee652b"
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=181&server_id=dev1&time=1413775584&sign=86e869d8611096f4ba728c695fe1194a&isAdult=1&lgn|Puserid=181,svrid=dev1,fcm=1,timestamp=1413775584,sign=26687bd68e6dd77f624fa83338cd4db5";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=203&server_id=dev1&time=1413798950&sign=e3afb2053ad9d8a4e02cb16e2090c36d&isAdult=1&lgn|Puserid=203,svrid=dev1,fcm=1,timestamp=1413798950,sign=1a78718be1e50e66337409e5aeb7a246";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=115&server_id=dev1&time=1413626559&sign=cd4c394975bf4bdb3339252ef313009c&isAdult=1&lgn|Puserid=115,svrid=dev1,fcm=1,timestamp=1413626559,sign=c6cf8bbfe8ef50f193054252bf4dca9b";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=360&server_id=dev1&time=1414056199&sign=07e86a072f783389d41c4f9593d5e462&isAdult=1&lgn|Puserid=360,svrid=dev1,fcm=1,timestamp=1414056199,sign=6a223c2b0df030607d837cf90d3d6b8d";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=396&server_id=dev1&time=1414121640&sign=81f8270b47dce0471cc3ef986b8b55b4&isAdult=1&lgn|Puserid=396,svrid=dev1,fcm=1,timestamp=1414121640,sign=a3e3d9a76ead4d0dc79f13956add8049";
				
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=38&server_id=dev1&time=1413430995&sign=23169b477be7a0b41e2f6eb158c367ec&isAdult=1&lgn|Puserid=38,svrid=dev1,fcm=1,timestamp=1413430995,sign=810f32d917f0186685dd7ad150d3246a";
			
//			this.userNameTinput.text="lgn|Puserid=102681583,svrid=S1,fcm=1,timestamp=1414459719,sign=71fe3159dd1c59afb563daf4ea671005";
			
//			this.userNameTinput.text="lgn|Puserid=1193126246,svrid=S1,fcm=1,timestamp=1414573229,sign=14ff5c755d2aa279a81824b304532796";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=521&server_id=dev1&time=1414759484&sign=b9b982548798744251b0e989a30f5303&isAdult=1&lgn|Puserid=521,svrid=dev1,fcm=1,timestamp=1414759484,sign=32cd3cddb713e7747f2303e9e20fdc5f";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=537&server_id=dev1&time=1414764935&sign=17c33bfa07edb2831496c86f7701345f&isAdult=1&lgn|Puserid=537,svrid=dev1,fcm=1,timestamp=1414764935,sign=10ddb557c8e2b2aec16f2a87ed33f073";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=538&server_id=dev1&time=1414765598&sign=792f8fe261f084c56218f99f630c2d29&isAdult=1&lgn|Puserid=538,svrid=dev1,fcm=1,timestamp=1414765598,sign=8641460ac34e2fef1742f0fed4a17ef7";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=539&server_id=dev1&time=1414765602&sign=3d0170692695d04fb2514c3af7811bee&isAdult=1&lgn|Puserid=539,svrid=dev1,fcm=1,timestamp=1414765602,sign=2799b92b54b07872f7a194f4371c9ee2";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=542&server_id=dev1&time=1414775610&sign=9f085dd5f74da32a5e04fd1e52180dbb&isAdult=1&lgn|Puserid=542,svrid=dev1,fcm=1,timestamp=1414775610,sign=a32695be2150055371a56426cb6adeaf";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=552&server_id=dev1&time=1414982084&sign=6cd00c3d381452b115718bf72ad440a1&isAdult=1&lgn|Puserid=552,svrid=dev1,fcm=1,timestamp=1414982084,sign=2c89727304f71c0c541a18209580e039";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=556&server_id=dev1&time=1414983600&sign=651cf0d448d155311718eb5134d26718&isAdult=1&lgn|Puserid=556,svrid=dev1,fcm=1,timestamp=1414983600,sign=493452a0d009ebc7efd02b7a6a119c68";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=557&server_id=dev1&time=1414983837&sign=a032495451e84d66d597deeca8f4e33f&isAdult=1&lgn|Puserid=557,svrid=dev1,fcm=1,timestamp=1414983837,sign=d3714198c7a09880c0040d7e8fd853c8";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=38&server_id=dev1&time=1413430995&sign=23169b477be7a0b41e2f6eb158c367ec&isAdult=1&lgn|Puserid=38,svrid=dev1,fcm=1,timestamp=1413430995,sign=810f32d917f0186685dd7ad150d3246a";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=567&server_id=dev1&time=1415005492&sign=d009bb9d2c462ad0748770cc6b404e4c&isAdult=1&lgn|Puserid=567,svrid=dev1,fcm=1,timestamp=1415005492,sign=c720d3f69a6aaf672c5987a8a66fe5e8";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=574&server_id=dev1&time=1415009519&sign=9859b1c8c11404c0794cecb3abfaa4b6&isAdult=1&lgn|Puserid=574,svrid=dev1,fcm=1,timestamp=1415009519,sign=305b908d1d66317822ccea73dcb27de6";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=575&server_id=dev1&time=1415009820&sign=ee57f592509545267c84e906ac46be79&isAdult=1&lgn|Puserid=575,svrid=dev1,fcm=1,timestamp=1415009820,sign=bf3965f93f8b7772d71d0aeb6cd7f006";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=582&server_id=dev1&time=1415066080&sign=96aab7a6c5860d01f1eb28c066aca751&isAdult=1&lgn|Puserid=582,svrid=dev1,fcm=1,timestamp=1415066080,sign=901d0f41a6043615213023bd84d64e94";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=584&server_id=dev1&time=1415071044&sign=596fac7b45f6bf1102ce5847d1dc358e&isAdult=1&lgn|Puserid=584,svrid=dev1,fcm=1,timestamp=1415071044,sign=30dc289cf0224040dfb8f2416b16c19b";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=585&server_id=dev1&time=1415071377&sign=3dbd8f9abba344e1b8d854fcf076db4c&isAdult=1&lgn|Puserid=585,svrid=dev1,fcm=1,timestamp=1415071377,sign=952105bee99bd59a5f741af66137cec3";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=586&server_id=dev1&time=1415071678&sign=421cef47bcff66cbaa13eaee916fd1cf&isAdult=1&lgn|Puserid=586,svrid=dev1,fcm=1,timestamp=1415071678,sign=ba2c9196839b61e3a1fdd75ebe5666b5";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=587&server_id=dev1&time=1415072532&sign=918ee4c5d58a8452010a468cbb88cada&isAdult=1&lgn|Puserid=587,svrid=dev1,fcm=1,timestamp=1415072532,sign=d8c59a323e29f4f622091b8f58852268";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=589&server_id=dev1&time=1415073938&sign=c92bec8d8f4a2e0866d722c8233ea217&isAdult=1&lgn|Puserid=589,svrid=dev1,fcm=1,timestamp=1415073938,sign=cebb827c25c469c463f2f63ffd109b17";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=590&server_id=dev1&time=1415074251&sign=c7c518c1f8c1c581c4ce35313c07a1ec&isAdult=1&lgn|Puserid=590,svrid=dev1,fcm=1,timestamp=1415074251,sign=90daefd4ca017e32a250a977dc4b14ec";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=38&server_id=dev1&time=1413430995&sign=23169b477be7a0b41e2f6eb158c367ec&isAdult=1&lgn|Puserid=38,svrid=dev1,fcm=1,timestamp=1413430995,sign=810f32d917f0186685dd7ad150d3246a";
			
//			this.userNameTinput.text="lgn|Puserid=624072057,svrid=S2,fcm=1,timestamp=1415152316,sign=a898061b3e2c774a524f2bfa6be70ef5";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=115&server_id=dev1&time=1415157817&sign=cbec54b1b6cb9f95d7145e9874e0a58e&isAdult=1&lgn|Puserid=115,svrid=dev1,fcm=1,timestamp=1415157817,sign=c37655f66a20840959ce725af8342b05";
			
//			this.userNameTinput.text="lgn|Puserid=102681583,svrid=S1,fcm=1,timestamp=1415160074,sign=50ce8eaf63f0c5b50cbeb4fcce8f2279";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=650&server_id=dev1&time=1415246936&sign=424dbebc22b208dee9d36f13f359fa18&isAdult=1&lgn|Puserid=650,svrid=dev1,fcm=1,timestamp=1415246936,sign=cce42b9bdf112748032d405099462066";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=681&server_id=dev1&time=1417593464&sign=8e1a05a147ac53a92a50f1b6483d6793&isAdult=1&lgn|Puserid=681,svrid=dev1,fcm=1,timestamp=1417593464,sign=19079de934dc16a1336522cbbbff14af";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=682&server_id=dev1&time=1417589908&sign=dc67a460b6f79853529749909fbe3e3e&isAdult=1&lgn|Puserid=682,svrid=dev1,fcm=1,timestamp=1417589908,sign=e929ff702f4ff915ffbf72ff8c96b245";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=683&server_id=dev1&time=1417596636&sign=7b36b5d55cc89368ff2e33349c4c2192&isAdult=1&lgn|Puserid=683,svrid=dev1,fcm=1,timestamp=1417596636,sign=75f6c1139034edda0f4ea82ce70149c9";
//			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=1102&server_id=dev1&time=1417147509&sign=6ee50c094380a9da79056a709ceb4986&isAdult=1&lgn|Puserid=1102,svrid=dev1,fcm=1,timestamp=1417147509,sign=84e759dae28496886e1ba797056d8792";
		
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=1539&server_id=dev1&time=1418786810&sign=0c95ab39f298789cffe184adc53d8b2f&isAdult=1&lgn|Puserid=1539,svrid=dev1,fcm=1,timestamp=1418786810,sign=09d1b51d3bc3e91f502dfbd235185c59";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=1549&server_id=dev1&time=1418788737&sign=b25c981bfe87ce2ec3616b05e64ee162&isAdult=1&lgn|Puserid=1549,svrid=dev1,fcm=1,timestamp=1418788737,sign=30084936c91ee5640f4fa1f7585cb27d";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=1619&server_id=dev1&time=1418898705&sign=71ddaa1f42218413c3face9f751262da&isAdult=1&lgn|Puserid=1619,svrid=dev1,fcm=1,timestamp=1418898705,sign=c1b80d028ae3a3c3240b2a42e9cda937";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=1624&server_id=dev1&time=1418954015&sign=cbee93a0e61d0d6d168ed0a072e55f38&isAdult=1&lgn|Puserid=1624,svrid=dev1,fcm=1,timestamp=1418954015,sign=65f23616fbed52b481fcc1e26640f585";
			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=1642&server_id=dev1&time=1419063268&sign=aa8017b85bb6505f410fbe903a1f67eb&isAdult=1&lgn|Puserid=1642,svrid=dev1,fcm=1,timestamp=1419063268,sign=9954ce95ca04e8037465dd74912e4489";
			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=681&server_id=dev1&time=1419212488&sign=0f1e0a9ca77b37f566a11c2875096a7b&isAdult=1&lgn|Puserid=681,svrid=dev1,fcm=1,timestamp=1419212488,sign=ff075627923238fc3ace428d2ca2166b";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=1686&server_id=dev1&time=1419485228&sign=89c407b49cf41d6f7d7e3bce84143cf8&isAdult=1&lgn|Puserid=1686,svrid=dev1,fcm=1,timestamp=1419485228,sign=5b8f5f890949c9e4a2fa521fc7ac5373";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=dev1658&server_id=dev1&time=1421829809&sign=a31db4300a4deb0e18ec20af53f8ea4f&isAdult=1&key=dev";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=devasda12312&server_id=dev1&time=1432093959&sign=e0c1f6662e6675e654f91965b9e2f09a&isAdult=1&key=dev";
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?qid=dev1&server_id=dev1&time=1421921870&sign=ebe377a101c8c3db6f952ee757c64d4a&isAdult=1&key=dev";
//			this.userNameTinput.text="lgn|Puserid=dev1741,svrid=dev1,fcm=1,timestamp=1422525279,sign=62624af1b8b3e11691d6d0e0a6bf9e25";
//			this.userNameTinput.text="lgn|Puserid=dev4,svrid=dev1,fcm=1,timestamp=1423110393,sign=6d683b45e6f6f20e46b15af2d345e575";
//			this.userNameTinput.text="lgn|Puserid=dev1,svrid=dev1,fcm=1,timestamp=1423899976,sign=02b5b561968659fb0a06b579c542d9b0";
//			this.userNameTinput.text="lgn|Puserid=dev,svrid=dev1,fcm=1,timestamp=1424922535,sign=50e02f559e89fbd199153d3db2be0d7c";
			this.userNameTinput.text="lgn|Puserid=dev52,svrid=dev1,fcm=1,timestamp=1425110846,sign=571637d74a4babd04f4a0cf25a211642";
			this.userNameTinput.text="lgn|Puserid=dev,svrid=dev1,fcm=1,timestamp=1425173971,sign=2d6c7ecaac6b6625a4292576fbeaa64c";
//			this.userNameTinput.text="lgn|Puserid=dev1,svrid=dev1,fcm=1,timestamp=1426833186,sign=813e707f3c614a17a561c1057c557d28";
//			this.userNameTinput.text="lgn|Puserid=dev,svrid=dev1,fcm=1,timestamp=1427253052,sign=9247b08c6252f0127eb39a789f9b4bab";
//			this.userNameTinput.text="lgn|Puserid=devs1,svrid=dev1,fcm=1,timestamp=1430391276,sign=f9c90333852b94bce4e9124a766747eb";
//			this.userNameTinput.text="lgn|Puserid==dev1,svrid=dev1,fcm=1,timestamp=1432110082,sign=cb0a7c0853229dcfccb72d15189678f9";
			this.userNameTinput.text="lgn|Puserid=devxh002,svrid=dev1,fcm=1,timestamp=1434106640,sign=ae0d1982c583391117f302b6dfc16e6f";
			this.userNameTinput.text="lgn|Puserid=devxh003,svrid=dev1,fcm=1,timestamp=1434107054,sign=690bc6dc6d6e60d3e6386e0339d7fac5";
//			this.userNameTinput.text="lgn|Puserid=devcl051,svrid=dev1,fcm=1,timestamp=1434365189,sign=fea9d1b1de25659a4bb51e3bd8c8d27a";
//			this.userNameTinput.text="lgn|Puserid=devndl1,svrid=dev1,fcm=1,timestamp=1434365593,sign=f57afed2c63919643d9b664b5eb24560";
//			this.userNameTinput.text="lgn|Puserid=dev1,svrid=dev1,fcm=1,timestamp=1435137576,sign=a6c66104554a0b738670673cc26d36b8";
			this.userNameTinput.text="lgn|Puserid=devasdafzxzcqaq11,svrid=dev1,fcm=1,timestamp=1435202888,sign=82687433cfe1c920ca65be99cec8d4ef";
//			this.userNameTinput.text="lgn|Puserid=dev1,svrid=dev1,fcm=1,timestamp=1435922185,sign=67dbb191454aee7c19e74c344aac1009";
//			this.userNameTinput.text="lgn|Puserid=devzazaza,svrid=dev1,fcm=1,timestamp=1434681412,sign=1fc657dd4309e15d966f33f44dfba748";
//			this.userNameTinput.text="lgn|Puserid=devww,svrid=S1,fcm=1,timestamp=1435218963,sign=4fca30dfa010554fca3ef767129f4dcf";
//			this.userNameTinput.text="lgn|Puserid=deva1,svrid=dev1,fcm=1,timestamp=1436320025,sign=48f08a3b9f5ed77543f96af3467e64a4";
//			this.userNameTinput.text="lgn|Puserid=deva4,svrid=dev1,fcm=1,timestamp=1436320078,sign=ac8c236c6db757ccf6a714df90769c6f";
//			this.userNameTinput.text="lgn|Puserid=dev1,svrid=deva3,fcm=1,timestamp=1436320056,sign=7a4424788287231d90efaeb92f3c9d16";
//			this.userNameTinput.text="lgn|Puserid=dev1,svrid=dev1,fcm=1,timestamp=1436323073,sign=6c2eed09659a6eeaf3492aa758a34cea";
//			this.userNameTinput.text="lgn|Puserid=dev7,svrid=dev1,fcm=1,timestamp=1436324127,sign=47d4e72c23ec926e93acd8eae40a5cd9";
//			this.userNameTinput.text="lgn|Puserid=deva5,svrid=dev1,fcm=1,timestamp=1436320090,sign=fa055281599bd7ca19dd7bab8f30c58b";
			this.userNameTinput.text="lgn|Puserid=deva6,svrid=dev1,fcm=1,timestamp=1436324987,sign=a452b2e9a0d8a859f2374d3772825a16";
			this.userNameTinput.text="lgn|Puserid=dev12,svrid=dev1,fcm=1,timestamp=1441114331,sign=62c19cc345abbee5bf0ea4d1e0cdb762";
//			this.userNameTinput.text="lgn|Puserid=deva8,svrid=dev1,fcm=1,timestamp=1436325002,sign=22b6b3389a08fb84ada2f8109a67a29d";
//			this.userNameTinput.text="lgn|Puserid=devzxcaq11,svrid=dev1,fcm=1,timestamp=1436353621,sign=087de14eff55a7cee1c00a6069d39c48";
//			this.userNameTinput.text="lgn|Puserid=devzxca11aa,svrid=dev1,fcm=1,timestamp=1436406581,sign=03ea9fefdb82b82b718a9882e497002d";
//			this.userNameTinput.text="lgn|Puserid=devsada11a1,svrid=dev1,fcm=1,timestamp=1436406987,sign=0157e076bcc524358e36699eaf6e00c8";
//			this.userNameTinput.text="lgn|Puserid=dev682,svrid=dev1,fcm=1,timestamp=1448501769,sign=2bea1b31be6b4057922ddcc703258d26";
//			this.userNameTinput.text="lgn|Puserid=zaq1123aaz,svrid=dev1,fcm=1,timestamp=1436407267,sign=4c5391db3d76f0dc398296fe6caf1d51";
//			this.userNameTinput.text="lgn|Puserid=devsadzdz`11,svrid=dev1,fcm=1,timestamp=1436407906,sign=d4dd01e0b1867af951714075b733bb63";
//			this.userNameTinput.text="lgn|Puserid=dev681,svrid=dev1,fcm=1,timestamp=1438760796,sign=65b5fafa0fdaa6754dbdd29e856c3f39";
//			this.userNameTinput.text="lgn|Puserid=dev1,svrid=dev1,fcm=1,timestamp=1438738692,sign=d4c0d6b4bc67601429ca81a171f55315";
//			this.userNameTinput.text="lgn|Puserid=dev1,svrid=dev1,fcm=1,timestamp=1438656579,sign=0ae3f02ce684ba414d4dee815d15d500";
//			this.userNameTinput.text="lgn|Puserid=dev1,svrid=dev1,fcm=1,timestamp=1438937942,sign=394e4c616998f159a252aad7da9dcda2";
//			this.userNameTinput.text="lgn|Puserid=dev1,svrid=dev1,fcm=1,timestamp=1440555153,sign=456afe8639a8e3da42c95cb5446e0b08";
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/index.php?qid=dev5&server_id=dev1&time=1437527353&sign=01f3f0c152a9e133843a11885c47ed75&isAdult=1&key=TW";
//			this.userNameTinput.text="lgn|Puserid=dev2,svrid=dev1,fcm=1,timestamp=1443005081,sign=27a500dd0c7ff9c45a44389bfb52904a";
//			this.userNameTinput.text="lgn|Puserid=dev3,svrid=dev1,fcm=1,timestamp=1443005584,sign=96c9e44e68d8884021fbc611b1324758";
//			this.userNameTinput.text="lgn|Puserid=dev5,svrid=dev1,fcm=1,timestamp=1443007629,sign=8f5336531cb2e939e5af614b8f30bea0";
			this.userNameTinput.text="lgn|Puserid=devqweasd112,svrid=dev1,fcm=1,timestamp=1443059094,sign=37b95addf5509b51c9c7e2ffe707e117";
//			this.userNameTinput.text="lgn|Puserid=dev1,svrid=dev1,fcm=1,timestamp=1445918589,sign=fdea12e814976de2ffd581306215794a";
//			this.userNameTinput.text="lgn|Puserid=devzxcasdad111a1,svrid=dev1,fcm=1,timestamp=1443060827,sign=a71756a60b08e5dfbb29819fd2bd7518";
			this.userNameTinput.text="lgn|Puserid=dev5,svrid=dev1,fcm=1,timestamp=1445328863,sign=c67b9969b88a69cec601fd1473edf465";
//			this.userNameTinput.text="lgn|Puserid=dev1,svrid=dev1,fcm=1,timestamp=1451037956,sign=db0827deb6a2365e010d6addd502151e";
//			this.userNameTinput.text="lgn|Puserid=U381389024020,svrid=S13,fcm=1,timestamp=1451971740,sign=81e1c02f9dcceabf0cbbbe8fb8bf5a0b";
//			this.userNameTinput.text="lgn|Puserid=dev2,svrid=dev1,fcm=1,timestamp=1454478758,sign=5efda29b306a2087326fb112d424bd54";
//			this.userNameTinput.text="lgn|Puserid=devzxcaa11a131,svrid=dev1,fcm=1,timestamp=1455783464,sign=e148d5b9e887d92bdb7c6cb500739e6c";
//			this.userNameTinput.text="lgn|Puserid=dev2,svrid=dev1,fcm=1,timestamp=1457943069,sign=dde70b5bdc944b677066e8b174d506a8";
//			this.userNameTinput.text="lgn|Puserid=dev2,svrid=dev1,fcm=1,timestamp=1458274667,sign=ea51bd0dab3eab0cfb0926bb52939b11";
			this.userNameTinput.text="lgn|Puserid=devsddswqwqe12,svrid=dev1,fcm=1,timestamp=1458612168,sign=8fc474f0f8cc3f043163ac5f37349ca6";
//			this.userNameTinput.text="lgn|Puserid=devasafafsdfad,svrid=dev1,fcm=1,timestamp=1458636844,sign=895ef8dcebb4504b513ed21f8f7acf38";
//			this.userNameTinput.text="lgn|Puserid=devzxvzcxzvz232131,svrid=dev1,fcm=1,timestamp=1458644014,sign=4f4517b3cecdd4389a17c9905bbe9a0d";
//			this.userNameTinput.text="lgn|Puserid=devsdadsgsda21`32131,svrid=dev1,fcm=1,timestamp=1458717789,sign=17980c94a2d3a389e075dbb3185def6b";
//			this.userNameTinput.text="lgn|Puserid=devdsa2131421,svrid=dev1,fcm=1,timestamp=1459482880,sign=d80ce2e359e2a4986e300634344d44b3";
//			this.userNameTinput.text="lgn|Puserid=devsafgd21312412,svrid=dev1,fcm=1,timestamp=1459497998,sign=2549ac5903026e4cfffd760f4b65ad5f";
//			this.userNameTinput.text="lgn|Puserid=devndl123,svrid=dev1,fcm=1,timestamp=1459997381,sign=0d3f8348cedd72487f92bd1f04333404";
//			this.userNameTinput.text="lgn|Puserid=devndl002,svrid=dev1,fcm=1,timestamp=1460018022,sign=633d2e620e1656df4ffda5348ccea439";
			this.userNameTinput.text="lgn|Puserid=devsagsqwe13131,svrid=dev1,fcm=1,timestamp=1460019544,sign=9521ebb34855b56c636fb93eb7113841";
//			this.userNameTinput.text="lgn|Puserid=devga2312412,svrid=dev1,fcm=1,timestamp=1460020717,sign=6f8af819ae37aeb23bcd09e5c28f8906";
//			this.userNameTinput.text="lgn|Puserid=devndl330,svrid=dev1,fcm=1,timestamp=1460100699,sign=7b3263d6aedb3742fd46e9e82b2de7e7";
//			this.userNameTinput.text="lgn|Puserid=devzxcvxz31231241,svrid=dev1,fcm=1,timestamp=1460112082,sign=467c7933afd218c9fe14058f82989349";
//			this.userNameTinput.text="lgn|Puserid=ndlasd11,svrid=dev1,fcm=1,timestamp=1460443128,sign=91c0c73f1a199bf1ed28c41fb7da47b9";
//			this.userNameTinput.text="lgn|Puserid=devasd1232141,svrid=dev1,fcm=1,timestamp=1460453432,sign=d00b433f686a8160593310a32c137609";
//			this.userNameTinput.text="lgn|Puserid=ddeevvzxv21412,svrid=dev1,fcm=1,timestamp=1460721021,sign=e35b5093bb923ce8733eba2d8dc6e445";
			this.userNameTinput.text="lgn|Puserid=devndl123,svrid=dev1,fcm=1,timestamp=1460721916,sign=fa3f887c24c11d09efceab6bb377c1f8";
//			this.userNameTinput.text="lgn|Puserid=ygf123,svrid=dev1,fcm=1,timestamp=1460721998,sign=7d3c675e873a92807c02d4dfba8b7d50";
//			this.userNameTinput.text="lgn|Puserid=xhzqndkkdw,svrid=dev1,fcm=1,timestamp=1461121352,sign=a3e36c7f3640a681300327b60de1b4ba";
//			this.userNameTinput.text="lgn|Puserid=xcv1231asdaa12,svrid=dev1,fcm=1,timestamp=1461324678,sign=51ea0f8aca0c8ffb64c1308758e798ab";
//			this.userNameTinput.text="lgn|Puserid=xczvasqw12321,svrid=dev1,fcm=1,timestamp=1461572524,sign=d6306078e1da259183690446c901f7cb";
//			this.userNameTinput.text="lgn|Puserid=devsdgs12321412,svrid=dev1,fcm=1,timestamp=1461580930,sign=d43666227afae9c0d7dc5368a194ef63";
//			this.userNameTinput.text="lgn|Puserid=123sadas,svrid=S1,fcm=1,timestamp=1461583170,sign=88f4f36bcdb260f5f8fdfaa80e8674fe";
//			this.userNameTinput.text="lgn|Puserid=devsdag123412,svrid=dev1,fcm=1,timestamp=1461657919,sign=89acad2d1508dfee21a305d0a131e348";
			this.userNameTinput.text="lgn|Puserid=dev1,svrid=dev1,fcm=1,timestamp=1461810134,sign=2b48293c7d0d36dee6f056a63e007e0b";
//			this.userNameTinput.text="lgn|Puserid=devdasf1231421,svrid=dev1,fcm=1,timestamp=1461810815,sign=d5750a27e542efac6310423637943968";
//			this.userNameTinput.text="lgn|Puserid=nnddllgannidfsamadev,svrid=dev1,fcm=1,timestamp=1461819048,sign=444dffc014536838bfa03db84f7ff01d";
//			this.userNameTinput.text="lgn|Puserid=dsaf21312ssa21zq112121,svrid=dev1,fcm=1,timestamp=1461923219,sign=c6264102276ddc2613b6cf4786230dfc";
//			this.userNameTinput.text="lgn|Puserid=devASD12312,svrid=dev1,fcm=1,timestamp=1462265900,sign=80fbcac2d4c2a7ea6741b2c91efec76a";
			this.userNameTinput.text="lgn|Puserid=zxc1211a1231,svrid=dev1,fcm=1,timestamp=1462334382,sign=668a02497d93ed65629c64bf505c8ad1";
			this.userNameTinput.text="lgn|Puserid=devsada12312412,svrid=dev1,fcm=1,timestamp=1462335220,sign=bdf26d215c87855fd61097c890420135";
			this.userNameTinput.text="lgn|Puserid=devyxh001,svrid=dev1,fcm=1,timestamp=1462335453,sign=cce41bf7769c59c4d8e138039520c68b";
			this.userNameTinput.text="lgn|Puserid=devyeguofeng001,svrid=dev1,fcm=1,timestamp=1462335469,sign=992bb5a4c2869e4a1b93656ebd9bbcd0";
//			this.userNameTinput.text="lgn|Puserid=devqinzhenqiang001,svrid=dev1,fcm=1,timestamp=1462335484,sign=28a78c3971364dfe5e590fad91cb4fcb";
//			this.userNameTinput.text="lgn|Puserid=dev123456111lxsjd123,svrid=dev1,fcm=1,timestamp=1462335504,sign=408a4027daf07eeb09040e350ab7fc84";
//			this.userNameTinput.text="lgn|Puserid=ridayewkj@04,svrid=dev1,fcm=1,timestamp=1462337483,sign=3302c37613a636b6ef2f038d62c2b28f";
//			this.userNameTinput.text="lgn|Puserid=ridayewkj@03,svrid=dev1,fcm=1,timestamp=1462337471,sign=fc877e43cb2e61dd7dd103ee39ae9331";
//			this.userNameTinput.text="lgn|Puserid=delstvivieintstring@1,svrid=dev1,fcm=1,timestamp=1462339395,sign=0e8c18b78870ed655e8ac26a2e242634";
//			this.userNameTinput.text="lgn|Puserid=delstvivieintstring@3,svrid=dev1,fcm=1,timestamp=1462339425,sign=28087d9c49eda89039bf3dba8f969592";
//			this.userNameTinput.text="lgn|Puserid=ndlqzqwuyu@123,svrid=dev1,fcm=1,timestamp=1462346334,sign=193ca20cb0497e9d0dae432b7ebdb3f2";
//			this.userNameTinput.text="lgn|Puserid=devxzcasdqweqgfg,svrid=dev1,fcm=1,timestamp=1462349658,sign=a9139f1459cf88e2f21c96ede7df05b9";
//			this.userNameTinput.text="lgn|Puserid=cxzas121aazxcas123,svrid=dev1,fcm=1,timestamp=1462353630,sign=7a912f8d42a52b877d0bd532c8a185e1";
			this.userNameTinput.text="lgn|Puserid=wbllsxkjsda001,svrid=dev1,fcm=1,timestamp=1462415472,sign=587d255e36e17d3b4aa31d39f5777311";
			this.userNameTinput.text="lgn|Puserid=wbwowowozxc002,svrid=dev1,fcm=1,timestamp=1462416072,sign=cd16f80f67e5e036866a91d045545df7";
			this.userNameTinput.text="lgn|Puserid=cwewwwbbb003,svrid=dev1,fcm=1,timestamp=1462417606,sign=159e06557c866791b3a4255180f7cfb1";
			this.userNameTinput.text="lgn|Puserid=cwewwwbbb004,svrid=dev1,fcm=1,timestamp=1462418551,sign=acc68e2968aa2ed0efcd70b7963895b2";
//			this.userNameTinput.text="lgn|Puserid=cwewwwbbb005,svrid=dev1,fcm=1,timestamp=1462419181,sign=753c8aa95e296d3f1390600b43a34ce3";
			this.userNameTinput.text="lgn|Puserid=xzzxcz11231231,svrid=dev1,fcm=1,timestamp=1462448110,sign=0ad59192aa7c8a6ec9b82d1f73c909c4";
			
			
//			this.userNameTinput.text="http://192.168.10.16/dragon/game/?ip=192.168.10.88?port=9932?lgn|Puserid=dev1212,svrid=dev1,fcm=1,timestamp=1431419816,sign=50c13694517e451a564b2486d533f394";
//			this.userNameTinput.text="lgn|Puserid=dev2,svrid=dev1,fcm=1,timestamp=1433939439,sign=07aa684b730b5e8a821126cddfb43aae";
			
			if (Core.webId && Core.webId != "") {
				this.userNameTinput.text=Core.webId;
				this.loginBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				this.mouseChildren=this.mouseEnabled=false;
				this.alpha=0.5;
				this.visible=false;
			}

		}

		private function onClick(evt:MouseEvent):void {
			switch (evt.target.name) {
				case "loginBtn":
					this.onLogin();
					break;
				case "signBtn": //注册
					navigateToURL(new URLRequest("http://192.168.10.88/game"));
					break;
				case "forgetPassWorldBtn": //忘记密码
					break;
				case "saveNameCheckBox":
					if (this.saveNameCheckBox.isOn) {
						//存账号

					} else {
						//不存账号

					}
					break;
			}
		}

		private function onLogin():void {
			LogManager.getInstance().showLog("连接服务器：" + Core.serverIp + ":" + Core.loginPort);
			trace("连接服务器：" + Core.serverIp + ":" + Core.loginPort);
			NetGate.getInstance().connect(Core.serverIp, Core.loginPort);
		}

		public function onConnect():void {
			Cmd_Login.cm_lgn(this.userNameTinput.text);
		}

		override public function die():void {
			this.loginBtn.removeEventListener(MouseEvent.CLICK, onClick);
			if (this.parent != null)
				this.parent.removeChild(this);
		}

		public function onResize($w:Number=0, $h:Number=0):void {
			this.x=(UIEnum.WIDTH - this.width) >> 1;
			this.y=(UIEnum.HEIGHT - this.height) >> 1;
		}

	}

}
