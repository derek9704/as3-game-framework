package com.brickmice.view.component
{
	import com.framework.ui.sprites.CTextButton;
	import com.framework.utils.FilterUtils;
	
	import flash.text.TextFormat;
	
	/**
	 * @author derek
	 */
	public class McButton extends CTextButton {
		/**
		 * 通用按钮.4或者2个字
		 * 
		 * @param txt 按钮文本
		 */
		public function McButton(txt:String) {
			var format : TextFormat = new TextFormat();
			format.color = 0xffc88c;
			format.size = 12;
			
			super(new ResBtn(),txt,-1,-1,format,false,[FilterUtils.createGlow(0x581a1a,8,2)]);
		}
	}
}
