package com.brickmice.view.userinfo
{
	import com.brickmice.ControllerManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McImage;
	import com.brickmice.view.component.McTip;
	import com.framework.utils.TipHelper;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class UserInfo extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "UserInfo";
		
		private var _mc:MovieClip;
		private var _campLogo:MovieClip;
		private var _vip:MovieClip;
		private var _coins:TextField;
		private var _job:TextField;
		private var _guild:TextField;
		private var _playerName:TextField;
		private var _boyHeroDetailBtn:MovieClip;
		private var _boyHeroCount:TextField;
		private var _honor:MovieClip;
		private var _chargeBtn:MovieClip;
		private var _moonStoneReserve:MovieClip;
		private var _tech:MovieClip;
		private var _girlHeroCount:TextField;
		private var _girlHeroDetailBtn:MovieClip;
		private var _closeBtn:MovieClip;
		private var _nightStoneReserve:MovieClip;
		private var _ironReserve:MovieClip;
		private var _camp:TextField;
		private var _lifeStoneReserve:MovieClip;
		private var _pureeReserve:MovieClip;
		private var _golden:TextField;
		private var _headImg:McImage;
		
		private var _honorMax:int;
		private var _techMax:int;
		
		
		public function UserInfo(data : Object)
		{
			_mc = new ResUserInfoWindow;
			super(NAME, _mc);
			
			_campLogo = _mc._campLogo;
			_vip = _mc._vip;
			_coins = _mc._coins;
			_job = _mc._job;
			_guild = _mc._guild;
			_playerName = _mc._playerName;
			_boyHeroDetailBtn = _mc._boyHeroDetailBtn;
			_boyHeroCount = _mc._boyHeroCount;
			_honor = _mc._honor;
			_chargeBtn = _mc._chargeBtn;
			_moonStoneReserve = _mc._moonStoneReserve;
			_tech = _mc._tech;
			_girlHeroCount = _mc._girlHeroCount;
			_girlHeroDetailBtn = _mc._girlHeroDetailBtn;
			_closeBtn = _mc._closeBtn;
			_nightStoneReserve = _mc._nightStoneReserve;
			_ironReserve = _mc._ironReserve;
			_camp = _mc._camp;
			_lifeStoneReserve = _mc._lifeStoneReserve;
			_pureeReserve = _mc._pureeReserve;
			_golden = _mc._golden;
			
			_guild.text = '';
			_job.text = '';
			
			_chargeBtn.visible = false;
			new BmButton(_chargeBtn, function():void{});
			
			new BmButton(_boyHeroDetailBtn, function():void{
				ControllerManager.boyHeroController.showBoyHero();
			});
			new BmButton(_girlHeroDetailBtn, function():void{
				ControllerManager.girlHeroController.showGirlHero();
			});
			
			_honorMax = _honor._exp.width;
			_honor._expDetailed.visible = false;
			_honor._expDetailed.mouseEnabled = _honor._exp.mouseEnabled = false;
			_honor._expBox.addEventListener(MouseEvent.MOUSE_OVER, function():void{
				_honor._expDetailed.visible = true;
			});
			_honor._expBox.addEventListener(MouseEvent.MOUSE_OUT, function():void{
				_honor._expDetailed.visible = false;
			});
			
			_techMax = _tech._exp.width;
			_tech._expDetailed.visible = false;
			_tech._expDetailed.mouseEnabled = _tech._exp.mouseEnabled = false;
			_tech._expBox.addEventListener(MouseEvent.MOUSE_OVER, function():void{
				_tech._expDetailed.visible = true;
			});
			_tech._expBox.addEventListener(MouseEvent.MOUSE_OUT, function():void{
				_tech._expDetailed.visible = false;
			});
			
			setData();
		}
		
		public function setData() : void
		{
			_headImg = new McImage(Data.data.user.headImg + "b");
			addChildEx(_headImg, 30, 42);
			
			
			_playerName.text = Data.data.user.name;
			_job.text = Data.data.user.honorName;
			_vip.gotoAndStop(int(Data.data.user.vip) + 1);
			_campLogo.gotoAndStop(Data.data.user.union);
			_camp.text = Data.data.user.unionName;
			_coins.text = Data.data.user.coins;
			_golden.text = (int(Data.data.user.golden) + int(Data.data.user.silver)).toString();
			
			_honor._Lvl.text = Data.data.user.honorLevel;
			_honor._exp.width = Data.data.user.honorExp / Data.data.user.upgradeHonorExp * _honorMax;
			var msg:String = Data.data.user.honorExp + ' / ' + Data.data.user.upgradeHonorExp + '  (' + (int(Data.data.user.honorExp) * 100 / int(Data.data.user.upgradeHonorExp)).toFixed(2).toString()  + '%)';
			_honor._expDetailed.text = msg;
			
			_tech._Lvl.text = Data.data.user.techLevel;
			_tech._exp.width = Data.data.user.techExp / Data.data.user.upgradeTechExp * _techMax;
			var msg2:String = Data.data.user.techExp + ' / ' + Data.data.user.upgradeTechExp + '  (' + (int(Data.data.user.techExp) * 100 / int(Data.data.user.upgradeTechExp)).toFixed(2).toString()  + '%)';
			_tech._expDetailed.text = msg2;
			
			if(Data.data.guild && Data.data.guild.id){
				_guild.text = Data.data.guild.name;
			}

			var data:Object = Data.data.boyHero;
			var heroArr:Array = [];
			for(var k:String in data) heroArr.push(data[k]);
			_boyHeroCount.text = heroArr.length.toString();
			
			data = Data.data.girlHero;
			heroArr = [];
			for(var s:String in data) heroArr.push(data[s]);		
			_girlHeroCount.text = heroArr.length.toString();
			
			var volume:String = Data.data.storage.material.volume;
			data = Data.data.storage.material.items;
			
			_pureeReserve._num.text = data[Consts.ID_PUREE].num;
			_pureeReserve._volume.text = volume;
			_pureeReserve._produce.text = Data.data.mine.puree.produceRatio;
			
			_ironReserve._num.text = data[Consts.ID_IRON].num;
			_ironReserve._volume.text = volume;
			_ironReserve._produce.text = Data.data.mine.iron.produceRatio;
			
			_nightStoneReserve._num.text = data[Consts.ID_NIGHTSTONE].num;
			_nightStoneReserve._volume.text = volume;
			_nightStoneReserve._produce.text = Data.data.user.union == 1 ? '0' : Data.data.mine.gem.produceRatio;
			
			_lifeStoneReserve._num.text = data[Consts.ID_LIFESTONE].num;
			_lifeStoneReserve._volume.text = volume;
			_lifeStoneReserve._produce.text = 0;
			
			_moonStoneReserve._num.text = data[Consts.ID_MOONSTONE].num;
			_moonStoneReserve._volume.text = volume;
			_moonStoneReserve._produce.text = Data.data.user.union == 1 ? Data.data.mine.gem.produceRatio : '0';
		}
	}
}