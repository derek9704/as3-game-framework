package com.brickmice
{
	import com.brickmice.model.ActivityModel;
	import com.brickmice.model.ArenaModel;
	import com.brickmice.model.BagModel;
	import com.brickmice.model.BossModel;
	import com.brickmice.model.BoyHeroModel;
	import com.brickmice.model.BrainModel;
	import com.brickmice.model.ChurchModel;
	import com.brickmice.model.DiscoveryModel;
	import com.brickmice.model.EquipModel;
	import com.brickmice.model.FactoryModel;
	import com.brickmice.model.GirlHeroModel;
	import com.brickmice.model.GuildModel;
	import com.brickmice.model.InstituteModel;
	import com.brickmice.model.MailModel;
	import com.brickmice.model.MineModel;
	import com.brickmice.model.PlanetModel;
	import com.brickmice.model.RailwayModel;
	import com.brickmice.model.RankModel;
	import com.brickmice.model.SchoolModel;
	import com.brickmice.model.SolarModel;
	import com.brickmice.model.StockModel;
	import com.brickmice.model.StorageModel;
	import com.brickmice.model.TaskModel;
	import com.brickmice.model.UserModel;
	import com.brickmice.model.WarModel;

	/**
	 * 所有的Model在这里进行注册
	 * @author derek
	 */
	public class ModelManager
	{
		public static var userModel:UserModel;
		public static var bagModel : BagModel
		public static var mailModel : MailModel;
		public static var mineModel : MineModel;
		public static var storageModel : StorageModel;
		public static var factoryModel : FactoryModel;
		public static var brainModel : BrainModel;
		public static var churchModel : ChurchModel;
		public static var schoolModel : SchoolModel;
		public static var boyHeroModel : BoyHeroModel;
		public static var girlHeroModel : GirlHeroModel;
		public static var railwayModel : RailwayModel;
		public static var instituteModel : InstituteModel;
		public static var activityModel : ActivityModel;
		public static var discoveryModel : DiscoveryModel;
		public static var warModel : WarModel;
		public static var planetModel : PlanetModel;
		public static var equipModel : EquipModel;
		public static var solarModel : SolarModel;
		public static var stockModel : StockModel;
		public static var taskModel : TaskModel;
		public static var guildModel : GuildModel;
		public static var rankModel : RankModel;
		public static var arenaModel : ArenaModel;
		public static var bossModel : BossModel;

		public static function init():void
		{
			userModel = new UserModel();
			bagModel = new BagModel();
			mailModel = new MailModel();
			mineModel = new MineModel();
			storageModel = new StorageModel();
			factoryModel = new FactoryModel();
			brainModel = new BrainModel();
			churchModel = new ChurchModel();
			schoolModel = new SchoolModel();
			boyHeroModel = new BoyHeroModel();
			girlHeroModel = new GirlHeroModel();
			railwayModel = new RailwayModel();
			instituteModel = new InstituteModel();
			activityModel = new ActivityModel();
			discoveryModel = new DiscoveryModel();
			warModel = new WarModel();
			planetModel = new PlanetModel();
			equipModel = new EquipModel();
			solarModel = new SolarModel();
			stockModel = new StockModel();
			taskModel = new TaskModel();
			guildModel = new GuildModel();
			rankModel = new RankModel();
			arenaModel = new ArenaModel();
			bossModel = new BossModel();
		}
	}
}
