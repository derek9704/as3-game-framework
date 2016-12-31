package com.brickmice
{
	import com.brickmice.controller.ActivityController;
	import com.brickmice.controller.ArenaController;
	import com.brickmice.controller.BagController;
	import com.brickmice.controller.BattleController;
	import com.brickmice.controller.BlueSunController;
	import com.brickmice.controller.BoyHeroController;
	import com.brickmice.controller.BrainController;
	import com.brickmice.controller.ChurchController;
	import com.brickmice.controller.CityController;
	import com.brickmice.controller.DiscoveryController;
	import com.brickmice.controller.EquipCombineController;
	import com.brickmice.controller.ExtraMoneyController;
	import com.brickmice.controller.FactoryController;
	import com.brickmice.controller.GirlHeroController;
	import com.brickmice.controller.GuildController;
	import com.brickmice.controller.HelperController;
	import com.brickmice.controller.InitController;
	import com.brickmice.controller.InstituteController;
	import com.brickmice.controller.MailController;
	import com.brickmice.controller.MineController;
	import com.brickmice.controller.PlanetController;
	import com.brickmice.controller.RailwayController;
	import com.brickmice.controller.RankController;
	import com.brickmice.controller.RenpinController;
	import com.brickmice.controller.ResearchController;
	import com.brickmice.controller.SchoolController;
	import com.brickmice.controller.ServerCallController;
	import com.brickmice.controller.SmithyController;
	import com.brickmice.controller.SolarController;
	import com.brickmice.controller.StockController;
	import com.brickmice.controller.StorageController;
	import com.brickmice.controller.TipController;
	import com.brickmice.controller.UserInfoController;
	import com.brickmice.controller.VipController;
	import com.brickmice.controller.WarAlarmController;
	import com.brickmice.controller.WindowController;
	import com.brickmice.controller.WorldController;
	import com.brickmice.controller.YahuanController;

	/**
	 * 所有的Controller在这里注册
	 * @author derek
	 */
	public class ControllerManager
	{
		public static var initController:InitController;
		public static var serverCallController:ServerCallController;
		public static var windowController:WindowController;
		public static var tipController:TipController;
		public static var cityController:CityController;
		public static var worldController:WorldController;
		public static var yahuanController:YahuanController;
		public static var bagController:BagController;
		public static var mailController:MailController;
		public static var mineController:MineController;
		public static var storageController:StorageController;
		public static var factoryController:FactoryController;
		public static var brainController:BrainController;
		public static var churchController:ChurchController;
		public static var schoolController:SchoolController;
		public static var boyHeroController:BoyHeroController;
		public static var girlHeroController:GirlHeroController;
		public static var railwayController:RailwayController;
		public static var instituteController:InstituteController;
		public static var smithyController:SmithyController;
		public static var equipCombineController:EquipCombineController;
		public static var guildController:GuildController;
		public static var solarController:SolarController;
		public static var discoveryController:DiscoveryController;
		public static var rankController:RankController;
		public static var warAlarmController:WarAlarmController;
		public static var userInfoController:UserInfoController;
		public static var extraMoneyController:ExtraMoneyController;
		public static var planetController:PlanetController;
		public static var blueSunController:BlueSunController;
		public static var helperController:HelperController;
		public static var stockController:StockController;
		public static var researchController:ResearchController;
		public static var vipController:VipController;
		public static var activityController:ActivityController;
		public static var renpinController:RenpinController;
		public static var arenaController:ArenaController;
		public static var battleController:BattleController;

		public static function init():void
		{
			initController = new InitController();
			serverCallController = new ServerCallController();
			windowController = new WindowController();
			tipController = new TipController();
			cityController = new CityController();
			worldController = new WorldController();
			yahuanController = new YahuanController();
			bagController = new BagController();
			mailController = new MailController();
			mineController = new MineController();
			storageController = new StorageController();
			factoryController = new FactoryController();
			brainController = new BrainController();
			churchController = new ChurchController();
			schoolController = new SchoolController();
			boyHeroController = new BoyHeroController();
			girlHeroController = new GirlHeroController();
			railwayController = new RailwayController();
			instituteController = new InstituteController();
			smithyController = new SmithyController();
			equipCombineController = new EquipCombineController();
			guildController = new GuildController();
			solarController = new SolarController();
			discoveryController = new DiscoveryController();
			rankController = new RankController();
			warAlarmController = new WarAlarmController();
			userInfoController = new UserInfoController();
			extraMoneyController = new ExtraMoneyController();
			planetController = new PlanetController();
			blueSunController = new BlueSunController();
			helperController = new HelperController();
			stockController = new StockController();
			researchController = new ResearchController();
			vipController = new VipController();
			activityController = new ActivityController();
			renpinController = new RenpinController();
			arenaController = new ArenaController();
			battleController = new BattleController();
		}
	}
}