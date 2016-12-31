package com.framework.ui.component
{
	import com.framework.ui.basic.sprite.CSprite;

	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	/**
	 * @author derek
	 */
	public class Menu extends CSprite
	{
		private var _margin : int;

		public function Menu(bgDo : DisplayObject, split : int, horizontal : Boolean = true, width : int = 100, height : int = 20, margin : int = 4)
		{
			super('', width, height);
			bg.setBg(bgDo);

			_split = split;
			horizontal = horizontal;

			_margin = _xoffset = _yoffset = margin;
		}

		/**
		 * 菜单项
		 */
		private var _items : Dictionary;
		/**
		 * 菜单项之间间隔
		 */
		private var _split : int = 6;
		private var _xoffset : int;
		private var _yoffset : int;
		/**
		 * 菜单方向(水平?)
		 */
		public var horizontal : Boolean = true;

		public function addItem(item : MenuItem) : void
		{
			_items[item] = item;

			addChildEx(item, _xoffset, _yoffset);

			if (horizontal)
			{
				cWidth = _xoffset + item.cWidth + _margin;
				_xoffset += item.cWidth + _split;
			}
			else
			{
				cHeight = _yoffset + item.cHeight + _margin;
				_yoffset += item.cHeight + _split;
			}
		}
	}
}
