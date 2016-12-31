package com.framework.ui.component
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	public class UrlImage extends Loader
	{
		public static const BASE_URL : String = 'image/';
		public static const EXT_NAME : String = '.png';
		// 是否已加载
		private var _blLoaded : Boolean;
		// 是否异步设置宽度和高度
		private var _blAsyncSetWidth : Boolean;
		private var _blAsyncSetHeight : Boolean;
		private var _width : Number;
		private var _height : Number;
		// 图片地址
		private var _url : String;

		/**
		 * 构造函数
		 * 
		 * @param name 图片名字
		 */
		public function UrlImage(name : String = null)
		{
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			this.contentLoaderInfo.addEventListener(Event.OPEN, openHandler);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_url = BASE_URL + name + EXT_NAME;
			if (name != '' && name != null)
				this.load(new URLRequest(_url));
		}

		public function reload(name : String) : void
		{
			_url = BASE_URL + name + EXT_NAME;
			this.load(new URLRequest(_url));
		}

		private function completeHandler(evt : Event) : void
		{
			_blLoaded = true;

			if (_blAsyncSetWidth)
			{
				content.x = (_width - content.width) / 2;
			}
			else
			{
				_width = this.content.width;
			}

			if (_blAsyncSetHeight)
			{
				content.y = (_height - content.height) / 2;
			}
			else
			{
				_height = this.content.height;
			}
		}

		private function openHandler(evt : Event) : void
		{
		}

		private function ioErrorHandler(evt : IOErrorEvent) : void
		{
			trace("MImage IOError", this._url);
		}

		public override function set width(value : Number) : void
		{
			_width = value;

			_blAsyncSetWidth = true;
		}

		public override function set height(value : Number) : void
		{
			_height = value;

			_blAsyncSetHeight = true;
		}

		public override function get width() : Number
		{
			if (!_width)
			{
				_width = 0;
			}
			return _width;
		}

		public override function get height() : Number
		{
			if (!_height)
			{
				_height = 0;
			}
			return _height;
		}
	}
}