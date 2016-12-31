package com.brickmice.view.component
{
	import com.framework.ui.sprites.CTip;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * 普通的文本提示
	 * 
	 * @author derek
	 */
	public class McTip extends CTip
	{
		/**
		 * 构造函数
		 * 
		 * @param title 提示内容
		 */
		public function McTip(msg : String)
		{
			// 构造文本
			var tf : TextFormat = new TextFormat();
			tf.size = 12;
			tf.color = 0xF1C976;
			tf.leading = 6;

			var txt : TextField = new TextField();
			txt.defaultTextFormat = tf;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.multiline = true;
			
			txt.htmlText = msg;
			
			// 如果超出了最高宽度.则进行折行处理
			if (txt.width > 250)
			{
				txt.width = 250;
				txt.wordWrap = true;
			}

			cWidth = txt.width + 10;
			cHeight = txt.textHeight + 25;

			// 设定背景
			bg.setBg(new ResTipBg);

			addChildCenter(txt);
			txt.y -= 4;
		}
	}
}
