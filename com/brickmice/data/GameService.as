package com.brickmice.data
{
	import com.brickmice.Main;
	import com.framework.utils.json.JSONEncoder;
	import com.framework.utils.json.decodeJson;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * 后台数据请求类
	 * @author derek
	 *
	 */
	public class GameService
	{
		/**
		 * 向服务器请求数据
		 *
		 * @param args 参数列表 要求参数格式: [Object, Object, ...];
		 * Object格式为{"action":"methodName", "args":{"参数名":"参数值", "参数名":"参数值", ...}, 其中action, args不变
		 * @param success 请求成功回调函数 格式: success():void;
		 * @param fail 请求失败回调函数 格式: fail():void;
		 * @param lock 是否锁定屏幕
		 * @param showLoading 是否显示Loading动画
		 */
		public static function request(args:Array, success:Function = null, fail:Function = null, lock:Boolean = true, showLoading:Boolean = false):void
		{
			var request:URLRequest = new URLRequest(Consts.requestURL);
			request.method = URLRequestMethod.POST;

			var values:URLVariables = new URLVariables();
			var str:String = new JSONEncoder(args).getString();

			values.d = str;

			trace("发送数据: " + str);
			request.data = values;

			var loader:URLLoader = new URLLoader(request);

			loader.addEventListener(IOErrorEvent.IO_ERROR, function(evt:Event):void
			{
				loader.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
				Main.self.unlockScene();
				trace("Php服务连接错误");
			});

			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(evt:Event):void
			{
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, arguments.callee);
				Main.self.unlockScene();
				trace("Php服务器连接安全沙箱错误");
			});

			loader.addEventListener(Event.COMPLETE, function(evt:Event):void
			{
				loader.removeEventListener(Event.COMPLETE, arguments.callee);
				// 解锁
				if (lock)
					Main.self.unlockScene();
				
				// 把数据设置到缓存中
				var d:Object = decodeJson(evt.target.data);
				var ret:Boolean = Data.setData(d);
				
				trace("php返回数据(解析后): " + new JSONEncoder(d).getString());
				
				// 成功的请求
				if (ret && success != null)
				{
					success();
					return;
				}
				
				// 有错误信息.回调之
				if (!ret && fail != null)
				{
					fail();
					trace('请求发生错误');
				}
			});

			// 执行
			if (lock)
				Main.self.lockScene(showLoading, true);

			loader.load(request);
		}
	}
}
