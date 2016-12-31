package com.brickmice.view.component
{
	import com.framework.ui.component.RadioButton;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	/**
	 * @author derek
	 */
	public class McCheckBox extends RadioButton
	{
		/**
		 * 多选框
		 * 
		 * @param title 显示的文本
		 * @param callback 单击的回调函数
		 * @param selected 默认是否选中
		 * @param id id.如果没指定.则使用title
		 */
		public function McCheckBox(title : String = '', callback : Function = null, selected : Boolean = false, id : String = null, color : int = 0xf8eeb1)
		{
			var format : TextFormat = new TextFormat();
			format.color = color;

			super(title, new ResCheckBox(), id, selected, 4, format);

			// 设定单击的回调函数
			click = function(event : MouseEvent) : void
			{
				// 是否选中
				select = !select;

				if (callback != null)
					callback(select);
			};
		}
	}
}
