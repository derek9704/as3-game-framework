package com.framework.ui.component
{
	import com.framework.ui.basic.sprite.CSprite;

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;

	/**
	 * 单选框
	 */
	public class RadioButton extends CSprite
	{
		private var _mc : MovieClip;
		private var _id : String;
		private var _callback : Function;
		private var _title : TextField;

		/**
		 * 构造函数
		 * 
		 * @param title 显示文本
		 * @param mc 按钮对象
		 * @param id id
		 * @param selected 是否选中
		 * @param xSpace 文本和按钮之间的间隔
		 * @param format 文本的格式
		 */
		public function RadioButton(title : String, mc : MovieClip, id : String, selected : Boolean, xSpace : int, format : TextFormat, filters : Array = null)
		{
			super('', mc.width, mc.height);

			// 禁用子对象的鼠标事件
			mouseChildren = false;

			// 构造并初始化值
			_mc = mc;
			_mc.gotoAndStop(selected ? 2 : 1);

			addChildV(_mc);

			// 如果没有传入ID则使用title作为id;
			_id = id == null || id == '' ? title : id;

			// 设定单击事件

			evts.addClick(function(event : MouseEvent) : void
			{
				if (_callback != null)
					_callback(event);
			});

			// 如果没有传入文本.就不显示
			if (title == '' || title == null)
				return;

			// 如果没有传入文本样式.则使用默认样式
			// 12号字.白色
			if (format == null)
			{
				format = new TextFormat();
				format.size = 12;
				format.color = 0xffffff;
			}
			;

			// 构造文本框
			_title = new TextField();

			_title.defaultTextFormat = format;
			_title.autoSize = TextFieldAutoSize.LEFT;
			_title.text = title;

			// 设置控件宽度
			cWidth = _mc.width + xSpace + _title.width;

			// 取最大高度作为控件的高度.这里要用textHeight.而不是height.
			cHeight = _title.textHeight > _mc.height ? _title.textHeight : _mc.height;
			// 加入选择框和文本框
			addChildV(_title, _mc.width + xSpace);

			// 修改mc的y offset
			if (cHeight > mc.height)
				mc.y = (cHeight - mc.height) / 2;

			if (filters != null)
				_title.filters = filters;
		}

		/**
		 * id
		 */
		public function get id() : String
		{
			return _id;
		}

		/**
		 * 选中状态
		 */
		public function get select() : Boolean
		{
			return _mc.currentFrame == 2;
		}

		/**
		 *  获取显示文本
		 */
		public function get text() : String
		{
			return _title.text;
		}

		/**
		 * 设置文本
		 */
		public function set text(val : String) : void
		{
			var oldWidth : int = _title.width;

			_title.text = val;

			// 重新设置控件宽度
			cWidth = cWidth - oldWidth + _title.width;
		}

		/**
		 * 选中状态
		 */
		public function set select(value : Boolean) : void
		{
			_mc.gotoAndStop(value ? 2 : 1);
		}

		/**
		 * 单击的回调函数
		 */
		public function set click(callback : Function) : void
		{
			_callback = callback;
		}
	}
}