package com.brickmice.view.mail
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmCheckBox;
	import com.brickmice.view.component.BmTabView;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.prompt.TextMessage;
	import com.framework.utils.KeyValue;
	import com.framework.utils.UiUtils;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Mail extends BmWindow
	{
		/**
		 * 收件箱
		 */
		public static const INBOX : int = 1;
		/**
		 * 未读邮件
		 */
		public static const UNREADBOX : int = 2;
		/**
		 * 邮箱名
		 */
		public static const NAME : String = "Mail";
		
		private var _mc:MovieClip;
		private var _writeBtn:MovieClip;
		private var _unreadTab:MovieClip;
		private var _addressee:TextField;
		private var _replyBtn:MovieClip;
		private var _selectAll:MovieClip;
		private var _addresseeTxt:TextField;
		private var _content:TextField;
		private var _nextBtn:MovieClip;
		private var _prevBtn:MovieClip;
		private var _dropDown:MovieClip;
		private var _receiveAttachmentsBtn:MovieClip;
		private var _closeBtn:MovieClip;
		private var _inboxTab:MovieClip;
		private var _sendMailBtn:MovieClip;
		private var _delBtn:MovieClip;
		private var _num:TextField;
		private var _title:TextField;
		
		private var _maxPage : int;
		private var _nowPage : int;
		private var _type : int;
		private var _tabs : BmTabView;
		private var _mails : MailTable;
		private var _mailPanel : ViewMailView;
		private var _sendPanel : SendMailView;
		private var _checkBox : BmCheckBox;
		
		
		public function Mail(data : Object)
		{
			_mc = new ResMailWindow;
			super(NAME, _mc);
			
			_writeBtn = _mc._writeBtn;
			_unreadTab = _mc._unreadTab;
			_addressee = _mc._addressee;
			_replyBtn = _mc._replyBtn;
			_selectAll = _mc._selectAll;
			_addresseeTxt = _mc._addresseeTxt;
			_content = _mc._content;
			_nextBtn = _mc._nextBtn;
			_prevBtn = _mc._prevBtn;
			_dropDown = _mc._dropDown;
			_receiveAttachmentsBtn = _mc._receiveAttachmentsBtn;
			_closeBtn = _mc._closeBtn;
			_inboxTab = _mc._inboxTab;
			_sendMailBtn = _mc._sendMailBtn;
			_delBtn = _mc._delBtn;
			_num = _mc._num;
			_title = _mc._title;
			
			// 加入tab
			var tabs : Vector.<KeyValue> = new Vector.<KeyValue>();
			tabs.push(new KeyValue('收件箱', _inboxTab), new KeyValue('未读邮件', _unreadTab));
			_tabs = new BmTabView(tabs, function(title : String) : void
			{
				switch(title)
				{
					case '收件箱':
						ModelManager.mailModel.queryMailList(INBOX, 1, function():void{
							changeTab(INBOX);
						});
						break;
					case '未读邮件':
						ModelManager.mailModel.queryMailList(UNREADBOX, 1, function():void{
							changeTab(UNREADBOX);
						});
						break;
					default:
				}
			});			
			
			// 加入面板
			_mails = new MailTable(function(id : String) : void
			{
				ModelManager.mailModel.setMailReaded(int(id), function():void{
					changeTab('收邮件', Data.data.mail.list[id]);
				});
			});
			addChildEx(_mails, 35, 105);
			
			new BmButton(_delBtn, function(event : MouseEvent) : void
			{
				var selectedRow : Vector.<String> = _mails.selectedRow();
				
				if (selectedRow.length == 0)
				{
					TextMessage.showEffect("请选择准备删除的邮件", 2);
					return;
				}
				
				var ids : Array = vector2Array(selectedRow);
				var hasAttachFlag:Boolean = false;
				for each (var i:int in ids) 
				{
					if(Data.data.mail.list[i].attachment.length){
						hasAttachFlag = true;
						break;
					}
				}
				if(hasAttachFlag){
					TextMessage.showEffect("带附件的邮件无法删除，请先收取附件", 2);
					return;			
				}
				
				ModelManager.mailModel.delMail(_type, _nowPage, ids, function():void{
					changeTab("发邮件");
					changeTab(_type);
				});
			});
			
			new BmButton(_receiveAttachmentsBtn, function(event : MouseEvent) : void
			{
				var selectedRow : Vector.<String> = _mails.selectedRow();
				
				if (selectedRow.length == 0)
				{
					TextMessage.showEffect("请选择收取附件的邮件", 2);
					return;
				}
				
				var ids : Array = vector2Array(selectedRow);
				var hasAttachFlag:Boolean = false;
				for each (var i:int in ids) 
				{
					if(Data.data.mail.list[i].attachment.length){
						hasAttachFlag = true;
						break;
					}
				}
				if(!hasAttachFlag){
					TextMessage.showEffect("所选邮件没有附件", 2);
					return;			
				}
				
				ModelManager.mailModel.getMailAttachment(ids, function():void{
					changeTab('收邮件', Data.data.mail.list[ids[0]]);
					changeTab(_type);
				});
			});
			
			_checkBox = new BmCheckBox(_selectAll, function(selected : Boolean) : void
			{
				_mails.selectAll(selected);
			});
			
			// 加入翻页
			new BmButton(_prevBtn, function(event : MouseEvent) : void
			{
				ModelManager.mailModel.queryMailList(INBOX, _nowPage - 1, function():void{
					changeTab(_type);
				});
			});
			
			new BmButton(_nextBtn, function(event : MouseEvent) : void
			{
				ModelManager.mailModel.queryMailList(INBOX, _nowPage + 1, function():void{
					changeTab(_type);
				});
			});
			
			_mailPanel = new ViewMailView(_mc, changeTab, function(id:int):void{
				ModelManager.mailModel.getMailAttachment([id], function():void{
					changeTab('收邮件', Data.data.mail.list[id]);
					changeTab(_type);
				});
			});
			_sendPanel = new SendMailView(_mc, removeItem);
			
			// 写邮件按钮
			new BmButton(_writeBtn, function(event : MouseEvent) : void
			{
				changeTab('发邮件');
			});
			
			// 默认选择 收件箱
			changeTab(INBOX);
			changeTab('发邮件');
		}
		
		private function vector2Array(data : *) : Array
		{
			var result : Array = [];
			
			var len : int = data.length;
			
			for (var i : int = 0; i < len; i++)
			{
				result.push(data[i]);
			}
			
			return result;
		}
		
		private function removeItem() : void
		{
			_mailPanel.removeItem();
		}
		
		/**
		 * 修改当前tab
		 * 
		 * @param title tab的标识
		 */
		private function changeTab(type : *, data:* = null) : void
		{
			// 根据新标题类型来显示当前面板
			switch(type)
			{
				case INBOX:
				case UNREADBOX:
					_type = type;
					_mails.setMails(Data.data.mail.list);
					_nowPage = Data.data.mail.page;
					_maxPage = Data.data.mail.maxpage ;
					_checkBox.select = false;
					break;
				case '收邮件':
					_mailPanel.init(data);
					break;
				case '发邮件':
					_sendPanel.init(data);
					break;
				default:
					throw '未知邮件类型';
			}
			
			_num.text = _nowPage + '/' + _maxPage;
			
			// 重置2个翻页按钮
			resetBtns();
		}
		
		private function resetBtns() : void
		{
			UiUtils.setButtonEnable(_prevBtn, _nowPage > 1);
			UiUtils.setButtonEnable(_nextBtn, _nowPage < _maxPage);
		}		
	}
}