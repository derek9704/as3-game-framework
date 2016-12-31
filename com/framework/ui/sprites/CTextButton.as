package com.framework.ui.sprites
{
	import flash.display.MovieClip;
	import flash.text.TextFormat;

	/**
	 * 文本按钮类.即有文字的那些按钮
	 * 所有.有文字的按钮都应该继承自本类
	 *
	 * @author derek
	 */
	public class CTextButton extends CButton
	{
		/**
		 * 构造函数
		 *
		 * @param mc mc资源(第一帧普通状态.第二帧OVER状态(此帧可以没有).第三帧按下状态(此帧可以没有)).
		 * @param text 按钮上的文本
		 * @param normalColor 普通状态文本颜色
		 * @param overColor 鼠标移入文本颜色
		 * @param embed 按钮文本是否嵌入字体
		 * @param textFormat 按钮文本格式
		 * @param filters 按钮文本的特效
		 */
		public function CTextButton(mc:MovieClip, text:String, normalColor:int, overColor:int, textFormat:TextFormat, embed:Boolean, filters:Array)
		{
			super(mc, text, 1, true, normalColor, overColor, embed, textFormat, filters);
		}
	}
}
