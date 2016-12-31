package com.brickmice.view.component.prompt
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.view.component.BmButton;
	import com.framework.ui.sprites.CWindow;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class ConfirmMessage extends CWindow
	{
		//SERVER调用的回调函数
		public static var callBack:Function = null;

		public function ConfirmMessage(data : Object)
		{
			var str:String = data.msg;
			var action:String = data.action;
			var args:Object = data.args;
			
			if(!data.server) callBack = null;
			
			// 构造窗体
			var mc:ResSystenWindow = new ResSystenWindow;
			super(name, mc.width, mc.height, null, null, 0, 0);
			addChildEx(mc);
			
			mc._systemTitle.text = "确认框";

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
			
			new BmButton(mc._Btn, function() : void
			{
				if(action == 'client'){
					args();
				}else
//					NewbieController.refreshNewBieBtn(26, 4);
					ModelManager.userModel.responseConfirm(action, args, callBack);
				closeWindow();
			});

			new BmButton(mc._cancelBtn, function() : void
			{
				closeWindow();
			});
			
			//新手指引
			NewbieController.showNewBieBtn(21, 3, this, 327, 186, true, "确定购买");
//			NewbieController.showNewBieBtn(26, 3, this, 327, 186, true, "确定购买");
//			NewbieController.showNewBieBtn(32, 4, this, 327, 186, true, "确认立即到达");
		}
	}
}