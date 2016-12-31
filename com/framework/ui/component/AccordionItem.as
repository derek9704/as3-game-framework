package com.framework.ui.component
{
	import flash.text.TextFormat;

	/**
	 * @author derek
	 */
	public class AccordionItem
	{
		public var item : SwitchButton;
		public var barIndex : int;
		public var items : Vector.<AccordionItem>;
		public var status : int;

		/**
		 * @param mc 按钮MC的引用类.
		 * @param width 宽度 = -1 则为默认宽度
		 * @param height 高度 = -1则为默认高度
		 * @param normalColor 普通状态文本颜色
		 * @param overColor over状态文本颜色
		 * @param selectColor 选择状态文本颜色
		 * @param filters 文本的特效
		 * @param barIndex item父项的index
		 * @param title 按钮标题
		 * @param id id
		 * @param calback 被选择的回调函数格式为 callback(id:String):void; id=设置的id
		 * @param onSelected 已经被选择的时候被点击的回调函数 onSelected(id:String):void; id=设置的id.
		 * 					 为空则不响应
		 * @param center 是否文字居中
		 * @param margin 文字和左边间隔.当center = true时.本参数不起作用.
		 */
		public function AccordionItem(mc : Class, width : int, height : int, normalColor : int, overColor : int, selectColor : int, filters : Array, barIndex : int, title : String, id : String, callback : Function, onSelected : Function = null, center : Boolean = true, margin : int = 0)
		{
			this.item = new SwitchButton(mc, title, id, normalColor, overColor, selectColor, new TextFormat(), false, width, height, callback, filters, onSelected, center, margin);
			this.barIndex = barIndex;
			items = new Vector.<AccordionItem>();
		}

		public function set title(val : String) : void
		{
			item.title = val;
		}

		public function get title() : String
		{
			return item.title;
		}
	}
}
