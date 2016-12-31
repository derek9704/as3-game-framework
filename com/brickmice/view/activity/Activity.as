package com.brickmice.view.activity
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmTabView;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McPanel;
	import com.framework.utils.KeyValue;
	import com.framework.utils.TipHelper;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Activity extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Activity";
		
		private var _mc:MovieClip;
		
		private var _chooseKaifuDay : int = 7;
		
		private var _kaifuTab : BmTabView;
		private var _winnerPanel : McPanel;
		private var _kaifuReward1:McItem;
		private var _kaifuReward2:McItem;
		private var _kaifuReward3:McItem;
		private var _kaifuReward4:McItem;
		private var _kaifuReward5:McItem;
		
		public function Activity(data : Object)
		{
			_mc = new ResActivityWindow;
			super(NAME, _mc);
			
			//Tabs
			var today:int = 0;
			var tabs : Vector.<KeyValue> = new Vector.<KeyValue>();
			for(var i:int = 1; i <= 7; i++){
				tabs.push(new KeyValue(i.toString(), _mc._kaifuSideBar["_day" + i + "Tab"]));	
				_mc._kaifuSideBar["_day" + i + "Tab"]._finishLabel.visible = Data.data.kaifu[i].isExpire ? true : false;
				if(!Data.data.kaifu[i].isExpire && !today) today = i;
			}
			if(today) _chooseKaifuDay = today;
			
			_kaifuTab = new BmTabView(tabs, function(id : String) : void
			{
				_chooseKaifuDay = int(id);
				changeKaifuDay();
			});
			_kaifuTab.selectId = _chooseKaifuDay.toString();
			
			// 面板
			_winnerPanel = new McPanel('', 500, 160);
			addChildEx(_winnerPanel, 181, 181);
			_winnerPanel.addItem(_mc._winnerPanel, 0, 0);
			for (var j:int = 1; j <= 5; j++) 
			{
				this['_kaifuReward' + j.toString()] = new McItem();
				this['_kaifuReward' + j.toString()].x = 20;
				this['_kaifuReward' + j.toString()].y = 26;
				_mc._winnerPanel['_' + j.toString() + 'st'].addChild(this['_kaifuReward' + j.toString()]);
			}

			changeKaifuDay();
		}
		
		private function changeKaifuDay():void
		{
			var data:Object = Data.data.kaifu;
			data = data[_chooseKaifuDay];
			_mc._kaifuPanel._detail1.htmlText = data.describe;
			_mc._kaifuPanel._detail2.htmlText = '结束时间：' + data.expire;
			
			var rankArr:Array = [1, 2, 3, 4, 11];
			var count:int = 0;
			for each (var i:int in rankArr) 
			{
				var mc:MovieClip = _mc._winnerPanel['_' + (count+1).toString() + 'st'];
				if(data.rank[i].length){
					mc._player.text = data.rank[i][0];
					mc._campLogo.gotoAndStop(data.rank[i][1]);
					mc._campLogo.visible = true;
				}else{
					mc._player.text =  '空置';
					mc._campLogo.visible = false;
				}
				var item:McItem = this['_kaifuReward' + (count+1).toString()];
				item.resetImage(data['reward'][count].img);
				item.num2 = data['reward'][count].num;
				TipHelper.setTip(item, Trans.transTips(data['reward'][count]));
				count++;
			}
		}
		
	}
}