package com.brickmice.view.activity
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmTabView;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McPanel;
	import com.brickmice.view.component.McTip;
	import com.brickmice.view.component.prompt.NoticeMessage;
	import com.brickmice.view.component.prompt.TextMessage;
	import com.framework.ui.sprites.WindowData;
	import com.framework.utils.KeyValue;
	import com.framework.utils.TipHelper;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Renpin extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Renpin";
		
		private var _mc:MovieClip;
		
		private var _chooseRenpin : String = 'study';
		
		private var _renpinTab : BmTabView;
		private var _myRenpin:McPanel;
		private var _legend:McPanel;
		private var _round:int = 0;
		private var _oneBtn:BmButton;
		private var _10Btn:BmButton;
		private var _50Btn:BmButton;
		
		public function Renpin(data : Object)
		{
			_mc = new ResRenpinWindow;
			super(NAME, _mc);

			//renpinTab
			var tabs : Vector.<KeyValue> = new Vector.<KeyValue>();
			tabs.push(new KeyValue('study', _mc._renpinStudyTab), new KeyValue('exchange', _mc._renpinExchangeTab));	
			_renpinTab = new BmTabView(tabs, function(id : String) : void
			{
				_chooseRenpin = id;
				changeRenpin();
			});
			
			_mc._renpinStudyPanel.addFrameScript(1, function():void{
				if(_round < 2) _round++;
				else{
					_round = 0;
					var index:int;
					switch(Data.data.renpin.key)
					{
						case 0:
						case 1:
						case 2:
						case 3:
						case 4:
						{
							index = Data.data.renpin.key + 15;
							break;
						}
						case 5:
						case 6:
						case 7:
						case 8:
						case 9:
						{
							index = 16 - Data.data.renpin.key;
							break;
						}
						case 10:
						case 11:
						case 12:
						{
							index = 32 - Data.data.renpin.key;
							break;
						}
						case 13:
						case 14:
						case 15:
						{
							index = 27 - Data.data.renpin.key;
							break;
						}
						case 16:
						{
							index = 6;
							break;
						}
						case 17:
						{
							index = 5;
							break;
						}
						case 18:
						{
							index = 4;
							break;
						}
						case 19:
						{
							index = 3;
							break;
						}
						case 20:
						{
							index = 2;
							break;
						}
					}
					_mc._renpinStudyPanel.gotoAndStop(index);
					changeRenpin();
					_oneBtn.enable = _10Btn.enable = _50Btn.enable = true;
					TextMessage.showEffect(Data.data.renpin.noticeMsg, 1);
				}
			});
			
			//button
			_oneBtn = new BmButton(_mc._renpinStudyPanel._tryOneBtn, function():void{
				ModelManager.activityModel.tryRenpin(1, function():void{
					_oneBtn.enable = _10Btn.enable = _50Btn.enable = false;
					_mc._renpinStudyPanel.gotoAndPlay(2);
				});
			});
			TipHelper.setTip(_mc._renpinStudyPanel._tryOneBtn, new McTip('花费10宇宙钻'));
			
			_10Btn = new BmButton(_mc._renpinStudyPanel._tryTenBtn, function():void{
				ModelManager.activityModel.tryRenpin(2, function():void{
					var msg:String = Data.data.renpin.noticeMsg;
					var title:String = "获得物品";
					ControllerManager.windowController.showWindow(new WindowData(NoticeMessage, {msg:msg, title:title}, false, 0, 0, 0, false));
					changeRenpin();
				});
			});
			TipHelper.setTip(_mc._renpinStudyPanel._tryTenBtn, new McTip('花费100宇宙钻'));
			
			_50Btn = new BmButton(_mc._renpinStudyPanel.tryFiftyBtn, function():void{
				ModelManager.activityModel.tryRenpin(3, function():void{
					var msg:String = Data.data.renpin.noticeMsg;
					var title:String = "获得物品";
					ControllerManager.windowController.showWindow(new WindowData(NoticeMessage, {msg:msg, title:title}, false, 0, 0, 0, false));
					changeRenpin();
				});
			});
			TipHelper.setTip(_mc._renpinStudyPanel.tryFiftyBtn, new McTip('花费500宇宙钻'));
			
			_myRenpin = new McPanel('', 147, 67, true, true);
			addChildEx(_myRenpin, 545, 107);
			
			_legend = new McPanel('', 147, 139, true, true);
			addChildEx(_legend, 545, 213);
			
			_mc._renpinStudyPanel.gotoAndStop(1);
			
			(_mc._renpinStudyPanel._pic as MovieClip).mouseEnabled = false;
			
			var data:Object = Data.data.renpin.reward;
			for (var i:int = 0; i < 21; i++) 
			{
				TipHelper.setTip(_mc._renpinStudyPanel['_' + (i + 1).toString()], Trans.transTips(data[i]));
			}
			
			data = Data.data.renpin.exchange;
			for (var j:int = 1; j <= 8; j++) 
			{
				setExchangePanel(j, data[j-1]);
			}			

			changeRenpin();
		}
		
		private function setExchangePanel(index:int, data:Object):void
		{
			var item:McItem = new McItem(data.img, 0, data.num);
			TipHelper.setTip(item, Trans.transTips(data));
			item.x = 24.15;
			item.y = 19.35;
			new BmButton(_mc._renpinExchangePanel['_' + index.toString()]._btn, function():void{
				ModelManager.activityModel.renpinExchange(index, function():void{
					_mc._num.text = Data.data.user.renpin || 0;
				});
			});
			_mc._renpinExchangePanel['_' + index.toString()]._name.text = data.name;
			_mc._renpinExchangePanel['_' + index.toString()]._num.text = data.renpin;
			_mc._renpinExchangePanel['_' + index.toString()].addChild(item);
		}
		
		private function changeRenpin():void
		{
			_mc._num.text = Data.data.user.renpin || 0;
			
			var data:Object = Data.data.renpin;
			if(_chooseRenpin == 'study'){
				_mc._renpinStudyPanel.visible = _myRenpin.visible = _legend.visible = true;
				_mc._renpinExchangePanel.visible = false;
				
				var tf : TextFormat = new TextFormat();
				tf.size = 12;
				tf.color = 0xFAEED7;
				tf.leading = 5;
				tf.font = 'SimSun';
				
				var txt:TextField = new TextField;
				txt.width = 142;
				txt.defaultTextFormat = tf;
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.mouseEnabled = false;
				txt.multiline = true;
				txt.wordWrap = true;
				txt.htmlText = data.myRenpin
				_myRenpin.panel.removeAllChildren();
				_myRenpin.addItem(txt);
				
				var txt2:TextField = new TextField;
				txt2.width = 142;
				txt2.defaultTextFormat = tf;
				txt2.autoSize = TextFieldAutoSize.LEFT;
				txt2.mouseEnabled = false;
				txt2.multiline = true;
				txt2.wordWrap = true;
				txt2.htmlText = data.legend
				_legend.panel.removeAllChildren();
				_legend.addItem(txt2);
			}else{
				_mc._renpinStudyPanel.visible =  _myRenpin.visible = _legend.visible = false;
				_mc._renpinExchangePanel.visible = true;
			}
		}
		
	}
}