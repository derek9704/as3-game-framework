package com.framework.ui.component.slim
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author derek
	 */
	public class SlimSwitchButton
	{
		private var _mc : MovieClip;

		/**
		 */
		public function SlimSwitchButton(mc : MovieClip, id : *)
		{
			_mc = mc;

			// 保存ID
			_id = id;

			// 默认1
			_mc.gotoAndStop(1);

			// 鼠标移入.如果是普通状态.则改成移入状态
			mc.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				if (_mc.currentFrame == 1)
				{
					_mc.gotoAndStop(2);
				}
			});

			// 鼠标移出.如果是普通状态.则改成普通状态
			mc.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				if (_mc.currentFrame == 2)
				{
					_mc.gotoAndStop(1);
				}
			});

			// 鼠标点击.
			mc.addEventListener(MouseEvent.CLICK, function(event : MouseEvent) : void
			{
				if (_mc.currentFrame == 3)
				{
					return;
				}

				// 回调被选择的ID
				if (click != null)
					click(id);

				// 按钮设置为已选择
				_mc.gotoAndStop(3);
			});
			mc.buttonMode = true;
		}

		/**
		 *  设置按钮状态
		 */
		public function set status(value : int) : void
		{
			_mc.gotoAndStop(value);
		}

		public function get select() : Boolean
		{
			return _mc.currentFrame == 3;
		}

		public function set select(val : Boolean) : void
		{
			_mc.gotoAndStop(val ? 3 : 1);
		}

		private var _id : *;

		/**
		 * id
		 */
		public function get id() : *
		{
			return _id;
		}

		/**
		 * id
		 */
		public function set id(id : *) : void
		{
			_id = id;
		}

		public var click : Function;
	}
}
