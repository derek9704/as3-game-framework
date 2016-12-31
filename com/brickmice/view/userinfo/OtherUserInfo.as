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

	public class OtherUserInfo extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "OtherUserInfo";
		
		private var _mc:MovieClip;
		private var _campLogo:MovieClip;
		private var _vip:MovieClip;
		private var _job:TextField;
		private var _guild:TextField;
		private var _playerName:TextField;
		private var _boyHeroCount:TextField;
		private var _honor:MovieClip;
		private var _tech:MovieClip;
		private var _girlHeroCount:TextField;
		private var _camp:TextField;
		private var _headImg:McImage;
		
		
		public function OtherUserInfo()
		{
			_mc = new ResOtherUserInfoWindow;
			super(NAME, _mc);
			
			_campLogo = _mc._campLogo;
			_vip = _mc._vip;
			_job = _mc._job;
			_guild = _mc._guild;
			_playerName = _mc._playerName;
			_boyHeroCount = _mc._boyHeroCount;
			_honor = _mc._honor;
			_tech = _mc._tech;
			_girlHeroCount = _mc._girlHeroCount;
			_camp = _mc._camp;
			
			_guild.text = '';
			_job.text = '';
			
			_vip.visible = false;
			
			setData();
		}
		
		public function setData() : void
		{
			var data:Object = Data.data.otherUser;
			
			_headImg = new McImage(data.headImg + "b");
			addChildEx(_headImg, 30, 53);
			
			_playerName.text = data.name;
			_job.text = data.honorName;
			_campLogo.gotoAndStop(data.union);
			_camp.text = data.unionName;
			_honor._Lvl.text = data.honorLevel;
			_tech._Lvl.text = data.techLevel;
			if(data.guild && data.guild.id){
				_guild.text = data.guild.name;
			}
			_boyHeroCount.text = data.boyCount;
			_girlHeroCount.text = data.girlCount;
		}
	}
}