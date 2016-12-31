package com.framework.ui.component.slim
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author derek
	 */
	public class SlimCheckbox
	{
		private var _mc : MovieClip;

		public function set select(value : Boolean) : void
		{
			_mc.gotoAndStop(value ? 2 : 1);
		}

		public function get select() : Boolean
		{
			return _mc.currentFrame == 2;
		}

		public function SlimCheckbox(mc : MovieClip, title : TextField = null, onClick : Function = null)
		{
			// 保存ID
			_id = id;

			_mc = mc;

			// 默认1
			mc.gotoAndStop(1);

			var click : Function = function(event : MouseEvent) : void
			{
				_mc.currentFrame == 1 ? _mc.gotoAndStop(2) : _mc.gotoAndStop(1);

				onClick(_mc.currentFrame == 2);
			};

			if (title != null)
			{
				title.addEventListener(MouseEvent.CLICK, click);
			}

			// 鼠标点击.
			mc.addEventListener(MouseEvent.CLICK, click);
			mc.buttonMode = true;
		}

		private var _id : String;

		/**
		 * id
		 */
		public function get id() : String
		{
			return _id;
		}

		/**
		 * id
		 */
		public function set id(id : String) : void
		{
			_id = id;
		}
	}
}
