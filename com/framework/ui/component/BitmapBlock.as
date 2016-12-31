package com.framework.ui.component
{
	import flash.display.BitmapData;
	import flash.display.Sprite;

	/**
	 * @author derek
	 */
	public class BitmapBlock extends Sprite
	{
		private var _block : BitmapData;

		public function BitmapBlock(refClass : Class, width : int, height : int)
		{
			_width = width;
			_height = height;
			_block = new refClass();

			if (width == 0 || height == 0)
				return;

			relayout();
		}

		public override function set width(val : Number) : void
		{
			_width = val;
			relayout();
		}

		public override function set height(val : Number) : void
		{
			_height = val;
			relayout();
		}

		public override function get width() : Number
		{
			return _width;
		}

		public override function get height() : Number
		{
			return _height;
		}

		private var _width : int;
		private var _height : int;

		private function relayout() : void
		{
			// 设置背景
			graphics.clear();
			graphics.beginBitmapFill(_block);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
		}
	}
}
