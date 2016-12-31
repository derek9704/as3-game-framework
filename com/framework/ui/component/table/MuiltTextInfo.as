package com.framework.ui.component.table
{
	/**
	 * 单元格文本数据
	 * 
	 * @author derek
	 */
	public class MuiltTextInfo
	{
		/**
		 * 文本
		 */
		public var title : String;
		/**
		 * 默认颜色
		 */
		public var normalColor : int;
		/**
		 * 鼠标移入颜色
		 */
		public var hotColor : int;
		/**
		 * 滤镜
		 */
		public var filter : Array;
		/**
		 * 是否嵌入字体
		 */
		public var embed : Boolean;
		/**
		 * 字体
		 */
		public var font : String;
		/**
		 * 被选择的文本颜色
		 */
		public var selectColor : int;

		/**
		 * 构造函数
		 * 
		 * @param title 文本
		 * @param normalColor 普通颜色
		 * @param hotColor 移入颜色
		 */
		public function MuiltTextInfo(title : String, normalColor : int, hotColor : int, filter : Array = null, font : String = null, embed : Boolean = false)
		{
			this.title = title;
			this.normalColor = normalColor;
			this.selectColor = hotColor;
			this.hotColor = hotColor;
			this.filter = filter;
			this.font = font;
			this.embed = embed;
		}
	}
}
