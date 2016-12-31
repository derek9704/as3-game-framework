package com.brickmice.view.mail
{
	import com.brickmice.view.component.McCheckBoxTable;
	import com.framework.utils.KeyValue;
	
	import flash.utils.Dictionary;

	/**
	 * @author derek
	 */
	public class MailTable extends McCheckBoxTable
	{
		private var _mails : Dictionary;

		/**
		 * 构造函数
		 * 
		 * @param onSelect 当选择了某个邮件后的回调函数,格式: onSelect(id:String):void; id=邮件id.
		 */
		public function MailTable(onSelect : Function)
		{
			var cols : Vector.<KeyValue> = new Vector.<KeyValue>();
			cols.push(new KeyValue('', 26), new KeyValue('', 242));
			
			super(true, false, 222, cols, function(id : String) : void
			{
				(_mails[id] as MailListItem).status = false;
				onSelect(id);
				selectAll(false);
				selectRow(id, true);
			}, null, null, 37, true, false, 0);
			head = false;
		}

		/**
		 * 设置所有邮件
		 * 
		 * @param mails 邮件列表 
		 */
		public function setMails(mails : Object) : void
		{
			removeAll();

			_mails = new Dictionary();
			
			var arr:Array = [];
			
			for(var k:String in mails) arr.push(mails[k]);
			
			arr.sortOn("id", Array.DESCENDING | Array.NUMERIC);
			
			for each(var s:Object in arr) addMail(s);

			// 填补空白行
			addNullRows();
		}

		/**
		 * 新建一个邮件
		 * 
		 * @param mail 邮件信息
		 */
		private function addMail(mail : Object) : void
		{
			var mailItem : MailListItem = new MailListItem(mail);
			_mails[mail.id.toString()] = mailItem;
			addRow(mail.id.toString(), [mailItem], -1, null, 0, true);
		}
	}
}
