package com.brickmice.view.gift
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmTabView;
	import com.brickmice.view.component.BmWindow;
	import com.framework.utils.KeyValue;
	
	import flash.display.MovieClip;

	public class Gift extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Gift";
		
		private var _mc:MovieClip;
		private var _tabView : BmTabView;
		private var _type:String;
		private var _chargePackage:ChargePackage;
		private var _consumePackage:ConsumePackage;
		
		public function Gift(data : Object)
		{
			_type = 'charge';
			
			_mc = new ResGiftWindow;
			super(NAME, _mc);
			
			//Tabs
			var tabs : Vector.<KeyValue> = new Vector.<KeyValue>();
			tabs.push(new KeyValue('charge', _mc._chargeTab), new KeyValue('consume', _mc._consumeTab), new KeyValue('share', _mc._shareTab));
			_tabView = new BmTabView(tabs, function(id : String) : void
			{
				_type = id;
				setData();
			});
			
			_tabView.selectId = _type;
			
			_chargePackage = new ChargePackage(_mc._chargePackage);
			_consumePackage = new ConsumePackage(_mc._consumePackage);
			
			new BmButton(_mc._sharePackage._getBtn, function():void{
				ModelManager.activityModel.getGiftByCode(_mc._sharePackage._txt.text);
			});

			setData();
		}
		
		public function setData() : void
		{
			_mc._chargePackage.visible = false;
			_mc._consumePackage.visible = false;
			_mc._sharePackage.visible = false;
			
			switch(_type)
			{
				case 'charge':
				{
					_mc._chargePackage.visible = true;
					break;
				}
				case 'consume':
				{
					_mc._consumePackage.visible = true;
					break;
				}
				case 'share':
				{
					_mc._sharePackage.visible = true;
					break;
				}
			}
		}
	}
}