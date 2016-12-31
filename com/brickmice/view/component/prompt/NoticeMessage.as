package com.brickmice.view.component.prompt
{
	import com.brickmice.view.component.BmButton;
	import com.framework.ui.sprites.CWindow;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class NoticeMessage extends CWindow
	{

		public function NoticeMessage(data : Object)
		{	
			var str:String = data.msg;
			var title:String = data.title;
			var callback:Function = data.callback;
				
			// 构造窗体
			var mc:ResSystenWindow = new ResSystenWindow;
			super(name, mc.width, mc.height, null, null, 0, 0);
			addChildEx(mc);
			
			mc._systemTitle.text = title;

			// 设定显示文本
			var textField : TextField = new TextField();
			var tf : TextFormat = new TextFormat();
			tf.size = 13;
			tf.color = 0xCCAC75;
			textField.textColor = 0xCCAC75;
			textField.defaultTextFormat = tf;
			textField.mouseEnabled = false;
			textField.multiline = true;
			textField.wordWrap = true;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.width = 300;
			textField.htmlText = str;
			
			if (textField.textWidth < textField.width)
			{
				textField.width = textField.textWidth + 10;
			}
			addChildCenter(textField);
			textField.y += 5;
			
			mc._cancelBtn.visible = false;

			new BmButton(mc._Btn, function() : void
			{
				if(callback != null) callback();
				closeWindow();
			});
		}
	}
}