package com.brickmice.view.girlhero
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

	public class GirlHeroTalentExchange extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "GirlHeroTalentExchange";
		
		private var _mc:MovieClip;
		private var _hid:int = 0;
		private var _img : McItem;
		
		public function GirlHeroTalentExchange(hid:int, callback:Function)
		{
			_mc = new ResGirlHeroTalenExchangeWindow;
			super(NAME, _mc);
			
			for (var i:int = 1; i <= 4; i++) 
			{
				setExchangeBtn(i);
			}
			
			//头像
			_img = new McItem();
			addChildEx(_img, 64, 291);
			
			_mc._exchangeCount1.text = '500';
			_mc._exchangeCount2.text = '1000';
			_mc._exchangeCount3.text = '3000';
			_mc._exchangeCount4.text = '6000';
			
			_mc._count.text = Data.data.solar.stone ? Data.data.solar.stone : "0";
			
			_hid = hid;
			selectHero(_hid);
			
			this.evts.removedFromStage(function():void{
				callback();
			});
		}
		
		private function selectHero(hid:int):void
		{
			_hid = hid;
			var data:Object = Data.data.girlHero[hid];
			_mc._ancestorBar._name.text = data.name;
			_mc._ancestorBar._lvl.text = "Lv：" + data.level;
			_mc._talentName.text = ((data.talent && data.talent.id) ? data.talent.name : "无");
			_mc._talentDetailed.text = ((data.talent && data.talent.id) ? data.talent.describe : "");
			_img.resetImage(data.img);
		}
		
		private function setExchangeBtn(i:int):void
		{
			new BmButton(_mc['_exchange' + i], function():void{
				ModelManager.girlHeroModel.exchangeGirlTalent(i, _hid, function():void
				{
					_mc._count.text = Data.data.solar.stone;
					//跳出兑换天赋窗口
					if (ViewManager.hasView(GirlHeroTalent.NAME)) return;
					var winData:WindowData = new WindowData(GirlHeroTalent, {'hid':_hid, 'newTalent':Data.data.girlHero[_hid].talentReplace, 'callback':function():void{
						var data:Object = Data.data.girlHero[_hid];
						_mc._talentName.text = ((data.talent && data.talent.id) ? data.talent.name : "无");
						_mc._talentDetailed.text = ((data.talent && data.talent.id) ? data.talent.describe : "");
					}}, true, 0, 0, 0, false);
					ControllerManager.windowController.showWindow(winData);
				});
			});	
		}
	}
}