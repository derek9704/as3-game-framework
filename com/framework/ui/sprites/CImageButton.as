package com.framework.ui.sprites
{
	import flash.display.MovieClip;

	/**
	 * 图片按钮.即没有文本的图片按钮.
	 *
	 * @author derek
	 */
	public class CImageButton extends CButton
	{
		/**
		 * 构造函数
		 *
		 * @param mc mc资源(第一帧普通状态.第二帧OVER状态(此帧可以没有).第三帧按下状态(此帧可以没有)).
		 * @param muiltFrame 是否是多帧按钮.
		 */
		public function CImageButton(mc:MovieClip, muiltFrame:Boolean = true)
		{
			super(mc, '', 1, muiltFrame);
		}
	}
}
