package com.brickmice.view.mail
{
	import com.brickmice.data.Trans;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McList;
	import com.framework.utils.TipHelper;
	import com.framework.utils.UiUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	/**
	 * 邮箱
	 *  
	 * @author derek
	 */
	public class ViewMailView
	{
		private var _items : Vector.<DisplayObject>;
		private var _data : Object;
		private var _itemsPanel : McList;
		
		private var _mc : MovieClip;
		private var _userIdentify : TextField;
		private var _username : TextField;
		private var _mailTitle : TextField;
		private var _mailContent : TextField;
		private var _replyMailBtn : MovieClip;
		private var _sendMailBtn : MovieClip;
		private var _getAttach : Function;
		
		/**
		 * 构造函数
		 */
		public function ViewMailView(mc:MovieClip, changePanel : Function, getAttach : Function)
		{
			_mc = mc;
			_getAttach = getAttach;
			_userIdentify = _mc._addresseeTxt;
			_username = _mc._addressee;
			_mailTitle = _mc._title;
			_mailContent = _mc._content;
			_replyMailBtn = _mc._replyBtn;
			_sendMailBtn = _mc._sendMailBtn;
			
			_mailTitle.maxChars = 20;			
			_mailContent.maxChars = 1000;
			
			_itemsPanel = new McList(3, 1, 4, 10, 44, 44, true);
			_itemsPanel.x = 328;
			_itemsPanel.y = 325;
			
			new BmButton(_replyMailBtn, function(event : MouseEvent) : void
			{
				changePanel('发邮件', _data);
			});
			
		}		
		
		public function removeItem() : void
		{
			if(_mc.contains(_itemsPanel))
				_mc.removeChild(_itemsPanel);		
		}
		
		
		public function init(data : Object) : void
		{
			clearPanel();
			
			_data = data;

			if(!_mc.contains(_itemsPanel))
				_mc.addChild(_itemsPanel);
			_replyMailBtn.visible = true;
			_sendMailBtn.visible = false;
			_userIdentify.text = "发件人：";
			UiUtils.setButtonEnable(_replyMailBtn, data.ownerid != 0);
			
			_mailTitle.text = data.title;
			_mailTitle.type = TextFieldType.DYNAMIC;
			_username.text = data.ownername;
			_username.type = TextFieldType.DYNAMIC;
			_mailContent.htmlText = data.content;
			_mailContent.type = TextFieldType.DYNAMIC;
			
			var len : int = data.attachment.length;
			
			_items = new Vector.<DisplayObject>();
			for (var i : int = 0; i < len; i++)
			{
				var item:McItem = new McItem(data.attachment[i].img, 0, data.attachment[i].num, false)
				TipHelper.setTip(item, Trans.transTips(data.attachment[i]));
				_items.push(item);
				item.evts.addEventListener(MouseEvent.CLICK, function(event : MouseEvent) : void
				{
					_getAttach(data.id);
				});
				item.buttonMode = true;
			}
			_itemsPanel.setItems(_items);
		}
		
		public function clearPanel() : void
		{
			_items = new Vector.<DisplayObject>();
			_itemsPanel.setItems(_items);
			_data = null;
			_mailTitle.text = "";
			_username.text = "";
			_mailContent.text = "";
		}		
		
	}
}
