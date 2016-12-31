package com.framework.ui.component.table
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * 文本单元格
	 * 
	 * @author derek
	 */
	public class TextCell extends Cell
	{
		private var _cellText : TextField;
		private var _selectColor : int;

		/**
		 * 生成一个文本内容的单元格
		 * 
		 * @param text 文本内容
		 * @param width 单元格宽度
		 * @param height 单元格高度
		 * @param size 字体大小
		 * @param color 文字颜色
		 * @param hotColor HOT时候的颜色
		 * @param bold 是否粗体
		 * @param leftColor 左边线颜色
		 * @param rightColor 右边线颜色
		 * @param topColor 上边线颜色
		 * @param bottomColor 下边线颜色
		 * @param showLine 是否显示边线
		 * @param filters 文本特效(glow,light)等
		 * @param font 字体
		 * @param embed 是否为嵌入字体
		 */
		public function TextCell(text : String, width : int, height : int, fontSize : int, fontColor : int, hotColor : int, selectColor : int, bold : Boolean, leftColor : int, rightColor : int = -1, topColor : int = -1, bottomColor : int = -1, showLine : Boolean = false, filters : Array = null, font : String = null, embed : Boolean = false, rowShowLine : Boolean = true) : void
		{
			super(width, height, showLine, leftColor, rightColor, topColor, bottomColor, rowShowLine);

			// 保存颜色
			this._normalColor = fontColor;
			this._hotColor = hotColor;
			_selectColor = selectColor;

			// 文本的格式
			var format : TextFormat = new TextFormat();
			format.size = fontSize;
			format.bold = bold;
			format.color = fontColor;

			// 指定了字体?
			if (font != null)
				format.font = font;

			// 表头文本TF
			_cellText = new TextField();

			// 默认格式/宽度/禁用鼠标/居中对齐/是否嵌入字体/单行显示/设定文字
			_cellText.defaultTextFormat = format;
			_cellText.width = width;
			_cellText.mouseEnabled = false;
			_cellText.autoSize = TextFieldAutoSize.CENTER;
			_cellText.embedFonts = embed;
			_cellText.multiline = false;
			_cellText.htmlText = text;

			// 如果指定了filters.就使用之
			if (filters != null)
				_cellText.filters = filters;

			// 文本垂直剧中
			_cellText.y = (height - _cellText.height) / 2;

			addChild(_cellText);

			// 保存数据
			data = _cellText;
		}

		private var _hotColor : int;
		private var _normalColor : int;

		/**
		 * 设置为hot状态
		 */
		public function hot() : void
		{
			_cellText.textColor = _hotColor;
		}

		/**
		 * 设置为普通状态
		 */
		public override function normal() : void
		{
			_cellText.textColor = _normalColor;
		}

		public override function select() : void
		{
			_cellText.textColor = _selectColor;
		}

		public var id : int;
	}
}
