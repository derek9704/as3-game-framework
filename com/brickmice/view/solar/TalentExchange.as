package com.brickmice.view.solar
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McHeroSelect;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.prompt.TextMessage;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;
	import com.framework.utils.FilterUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class TalentExchange extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "TalentExchange";
		
		private var _mc:MovieClip;
		private var _hid:int = 0;
		private var _img : McItem;
		
		public function TalentExchange()
		{
			_mc = new ResConversionTalenWindow;
			super(NAME, _mc);
			
			for (var i:int = 1; i <= 4; i++) 
			{
				setExchangeBtn(i);
			}
			
			//头像
			_img = new McItem();
			addChildEx(_img, 64, 291);
			_img.evts.addClick(function():void{
				if (ViewManager.hasView(SolarChooseBoyHero.NAME)) return;
				var win:BmWindow = new SolarChooseBoyHero(_hid, selectHero);
				addChildCenter(win);	
			});
			
			_mc._exchangeCount1.text = '500';
			_mc._exchangeCount2.text = '1000';
			_mc._exchangeCount3.text = '3000';
			_mc._exchangeCount4.text = '6000';
			
			_mc._count.text = Data.data.solar.stone ? Data.data.solar.stone : "0";
		}
		
		private function selectHero(hid:int):void
		{
			_hid = hid;
			var data:Object = Data.data.boyHero[hid];
			_mc._ancestorBar._name.text = data.name;
			_mc._ancestorBar._lvl.text = "Lv：" + data.level;
			_mc._talentName.text = ((data.talent && data.talent.id) ? data.talent.name : "无");
			_mc._talentDetailed.text = ((data.talent && data.talent.id) ? data.talent.describe : "");
			_img.resetImage(data.img);
		}
		
		private function setExchangeBtn(i:int):void
		{
			new BmButton(_mc['_exchange' + i], function():void{
				if(_hid == 0){
					TextMessage.showEffect("请先选择噩梦鼠", 2);
					return;
				}
				ModelManager.solarModel.exchangeSolarTalent(i, _hid, function():void
				{
					_mc._count.text = Data.data.solar.stone;
					//跳出兑换天赋窗口
					if (ViewManager.hasView(SolarTalent.NAME)) return;
					var winData:WindowData = new WindowData(SolarTalent, {'hid':_hid, 'newTalent':Data.data.boyHero[_hid].talentReplace, 'callback':function():void{
						var data:Object = Data.data.boyHero[_hid];
						_mc._talentName.text = ((data.talent && data.talent.id) ? data.talent.name : "无");
						_mc._talentDetailed.text = ((data.talent && data.talent.id) ? data.talent.describe : "");
					}}, true, 0, 0, 0, false);
					ControllerManager.windowController.showWindow(winData);
				});
			});	
		}
	}
}