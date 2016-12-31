package com.brickmice.model
{
	import com.brickmice.data.GameService;

	/**
	 * 邮件模块
	 * @author derek
	 */
	public class MailModel
	{
		/**
		 * 设置邮件已读
		 * @param mailId
		 * @param callback
		 * 
		 */
		public function setMailReaded(mailId : int, callback : Function) : void
		{
			GameService.request([{"action":"setMailReaded", "args":{'mailId':mailId}}], callback);
		}
		
		/**
		 * 获取附件
		 * @param ids id列表
		 * @param callback
		 */
		public function getMailAttachment(ids : Array, callback : Function) : void
		{
			GameService.request([{"action":"getMailAttachment", "args":{'ids':ids}}], callback);
		}

		/**
		 * 删除邮件
		 * @param type 邮件类型(Mail.INBOX or Mail.UNREADBOX)
		 * @param page 当前页
		 * @param ids
		 * @param callback 数据获取成功的回调函数
		 * 
		 */
		public function delMail(type : int, page:int, ids : Array, callback : Function) : void
		{
			GameService.request([{"action":"delMail", "args":{'type':type, "page":page, "ids":ids}}], callback);
		}

		/**
		 * 获取邮件列表
		 * 
		 * @param type 邮件类型(Mail.INBOX or Mail.UNREADBOX)
		 * @param page 当前页
		 * @param callback 数据获取成功的回调函数
		 */
		public function queryMailList(type : int, page : int, callback : Function) : void
		{
			GameService.request([{"action":"queryMailList", "args":{"type":type, "page":page}}], callback);
		}

		/**
		 * 发送邮件 
		 * @param targetName
		 * @param title
		 * @param content
		 * @param callback 数据获取成功的回调函数
		 * 
		 */
		public function sendMail(targetName : String, title:String, content:String, callback : Function) : void
		{
			GameService.request([{"action":"sendMail", "args":{"targetName":targetName, "title":title, "content":content}}], callback);
		}

	}
}
