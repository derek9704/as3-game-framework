package com.framework.ui.component
{
	import flash.display.Shape;

	/**
	 * @author derek
	 */
	public class PureColorBlock extends Shape
	{
		private var _color : int;

		public function PureColorBlock(color : int, width : int, height : int)
		{
			_color = color;
			_width = width;
			_height = height;

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

		private var _width : int;
		private var _height : int;

		private function relayout() : void
		{
			graphics.clear();
			graphics.beginFill(_color);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
		}
	}
}
