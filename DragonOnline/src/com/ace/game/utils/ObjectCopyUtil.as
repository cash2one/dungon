package com.ace.game.utils
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.flash_proxy;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class ObjectCopyUtil
	{

		private static var copier:ByteArray = new ByteArray();
		
		public static function cloneObject(source:Object):* {  
			var typeName:String = getQualifiedClassName(source);//获取全名  
			//trace("输出类的结构"+ typeName);  
			var packageName:String = typeName.split("::")[0];//切出包名  
			//trace("类的名称" + packageName);  
			var type:Class = getDefinitionByName(typeName) as Class;//获取Class  
			//trace(type);  
			registerClassAlias(packageName, type);//注册Class  
			//复制对象
			copier.position = 0;
			copier.writeObject(source);  
			copier.position = 0;
			return copier.readObject();  
		}  
	}
}