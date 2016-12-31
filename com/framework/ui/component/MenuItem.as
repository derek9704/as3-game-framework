package com.framework.ui.component
{
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.FilterUtils;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author derek
	 */
	public class MenuItem extends CSprite
	{
		private var _self : MenuItem;

		public function MenuItem(title : String, bg : MovieClip, callback : Function, subMenu : Menu)
		{
			super('', bg.width, bg.height);
			_bg = bg;

			_bg._txt = title;
			_self = this;

			if (callback != null)
				evts.addClick(function(event : MouseEvent) : void
				{
					callback(title);
				});

			if (subMenu != null)
			{
				addChildEx(subMenu);
				subMenu.visible = false;
			}

			evts.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_bg.gotoAndStop(2);

				if (subMenu == null)
					return;

				var parent : Menu = _self.parent as Menu;

				if (parent == null)
					return;

				var pos : Point = localToGlobal(new Point(x, y));

				if (parent.horizontal)
					pos.y += cHeight;
				else
					pos.x += cWidth;

				// 进行屏幕边缘的检查
				if (stage == null)
					return;

				if (pos.x + subMenu.cWidth > stage.stageWidth)
					subMenu.x = -subMenu.cWidth;
				else
					subMenu.x = cWidth;

				if (pos.y + subMenu.cHeight > stage.stageHeight)
					subMenu.y = -subMenu.cHeight;
				else
					subMenu.y = cHeight;

				subMenu.visible = true;
			});

			evts.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				_bg.gotoAndStop(1);

				if (subMenu != null)
					subMenu.visible = false;
			});
		}

		/**
		 * 是否禁用菜单项
		 */
		public function set disable(d : Boolean) : void
		{
			enable = !d;

			if (d)
				FilterUtils.setColorMask(this);
			else
				FilterUtils.clearColorMask(this);
		}

		private var _bg : MovieClip;
	}
}
