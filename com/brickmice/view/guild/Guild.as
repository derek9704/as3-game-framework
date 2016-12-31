package com.brickmice.view.guild
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmTabView;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.McPanel;
	import com.brickmice.view.component.prompt.ConfirmMessage;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;
	import com.framework.utils.KeyValue;
	import com.framework.utils.TipHelper;
	import com.framework.utils.UiUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Guild extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Guild";
		public static const TASK : String = 'task';
		public static const SHOP : String = 'shop';
		public static const MEMBER : String = 'member';
		public static const RECORD : String = 'record';
		
		private var _mc:MovieClip;
		private var _exp:MovieClip;
		private var _expBox:MovieClip;
		
		private var _gid:int;
		private var _max : int;
		private var _tabView : BmTabView;
		private var _recordPanel:McPanel;
		private var _taskPanel : McList;
		private var _shopPanel : McList;
		private var _memberPanel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _selectedItem:int;
		private var _currentTab:String;
		
		public function Guild(data : Object)
		{
			_mc = new ResGuildWindow;
			super(NAME, _mc);
			
			_exp = _mc._exp;
			_expBox = _mc._expBox;
			
			//经验条
			_max = _exp.width;
			_mc._expDetailed.visible = false;
			_mc._expDetailed.mouseEnabled = _mc._exp.mouseEnabled = false;
			_mc._expBox.addEventListener(MouseEvent.MOUSE_OVER, function():void{
				_mc._expDetailed.visible = true;
			});
			_mc._expBox.addEventListener(MouseEvent.MOUSE_OUT, function():void{
				_mc._expDetailed.visible = false;
			});
			
			new BmButton(_mc._otherGuildBtn, function():void{
				if (ViewManager.hasView(GuildList.NAME)) return;
				ModelManager.guildModel.guildList(1, '', function():void{
					var win:BmWindow = new GuildList();
					addChildCenter(win);		
				});
			});
			
			new BmButton(_mc._quitBtn, function():void{
				var data:Object = {};
				data.msg = "确认要退出联盟吗？你将丢失所有贡献度！";
				data.action = "client";
				data.args = function():void{
					ModelManager.guildModel.quitGuild(_gid, function():void{
						closeWindow();
					});
				}
				ControllerManager.windowController.showWindow(new WindowData(ConfirmMessage, data, true, 0, 0, 0, false));
			});
			
			new BmButton(_mc._processBtn, function():void{
				if (ViewManager.hasView(GuildApply.NAME)) return;
				var win:BmWindow = new GuildApply(setData);
				addChildCenter(win);		
			});
			
			new BmButton(_mc._optionBtn, function():void{
				if (ViewManager.hasView(GuildSetting.NAME)) return;
				var win:BmWindow = new GuildSetting(setData);
				addChildCenter(win);		
			});
			
			new BmButton(_mc._disbandBtn, function():void{
				var data:Object = {};
				data.msg = "确认要解散联盟吗？";
				data.action = "client";
				data.args = function():void{
					ModelManager.guildModel.disbandGuild(_gid, function():void{
						closeWindow();
					});
				}
				ControllerManager.windowController.showWindow(new WindowData(ConfirmMessage, data, true, 0, 0, 0, false));
			});
			
			new BmButton(_mc._transferBtn, function():void{
				if (ViewManager.hasView(GuildTransfer.NAME)) return;
				var win:BmWindow = new GuildTransfer(setData);
				addChildCenter(win);		
			});
			
			new BmButton(_mc._buyBtn, function():void{
				ModelManager.equipModel.buyEquip(_selectedItem);
			});
			UiUtils.setButtonEnable(_mc._buyBtn, false);
			
			//Tabs
			_mc._recordTab.visible = false;
			var tabs : Vector.<KeyValue> = new Vector.<KeyValue>();
			tabs.push(new KeyValue(TASK, _mc._questTab), new KeyValue(SHOP, _mc._shopTab), new KeyValue(MEMBER, _mc._memberTab), new KeyValue(RECORD, _mc._recordTab));
			_tabView = new BmTabView(tabs, function(id : String) : void
			{
				changeTab(id);
			});
			
			// 面板
			_taskPanel = new McList(1, 5, 0, 0, 418, 37, false);
			addChildEx(_taskPanel, 256, 140);
			
			_shopPanel = new McList(5, 2, 5, 1, 85, 93, false);
			addChildEx(_shopPanel, 245.6, 141);		
			
			_memberPanel = new McList(1, 9, 0, 1, 435, 18, false);
			addChildEx(_memberPanel, 253, 157);		
			
			_recordPanel = new McPanel('', 414, 187);
			addChildEx(_recordPanel, 264, 140);
			
			changeTab(data.type);
			setData();
		}
		
		private function changeTab(tab:String):void
		{
			_currentTab = tab;
			_taskPanel.visible = false;
			_shopPanel.visible = false;
			_memberPanel.visible = false;
			_recordPanel.visible = false;
			_mc._memberTop.visible = false;
			_mc._buyBtn.visible = false;
			switch(tab)
			{
				case TASK:
				{
					_taskPanel.visible = true;
					break;
				}
				case SHOP:
				{
					_shopPanel.visible = true;
					_mc._buyBtn.visible = true;
					break;
				}
				case MEMBER:
				{
					_mc._memberTop.visible = true;
					_memberPanel.visible = true;
					break;
				}
				case RECORD:
				{
					_recordPanel.visible = true;
					break;
				}
			}
		}
		
		public function setData() : void
		{
			_tabView.selectId = _currentTab;
			
			var data:Object = Data.data.guild; 
			_gid = data.id;
			
			_exp.width = data.exp / data.upgradeExp * _max;
			var msg:String = data.exp + ' / ' + data.upgradeExp + '  (' + (int(data.exp) * 100 / int(data.upgradeExp)).toFixed(2).toString()  + '%)';
			_mc._expDetailed.text = msg;
			
			_mc["_name"].text = data.name;
			_mc._lvl.text = data.level;
			_mc._rank.text = data.rank;
			_mc._memberCountNow.text = data.memberCount;
			_mc._memberCountMax.text = data.memberLimit;
			_mc._qq.text = data.qq;
			_mc._bulletin.text = data.claim;
			
			// 生成显示的面板
			_items = new Vector.<DisplayObject>;
			var uid:int = Data.data.user.id;
			var myInfo:Object;
			for each (var member:Object in data.member) 
			{
				if(member.id == uid) myInfo = member;
			}
			for each (member in data.member) 
			{
				var mc : GuildMemberItem = new GuildMemberItem(member, myInfo.job > 0, setData);
				mc.buttonMode = true;
				_items.push(mc);
			}
			_memberPanel.setItems(_items);
			
			_items = new Vector.<DisplayObject>;
			for each (var task:Object in Data.data.task) 
			{
				if(task.type != 4) continue;
				var mc3 : GuildTaskItem = new GuildTaskItem(_gid, task, setData);
				_items.push(mc3);
			}
			_taskPanel.setItems(_items);		
			
			//这个ITEMS放到最后
			_items = new Vector.<DisplayObject>;
			for each (var item:Object in data.shop) 
			{
				var mc2 : GuildShopItem = new GuildShopItem(item);
				setItem(mc2, item);
				_items.push(mc2);
			}
			_shopPanel.setItems(_items);
			
			_mc._contr.text = myInfo.totalContr;
			switch(myInfo.job)
			{
				case "0":
				{
					_mc._position.text = "会员";
					_mc._applyText.visible = _mc._application.visible = _mc._processBtn.visible = _mc._optionBtn.visible = false;
					_mc._disbandBtn.visible = _mc._transferBtn.visible = false;
					break;
				}
				case "1":
				{
					_mc._position.text = "理事";
					_mc._application.text = data.apply.length;
					_mc._disbandBtn.visible = _mc._transferBtn.visible = false;
					break;
				}
				case "2":
				{
					_mc._position.text = "盟主";
					_mc._application.text = data.apply.length;
					break;
				}
			}
			var recordTxt:TextField = new TextField;
			var tf : TextFormat = new TextFormat();
			tf.size = 12;
			tf.color = 0x000000;
			tf.leading = 7;
			tf.font = 'SimSun';
			recordTxt.defaultTextFormat = tf;
			recordTxt.autoSize = TextFieldAutoSize.LEFT;
			recordTxt.mouseEnabled = false;
			recordTxt.multiline = true;
			for each (var event:Object in data.event) 
			{
				recordTxt.htmlText = event.msg + "             (" + event.time + ")<br>" + recordTxt.htmlText;
			}
			_recordPanel.panel.removeAllChildren();
			_recordPanel.addItem(recordTxt);
		}
		
		private function setItem(mc : GuildShopItem, data:Object):void
		{
			mc.evts.addClick(function():void{
				UiUtils.setButtonEnable(_mc._buyBtn, true);
				_selectedItem = data.id;
				
				for each (var everyItem:DisplayObject in _items)
				{
					(everyItem as GuildShopItem).borderLight = false;
				}
				mc.borderLight = true;
			});
			// 设置tip
			TipHelper.setTip(mc, Trans.transTips(data));
		}
		
	}
}