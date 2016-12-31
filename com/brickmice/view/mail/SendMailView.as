package com.brickmice.view.mail
{
	import com.brickmice.ModelManager;
	import com.brickmice.view.component.BmButton;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	/**
	 * @author derek
	 */
	public class SendMailView
	{
		private var _mc : MovieClip;
		private var _userIdentify : TextField;
		private var _username : TextField;
		private var _mailTitle : TextField;
		private var _mailContent : TextField;
		private var _replyMailBtn : MovieClip;
		private var _sendMailBtn : MovieClip;
		private var _removeItem : Function;
		
		public function SendMailView(mc:MovieClip, removeItem : Function)
		{
			_mc = mc;
			_removeItem = removeItem;
			_userIdentify = _mc._addresseeTxt;
			_username = _mc._addressee;
			_mailTitle = _mc._title;
			_mailContent = _mc._content;
			_replyMailBtn = _mc._replyBtn;
			_sendMailBtn = _mc._sendMailBtn;

			_mailTitle.maxChars = 20;			
			_mailContent.maxChars = 1000;

			new BmButton(_sendMailBtn, function(event : MouseEvent) : void
			{				
				ModelManager.mailModel.sendMail(_username.text, _mailTitle.text, _mailContent.text, function():void{
					_mailTitle.text = '';
					_mailContent.text = '';
					_username.text = '';
				});
			});
		}
		
		/**
		 * 设置显示对象
		 */
		public function init(data : Object = null) : void
		{
			_removeItem();
			
			_replyMailBtn.visible = false;
			_sendMailBtn.visible = true;
			_userIdentify.text = "收件人：";
			
			_mailTitle.type = TextFieldType.INPUT;
			_username.type = TextFieldType.INPUT;
			_mailContent.type = TextFieldType.INPUT;
			
			_mailContent.text = "";
			
			if (data == null){
				_mailTitle.text = "";
				_username.text = '';	
			}else{
				_mailTitle.text = "回复:" + data.title;
				_username.text = data.ownername;
			}
		}		
	}
}
