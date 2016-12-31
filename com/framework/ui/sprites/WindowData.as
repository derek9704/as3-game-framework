package com.framework.ui.sprites
{

	/**
	 * 窗体的相关数据
	 *
	 * @author derek
	 */
	public class WindowData
	{
		/**
		 * 是否模式窗口
		 */
		public var model:Boolean;
		/**
		 * 是否独立窗口
		 */
		public var alone:Boolean;
		public var xoffset:int;
		public var yoffset:int;
		public var align:int;
		/**
		 * 初始化数据
		 */
		private var _initData:*;
		/**
		 * 窗体类.应该继承自CWindow
		 */
		private var _class:Class;
		/**
		 * 窗体
		 */
		private var _window:CWindow;

		/**
		 * 窗体
		 */
		public function get window():CWindow
		{
			// 当第一次使用的时候.则生成之
			if (_window == null)
				_window = new _class(_initData);

			return _window;
		}

		/**
		 * 窗体数据
		 *
		 * @param type 窗体类型
		 * @param initData 窗体的初始化数据
		 * @param model 是否是模式窗口
		 * @param alone 是否是独立窗口，打开后自动关闭另外一个
		 */
		public function WindowData(type:Class, initData:* = null, model:Boolean = false, xoffset:int = 0, yoffset:int = 0, align:int = 0, alone:Boolean = true)
		{
			_initData = initData;
			this.model = model;
			this.alone = alone;
			this.xoffset = xoffset;
			this.yoffset = yoffset;
			this.align = align;
			_class = type;
		}
	}
}
