package com.framework.ui.component
{
	import com.framework.ui.basic.canvas.CCanvas;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * TablePanel上的一个按钮.
	 * 请不要直接使用本类.在TabPanel类中.对本类进行了使用方法上的封装.
	 * 因此请直接使用TabPanel即可(项目中请使用已经被封装掉的TabPanel).
	 * 
	 * @author derek
	 */
	public class SwitchButton extends CCanvas
	{
		private var _text : TextField;
		private var _overColor : int;
		private var _normalColor : int;
		private var _selectColor : int;

		/**
		 * @param bgRef 按钮MC的引用类.详细说明参见TabPanel点构造函数
		 * @param title 按钮标题
		 * @param id id
		 * @param normalColor 普通状态文本颜色
		 * @param overColor over状态文本颜色
		 * @param selectColor 选择状态文本颜色
		 * @param format 按钮的文本格式
		 * @param embed 按钮是否使用的嵌入字体
		 * @param w 宽度 = -1 则为默认宽度
		 * @param h 高度 = -1则为默认高度
		 * @param calback 被选择的回调函数格式为 callback(id:String):void; id=设置的id
		 * @param filters 文本的特效
		 * @param onSelected 已经被选择的时候被点击的回调函数 onSelected(id:String):void; id=设置的id.
		 * 					 为空则不响应
		 * @param center 是否文字居中
		 * @param margin 文字和左边间隔.当center = true时.本参数不起作用.
		 */
		public function SwitchButton(bgRef : Class, title : String, id : String, normalColor : int, overColor : int, selectColor : int, format : TextFormat, embed : Boolean, w : int, h : int, callback : Function, filters : Array, onSelected : Function = null, center : Boolean = true, titleMargin : int = 0, marginHorizontal : Boolean = true, widthAutoSizeMarginX : int = 0, callback2 : Function = null)
		{
			// 构造背景
			var bgMc : MovieClip = new bgRef();

			if (w > 0)
				bgMc.width = w;

			if (h > 0)
				bgMc.height = h;

			// 空间大小 = bg大小
			super(bgMc.width, bgMc.height);

			// 构造文本
			_text = new TextField();
			_text.defaultTextFormat = format;
			_text.autoSize = TextFieldAutoSize.LEFT;
			_text.embedFonts = embed;
			_text.mouseEnabled = false;

			if (title == '' || title == null)
			{
				title = '我靠';
			}
			_text.htmlText = title;

			_text.textColor = normalColor;

			_text.filters = filters;

			// 如果指定了..marginX.则按照marginX进行计算宽度
			if (widthAutoSizeMarginX > 0)
			{
				cWidth = widthAutoSizeMarginX * 2 + _text.width;
				bgMc.width = cWidth;
			}

			// 加入背景.加入文本
			addChild(bgMc);

			if (center)
				addChildCenter(_text);
			else if (marginHorizontal)
				addChildV(_text, titleMargin);
			else
			{
				addChildH(_text, titleMargin);
			}

			if (title == '我靠')
			{
				_text.text = '';
			}

			// 保存背景
			_bg = bgMc;

			// 保存3态颜色
			_normalColor = normalColor;
			_overColor = overColor;
			_selectColor = selectColor;

			// 保存ID
			_id = id;

			// 默认1
			bgMc.gotoAndStop(1);

			// 鼠标移入.如果是普通状态.则改成移入状态
			evts.mouseOver(function(event : MouseEvent) : void
			{
				if (bgMc.currentFrame == 1)
				{
					bgMc.gotoAndStop(2);
					_text.textColor = overColor;
				}
			});

			// 鼠标移出.如果是普通状态.则改成普通状态
			evts.mouseOut(function(event : MouseEvent) : void
			{
				if (bgMc.currentFrame == 2)
				{
					bgMc.gotoAndStop(1);
					_text.textColor = normalColor;
				}
			});

			// 鼠标点击.
			evts.addClick(function(event : MouseEvent) : void
			{
				// 如果已经选择就返回
				if (bgMc.currentFrame == 3)
				{
					// 切换回调函数
					if (onSelected != null)
					{
						onSelected(id);

						// 切换响应
						bgMc.gotoAndStop(1);
						_text.textColor = normalColor;
					}

					// 点击状态下又点击的回调函数
					if (callback2 != null)
						callback2(id);

					return;
				}

				// 回调被选择的ID
				callback(id);

				// 按钮设置为已选择
				bgMc.gotoAndStop(3);

				_text.textColor = selectColor;
			});
		}

		public function set title(val : String) : void
		{
			_text.text = val;
			_text.x = (cWidth - _text.width) / 2;
		}

		public function get title() : String
		{
			return _text.text;
		}

		/**
		 *  设置按钮状态
		 */
		public function set status(value : int) : void
		{
			_bg.gotoAndStop(value);

			_text.textColor = (value == 1) ? _normalColor : ((value == 2) ? _overColor : _selectColor);
		}

		private var _id : String;
		/**
		 * 背景
		 */
		private var _bg : MovieClip;

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
