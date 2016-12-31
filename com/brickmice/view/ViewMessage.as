package com.brickmice.view
{

	/**
	 * @author derek
	 */
	public class ViewMessage
	{
		public static const REFRESH_USER:String = "REFRESH_USER";
		public static const REFRESH_UNITPOINT:String = "REFRESH_UNITPOINT";
		public static const REFRESH_EQUIPPOINT:String = "REFRESH_EQUIPPOINT";
		public static const REFRESH_SOLARPOINT:String = "REFRESH_SOLARPOINT";
		public static const REFRESH_SOLARSTONE:String = "REFRESH_SOLARSTONE";
		public static const REFRESH_SOLAROPENPLANET:String = "REFRESH_SOLAROPENPLANET";
		public static const REFRESH_RAILWAY:String = "REFRESH_RAILWAY";
		public static const REFRESH_EXPBAR:String = "REFRESH_EXPBAR";
		public static const REFRESH_FACTORY:String = "REFRESH_FACTORY";
		public static const REFRESH_BOYHERO:String = "REFRESH_BOYHERO";
		public static const REFRESH_MATERIAL:String = "REFRESH_MATERIAL";
		public static const REFRESH_TASK:String = "REFRESH_TASK";
		public static const REFRESH_NEWBIE:String = "REFRESH_NEWBIE";
		public static const REFRESH_CHALLENGE:String = "REFRESH_CHALLENGE";
		public static const REFRESH_INSTITUTE:String = "REFRESH_INSTITUTE";
		public static const REFRESH_WARALARMFLAG:String = "REFRESH_WARALARMFLAG";
		public static const REFRESH_TECHLEVEL:String = "REFRESH_TECHLEVEL";
		public static const REFRESH_HONORLEVEL:String = "REFRESH_HONORLEVEL";
		public static const REFRESH_BRAIN:String = "REFRESH_BRAIN";
		public static const REFRESH_SCHOOL:String = "REFRESH_SCHOOL";
		public static const REFRESH_STORAGE:String = "REFRESH_STORAGE";
		public static const REFRESH_DAILYLOGONREWARD:String = "REFRESH_DAILYLOGONREWARD";
		public static const REFRESH_SHOUCHONGREWARD:String = "REFRESH_SHOUCHONGREWARD";
		public static const REFRESH_BLUESUN:String = "REFRESH_BLUESUN";
		
		public static const UPGRADE_MINE:String = "UPGRADE_MINE";
		public static const UPGRADE_STORAGE:String = "UPGRADE_STORAGE";
		public static const UPGRADE_INSTITUTE:String = "UPGRADE_INSTITUTE";
		public static const UPGRADE_FACTORY:String = "UPGRADE_FACTORY";
		public static const UPGRADE_CHURCH:String = "UPGRADE_CHURCH";
		public static const UPGRADE_SCHOOL:String = "UPGRADE_SCHOOL";
		public static const UPGRADE_RAILWAY:String = "UPGRADE_RAILWAY";
		public static const NEW_MAIL:String = "NEW_MAIL";
		public static const ENTER_CITY:String = "ENTER_CITY";
		public static const ENTER_WORLD:String = "ENTER_WORLD";
		public static const SET_MUSIC:String = "SET_MUSIC";
		public static const UPDATE_PLANET:String = "UPDATE_PLANET";
		public static const UPDATE_STOCK:String = "UPDATE_STOCK";
		public static const HERO_LEVELUP:String = "HERO_LEVELUP";
		public static const GOT_DISCOVERY:String = "GOT_DISCOVERY";
		public static const UPDATE_UNIT_STATUS:String = "UPDATE_UNIT_STATUS";
		public static const WAR_VICTORY:String = "WAR_VICTORY";
		public static const CALL_KAN:String = "CALL_KAN";
		
		public static const REFRESH_TYPE:Object = {
			REFRESH_USER:"user", REFRESH_EXPBAR:"user/techExp", REFRESH_UNITPOINT:"unit", REFRESH_RAILWAY:"railway",
			REFRESH_FACTORY:"factory", REFRESH_BOYHERO:"boyHero", REFRESH_EQUIPPOINT:"equip", REFRESH_MATERIAL:"storage/material",
			REFRESH_SOLARPOINT:"solar", REFRESH_SOLAROPENPLANET:"solar/openPlanet", REFRESH_TASK:"task", REFRESH_CHALLENGE:"solar/challenge",
			REFRESH_INSTITUTE:"institute", REFRESH_WARALARMFLAG:"warAlarmFlag", REFRESH_TECHLEVEL:"user/techLevel", 
			REFRESH_HONORLEVEL:"user/honorLevel", REFRESH_SOLARSTONE:"solar/stone", UPDATE_UNIT_STATUS:"finishedTask",
			REFRESH_BRAIN:"brain",REFRESH_SCHOOL:"school",REFRESH_STORAGE:"storage", REFRESH_DAILYLOGONREWARD:"user/logonReward",
			REFRESH_SHOUCHONGREWARD:"user/shouChongRewardGot", REFRESH_BLUESUN:"blueSun"
		};
	}
}
