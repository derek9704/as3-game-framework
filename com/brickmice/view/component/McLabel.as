package com.brickmice.view.component
{

	import com.framework.utils.FilterUtils;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author derek
	 */
	public class McLabel extends TextField
	{
		/**
		 * 构造函数
		 * 
		 * @param title  显示的文本（html格式）
		 * @param align 文本对齐格式
		 * @param width 宽度 (小于 0 为自动)
		 * @param height 高度 (小于 0 为自动)  
		 */
		public function McLabel(title : String, textColor : int = 0xdec990, align : String = "left", width : int = 0, height : int = 0, size : int = 12, bold : Boolean = false, filters : Array = null)
		{
			mouseEnabled = false;

			var format : TextFormat = new TextFormat();
			format.align = align;
			format.size = size;
			format.color = textColor;
			format.leading = 3;
			format.bold = bold;
			format.font = 'SimSun';
			defaultTextFormat = format;
			autoSize = TextFieldAutoSize.LEFT;

			if (title != null)
				htmlText = title;
			if (width > 0 || height > 0)
			{
				multiline = true;
				wordWrap = true;

				if (width > 0)
					this.width = width;

				if (height > 0)
					this.height = height;
			}
			else
			{
				multiline = false;
				wordWrap = false;
			}

			// 添加filters
			if (filters == null)
				return;

			this.filters = filters;
		}
	}
}
