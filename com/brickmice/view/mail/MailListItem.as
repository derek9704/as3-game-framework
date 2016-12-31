package com.brickmice.view.mail
{
	import flash.display.Sprite;

	/**
	 * @author derek
	 */
	public class MailListItem extends Sprite
	{
		private var _mc:ResMailTableRow;
		
		public function MailListItem(info : Object)
		{
			_mc = new ResMailTableRow;
			_mc.mouseChildren = false;
			addChild(_mc);
			
			_mc._mailIcon.gotoAndStop(info.isnew == 1 ? 1 : 2);

			// 加入标题
			_mc._title.text = info.title;

			// 附件提示
			if (!info.attachment.length)
			{
				_mc._attachment.visible = false;
			}

			// 发件人
			_mc._senderName.text = info.ownername;
			//发件时间
			_mc._senderTime.text = info.sendtime.substr(5, 11);
		}
		
		/**
		 * 邮件状态
		 * 
		 * @param val 状态:true = 新邮件 false = 旧邮件
		 */
		public function set status(val : Boolean) : void
		{
			_mc._mailIcon.gotoAndStop(val ? 1 : 2);
		}
	}
}
