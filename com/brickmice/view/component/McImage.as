package com.brickmice.view.component
{
	import com.brickmice.data.Consts;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	public class McImage extends Loader
	{
		public static const BASE_URL : String = Consts.resourceURL + 'image/';
		public static const EXT_NAME : String = '.png';
		// 图片地址
		private var _url : String;
		private var _success : Function;

		/**
		 * 构造函数
		 * 
		 * @param name 图片名字
		 */
		public function McImage(name : String = 'init', success : Function = null)
		{
			_success = success;

			this.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			this.contentLoaderInfo.addEventListener(Event.OPEN, openHandler);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			if (name == "" || name == null)
			{
				name = "missImg";
			}
			if(name != 'init'){
				_url = Consts.resourceURL + 'image/' + name + EXT_NAME;
				this.load(new URLRequest(_url));	
			}
		}

		public function reload(name : String, success : Function = null) : void
		{
			// 更新成功的callback
			_success = success;

			if (name == "" || name == null)
			{
				name = "missImg";
			}

			// 不需要重载?
			if (_url == Consts.resourceURL + 'image/' + name + EXT_NAME)
			{
				if (_success != null)
					_success();

				return;
			}

			_url = Consts.resourceURL + 'image/' + name + EXT_NAME;

			this.load(new URLRequest(_url));
		}

		private function completeHandler(evt : Event) : void
		{
			if (_success != null)
				_success();
		}

		private function openHandler(evt : Event) : void
		{
		}

		private function ioErrorHandler(evt : IOErrorEvent) : void
		{
			trace("MImage IOError", this._url);
		}
	}
}