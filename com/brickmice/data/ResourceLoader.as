package com.brickmice.data
{
	import com.brickmice.Main;
	
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;

	public class ResourceLoader
	{
		/**
		 * 构造函数
		 *
		 */
		public function ResourceLoader()
		{
		}

		/**
		 * 加载XML 记得随后System.disposeXML(xml);
		 *
		 * @param xml 名字
		 * @param callback 成功后的回调函数.格式 callback(xml:XML):void;
		 */
		public static function loadXml(xml:String, callback:Function):void
		{
			// 读取xml
			var url:URLRequest = new URLRequest(xml);
			var loader:URLLoader = new URLLoader(url);

			// 载入配置文件
			loader.addEventListener(Event.COMPLETE, function(event:Event):void
			{
				loader.removeEventListener(Event.COMPLETE, arguments.callee);
				callback(new XML(loader.data));
			});
		}
		
		/**
		 *  加载游戏资源 
		 * @param items
		 * @param complete
		 * 
		 */
		public static function loadRes(items : Array, complete : Function) : void
		{			
			Main.self.lockScene();
			// 载入各种资源
			loadItems(items, function(pre : int) : void
			{
				Main.self.loadingLayer.setLoadingProcess(pre);
			}, function(url : String, index : int, len : int) : void
			{
			}, function() : void
			{
				Main.self.unlockScene();
				complete();
			});
		}	

		/**
		 * 批量加载资源
		 *
		 * @param items 资源列表 一个字符串数组
		 * @param progress 处理中函数 process(pre:int):void; pre:当前加载资源的百分比
		 * @param start 开始加载一个资源的回调方法 start(url:String,index:int,len:int);  url:当前加载的资源名; index:当前加载的偏移,len:总个数
		 * @param complete 全部加载完成的回调函数 complete();  
		 */
		public static function loadItems(items : Array, progress : Function, start : Function, complete : Function) : void
		{
			// 资源总数
			var len:int = items.length;

			// 当前加载资源的偏移量
			var offset:int = 0;

			// 加载资源的函数
			var process:Function = function():void
			{
				// 开始加载
				start(items[offset], offset, len);

				// 载入当前资源
				load(items[offset], function():void
				{
					// 载入完成.下一个
					offset++;

					// 如果已经最后一个,回调成功.返回
					if (offset >= len)
					{
						complete();
						return;
					}

					// 成功后加载下一个资源
					process();
				}, progress);
			};

			process();
		}

		/**
		 * 加载目标资源
		 *
		 * @param item 资源url
		 * @param complete 当加载完成的callback, 格式 complete():void;
		 * @param progress 加载中的回调函数,格式progress(pre:int):void;   pre为当前完成的百分比( 100 - 0)
		 *
		 */
		public static function load(item : String, complete : Function, progress : Function) : void
		{
			var request : URLRequest = new URLRequest(Consts.resourceURL + item);

			var context:LoaderContext = new LoaderContext();

			context.applicationDomain = ApplicationDomain.currentDomain;
//			context.securityDomain = SecurityDomain.currentDomain;

			// load
			var loaderTimes:Boolean = true;
			var loader:Loader = new Loader();

			var completeHandler:Function = function(e:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loader.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);

				complete();
			};

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);

			var progressHandler:Function = function(e:ProgressEvent):void
			{
				progress(int(e.bytesLoaded / e.bytesTotal * 100));
			};

			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);

			var ioErrorHandler:Function = function(evt:ErrorEvent):void
			{
				// trace("Load error!  "+evt.errorID);
				// 加载
				if (loaderTimes)
				{
					loader.load(request, context);
					loaderTimes = false;
				}
				else
				{
					Main.self.unlockScene();
				}
			};

			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

			var uncaughtErrorHandler:Function = function(event:UncaughtErrorEvent):void
			{
				// 加载
				if (loaderTimes)
				{
					loader.load(request, context);
					loaderTimes = false;
				}
				else
				{
					Main.self.unlockScene();
				}
			};

			loader.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);

			// 加载
			loader.load(request, context);
		}
	}
}
