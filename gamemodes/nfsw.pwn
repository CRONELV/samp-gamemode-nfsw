//TGA Nsa Drasena Pultymierya lol
// Unfinished "copy" of NFSW
// Author: SDraw
// Original posts only on forum.sa-mp.com and pawno.ru
// GitHub repository: http://github.com/SDraw/samp-gamemode-nfsw
// You can modify gamemode but without deleting of copyrights. But if you delete it, you're little schooler with tiny brain...and dick...and you have brain cancer...
// Have fun :3
#include <a_samp>
#undef MAX_PLAYERS
#define MAX_PLAYERS (50)
#undef MAX_VEHICLES
#define MAX_VEHICLES (MAX_PLAYERS+3)
#include <streamer>
#include <audio>
#include <mysql>
#include <sscanf2>
#include <gvar>
#include <md5>
#include <AntiCheat>
//#include <antiattack>
#define FOREACH_NO_BOTS
#include <foreach>
#include <a_conio>
#include <acuf>
#include <nfsw\offset.txt>
#define MINIMUM_DRIVERS (2)
#define MAX_RACES (4)
#define MAX_JOINS (MAX_PLAYERS/2)
#define JOIN_WORLD (MAX_PLAYERS+2)
#define EVENT_WORLD (JOIN_WORLD+MAX_JOINS*MAX_RACES+1)

forward MoveCamera(playerid);
forward PlayMainTheme(playerid);
forward CheckForAP(playerid);
forward SGivePlayerMoney(playerid,amount);
forward UpdatePlayerExpLine(playerid);
forward TakePlayerInWorld(playerid);
forward CheckForSymbols(text[],len);
forward SaveDriver(playerid);
forward RestoreNitroItem(playerid);
forward RemoveNitro(playerid);
forward RestoreRamItem(playerid);
forward RemoveRam(playerid);
forward RestoreReadyItem(playerid);
forward RotateRacesLights();
forward WaitJoin(playerid);
forward StartCountDown(raceid,index);
forward ClearDriversList(playerid);
forward StartCountDownEv(raceid,index);
forward EventTime(raceid,index);
forward HideBonuses(playerid);
forward ShowBonuses(playerid);
forward ClearDriversListAfterRace(playerid);
forward HideSpeedometre(playerid);
forward ShowSpeedometre(playerid);
forward ClearEventAndJoin(raceid,index);
forward UpdatePlaceTDForEvent(raceid,index);
forward ShowPlayerBrick(playerid);
forward HidePlayerBrick(playerid);
forward ForcePlayerCameraSafehouse(playerid);
forward VehModelToArrayID(model);
forward CameraViewChange(playerid,id);
forward LeftHudProccessed(playerid);
forward SetVehicleTunning(playerid,vehid);
forward SafeTunning(playerid);
forward PartModelToArrayID(modelid);
forward VehicleModelToPaintjobNum(modelid);
forward SaveVehicles(playerid);
forward CheckForVehDeath(playerid,vehicleid);
forward CheckForTreasureLogin(playerid);
forward CheckForTreasure(playerid);
forward CreateTreasureAfterReg(playerid);
forward ShowTreasureTDs(playerid);
forward HideTreasureTDs(playerid);
forward TreasureReward(playerid);
forward RestoreFlip(playerid);
forward DestroyVehicleEx(vehicleid);
forward TimeChange();
forward SetPlayerWorldTime(playerid);
forward RandomTreasureArray(array[],trnum);
forward CheckEmail(str[],size);
forward CheckDriverName(str[],size);
forward RestoreKick(playerid);
#define DIALOG_LOG_LOG (1)
#define DIALOG_LOG_PASS (2)
#define DIALOG_NEW_DRIVER_FR (3)
#define DIALOG_REG_LOG (4)
#define DIALOG_REG_PASS (5)
//TetxDraws
new Text:WelcomeTDs[5];
new Text:RegLog[5];
new Text:BoxCon;
new Text:Tutorial[12];
new Text:VehSelect[12];
new Text:Lines[2];
new Text:MainLineStruct[4];
new Text:DriverChooseTD[13];
new Text:VHS_Main[2];
new Text:Bonuses[21];
new Text:RaceTD[16];
new Text:DriversListTD[30];
new Text:CDTD[8];
new Text:EventTD[3];
new Text:FinishTD[14];
new Text:RepTD[15];
new Text:Brick[4];
new Text:SafehouseTD[35];
new Text:BackButton;
new Text:CustomTD[35];
new Text:ColorTD[20];
new Text:VehBuyTD[22];
new Text:VehSellTD[4];
new Text:VehSelectTD[2];
new Text:TreasureTD[40];
new PlayerText:TreasureTDPl[MAX_PLAYERS][2];
new PlayerText:VehListTDPl[MAX_PLAYERS][3];
new PlayerText:VehBuyTDPl[MAX_PLAYERS][9];
new PlayerText:ColorTDPl[MAX_PLAYERS][7];
new PlayerText:CustomTDPl[MAX_PLAYERS][32];
new PlayerText:TextCon[MAX_PLAYERS];
new PlayerText:VehSelectPl[MAX_PLAYERS][5];
new PlayerText:MoneyInd[MAX_PLAYERS];
new PlayerText:MainLineStructPl[MAX_PLAYERS][3];
new PlayerText:DriverChooseTDPl[MAX_PLAYERS][5];
new PlayerText:VHS[MAX_PLAYERS][31];
new PlayerText:BonusesPl[MAX_PLAYERS][6];
new PlayerText:RaceTDPl[MAX_PLAYERS][3];
new PlayerText:DriversListTDPl[MAX_PLAYERS][16];
new PlayerText:EventTDPl[MAX_PLAYERS][5];
new PlayerText:RepTDPl[MAX_PLAYERS][2];
//Player Variables
new CameraMoveAngle[MAX_PLAYERS];
new bool:EnterInServer[MAX_PLAYERS];
new bool:InGame[MAX_PLAYERS];
	//Audio
new EffectHandle[MAX_PLAYERS];
new MainThemeHandle[MAX_PLAYERS];
new FreeroamHandle[MAX_PLAYERS];
new EventHandle[MAX_PLAYERS];
new FinishHandle[MAX_PLAYERS];
new SafehouseHandle[MAX_PLAYERS];
 	//Others
new TutStep[MAX_PLAYERS];
new VehSelectNum[MAX_PLAYERS];
new MoveCameraTimer[MAX_PLAYERS];
new bool:IsSpeedShown[MAX_PLAYERS];
new bool:IsSpeedBarShown[MAX_PLAYERS][30];
new bool:CanUseNitroItem[MAX_PLAYERS];
new bool:CanUseRamItem[MAX_PLAYERS];
new bool:CanUseReadyItem[MAX_PLAYERS];
new bool:CanFlip[MAX_PLAYERS];
new FlipTimer[MAX_PLAYERS];
new bool:InFreeRoam[MAX_PLAYERS];
new bool:InRace[MAX_PLAYERS];
new bool:LookingFinishList[MAX_PLAYERS];
new bool:LookingRep[MAX_PLAYERS];
new RaceStartZone[MAX_PLAYERS];
new JoinedJNum[MAX_PLAYERS];
new JoinTimer[MAX_PLAYERS];
new bool:JoinedInRace[MAX_PLAYERS];
new CancelSeconds[MAX_PLAYERS];
new DriverName[MAX_PLAYERS][3][32];
new EventArea[MAX_PLAYERS];
new NumPassedArea[MAX_PLAYERS];
new CurLap[MAX_PLAYERS];
new bool:WrongWay[MAX_PLAYERS];
new PrimaryColor[MAX_PLAYERS];
new SecondaryColor[MAX_PLAYERS];
new VinylJob[MAX_PLAYERS];
new RepaintValue[MAX_PLAYERS];
new bool:ChangedPrimaryColor[MAX_PLAYERS];
new bool:ChangedSecondaryColor[MAX_PLAYERS];
new bool:ChangedVinylJob[MAX_PLAYERS];
new VehListArray[MAX_PLAYERS];
new VehListArrayLimit[MAX_PLAYERS];
new VehListSelected[MAX_PLAYERS];
new bool:Logged[MAX_PLAYERS];
new bool:FullConnect[MAX_PLAYERS];
new TreasureTimer[MAX_PLAYERS];
new bool:LookTreasureReward[MAX_PLAYERS];
new bool:RegOrLog[MAX_PLAYERS];
new bool:CanBeKicked[MAX_PLAYERS];
new KickTimer[MAX_PLAYERS];
#define PAINT_VALUE (1000)
#define VYNIL_VALUE (5000)
#define SAFEHOUSE_STATE_NONE (-1)
#define SAFEHOUSE_STATE_MAIN (0)
#define SAFEHOUSE_STATE_CUSTOM (1)
#define SAFEHOUSE_STATE_AFTERMARKET (2)
#define SAFEHOUSE_STATE_PAINT (3)
#define SAFEHOUSE_STATE_DEALER (4)
#define SAFEHOUSE_STATE_DEALER_BUY (5)
#define SAFEHOUSE_STATE_DEALER_SELL (6)
#define SAFEHOUSE_STATE_VEH_CHANGE (7)
new SafeHouseState[MAX_PLAYERS] = {SAFEHOUSE_STATE_NONE,...};
#define CUSTOM_SPOILER (0)
#define CUSTOM_HOOD (1)
#define CUSTOM_WHEEL (2)
#define CUSTOM_NEON (3)
#define CUSTOM_PLATE (4)
#define CUSTOM_INTAKE (5)
#define CUSTOM_ROOF (6)
#define CUSTOM_SIDESKIRT (7)
#define CUSTOM_EXHAUST (8)
#define CUSTOM_FBUMPER (9)
#define CUSTOM_RBUMPER (10)
#define CUSTOM_VENT (11)
#define CUSTOM_LIGHT (12)
new CustomType[MAX_PLAYERS];
new CustomListNum[MAX_PLAYERS];
new CustomLimitNum[MAX_PLAYERS];
new bool:HasValidVersion[MAX_PLAYERS];
enum pInfo { pVehID,pMoney[3],pLevel[3],
	pExp[3],pVehModel[9],pActiveVehNum[3],
	pVehiclesNum[3],pEmail[64],pDriversNum,pTreasureDays,pCollectedLastTime,
	vParams[16],
	pSelectedDriver,
	Float:pPosInWorld[4],
	iNitro,iRam,iReady,
	tNitro,tRam,tReady,
	trCollected,trObj[30],trIcon[15],trArea[15],
	pChatRoom
};
new PlayerInfo[MAX_PLAYERS][pInfo];
enum rewInfo { Reputation,Money };
new RewardInfo[MAX_PLAYERS][rewInfo];
new APCheckTimer[MAX_PLAYERS];
new SpeedKick[MAX_PLAYERS];
new CheckVehDeathTimer[MAX_PLAYERS];
//Vehicles
new Float:VehPlaces[][4] = {
	{-1963.5906,204.2641,26.2243,90.7118},
    {-1963.3105,193.8967,26.2323,90.6108},
    {-1963.5502,184.4369,26.5958,90.2790},
    {-1963.1056,175.0601,27.1205,89.5627},
    {-1983.4899,215.2414,27.3926,90.6745},
    {-1983.5590,210.4479,27.3926,89.8209},
    {-1983.9586,206.4639,27.3928,90.2305},
    {-1997.3395,81.4235,27.3891,358.6963},
    {-1992.0426,80.9955,27.3908,358.9545},
    {-1986.4604,81.8672,27.3913,0.2669},
    {-1997.3395,81.4235,27.3891,358.6963},
    {-1997.3395,81.4235,27.3891,358.6963},
    {-1980.7633,81.8814,27.3926,359.4695}
};
enum vI { Name[32],MI,Float:TS,Float:AR,Float:HL,Price,Float:MSpeed };
new VehiclesIndent[64][vI] = {
	{"Bravura",401,160.0,150.0,170.0,20000,99.0},
	{"Buffalo",402,200.0,280.0,150.0,120000,160.0},
	{"Perenniel",404,150.0,120.0,180.0,15000,81.0},
	{"Sentinel",405,165.0,240.0,140.0,75000,124.0},
	{"Manana",410,160.0,190.0,200.0,65000,77.0},
	{"Infernus",411,240.0,300.0,160.0,230000,227.0},
	{"Voodoo",412,160.0,230.0,160.0,150000,131.0},
	{"Esperanto",419,160.0,180.0,120.0,87000,102.0},
	{"Washington",421,180.0,210.0,100.0,65000,109.0},
	{"Premier",426,200.0,220.0,140.0,125000,138.0},
	{"Banshee",429,200.0,300.0,160.0,195000,187.0},
	{"Previon",436,160.0,180.0,160.0,77000,102.0},
	{"Stallion",439,160.0,230.0,140.0,83000,131.0},
	{"Admiral",445,165.0,220.0,145.0,100000,123.0},
	{"Turismo",451,240.0,300.0,160.0,215000,172.0},
	{"Solair",458,165.0,200.0,100.0,98000,114.0},
	{"Glendale",466,160.0,220.0,140.0,73000,99.0},
	{"Oceanic",467,160.0,160.0,140.0,34000,91.0},
	{"Hermes",474,160.0,180.0,100.5,48000,102.0},
	{"Sabre",475,160.0,240.0,130.0,50000,138.0},
	{"ZR-350",477,200.0,280.0,160.0,150000,160.0},
	{"Regina",479,165.0,160.0,150.0,68000,90.0},
	{"Comet",480,200.0,300.0,160.0,168000,157.0},
	{"Virgo",491,160.0,180.0,130.0,45000,102.0},
	{"Greenwood",492,160.0,200.0,140.0,83000,91.0},
	{"Blista",496,200.0,260.0,200.0,115000,122.0},
	{"Mesa",500,160.0,240.0,150.0,98000,91.0},
	{"Super GT",506,230.0,260.0,50.0,178000,148.0},
	{"Elegant",507,165.0,200.0,100.0,110000,127.0},
	{"Nebula",516,165.0,200.0,100.0,105000,114.0},
	{"Majestic",517,165.0,220.0,100.0,97000,114.0},
	{"Buccaneer",518,160.0,240.0,150.0,100000,124.0},
	{"Fortune",526,160.0,200.0,100.0,75000,115.0},
	{"Cadrona",527,160.0,200.0,50.0,70000,102.5},
	{"Willard",529,160.0,180.0,150.0,65000,102.0},
	{"Feltzer",533,200.0,280.0,250.0,138000,128.5},
	{"Remington",534,160.0,230.0,50.0,125000,131.0},
	{"Slamvan",535,160.0,40.0,100.0,98000,115.0},
	{"Blade",536,160.0,240.0,50.0,95000,138.0},
	{"Vincent",540,160.0,180.0,200.0,85000,102.0},
	{"Bullet",541,230.0,300.0,100.0,198000,190.0},
	{"Clover",542,160.0,240.0,100.0,78000,124.0},
	{"Hustler",545,160.0,220.0,100.0,95000,99.5},
	{"Intruder",546,160.0,180.0,250.0,85000,102.5},
	{"Primo",547,160.0,180.0,170.0,73000,94.0},
	{"Tampa",549,160.0,240.0,100.0,50000,108.5},
	{"Sunrise",550,160.0,170.0,50.0,70000,96.5},
	{"Merit",551,165.0,220.0,100.0,83000,114.0},
	{"Windsor",555,180.0,300.0,100.0,96000,115.5},
	{"Uranus",558,200.0,200.0,50.0,120000,112.0},
	{"Jester",559,200.0,280.0,100.0,135000,145.5},
	{"Sultan",560,200.0,280.0,50.0,130000,132.0},
	{"Stratum",561,200.0,200.0,100.0,140000,109.0},
	{"Elegy",562,200.0,280.0,50.0,135000,146.0},
	{"Flash",565,200.0,240.0,100.0,110000,125.5},
	{"Tahoma",566,160.0,240.0,100.0,68000,118.0},
	{"Tornado",576,160.0,200.0,100.0,79000,114.5},
	{"Stafford",580,165.0,240.0,150.0,81000,108.0},
	{"Emperor",585,165.0,210.0,200.0,91000,108.0},
	{"Euros",587,200.0,240.0,50.0,95000,125.0},
	{"Club",589,200.0,300.0,100.0,105000,122.0},
	{"Picador",600,165.0,250.0,200.0,87000,105.0},
	{"Alpha",602,200.0,230.0,50.0,92000,132.0},
	{"Phoenix",603,200.0,260.0,50.0,140000,135.5}
};
new RamObject[MAX_VEHICLES+1] = {INVALID_OBJECT_ID, ...};
#include <nfsw\vehicles_names.txt>
new NeonObject[MAX_VEHICLES+1][2];
//Races/Events/Queues
new Float:radius = 2.0;
new Float:rad_by_line[8];
new Float:speed_by_line[8];
new Float:speed = 0.64;
new Float:GlobalPov = 90.0;
new Float:Radius = 5.0;
enum rInfo { AreaID,Name[32],Type[32],MaxDrivers,Level,Dist,RaceTime,Laps,Float:X,Float:Y,Float:Z,Light[32],Float:SpawnPos[32],AreaNum,FinishArea };
new FirstRaceArea[MAX_RACES];
new RaceInfo[MAX_RACES][rInfo] = {
	{-1,"Center & Club","Sprint",8,1,5,240,0,-2004.0145,1066.0697,55.2974,-1,
		{-2007.350952,1045.442016,55.363998,180.0,
		-1998.630004,1052.240966,55.363998,180.0,
		-2003.567993,1052.240966,55.369998,180.0,
		-2008.553955,1052.240966,55.369998,180.0,
		-1998.630004,1059.282958,55.369998,180.0,
		-2003.567993,1059.282714,55.369998,180.0,
		-2008.553955,1059.282714,55.369998,180.0},17},
	{-1,"Pier & Paradise","Sprint",8,1,6,270,0,-2035.1224,1301.4928,6.9146,-1,
	    {-2025.6409912109,1313.8170166016,6.9320001602173,262.0,
    	-2026.7230224609,1308.9239501953,6.9320001602173,268.0,
    	-2027.2740478516,1304.0279541016,6.9260001182556,267.99499511719,
    	-2029.5450439453,1294.5959472656,6.9169998168945,261.99499511719,
    	-2029.8759765625,1290.2960205078,6.9079999923706,261.99096679688,
    	-2030.5920410156,1286.0589599609,6.9039998054504,261.99096679688,
    	-2034.9389648438,1301.7969970703,6.9869999885559,265.99499511719,
    	-2035.3050537109,1298.2919921875,6.9869999885559,261.98999023438},19},
	{-1,"Garcia & Flats","Circuit",8,1,4,400,3,-2255.9561,-70.2683,34.8990,-1,
		{-2263.040039,-64.305,34.972,0.0,
	    -2257.771972,-64.397003,34.972,0.0,
	    -2253.031005,-64.427001,34.972,0.0,
	    -2248.241943,-64.513999,34.972,0.0,
	    -2262.887939,-72.419998,34.972,0.0,
	    -2257.696044,-72.415,34.972,0.0,
	    -2252.900878,-72.369003,34.972,0.0,
	    -2248.135009,-72.310997,34.972,0.0},13},
	{-1,"Verona Heights","Circuit",8,1,6,300,3,632.0135,-1700.1470,14.8855,-1,
		{621.776,-1716.198974,13.795,352.0,
    	626.723999,-1717.005981,13.789999,351.996459,
	    631.71997,-1717.847045,13.795,351.996459,
	    636.875976,-1718.604003,13.795,351.996459,
	    622.849975,-1708.277954,14.255,351.996459,
	    627.981994,-1709.062988,14.194999,351.996459,
	    637.729003,-1710.859985,14.071999,351.996459,
	    632.700988,-1709.759033,14.149,351.996459},14}
};
new bool:AvaliableEvents[MAX_RACES][MAX_JOINS];
new Float:EventXByPos[8] = {-1287.1560,-1282.1560,-1292.1560,-1277.1560,-1297.1560,-1272.1560,-1302.1560,-1267.1560};
new RotateTimer;
//Chat rooms
#define CHAT_GLOBAL (0)
#define CHAT_RU (1)
#define CHAT_EN (2)
#define CHAT_DE (3)
#define CHAT_DEV (4)
new Iterator:ChatRoom[5]<MAX_PLAYERS>;
//Cameras
#define SAFEHOUSE_CAMERA_MAIN 1929.1203,-2217.9377,14.0699
#define SAFEHOUSE_CAMERA_BACK 1925.5863,-2209.4025,14.0699
#define SAFEHOUSE_CAMERA_LEFTSIDE 1930.5848,-2214.4020,14.0699
#define SAFEHOUSE_CAMERA_LEFTSIDE_ANGLE 1929.1203,-2210.8664,14.0699
//Customization
new CustomTypeName[13][] = {"Spoilers","Hoods","Wheels","Neon","Lic plates","Intakes","Roofs","Sideskirts","Exhausts","Front bumpers","Rear bumpers","Vents","Lights"};
new CustomTypeHudName[13][] = {"Spoiler","Hood","Wheel","Neon","Lic plate","Intake","Roof","Sideskirt","Exhaust","Front bumper","Rear bumper","Vent","Lights"};
new TypeBorder[13] = { 20,4,17,6,34,13,4,20,29,23,22,2,2 };
//Audio
new TracksArray[] = { 8,9,10,11,12 };
//Areas
new WaterArea,/*WaterAreaHigh,LakeLS,LakeG,LakeGt,BadLake,WorkLake,GolfLake,Tower,Sfink,Pirates,Rocks,Bas,*/SfLake; //Water Areas
new Digger,Airport,Trails; //Normal Areas
//Treasure Spawn
new Float:TreasurePos[][3] = {
	{2682.7651,-1430.2815,16.2500},
	{2806.9609,-1441.9250,40.0413},
	{2808.5542,-1183.7218,25.3526},
	{2431.1079,-1230.0797,25.0615},
	{2217.5979,-1164.4203,25.7266},
	{2126.8789,-1136.3993,25.4811},
	{1969.8909,-1195.4628,25.6960},
	{1917.0874,-1427.4166,10.3594},
	{1575.9215,-1620.0898,13.5469},
	{1531.4507,-1681.9447,5.8906},
	{1260.6360,-2024.3204,59.4017},
	{1252.7119,-1917.7286,30.9543},
	{1149.3146,-1740.7981,13.4037},
	{836.6820,-2010.5214,12.8672},
	{318.2292,-1799.8284,4.6309},
	{484.6989,-1514.9474,20.2848},
	{543.9567,-1280.5668,17.2422},
	{664.5754,-1276.8918,13.4609},
	{743.9811,-1341.6182,13.5248},
	{1128.3119,-1447.8398,15.7969},
	{1269.4158,-1338.3907,13.3363},
	{1022.7219,-1130.6323,23.8465},
	{910.3650,-1102.3086,24.2969},
	{1245.3655,-766.9848,92.0965},
	{929.3967,-852.6660,93.4984},
	{1798.1637,-2670.4150,5.5971},
	{1798.5491,-2685.2839,5.5970},
	{1488.9087,-2242.2104,-3.2651},
	{1797.7343,-2301.7029,-3.0031},
	{1961.7559,-2184.2129,13.2740},
	{1911.3053,-1776.6575,13.1099},
	{-2027.7900,-93.6177,34.9447},
	{-2267.4302,168.2144,34.8665},
	{-2265.1064,527.8909,34.8873},
	{-1818.1642,1299.8737,59.4392},
	{-1706.0132,1338.3486,6.8836},
	{-1593.7919,801.2514,6.5248},
	{-1247.4471,451.6920,6.8909},
	{-1548.7609,123.6485,3.2603},
	{-2138.0322,-445.0591,35.0406},
	{-2021.2703,-859.8148,31.8760},
	{-2520.9717,-612.5660,132.2661},
	{-2762.9250,-303.1905,6.7440},
	{-2399.2153,-254.2182,39.4925},
	{-1735.6075,540.3297,39.3277},
	{-1711.9272,1050.7629,17.2902},
	{-2443.1467,741.7047,34.7204},
	{-2661.8562,607.7349,14.1578},
	{-2706.2107,376.5625,4.6744},
	{-2978.8352,470.7602,4.6188},
	{-2579.1050,1161.5995,54.9956},
	{-2623.9685,1404.1307,6.8075},
	{-1549.8007,-434.6489,5.7227},
	{-1225.5026,56.8086,13.8369},
	{-1091.1855,401.4872,13.8466}
};
//World Time
new bool:TimeForward = true;
new GlobMin = 0;
new TimeChangeTimer;

main() return 1;

public OnGameModeInit()
{
	new obj,str[1024];
	//Settings
	SetGameModeText("NFS World");
	ShowNameTags(false);
	mysql_init();
	mysql_connect("localhost","root","password","nfsw");
	mysql_query("SET NAMES utf8");
	mysql_query("UPDATE emails SET used=0");
	Audio_SetPack("nfsw",true,true);
	SetWorldTime(22);
	DisableInteriorEnterExits();
	LimitGlobalChatRadius(0);
	LimitPlayerMarkerRadius(300);
	EnableStuntBonusForAll(false);
	//Anticheat
	CheckSet(CHEAT_JETPACK);
	CheckSet(CHEAT_HEALTHARMOUR);
	CheckSet(CHEAT_WEAPON);
	SetMaxPing();
	for(new i = 1; i < 47; i++) SetWeaponAllowed(-1,i,false);
	AntiCheatSetUpdateDelay();
	//aat_Logging(false);
	//aat_Init(MAX_PLAYERS,false,false);
	Iter_Init(ChatRoom);
	//Race Joins
	for(new i = 0; i < MAX_RACES; i++)
	{
		RaceInfo[i][AreaID] = CreateDynamicSphere(RaceInfo[i][X],RaceInfo[i][Y],RaceInfo[i][Z],20.0,MAX_PLAYERS+1,0,-1);
		new mapi = CreateDynamicMapIcon(RaceInfo[i][X],RaceInfo[i][Y],RaceInfo[i][Z],53,0x00FFFFAA,MAX_PLAYERS+1,0,-1,6000.0);
		Streamer_SetIntData(STREAMER_TYPE_MAP_ICON,mapi,E_STREAMER_STYLE,MAPICON_GLOBAL_CHECKPOINT);
		SetDynamicObjectMaterialText(CreateDynamicObject(19133,RaceInfo[i][X],RaceInfo[i][Y],RaceInfo[i][Z]+4.0,0.0,0.0,90.0,MAX_PLAYERS+1,0,-1,150.0),0," ",OBJECT_MATERIAL_SIZE_64x64,"Arial",1,false,0xFFFFFFFF,0xFF00FFFF,1);
		new Float:x,Float:z;
		for(new j = 0; j < 32; j++)
		{
		    x = radius*floatcos(11.25*j,degrees);
	    	z = radius*floatsin(11.25*j,degrees);
	    	RaceInfo[i][Light][j] = CreateDynamicObject(19284,RaceInfo[i][X]+x,RaceInfo[i][Y],RaceInfo[i][Z]+4.0+z,0.0,0.0,0.0,MAX_PLAYERS+1,0,-1,150.0);
		}
	}
	for(new i = 0; i < 8; i++)
	{
		rad_by_line[i] = radius*floatcos(11.25*i,degrees);
		speed_by_line[i] = speed*floatcos(11.25*i,degrees);
	}
	for(new i = 0; i < MAX_RACES; i++) for(new j = 0; j < MAX_JOINS; j++) AvaliableEvents[i][j] = true;
	//Objects
 		//Safehouse/garage
	new for_players[MAX_PLAYERS+1];
	for(new i = 1; i <= MAX_PLAYERS; i++) for_players[i] = i;
	CreateDynamicObjectEx(14776,1923.5999755859,-2211.1000976563,18.89999961853,0,0,359.5,0.0,300.0,for_players,{0},{-1});
	obj = CreateDynamicObjectEx(983,1926.1999511719,-2214.1999511719,13.300000190735,0,90,0,0.0,300.0,for_players,{0},{-1});
	for(new i = 0; i < 6; i++) SetDynamicObjectMaterial(obj,i,0,"none","none",0);
	obj = CreateDynamicObjectEx(983,1925,-2214.1999511719,13.300000190735,0,90,0,0.0,300.0,for_players,{0},{-1});
	for(new i = 0; i < 6; i++) SetDynamicObjectMaterial(obj,i,0,"none","none",0);
	obj = CreateDynamicObjectEx(983,1926.19921875,-2220.3994140625,12.199999809265,19.9951171875,90,0,0.0,300.0,for_players,{0},{-1});
	for(new i = 0; i < 6; i++) SetDynamicObjectMaterial(obj,i,0,"none","none",0);
	obj = CreateDynamicObjectEx(983,1925,-2220.3999023438,12.199999809265,19.9951171875,90,0,0.0,300.0,for_players,{0},{-1});
	for(new i = 0; i < 6; i++) SetDynamicObjectMaterial(obj,i,0,"none","none",0);
		//Join Event Zone
	obj = CreateDynamicObjectEx(18845, -1287.3879394531, -184.78300476074, -5.3720002174377, 0, 0, 0,150.0,150.0,{-1},{1},{-1});
	SetDynamicObjectMaterialText(obj,1," ",OBJECT_MATERIAL_SIZE_32x32,"Arial",1,false,0xFFFFFFFF,0xFF858585,0);
	obj = CreateDynamicObjectEx(8172, -1273.1219482422, -164.80099487305, 13.28, 0, 0, 0,150.0,150.0,{-1},{1},{-1});
	SetDynamicObjectMaterialText(obj,0," ",OBJECT_MATERIAL_SIZE_32x32,"Arial",1,false,0xFFFFFFFF,0xFF45536E,0);
	SetDynamicObjectMaterialText(obj,1," ",OBJECT_MATERIAL_SIZE_32x32,"Arial",1,false,0xFFFFFFFF,0xFF45536E,0);
    obj = CreateDynamicObjectEx(8172, -1301.5009765625, -182.12699890137, 13.28, 0, 0, 180.0,150.0,150.0,{-1},{1},{-1});
	SetDynamicObjectMaterialText(obj,0," ",OBJECT_MATERIAL_SIZE_32x32,"Arial",1,false,0xFFFFFFFF,0xFF45536E,0);
	SetDynamicObjectMaterialText(obj,1," ",OBJECT_MATERIAL_SIZE_32x32,"Arial",1,false,0xFFFFFFFF,0xFF45536E,0);
	    //Races
 	new rworld[MAX_JOINS];
 	new object1,object2;
 	for(new i = 0; i < MAX_JOINS; i++) rworld[i] = EVENT_WORLD+i;
 	#include <nfsw\center_and_club.txt>
for(new i = 0; i < MAX_JOINS; i++) rworld[i] = EVENT_WORLD+MAX_JOINS+i;
#include <nfsw\heights_and_paradise.txt>
for(new i = 0; i < MAX_JOINS; i++) rworld[i] = EVENT_WORLD+MAX_JOINS*2+i;
#include <nfsw\garcia_and_flats.txt>
for(new i = 0; i < MAX_JOINS; i++) rworld[i] = EVENT_WORLD+MAX_JOINS*3+i;
#include <nfsw\verona_heights.txt>
	//Object setting
for(new o, s = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); o <= s; o++)
{
    if(IsValidDynamicObject(o))
    {
        new Float: distance;
        Streamer_GetFloatData(STREAMER_TYPE_OBJECT, o, E_STREAMER_STREAM_DISTANCE, distance);
        Streamer_SetFloatData(STREAMER_TYPE_OBJECT, o, E_STREAMER_DRAW_DISTANCE, distance);
    }
}
//Objects for gates
CreateDynamicObject(8957, 2071.6001, -1831.09998, 15.4, 0, 0, 0,-1,-1,-1,150.0);
CreateDynamicObject(8957, 2644.8999, -2039.30005, 12.9, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 2505.19995, -1691, 14, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1041.80005, -1026, 34, 0, 0, 270,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1025.19995, -1029.44495, 34, 0, 0, 269.995,-1,-1,-1,150.0);
CreateDynamicObject(8957, 488.29999, -1734.69995, 13, 0, 0, 81.744,-1,-1,-1,150.0);
CreateDynamicObject(8957, 322.20001, -1768.995, 4.4, 0, 0, 270,-1,-1,-1,150.0);
CreateDynamicObject(8957, -1935.90002, 238.5, 36.2, 0, 0, 269.995,-1,-1,-1,150.0);
CreateDynamicObject(8957, -1904.5, 277.70001, 42.9, 0, 0, 269.995,-1,-1,-1,150.0);
CreateDynamicObject(8957, -2454.6001, -120.6, 28, 0, 0, 180,-1,-1,-1,150.0);
CreateDynamicObject(8957, -2454.6001, -127.8, 28, 0, 0, 179.995,-1,-1,-1,150.0);
CreateDynamicObject(8957, -2695.3999, 821.40002, 51.9, 0, 0, 270,-1,-1,-1,150.0);
CreateDynamicObject(8957, -2425.69995, 1028.19995, 52.3, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, -2105.19995, 897, 78.6, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, -2025.40002, 129.5, 30.3, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, -2029.19995, 129.5, 30.1, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, -1420.5, 2591.1001, 57.7, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, -2716, 217.5, 6.2, 0, 0, 0,-1,-1,-1,150.0);
CreateDynamicObject(8957, -360.89999, 1194.30005, 19.2, 90, 0, 270,-1,-1,-1,150.0);
CreateDynamicObject(8957, 430, 2546.5, 17, 0, 0, 180,-1,-1,-1,150.0);
CreateDynamicObject(8957, 415.10001, 2476.3999, 18.4, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 407.89999, 2476.3999, 18.4, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 400.70001, 2476.3999, 18.4, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 393.5, 2476.3999, 18.4, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 415.10001, 2476.3999, 20.7, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 407.89999, 2476.3999, 20.8, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 400.70001, 2476.3999, 20.7, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 393.5, 2476.3999, 20.6, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1278.90002, 2527.3999, 10.4, 0, 0, 0,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1278.90002, 2531.69995, 10.4, 0, 0, 0,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1968.19995, 2162.5, 12.7, 0, 0, 180,-1,-1,-1,150.0);
CreateDynamicObject(8957, 2385.1001, 1043.30005, 12.7, 0, 0, 270,-1,-1,-1,150.0);
CreateDynamicObject(8957, 2388.80005, 1043.30005, 12.7, 0, 0, 269.995,-1,-1,-1,150.0);
CreateDynamicObject(8957, 719.90002, -462.5, 17.7, 0, 0, 269.995,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1352.59998, -627, 109, 0, 0, 109,-1,-1,-1,150.0);
CreateDynamicObject(8957, -100, 1111.40002, 21.6, 0, 0, 270,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1408.69995, 1901.90002, 10.5, 0, 0, 180,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1616.5, 1223.19995, 12.9, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1609.30005, 1223.19995, 12.9, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1602.09998, 1223.19995, 12.9, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1594.90002, 1223.19995, 12.9, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1587.69995, 1223.19995, 12.9, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1580.5, 1223.19995, 12.9, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1573.30005, 1223.19995, 12.9, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1566.09998, 1223.19995, 12.9, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1558.90002, 1223.19995, 12.9, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1552.80005, 1223.19995, 12.9, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1616.40002, 1223.19995, 18.7, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1609.19995, 1223.19995, 18.7, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1602, 1223.19995, 18.7, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1594.80005, 1223.19995, 18.7, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1587.59998, 1223.19995, 18.7, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1580.40002, 1223.19995, 18.7, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1573.19995, 1223.19995, 18.7, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1566, 1223.19995, 18.7, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1558.80005, 1223.19995, 18.7, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1552.69995, 1223.19995, 18.7, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1616.40002, 1223.19995, 24.5, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1609.19995, 1223.19995, 24.5, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1602, 1223.19995, 24.5, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1594.80005, 1223.19995, 24.5, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1587.59998, 1223.19995, 24.5, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1580.40002, 1223.19995, 24.5, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1573.19995, 1223.19995, 24.5, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1566, 1223.19995, 24.5, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1558.80005, 1223.19995, 24.5, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1553.30005, 1223.19995, 24.5, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1616.40002, 1223.19995, 27.6, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1609.19995, 1223.19995, 30.3, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1602, 1223.19995, 30.3, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1594.80005, 1223.19995, 30.3, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1587.59998, 1223.19995, 30.3, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1580.40002, 1223.19995, 30.3, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1573.19995, 1223.19995, 30.3, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1566, 1223.19995, 30.3, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1558.80005, 1223.19995, 30.3, 0, 0, 90,-1,-1,-1,150.0);
CreateDynamicObject(8957, 1554.09998, 1223.19995, 27.1, 0, 0, 90,-1,-1,-1,150.0);
	//Vehicles
AddStaticVehicle(411,1925.5848,-2214.4021,14.0700,179.8839,0,0);
SetVehicleNumberPlate(1,"ND4SPD");
for(new i = 1; i <= MAX_VEHICLES; i++) for(new b = 0; b < 2; b++) NeonObject[i][b] = INVALID_OBJECT_ID;
	//Timers
RotateTimer = SetTimer("RotateRacesLights",2750,true);
TimeChangeTimer = SetTimer("TimeChange",60000,true);
	//TD's
#include <nfsw\global_textdraws.txt>
#include <nfsw\parts.txt>
//Areas
WaterArea = CreateDynamicCube(-FLOAT_INFINITY,-FLOAT_INFINITY,-90.0,FLOAT_INFINITY,FLOAT_INFINITY,0.0,-1,-1,-1);
CreateDynamicPolygon(Float:{-509.9360,2014.0149,-898.2150,2015.4291,-970.5613,2116.9011,-1371.7938,2091.2944,-1394.5951,2171.3130,-1049.9257,2232.3013,-1024.7546,2357.0845,-1055.8326,2435.1860,-1188.6459,2693.4402,-1242.9984,2771.7454,-1086.5153,2810.4453,-839.7018,2561.5828,-877.3839,2338.7505,-843.7703,2269.8711,-508.0893,2299.2173,-461.2944,2191.6062},0.0,40,32,-1,-1,-1);
CreateDynamicPolygon(Float:{1248.8259,-2343.2087,1209.2585,-2346.3728,1196.7086,-2368.9578,1203.1014,-2401.2898,1232.9772,-2416.4102,1267.9711,-2410.9644,1284.8210,-2392.0464,1281.3915,-2366.4731,1272.3967,-2347.7388},0.0,9.0,18,-1,-1,-1);
CreateDynamicPolygon(Float:{1925.8822,-1197.5000,1937.6909,-1182.4822,1967.2963,-1177.0494,2000.5503,-1183.6466,2015.2195,-1196.6345,2001.9810,-1217.3060,1973.6250,-1222.6060,1932.8969,-1212.2323},0.0,18.0,16,-1,-1,-1);
CreateDynamicCube(2293.7612,-1428.2382,0.0,2327.6812,-1396.2980,22.0,-1,-1,-1);
CreateDynamicCube(-745.1481,-2125.2358,0.0,-464.5313,-1874.2383,5.0,-1,-1,-1);
CreateDynamicCube(-2041.9285,-957.9564,0.0,-2004.0154,-761.2062,30.0,-1,-1,-1);
CreateDynamicCube(-2519.5459,-303.7641,30.0,-2382.1331,-229.7946,35.5,-1,-1,-1);
CreateDynamicCube(2109.1106,1071.5259,0.0,2177.8572,1191.3342,7.5,-1,-1,-1);
CreateDynamicCube(2107.1504,1240.6536,0.0,2172.9031,1325.4194,7.7,-1,-1,-1);
CreateDynamicCube(1856.1029,1474.8727,0.0,2029.9984,1699.1683,8.5,-1,-1,-1);
CreateDynamicCube(2066.3350,1874.4409,0.0,2106.1472,1963.8606,9.5,-1,-1,-1);
CreateDynamicCube(1752.3804,2774.6631,0.0,1794.3169,2850.0769,8.5,-1,-1,-1);
SfLake = CreateDynamicPolygon(Float:{-2767.9883,-474.7314,-2702.8899,-526.3484,-2680.0974,-485.8489,-2699.1379,-409.2433,-2747.1643,-448.8282},0.0,3.0,10,-1,-1,-1);
Digger = CreateDynamicCircle(600.2857,882.2706,210.0,-1,-1,-1);
Airport = CreateDynamicCube(1352.4043,-2391.1252,-5.0,1833.1093,-2175.1992,10.0,-1,-1,-1);
Trails = CreateDynamicCube(2520.2661,1946.8344,-20.0,2770.1372,2409.0142,7.5,-1,-1,-1);
return 1;
}

public OnGameModeExit()
{
	mysql_close();
	Audio_DestroyTCPServer();
	KillTimer(RotateTimer);
	KillTimer(TimeChangeTimer);
	new str[32],ind;
	for(new i = 0; i < MAX_JOINS; i++)
	{
		ind = GetGVarsUpperIndex(i);
		if(ind != 0)
		{
			for(new j = 0; j < ind; j++)
			{
				GetGVarNameAtIndex(j,str,32,i);
				if(GetGVarType(str,i) != GLOBAL_VARTYPE_NONE) DeleteGVar(str,i);
			}
		}
	}
	for(new Text:i = BoxCon; i < TreasureTD[39]; _:i++) TextDrawDestroy(i);
	return 1;
}

public OnPlayerConnect(playerid)
{
	new str[32];
	GetPlayerVersion(playerid,str,32);
	if(!strcmp(str,"0.3x-R1-2",false)) HasValidVersion[playerid] = true;
	else
	{
	    SendClientMessage(playerid,Colour_Red,"* You are using invalid version of SA-MP.");
	    SendClientMessage(playerid,Colour_Red,"* Please, download the latest version, install it and connect to the server again.");
		HasValidVersion[playerid] = false;
		return 1;
	}
	//Main variables
    CameraMoveAngle[playerid] = 0;
    EnterInServer[playerid] = false;
    InGame[playerid] = false;
	EffectHandle[playerid] = -1;
    MainThemeHandle[playerid] = -1;
    FreeroamHandle[playerid] = -1;
    EventHandle[playerid] = -1;
    FinishHandle[playerid] = -1;
    SafehouseHandle[playerid] = -1;
    //Players Settings
	for(new i = 0; i < 9; i++) PlayerInfo[playerid][pVehModel][i] = 0;
	for(new i = 0; i < 3; i++)
	{
	    PlayerInfo[playerid][pLevel][i] = 1;
	    PlayerInfo[playerid][pExp][i] = 0;
	    PlayerInfo[playerid][pActiveVehNum][i] = 0;
	    PlayerInfo[playerid][pVehiclesNum][i] = 0;
	    PlayerInfo[playerid][pMoney][i] = 150000;
	    format(DriverName[playerid][i],32,"");
	}
	for(new i = 0; i < 15; i++) PlayerInfo[playerid][vParams][i] = 0;
	PlayerInfo[playerid][vParams][15] = -1;
 	format(PlayerInfo[playerid][pEmail],128,"");
 	PlayerInfo[playerid][pTreasureDays] = 1;
 	PlayerInfo[playerid][pCollectedLastTime] = 0;
 	PlayerInfo[playerid][trCollected] = 0;
 	PlayerInfo[playerid][pVehID] = INVALID_VEHICLE_ID;
 	PlayerInfo[playerid][pSelectedDriver] = 0;
 	PlayerInfo[playerid][pDriversNum] = 0;
 	PlayerInfo[playerid][iNitro] = 50;
 	PlayerInfo[playerid][iRam] = 50;
 	PlayerInfo[playerid][iReady] = 50;
 	PlayerInfo[playerid][tNitro] = -1;
 	PlayerInfo[playerid][tRam] = -1;
 	PlayerInfo[playerid][tReady] = -1;
 	PlayerInfo[playerid][pChatRoom] = CHAT_GLOBAL;
 	//Others settings
    TutStep[playerid] = 0;
	VehSelectNum[playerid] = 0;
	MoveCameraTimer[playerid] = -1;
	for(new i = 0; i < 30; i++) IsSpeedBarShown[playerid][i] = false;
	IsSpeedShown[playerid] = false;
	CanUseNitroItem[playerid] = true;
	CanUseRamItem[playerid] = true;
	CanUseReadyItem[playerid] = true;
	CanFlip[playerid] = false;
	FlipTimer[playerid] = -1;
	InFreeRoam[playerid] = false;
	RaceStartZone[playerid] = -1;
	JoinedJNum[playerid] = -1;
	JoinTimer[playerid] = -1;
	JoinedInRace[playerid] = false;
	CancelSeconds[playerid] = 0;
	InRace[playerid] = false;
	EventArea[playerid] = 0;
    NumPassedArea[playerid] = 0;
    LookingFinishList[playerid] = false;
    LookingRep[playerid] = false;
    APCheckTimer[playerid] = -1;
    CurLap[playerid] = 1;
    WrongWay[playerid] = false;
    PrimaryColor[playerid] = 0;
	SecondaryColor[playerid] = 0;
	VinylJob[playerid] = 0;
	RepaintValue[playerid] = 0;
	ChangedPrimaryColor[playerid] = false;
	ChangedSecondaryColor[playerid] = false;
	ChangedVinylJob[playerid] = false;
	Logged[playerid] = false;
	VehListArray[playerid] = 0;
	VehListArrayLimit[playerid] = 0;
	VehListSelected[playerid] = 0;
	FullConnect[playerid] = false;
	TreasureTimer[playerid] = -1;
	LookTreasureReward[playerid] = false;
	RegOrLog[playerid] = false;
    SafeHouseState[playerid] = SAFEHOUSE_STATE_NONE;
    SpeedKick[playerid] = 0;
    CheckVehDeathTimer[playerid] = -1;
    CanBeKicked[playerid] = true;
    KickTimer[playerid] = -1;
	//TextDraw's
	#include <nfsw\player_textdraws.txt>
#include <nfsw\shop_close.txt>
SendClientMessage(playerid,Colour_Yellow,"This server also uses Audio Plugin. With it you can see all functional of server.");
SendClientMessage(playerid,Colour_Yellow,"Download URL: http://www.solidfiles.com/d/e690df58ad (go to GTA SA User Files/SAMP and open file chatlog.txt to copy URL)");
SendClientMessage(playerid,Colour_Yellow,"If you have already installed it but nothing is happening, just reconnect.");
SetPlayerColor(playerid,0xF5BC1EFF);
return 1;
}

public OnPlayerDisconnect(playerid,reason)
{
    if(MoveCameraTimer[playerid] != -1) KillTimer(MoveCameraTimer[playerid]);
	if(PlayerInfo[playerid][pVehID] != INVALID_VEHICLE_ID) DestroyVehicleEx(PlayerInfo[playerid][pVehID]);
	if(JoinedInRace[playerid] && !InRace[playerid])
	{
	    new str[64],drv;
	    format(str,64,"QI[%d][DriversNum]",RaceStartZone[playerid]);
	    drv = GetGVarInt(str,JoinedJNum[playerid]);
	    if(drv == 1)
	    {
	        DeleteGVar(str,JoinedJNum[playerid]);
	        format(str,64,"QI[%d][Locked]",RaceStartZone[playerid]);
	        DeleteGVar(str,JoinedJNum[playerid]);
	        format(str,64,"QI[%d][Created]",RaceStartZone[playerid]);
			DeleteGVar(str,JoinedJNum[playerid]);
			format(str,64,"QI[%d][UntilStart]",RaceStartZone[playerid]);
			DeleteGVar(str,JoinedJNum[playerid]);
			format(str,64,"QI[%d][Timer]",RaceStartZone[playerid]);
		    KillTimer(GetGVarInt(str,JoinedJNum[playerid]));
		    DeleteGVar(str,JoinedJNum[playerid]);
		    if(!AvaliableEvents[RaceStartZone[playerid]][JoinedJNum[playerid]]) AvaliableEvents[RaceStartZone[playerid]][JoinedJNum[playerid]] = true;
		}
		else
		{
		    new str1[64],step,apid,dapid;
		    SetGVarInt(str,drv-1,JoinedJNum[playerid]);
		    drv--;
		    for(new p = 0; p < drv; p++)
			{
			    format(str,64,"QI[%d][ID][%d]",RaceStartZone[playerid],p);
			    apid = GetGVarInt(str,JoinedJNum[playerid]);
			    if(apid == playerid)
			    {
					for(new i = p; i < drv; i++)
					{
					    format(str1,64,"QI[%d][ID][%d]",RaceStartZone[playerid],i);
					    format(str,64,"QI[%d][ID][%d]",RaceStartZone[playerid],i+1);
					    SetGVarInt(str1,GetGVarInt(str,JoinedJNum[playerid]),JoinedJNum[playerid]);
					}
					break;
				}
			}
		    for(new i = 0; i < drv; i++)
			{
			    format(str,64,"QI[%d][ID][%d]",RaceStartZone[playerid],i);
			    apid = GetGVarInt(str,JoinedJNum[playerid]);
				ClearDriversList(apid);
				step = 1;
				for(new d = 0; d < drv; d++)
				{
					format(str,64,"QI[%d][ID][%d]",RaceStartZone[playerid],d);
					dapid = GetGVarInt(str,JoinedJNum[playerid]);
					if(apid == dapid) continue;
				    format(str,32,"] level %d",PlayerInfo[dapid][pLevel][PlayerInfo[dapid][pSelectedDriver]]);
        			PlayerTextDrawHide(apid,DriversListTDPl[apid][step*2]);
				    PlayerTextDrawColor(apid,DriversListTDPl[apid][step*2],-1);
				    PlayerTextDrawShow(apid,DriversListTDPl[apid][step*2]);
				    PlayerTextDrawSetString(apid,DriversListTDPl[apid][step*2],DriverName[dapid][PlayerInfo[dapid][pSelectedDriver]]);
				    PlayerTextDrawSetString(apid,DriversListTDPl[apid][step*2+1],str);
				    step++;
				}
			}
		}
	}
	if(InRace[playerid])
	{
	    new str[64],str1[64],drv,apid;
	    format(str,64,"EI[%d][DriversNum]",RaceStartZone[playerid]);
	    drv = GetGVarInt(str,JoinedJNum[playerid]);
	    format(str,64,"EI[%d][Started]",RaceStartZone[playerid]);
	    if(GetGVarInt(str,JoinedJNum[playerid]))
     	{
		    for(new i = 0; i < drv; i++)
		    {
		        format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],i);
		        apid = GetGVarInt(str,JoinedJNum[playerid]);
		        if(apid == playerid)
		        {
		            for(new t = i; t < drv-1; t++)
		            {
		                format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],t+1);
		                format(str1,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],t);
		                SetGVarInt(str1,GetGVarInt(str,JoinedJNum[playerid]),JoinedJNum[playerid]);
		                format(str,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],t+1);
		                format(str1,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],t);
		                SetGVarInt(str1,GetGVarInt(str,JoinedJNum[playerid]),JoinedJNum[playerid]);
		                format(str,64,"EI[%d][RacerName][%d]",RaceStartZone[playerid],t+1);
		                GetGVarString(str,str,64,JoinedJNum[playerid]);
		                format(str1,64,"EI[%d][RacerName][%d]",RaceStartZone[playerid],t);
		                SetGVarString(str1,str,JoinedJNum[playerid]);
					}
					break;
				}
			}
			format(str,64,"EI[%d][DriversNum]",RaceStartZone[playerid]);
			SetGVarInt(str,drv-1,JoinedJNum[playerid]);
			drv--;
			if(drv == 1)
			{
			    format(str,64,"EI[%d][PIDPlace][0]",RaceStartZone[playerid]);
			    apid = GetGVarInt(str,JoinedJNum[playerid]);
			    if(RaceStartZone[apid] == RaceStartZone[playerid] && JoinedJNum[apid] == JoinedJNum[playerid])
			    {
			        format(str,64,"EI[%d][AtFinish]",RaceStartZone[playerid]);
					if(!GetGVarInt(str,JoinedJNum[playerid]))
					{
						//Hide race Text draws for player with ID stored in EI[rid][PIDPlace][0] and take him in general world
						for(new t = 0; t < 3; t++) TextDrawHideForPlayer(apid,EventTD[t]);
						for(new t = 0; t < 5; t++) PlayerTextDrawHide(apid,EventTDPl[apid][t]);
						ShowTreasureTDs(apid);
						PlayerTextDrawSetString(apid,EventTDPl[apid][1],"0%");
		                SetVehicleVirtualWorld(PlayerInfo[apid][pVehID],MAX_PLAYERS+1),SetPlayerVirtualWorld(apid,MAX_PLAYERS+1);
		                RaceStartZone[apid] = -1;
		                JoinedJNum[apid] = -1;
		                InRace[apid] = false;
						NumPassedArea[apid] = 0;
		                if(Audio_IsClientConnected(apid))
						{
							Audio_Stop(apid,EventHandle[apid]);
							Audio_Play(apid,20,false,false,false);
							new for_rand[2] = {2,3};
							FreeroamHandle[apid] = Audio_Play(apid,for_rand[random(2)],false,false,false);
						}
						SendClientMessage(apid,Colour_Yellow,"Race was aborted. All players leaved race.");
						if(WrongWay[apid])
						{
							HidePlayerBrick(apid);
							WrongWay[apid] = false;
			    		}
					}
					else
					{
					    if(WrongWay[apid])
						{
							HidePlayerBrick(apid);
							WrongWay[apid] = false;
			    		}
					    if(LookingFinishList[apid])
					    {
							PlayerTextDrawHide(apid,DriversListTDPl[apid][2]);
	                        PlayerTextDrawColor(apid,DriversListTDPl[apid][2],-1);
	                        format(str,64,"EI[%d][RacerName][1]",RaceStartZone[playerid]);
	                        GetGVarString(str,str,64,JoinedJNum[playerid]);
	                        PlayerTextDrawSetString(apid,DriversListTDPl[apid][2],str);
	                        PlayerTextDrawShow(apid,DriversListTDPl[apid][2]);
	                        PlayerTextDrawSetString(apid,DriversListTDPl[apid][3],"DNF");
						}
					}
				}
				ClearEventAndJoin(RaceStartZone[playerid],JoinedJNum[playerid]);
				format(str,64,"EI[%d][Timer]",RaceStartZone[playerid]);
				KillTimer(GetGVarInt(str,JoinedJNum[playerid]));
			}
			else
			{
				format(str,64,"EI[%][LeavedPlayers]",RaceStartZone[playerid]);
				if(GetGVarInt(str,JoinedJNum[playerid]) >= drv)
				{
				    for(new i = 0; i < drv; i++)
				    {
				        format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],i);
				        apid = GetGVarInt(str,JoinedJNum[playerid]);
				        if(LookingFinishList[apid] && RaceStartZone[apid] == RaceStartZone[playerid] && JoinedJNum[apid] == JoinedJNum[playerid])
				        {
				            PlayerTextDrawHide(apid,DriversListTDPl[apid][drv*2]);
	                        PlayerTextDrawColor(apid,DriversListTDPl[apid][drv*2],-1);
	                        PlayerTextDrawSetString(apid,DriversListTDPl[apid][2],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
	                        PlayerTextDrawShow(apid,DriversListTDPl[apid][drv*2]);
	                        PlayerTextDrawSetString(apid,DriversListTDPl[apid][drv*2+1],"DNF");
						}
					}
				    ClearEventAndJoin(RaceStartZone[playerid],JoinedJNum[playerid]);
				    format(str,64,"EI[%d][Timer]",RaceStartZone[playerid]);
					KillTimer(GetGVarInt(str,JoinedJNum[playerid]));
				}
				else UpdatePlaceTDForEvent(RaceStartZone[playerid],JoinedJNum[playerid]);
			}
		}
		else
		{
		    for(new i = 0; i < drv; i++)
		    {
		        format(str,64,"EI[%d][ID][%d]",RaceStartZone[playerid],i);
		        apid = GetGVarInt(str,JoinedJNum[playerid]);
		        if(apid == playerid)
		        {
		            for(new t = i; t < drv-1; t++)
					{
					    format(str1,64,"EI[%d][ID][%d]",RaceStartZone[playerid],t);
					    format(str,64,"EI[%d][ID][%d]",RaceStartZone[playerid],t+1);
					    SetGVarInt(str1,GetGVarInt(str,JoinedJNum[playerid]),JoinedJNum[playerid]);
					}
				}
			}
			format(str,64,"EI[%d][DriversNum]",RaceStartZone[playerid]);
			SetGVarInt(str,drv-1,JoinedJNum[playerid]);
			drv--;
            if(drv < 2)
            {
                format(str,64,"EI[%d][ID][0]",RaceStartZone[playerid]);
                apid = GetGVarInt(str,JoinedJNum[playerid]);
				if(RaceStartZone[apid] == RaceStartZone[playerid] && JoinedJNum[apid] == JoinedJNum[playerid])
				{
    				RaceStartZone[apid] = -1;
        			JoinedJNum[apid] = -1;
           			InRace[apid] = false;
              		JoinedInRace[apid] = false;
                	SendClientMessage(apid,Colour_Yellow,"Race was aborted. All players leaved race.");
	                if(Audio_IsClientConnected(apid))
					{
						Audio_Play(apid,20,false,false,false);
						new for_rand[2] = {2,3};
						FreeroamHandle[apid] = Audio_Play(apid,for_rand[random(2)],false,false,false);
					}
	                for(new i = 0; i < 8; i++) TextDrawHideForPlayer(apid,CDTD[i]);
	                TextDrawHideForPlayer(apid,Lines[1]);
	                if(WrongWay[apid])
					{
						HidePlayerBrick(apid);
						WrongWay[apid] = false;
    				}
	                ShowTreasureTDs(apid);
	                ShowBonuses(apid);
	                ShowSpeedometre(apid);
	                TogglePlayerControllable(apid,true);
	                SetVehicleVirtualWorld(PlayerInfo[apid][pVehID],MAX_PLAYERS+1),SetPlayerVirtualWorld(apid,MAX_PLAYERS+1);
	                ClearEventAndJoin(RaceStartZone[playerid],JoinedJNum[playerid]);
	                format(str,64,"EI[%d][Timer]",RaceStartZone[playerid]);
					KillTimer(GetGVarInt(str,JoinedJNum[playerid]));
		                //Destroy Non-started Race (It is created, countdown is active)
						//Restore Player with ID stored in EI[rid][ID][0]
						//Hide Textdraw with countdown (use current time of countdown to hide right TD)
				}
			}
		}
	}
	if(LookingFinishList[playerid]||LookingRep[playerid])
	{
	    PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]] += RewardInfo[playerid][Money];
	    PlayerInfo[playerid][pExp][PlayerInfo[playerid][pSelectedDriver]] += RewardInfo[playerid][Reputation];
	    if(PlayerInfo[playerid][pExp][PlayerInfo[playerid][pSelectedDriver]] >= 500*(PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]+1)*PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]) PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]++;
	    SaveDriver(playerid);
	}
	if(LookTreasureReward[playerid])
	{
	    PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]] += RewardInfo[playerid][Money];
	    PlayerInfo[playerid][pExp][PlayerInfo[playerid][pSelectedDriver]] += RewardInfo[playerid][Reputation];
	    if(PlayerInfo[playerid][pExp][PlayerInfo[playerid][pSelectedDriver]] >= 500*(PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]+1)*PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]) PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]++;
	    SaveDriver(playerid);
	    new str[128];
		format(str,128,"UPDATE drivers SET treasparams='%d|15|1' WHERE drivername='%s'",PlayerInfo[playerid][pTreasureDays],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
		mysql_query(str);
	}
	if(APCheckTimer[playerid] != -1) KillTimer(APCheckTimer[playerid]);
	if(JoinTimer[playerid] != -1) KillTimer(JoinTimer[playerid]);
	if(Logged[playerid])
	{
	    new str[128];
	    format(str,128,"UPDATE emails SET used=0 WHERE email='%s'",PlayerInfo[playerid][pEmail]);
		mysql_query(str);
	}
	if(TreasureTimer[playerid] != -1) KillTimer(TreasureTimer[playerid]);
	if(PlayerInfo[playerid][trCollected] != 15)
	{
	    for(new i = 0; i < 15-PlayerInfo[playerid][trCollected]; i++)
	    {
	        DestroyDynamicMapIcon(PlayerInfo[playerid][trIcon][i]);
			DestroyDynamicObject(PlayerInfo[playerid][trObj][i*2]);
			DestroyDynamicObject(PlayerInfo[playerid][trObj][i*2+1]);
			DestroyDynamicArea(PlayerInfo[playerid][trArea][i]);
		}
	}
	if(InGame[playerid])
	{
	    new str[128];
	    format(str,128,"UPDATE drivers SET bonuses='%d|%d|%d' WHERE drivername='%s'",PlayerInfo[playerid][iNitro],PlayerInfo[playerid][iRam],PlayerInfo[playerid][iReady],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
	    mysql_query(str);
	    if(PlayerInfo[playerid][pChatRoom] != -1) Iter_Remove(ChatRoom[PlayerInfo[playerid][pChatRoom]],playerid);
	}
	if(FlipTimer[playerid] != -1) KillTimer(FlipTimer[playerid]);
	if(CheckVehDeathTimer[playerid] != -1) KillTimer(CheckVehDeathTimer[playerid]);
	if(KickTimer[playerid] != -1) KillTimer(KickTimer[playerid]);
	return 1;
}

public OnPlayerRequestClass(playerid,classid)
{
    TogglePlayerSpectating(playerid,true);
    SetPlayerTime(playerid,0,0);
    if(!HasValidVersion[playerid])
    {
		Kick(playerid);
		return 1;
	}
    APCheckTimer[playerid] = SetTimerEx("CheckForAP",20000,false,"d",playerid);
	return 1;
}

public OnPlayerCommandText(playerid,cmdtext[])
{
	new cmd[32],params[96];
	sscanf(cmdtext,"s[32]s[96]",cmd,params);
	if(!strcmp(cmd,"/changeroom",true))
	{
	    if(!InGame[playerid]) return 1;
	    if(PlayerInfo[playerid][pChatRoom] == -1) return SendClientMessage(playerid,Colour_Red,"[*] You are muted. Can't use the command.");
	    if(strlen(params) <= 0) return SendClientMessage(playerid,Colour_Yellow,"*/changeroom (RU/EN)");
	    if(!strcmp(params,"GLOBAL",true))
	    {
	        if(PlayerInfo[playerid][pChatRoom] == CHAT_GLOBAL) return SendClientMessage(playerid,Colour_Yellow,"* Room hasn't been changed.");
	        Iter_Remove(ChatRoom[PlayerInfo[playerid][pChatRoom]],playerid);
	        Iter_Add(ChatRoom[CHAT_GLOBAL],playerid);
	        PlayerInfo[playerid][pChatRoom] = CHAT_GLOBAL;
	        format(params,96,"* Room has been changed to Global. %d player(s) in room.",Iter_Count(ChatRoom[CHAT_GLOBAL])-1);
	        SendClientMessage(playerid,Colour_Green,params);
	        return 1;
		}
		if(!strcmp(params,"RU",true))
	    {
	        if(PlayerInfo[playerid][pChatRoom] == CHAT_RU) return SendClientMessage(playerid,Colour_Yellow,"* Room hasn't been changed.");
	        Iter_Remove(ChatRoom[PlayerInfo[playerid][pChatRoom]],playerid);
	        Iter_Add(ChatRoom[CHAT_RU],playerid);
	        PlayerInfo[playerid][pChatRoom] = CHAT_RU;
	        format(params,96,"* Room has been changed to Russian. %d player(s) in room.",Iter_Count(ChatRoom[CHAT_RU])-1);
	        SendClientMessage(playerid,Colour_Green,params);
	        return 1;
		}
		if(!strcmp(params,"EN",true))
	    {
	        if(PlayerInfo[playerid][pChatRoom] == CHAT_EN) return SendClientMessage(playerid,Colour_Yellow,"* Room hasn't been changed.");
	        Iter_Remove(ChatRoom[PlayerInfo[playerid][pChatRoom]],playerid);
	        Iter_Add(ChatRoom[CHAT_EN],playerid);
	        PlayerInfo[playerid][pChatRoom] = CHAT_EN;
	        format(params,96,"* Room has been changed to English. %d player(s) in room.",Iter_Count(ChatRoom[CHAT_EN])-1);
	        SendClientMessage(playerid,Colour_Green,params);
	        return 1;
		}
		if(!strcmp(params,"DE",true))
	    {
	        if(PlayerInfo[playerid][pChatRoom] == CHAT_DE) return SendClientMessage(playerid,Colour_Yellow,"* Room hasn't been changed.");
	        Iter_Remove(ChatRoom[PlayerInfo[playerid][pChatRoom]],playerid);
	        Iter_Add(ChatRoom[CHAT_DE],playerid);
	        PlayerInfo[playerid][pChatRoom] = CHAT_DE;
	        format(params,96,"* Room has been changed to German. %d player(s) in room.",Iter_Count(ChatRoom[CHAT_DE])-1);
	        SendClientMessage(playerid,Colour_Green,params);
	        return 1;
		}
		if(!strcmp(params,"DEV",true))
		{
			if(!strcmp(DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]],"SDraw",false)||!strcmp(DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]],"FrostLee",false))
			{
			    if(PlayerInfo[playerid][pChatRoom] == CHAT_DEV) return SendClientMessage(playerid,Colour_Yellow,"* Room hasn't been changed.");
		        Iter_Remove(ChatRoom[PlayerInfo[playerid][pChatRoom]],playerid);
		        Iter_Add(ChatRoom[CHAT_DEV],playerid);
		        PlayerInfo[playerid][pChatRoom] = CHAT_DEV;
		        format(params,96,"* Room has been changed to DEV. %d player(s) in room.",Iter_Count(ChatRoom[CHAT_DEV])-1);
	        	SendClientMessage(playerid,Colour_Green,params);
			}
			else SendClientMessage(playerid,Colour_Red,"[*] You can't enter in developers' chatroom.");
			return 1;
		}
		SendClientMessage(playerid,Colour_Yellow,"*/changeroom (GLOBAL/RU/EN/DE)");
		return 1;
	}
	if(!strcmp(cmd,"/about",true))
	{
	    SendClientMessage(playerid,Colour_LightGreen,"[*] Need For Speed World [SA-MP]");
	    SendClientMessage(playerid,Colour_LightGreen,"[*] Author: SDraw. Alpha tester: FrostLee");
	    SendClientMessage(playerid,Colour_LightGreen,"[*] Effects and music are copyrighted and belonged to EA");
		return 1;
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid,newkeys,oldkeys)
{
	if(newkeys == KEY_SPRINT)
	{
	    if(EnterInServer[playerid])
	    {
	        EnterInServer[playerid] = false;
	        RegOrLog[playerid] = true;
			if(Audio_IsClientConnected(playerid)) EffectHandle[playerid] = Audio_Play(playerid,16,false,false,false);
	        for(new i = 0; i < sizeof(WelcomeTDs); i++) TextDrawHideForPlayer(playerid,WelcomeTDs[i]);
	        for(new i = 0; i < 5; i++) TextDrawShowForPlayer(playerid,RegLog[i]);
			for(new i = 0; i < 2; i++) TextDrawShowForPlayer(playerid,Lines[i]);
			SelectTextDraw(playerid,0x73B1EDFF);
		}
		return 1;
	}
	if(newkeys & KEY_YES)
	{
	    if(RaceStartZone[playerid] != -1)
	    {
	        if(IsPlayerInDynamicArea(playerid,RaceStartZone[playerid]+1))
	        {
	            if(JoinedJNum[playerid] == -1)
	            {
	                new str[64];
		            for(new i = 0; i < MAX_JOINS; i++)
		            {
						if(AvaliableEvents[RaceStartZone[playerid]][i])
			            {
			                format(str,64,"QI[%d][Created]",RaceStartZone[playerid]);
			                if(GetGVarInt(str,i) == 0)
			                {
	        					CancelSeconds[playerid] = 10;
						        JoinedJNum[playerid] = i;
						        JoinTimer[playerid] = SetTimerEx("WaitJoin",1000,true,"d",playerid);
						        PlayerTextDrawSetString(playerid,RaceTDPl[playerid][2],"Cancel in 0:10");
						        PlayerTextDrawShow(playerid,RaceTDPl[playerid][2]);
								for(new t = 8; t < 10; t++) TextDrawHideForPlayer(playerid,RaceTD[t]);
								for(new t = 14; t < 16; t++) TextDrawShowForPlayer(playerid,RaceTD[t]);
								return 1;
							}
			                if(GetGVarInt(str,i) == 1)
			                {
			                    format(str,64,"QI[%d][UntilStart]",RaceStartZone[playerid]);
			                    if(GetGVarInt(str,i) > 20)
			                    {
                       				format(str,64,"QI[%d][DriversNum]",RaceStartZone[playerid]);
                           			if(GetGVarInt(str,i) != RaceInfo[RaceStartZone[playerid]][MaxDrivers])
		                            {
						                    //Founded existed race, wait for join
			                    		CancelSeconds[playerid] = 10;
      									JoinedJNum[playerid] = i;
							        	JoinTimer[playerid] = SetTimerEx("WaitJoin",1000,true,"d",playerid);
										PlayerTextDrawSetString(playerid,RaceTDPl[playerid][2],"Cancel in 0:10");
										PlayerTextDrawShow(playerid,RaceTDPl[playerid][2]);
										for(new t = 8; t < 10; t++) TextDrawHideForPlayer(playerid,RaceTD[t]);
										for(new t = 14; t < 16; t++) TextDrawShowForPlayer(playerid,RaceTD[t]);
										return 1;
									}
									else continue;
								}
								else continue;
							}
						}
					}
				}
				else
				{
				    if(!JoinedInRace[playerid] && JoinTimer[playerid] != -1)
				    {
					    new str[64],drv,apid;
					    KillTimer(JoinTimer[playerid]);
					    JoinTimer[playerid] = -1;
					    JoinedInRace[playerid] = true;
					    CancelSeconds[playerid] = 0;
						format(str,64,"QI[%d][Created]",RaceStartZone[playerid]);
					    if(GetGVarInt(str,JoinedJNum[playerid]) == 0) SetGVarInt(str,1,JoinedJNum[playerid]);
						format(str,64,"QI[%d][DriversNum]",RaceStartZone[playerid]);
						drv = GetGVarInt(str,JoinedJNum[playerid]);
						if(drv >= RaceInfo[RaceStartZone[playerid]][MaxDrivers])
						{
		            		for(new i = 0; i < MAX_JOINS; i++)
		            		{
								if(AvaliableEvents[RaceStartZone[playerid]][i])
			            		{
			            		    format(str,64,"QI[%d][Created]",RaceStartZone[playerid]);
					                if(GetGVarInt(str,i) == 0)
									{
										JoinedJNum[playerid] = i;
										SetGVarInt(str,1,i);
										break;
									}
					                else if(GetGVarInt(str,i) == 1)
					                {
					                    format(str,64,"QI[%d][UntilStart]",RaceStartZone[playerid]);
					                    if(GetGVarInt(str,i) > 20)
					                    {
		                       				format(str,64,"QI[%d][DriversNum]",RaceStartZone[playerid]);
		                           			if(GetGVarInt(str,i) != RaceInfo[RaceStartZone[playerid]][MaxDrivers])
				                            {
		      									JoinedJNum[playerid] = i;
												break;
											}
											else continue;
										}
										else continue;
									}
								}
							}
                            format(str,64,"QI[%d][DriversNum]",RaceStartZone[playerid]);
							drv = GetGVarInt(str,JoinedJNum[playerid]);
						}
						drv++;
						if(drv == 0) drv = 1;
						SetGVarInt(str,drv,JoinedJNum[playerid]);
						if(drv == 1)
						{
						    format(str,64,"QI[%d][UntilStart]",RaceStartZone[playerid]);
							SetGVarInt(str,60,JoinedJNum[playerid]);
							format(str,64,"QI[%d][Timer]",RaceStartZone[playerid]);
							SetGVarInt(str,SetTimerEx("StartCountDown",1000,true,"dd",RaceStartZone[playerid],JoinedJNum[playerid]),JoinedJNum[playerid]);
						}
						format(str,64,"QI[%d][ID][%d]",RaceStartZone[playerid],drv-1);
						SetGVarInt(str,playerid,JoinedJNum[playerid]);
						//TD work
						HideBonuses(playerid);
						HideSpeedometre(playerid);
						PlayerTextDrawColor(playerid,DriversListTDPl[playerid][0],-1);
					    PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][0],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
					    PlayerTextDrawShow(playerid,DriversListTDPl[playerid][0]);
					    format(str,32,"] level %d",PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]);
					    PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][1],str);
					    PlayerTextDrawShow(playerid,DriversListTDPl[playerid][1]);
					    for(new i = 0; i < 18; i++) TextDrawShowForPlayer(playerid,DriversListTD[i]);
						for(new i = 26; i < 30; i++) TextDrawShowForPlayer(playerid,DriversListTD[i]);
	                    for(new i = 0; i < drv-1; i++)
						{
      						format(str,64,"QI[%d][ID][%d]",RaceStartZone[playerid],i);
		        			apid = GetGVarInt(str,JoinedJNum[playerid]);
					        format(str,32,"] level %d",PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]);
					        PlayerTextDrawHide(apid,DriversListTDPl[apid][(drv-1)*2]);
 							PlayerTextDrawColor(apid,DriversListTDPl[apid][(drv-1)*2],-1);
				    		PlayerTextDrawShow(apid,DriversListTDPl[apid][(drv-1)*2]);
						    PlayerTextDrawSetString(apid,DriversListTDPl[apid][(drv-1)*2],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
						    PlayerTextDrawSetString(apid,DriversListTDPl[apid][(drv-1)*2+1],str);
						    PlayerTextDrawColor(playerid,DriversListTDPl[playerid][(i+1)*2],-1);
						    PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][(i+1)*2],DriverName[apid][PlayerInfo[apid][pSelectedDriver]]);
						    format(str,32,"] level %d",PlayerInfo[apid][pLevel][PlayerInfo[apid][pSelectedDriver]]);
						    PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][(i+1)*2+1],str);
						}
						for(new i = 0; i < 16; i++) TextDrawHideForPlayer(playerid,RaceTD[i]);
						for(new i = 0; i < 3; i++)
						{
							PlayerTextDrawHide(playerid,RaceTDPl[playerid][i]);
							PlayerTextDrawHide(playerid,MainLineStructPl[playerid][i]);
						}
						//TextDrawShowForPlayer(playerid,QI[jid][CountTD]);
						PlayerTextDrawHide(playerid,EventTDPl[playerid][2]);
						for(new i = 0; i < 16; i++) PlayerTextDrawShow(playerid,DriversListTDPl[playerid][i]);
						HideSpeedometre(playerid);
						for(new i = 0; i < 4; i++) TextDrawHideForPlayer(playerid,MainLineStruct[i]);
						TextDrawShowForPlayer(playerid,DriversListTD[18]);
						TextDrawShowForPlayer(playerid,Lines[1]);
						PlayerTextDrawHide(playerid,MoneyInd[playerid]);
						PlayerTextDrawShow(playerid,EventTDPl[playerid][2]);
						HideTreasureTDs(playerid);
						SetPlayerTime(playerid,0,0);
						GetVehiclePos(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][pPosInWorld][0],PlayerInfo[playerid][pPosInWorld][1],PlayerInfo[playerid][pPosInWorld][2]);
						GetVehicleZAngle(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][pPosInWorld][3]);
						SetVehiclePos(PlayerInfo[playerid][pVehID],EventXByPos[drv-1],-185.5920,14.0179);
						SetVehicleZAngle(PlayerInfo[playerid][pVehID],0.0);
						SetPlayerCameraPos(playerid,EventXByPos[drv-1]-6.778739,-179.429,16.9705);
						SetPlayerCameraLookAt(playerid,EventXByPos[drv-1],-185.5920,14.0179);
						SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],JOIN_WORLD+MAX_JOINS*RaceStartZone[playerid]+JoinedJNum[playerid]),SetPlayerVirtualWorld(playerid,JOIN_WORLD+MAX_JOINS*RaceStartZone[playerid]+JoinedJNum[playerid]);
						LinkVehicleToInterior(PlayerInfo[playerid][pVehID],1),SetPlayerInterior(playerid,1);
						Streamer_UpdateEx(playerid,EventXByPos[drv-1],-185.5920,14.0179,1000+MAX_JOINS*RaceStartZone[playerid]+JoinedJNum[playerid],1);
						SelectTextDraw(playerid,0x73B1EDFF);
						 //player press Y when time hasn't left
					 	return 1;
					}
				}
			}
		}
	}
	if(newkeys & KEY_NO)
	{
	    if(JoinTimer[playerid] != -1)
	    {
	        KillTimer(JoinTimer[playerid]);
	    	JoinTimer[playerid] = -1;
		    CancelSeconds[playerid] = 0;
			JoinedJNum[playerid] = -1;
			for(new i = 14; i < 16; i++) TextDrawHideForPlayer(playerid,RaceTD[i]);
			for(new i = 8; i < 10; i++) TextDrawShowForPlayer(playerid,RaceTD[i]);
			PlayerTextDrawHide(playerid,RaceTDPl[playerid][2]);
			return 1;
		}
	}
	if(newkeys & KEY_ANALOG_UP)
	{
	    if(InGame[playerid])
	    {
		    if(PlayerInfo[playerid][iNitro] == 0) return 1;
		    if(JoinedInRace[playerid]) return 1;
			if(!CanUseNitroItem[playerid]) return 1;
			if(GetVehicleComponentInSlot(PlayerInfo[playerid][pVehID],CARMODTYPE_NITRO) == 1010) return 1;
			CanUseNitroItem[playerid] = false;
			PlayerInfo[playerid][iNitro]--;
			new str[12];
			format(str,12,"%d",PlayerInfo[playerid][iNitro]);
			PlayerTextDrawSetString(playerid,BonusesPl[playerid][1],str);
			PlayerTextDrawHide(playerid,BonusesPl[playerid][0]);
			PlayerTextDrawColor(playerid,BonusesPl[playerid][0],0x00000055);
			PlayerTextDrawShow(playerid,BonusesPl[playerid][0]);
			if(PlayerInfo[playerid][tReady] == -1) RestoreReadyItem(playerid);
			AddVehicleComponent(PlayerInfo[playerid][pVehID],1010);
			SetTimerEx("RemoveNitro",10000,false,"d",playerid);
			PlayerInfo[playerid][tNitro] = SetTimerEx("RestoreNitroItem",25000,false,"d",playerid);
			return 1;
		}
	}
	if(newkeys & KEY_ANALOG_RIGHT)
	{
	    if(InGame[playerid])
	    {
	        if(PlayerInfo[playerid][iRam] == 0) return 1;
	        if(JoinedInRace[playerid]) return 1;
			if(!CanUseRamItem[playerid]) return 1;
			if(RamObject[PlayerInfo[playerid][pVehID]] != INVALID_OBJECT_ID) return 1;
			CanUseRamItem[playerid] = false;
			PlayerInfo[playerid][iRam]--;
			new str[12];
			format(str,12,"%d",PlayerInfo[playerid][iRam]);
			PlayerTextDrawSetString(playerid,BonusesPl[playerid][3],str);
			PlayerTextDrawHide(playerid,BonusesPl[playerid][2]);
			PlayerTextDrawColor(playerid,BonusesPl[playerid][2],0x00000055);
			PlayerTextDrawShow(playerid,BonusesPl[playerid][2]);
			if(PlayerInfo[playerid][tReady] == -1) RestoreReadyItem(playerid);
			new Float:p[3],Float:p2[3];
			RamObject[PlayerInfo[playerid][pVehID]] = CreateDynamicObject(19467,0,0,0,0,0,0,GetPlayerVirtualWorld(playerid),0,-1,300.0);
            GetVehicleModelInfo(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],VEHICLE_MODEL_INFO_SIZE,p[0],p[1],p[2]);
            GetVehicleModelInfo(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],VEHICLE_MODEL_INFO_FRONT_BUMPER_Z,p2[0],p2[1],p2[2]);
            AttachDynamicObjectToVehicle(RamObject[PlayerInfo[playerid][pVehID]],PlayerInfo[playerid][pVehID],0.0,p[1]/2+0.25,p2[2]-0.2,294.0,0,0);
            SetTimerEx("RemoveRam",10000,false,"d",playerid);
            PlayerInfo[playerid][tRam] = SetTimerEx("RestoreRamItem",25000,false,"d",playerid);
            if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,4,false,false,false);
            return 1;
		}
	}
	if(newkeys & KEY_ANALOG_DOWN)
	{
	    if(InGame[playerid])
	    {
			if(PlayerInfo[playerid][iReady] == 0) return 1;
			if(JoinedInRace[playerid]) return 1;
			if(!CanUseReadyItem[playerid]) return 1;
			CanUseReadyItem[playerid] = false;
			PlayerInfo[playerid][iReady]--;
			new str[12];
			format(str,12,"%d",PlayerInfo[playerid][iReady]);
			PlayerTextDrawSetString(playerid,BonusesPl[playerid][5],str);
			PlayerTextDrawHide(playerid,BonusesPl[playerid][4]);
			PlayerTextDrawColor(playerid,BonusesPl[playerid][4],0x00000055);
			PlayerTextDrawShow(playerid,BonusesPl[playerid][4]);
			if(PlayerInfo[playerid][tNitro] != -1)
			{
				KillTimer(PlayerInfo[playerid][tNitro]);
				RestoreNitroItem(playerid);
			}
			if(PlayerInfo[playerid][tRam] != -1)
			{
				KillTimer(PlayerInfo[playerid][tRam]);
				RestoreRamItem(playerid);
			}
			PlayerInfo[playerid][tReady] = SetTimerEx("RestoreReadyItem",30000,false,"d",playerid);
			if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,5,false,false,false);
			return 1;
		}
	}
	if(newkeys & KEY_SUBMISSION)
	{
	    if(InGame[playerid] && JoinedJNum[playerid] == -1 && !InRace[playerid] && !LookingFinishList[playerid] && !LookingRep[playerid] && !LookTreasureReward[playerid])
	    {
	        SafeHouseState[playerid] = SAFEHOUSE_STATE_MAIN;
	        SetPlayerTime(playerid,0,0);
	        GetVehiclePos(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][pPosInWorld][0],PlayerInfo[playerid][pPosInWorld][1],PlayerInfo[playerid][pPosInWorld][2]);
			GetVehicleZAngle(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][pPosInWorld][3]);
	        TogglePlayerSpectating(playerid,true);
			SetPlayerVirtualWorld(playerid,playerid+1);
			if(GetGVarInt("dead",PlayerInfo[playerid][pVehID]) == 1)
			{
				SetVehicleToRespawn(PlayerInfo[playerid][pVehID]);
				SetVehicleTunning(playerid,PlayerInfo[playerid][pVehID]);
				SetGVarInt("dead",0,PlayerInfo[playerid][pVehID]);
			}
			else SetVehiclePos(PlayerInfo[playerid][pVehID],1925.5848,-2214.4021,14.0700);
			SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
			SetVehicleZAngle(PlayerInfo[playerid][pVehID],180.0);
			RepairVehicle(PlayerInfo[playerid][pVehID]);
			if(GetGVarType("3did",PlayerInfo[playerid][pVehID]) != GLOBAL_VARTYPE_NONE)
			{
				new t3d = GetGVarInt("3did",PlayerInfo[playerid][pVehID]);
				DeleteGVar("3did",PlayerInfo[playerid][pVehID]);
				if(IsValidDynamic3DTextLabel(Text3D:t3d)) DestroyDynamic3DTextLabel(Text3D:t3d);
			}
			Streamer_UpdateEx(playerid,SAFEHOUSE_CAMERA_MAIN,playerid,-1);
			HideSpeedometre(playerid);
			HideBonuses(playerid);
			if(Audio_IsClientConnected(playerid))
			{
			    if(FreeroamHandle[playerid] != -1) Audio_Stop(playerid,FreeroamHandle[playerid]);
				SafehouseHandle[playerid] = Audio_Play(playerid,21,false,true,false);
			}
			HideTreasureTDs(playerid);
			TextDrawShowForPlayer(playerid,Lines[1]);
			for(new i = 0; i < 3; i++) PlayerTextDrawHide(playerid,MainLineStructPl[playerid][i]);
			for(new i = 0; i < 4; i++) TextDrawHideForPlayer(playerid,MainLineStruct[i]);
			for(new i = 0; i < 24; i++) TextDrawShowForPlayer(playerid,SafehouseTD[i]);
			SelectTextDraw(playerid,0x73B1EDFF);
			SetTimerEx("ForcePlayerCameraSafehouse",250+GetPlayerPing(playerid),false,"d",playerid);
			return 1;
	    }
	}
	if(newkeys & KEY_CTRL_BACK)
	{
	    if(CanFlip[playerid])
	    {
	        if(!InGame[playerid]||LookingFinishList[playerid]||LookingRep[playerid]||JoinedInRace[playerid]||SafeHouseState[playerid] != SAFEHOUSE_STATE_NONE||LookTreasureReward[playerid]) return 1;
	        new Float:z;
	        GetVehicleZAngle(PlayerInfo[playerid][pVehID],z);
	        SetVehicleZAngle(PlayerInfo[playerid][pVehID],z);
	        CanFlip[playerid] = false;
	        FlipTimer[playerid] = SetTimerEx("RestoreFlip",10000,false,"d",playerid);
	        return 1;
		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_REG_LOG)
	{
	    if(response)
	    {
			if(strlen(inputtext) <= 0) return ShowPlayerDialog(playerid,DIALOG_REG_LOG,DIALOG_STYLE_INPUT," ","Invalid E-mail was entered.\nEnter valid E-mail.","Enter","Cancel");
			if(strlen(inputtext) > 63) return ShowPlayerDialog(playerid,DIALOG_REG_LOG,DIALOG_STYLE_INPUT," ","E-mail is too long.\nTry again.","Enter","Cancel");
	        new str[256];
	        format(str,64,inputtext);
	        if(!CheckEmail(str,strlen(str))) return ShowPlayerDialog(playerid,DIALOG_REG_LOG,DIALOG_STYLE_INPUT," ","Invalid E-mail was entered.\nEnter valid E-mail.","Enter","Cancel");
			format(PlayerInfo[playerid][pEmail],64,str);
			mysql_real_escape_string(PlayerInfo[playerid][pEmail],PlayerInfo[playerid][pEmail]);
	        format(str,256,"SELECT * FROM emails WHERE email='%s' LIMIT 1",str);
	        mysql_query(str);
			mysql_store_result();
	        if(mysql_num_rows()) ShowPlayerDialog(playerid,DIALOG_REG_LOG,DIALOG_STYLE_INPUT," ","This E-mail is already registered. Use 'Login' instead, or enter another E-mail.","Enter","Cancel");
	        else ShowPlayerDialog(playerid,DIALOG_REG_PASS,DIALOG_STYLE_INPUT," ","Enter password for E-Mail.\nYou will be able to restore you password in any time.","Enter","Cancel");
	        mysql_free_result();
		}
		else
		{
		    for(new i = 0; i < 5; i++) TextDrawShowForPlayer(playerid,RegLog[i]);
			SelectTextDraw(playerid,0x73B1EDFF);
			format(PlayerInfo[playerid][pEmail],128,"");
			RegOrLog[playerid] = true;
		}
		return 1;
	}
	if(dialogid == DIALOG_REG_PASS)
	{
	    if(response)
	    {
	        if(strlen(inputtext) <= 0) return ShowPlayerDialog(playerid,DIALOG_REG_PASS,DIALOG_STYLE_INPUT," ","Entered password is empty/too long.\nEnter valid password.","Enter","Cancel");
	        new str[256];
			format(str,128,"SELECT * FROM emails WHERE email='%s'",PlayerInfo[playerid][pEmail]);
			mysql_query(str),mysql_store_result();
			if(mysql_num_rows() != 0)
			{
			    mysql_free_result();
				ShowPlayerDialog(playerid,DIALOG_REG_LOG,DIALOG_STYLE_INPUT," ","This E-mail is already registered. Use 'Login' instead, or enter another E-mail.","Enter","Cancel");
				return 1;
			}
			mysql_free_result();
			md5(str,inputtext,64);
            format(str,256,"INSERT INTO emails (email,password) VALUES('%s','%s')",PlayerInfo[playerid][pEmail],str);
            mysql_query(str);
            Logged[playerid] = true;
			for(new i = 0; i < 5; i++) TextDrawShowForPlayer(playerid,Tutorial[i]);
			SelectTextDraw(playerid,0x73B1EDFF);
			TutStep[playerid] = 1;
		}
		else
		{
		    for(new i = 0; i < 5; i++) TextDrawShowForPlayer(playerid,RegLog[i]);
			SelectTextDraw(playerid,0x73B1EDFF);
			format(PlayerInfo[playerid][pEmail],128,"");
			RegOrLog[playerid] = true;
		}
		return 1;
	}
	if(dialogid == DIALOG_LOG_LOG)
	{
	    if(response)
	    {
			if(strlen(inputtext) <= 0) return ShowPlayerDialog(playerid,DIALOG_LOG_LOG,DIALOG_STYLE_INPUT," ","Enter your registered E-mail","Enter","Cancel");
			if(strlen(inputtext) > 63) return ShowPlayerDialog(playerid,DIALOG_LOG_LOG,DIALOG_STYLE_INPUT," ","E-mail is too long.\nTry again.","Enter","Cancel");
			new str[256];
			format(str,64,inputtext);
			if(!CheckEmail(str,strlen(str))) return ShowPlayerDialog(playerid,DIALOG_LOG_LOG,DIALOG_STYLE_INPUT," ","Invalid E-mail.\nTry again.","Enter","Cancel");
			format(PlayerInfo[playerid][pEmail],64,inputtext);
			mysql_real_escape_string(PlayerInfo[playerid][pEmail],PlayerInfo[playerid][pEmail]);
			format(str,256,"SELECT * FROM emails WHERE email='%s' LIMIT 1",PlayerInfo[playerid][pEmail]);
			mysql_query(str);
			mysql_store_result();
			if(!mysql_num_rows())
			{
				ShowPlayerDialog(playerid,DIALOG_LOG_LOG,DIALOG_STYLE_INPUT," ","This E-mail doesn't exist.\nYou can register it or try another E-mail.","Ok","Cancel");
				mysql_free_result();
				return 1;
			}
			mysql_free_result();
            format(str,256,"SELECT used FROM emails WHERE email='%s'",PlayerInfo[playerid][pEmail]);
            mysql_query(str);
			mysql_store_result();
			mysql_fetch_row(str);
			mysql_free_result();
            if(strval(str) != 0) return ShowPlayerDialog(playerid,DIALOG_LOG_LOG,DIALOG_STYLE_INPUT," ","Current E-mail is being used in game.\nTry another E-mail.\nIf this is mistake, contact with administator.","Enter","Cancel");
			ShowPlayerDialog(playerid,DIALOG_LOG_PASS,DIALOG_STYLE_INPUT," ","Enter password of registered E-mail","Enter","Cancel");
		}
		else
		{
		    for(new i = 0; i < 5; i++) TextDrawShowForPlayer(playerid,RegLog[i]);
			SelectTextDraw(playerid,0x73B1EDFF);
			format(PlayerInfo[playerid][pEmail],128,"");
			RegOrLog[playerid] = true;
		}
		return 1;
	}
	if(dialogid == DIALOG_LOG_PASS)
	{
	    if(response)
	    {
	        if(strlen(inputtext) <= 0) return ShowPlayerDialog(playerid,DIALOG_LOG_PASS,DIALOG_STYLE_INPUT," ","You enter empty password/too long.\nTry again.","Enter","Cancel");
			new str[256],passch[128];
			format(str,256,"SELECT used FROM emails WHERE email='%s'",PlayerInfo[playerid][pEmail]);
            mysql_query(str);
			mysql_store_result();
			mysql_fetch_row(str);
			mysql_free_result();
            if(strval(str) != 0) return ShowPlayerDialog(playerid,DIALOG_LOG_LOG,DIALOG_STYLE_INPUT," ","Current E-mail is being used in game.\nTry another E-mail.\nIf this is mistake, contact with administator.","Enter","Cancel");
			format(str,128,"SELECT password FROM emails WHERE email='%s' LIMIT 1",PlayerInfo[playerid][pEmail]);
			mysql_query(str);
			mysql_store_result();
			mysql_fetch_row(str);
			mysql_free_result();
			md5(passch,inputtext,64);
			if(strcmp(str,passch,true) != 0) return ShowPlayerDialog(playerid,DIALOG_LOG_PASS,DIALOG_STYLE_INPUT," ","Wrong password for E-mail.\nTry again.","Enter","Cancel");
			format(str,256,"UPDATE emails SET used=1 WHERE email='%s'",PlayerInfo[playerid][pEmail]);
			mysql_query(str);
			Logged[playerid] = true;
			format(str,256,"SELECT driversnum FROM emails WHERE email='%s' LIMIT 1",PlayerInfo[playerid][pEmail]);
			mysql_query(str);
			mysql_store_result();
			mysql_fetch_row(str);
			mysql_free_result();
			PlayerInfo[playerid][pDriversNum] = strval(str);
			if(PlayerInfo[playerid][pDriversNum] == 0)
			{
			    TextDrawShowForPlayer(playerid,Tutorial[0]);
			    TextDrawShowForPlayer(playerid,Tutorial[4]);
	    		for(new i = 5; i < 8; i++) TextDrawShowForPlayer(playerid,Tutorial[i]);
	    		TutStep[playerid] = 2;
	    		SelectTextDraw(playerid,0x73B1EDFF);
			}
			else
			{
			    format(str,256,"SELECT drivers FROM emails WHERE email='%s' LIMIT 1",PlayerInfo[playerid][pEmail]);
			    mysql_query(str);
				mysql_store_result();
				mysql_fetch_row(str);
				mysql_free_result();
			    switch(PlayerInfo[playerid][pDriversNum])
				{
					case 1: sscanf(str,"s[32]",DriverName[playerid][0]);
			    	case 2: sscanf(str,"p<|>s[32]s[32]",DriverName[playerid][0],DriverName[playerid][1]);
			    	case 3: sscanf(str,"p<|>s[32]s[32]s[32]",DriverName[playerid][0],DriverName[playerid][1],DriverName[playerid][2]);
				}
			    for(new i = 1; i <= PlayerInfo[playerid][pDriversNum]; i++)
			    {
			        PlayerTextDrawSetString(playerid,DriverChooseTDPl[playerid][1+i],DriverName[playerid][i-1]);
					PlayerTextDrawSetSelectable(playerid,DriverChooseTDPl[playerid][1+i],true);
				}
			    for(new i = 0; i < PlayerInfo[playerid][pDriversNum]; i++)
			    {
			        format(str,256,"SELECT money,vehiclesnum,exp,level,actvehnum FROM drivers WHERE drivername='%s' LIMIT 1",DriverName[playerid][i]);
					mysql_query(str);
					mysql_store_result();
					mysql_fetch_row(str);
					mysql_free_result();
					sscanf(str,"p<|>ddddd",PlayerInfo[playerid][pMoney][i],PlayerInfo[playerid][pVehiclesNum][i],PlayerInfo[playerid][pExp][i],PlayerInfo[playerid][pLevel][i],PlayerInfo[playerid][pActiveVehNum][i]);
					if(PlayerInfo[playerid][pVehiclesNum][i] != 0)
					{
						format(str,256,"SELECT vehmodels FROM drivers WHERE drivername='%s' LIMIT 1",DriverName[playerid][i]);
						mysql_query(str);
						mysql_store_result();
						mysql_fetch_row(str);
						mysql_free_result();
					    if(PlayerInfo[playerid][pVehiclesNum][i] == 1) PlayerInfo[playerid][pVehModel][3*i] = strval(str);
					    if(PlayerInfo[playerid][pVehiclesNum][i] == 2) sscanf(str,"p<|>dd",PlayerInfo[playerid][pVehModel][3*i],PlayerInfo[playerid][pVehModel][3*i+1]);
					    if(PlayerInfo[playerid][pVehiclesNum][i] == 3) sscanf(str,"p<|>ddd",PlayerInfo[playerid][pVehModel][3*i],PlayerInfo[playerid][pVehModel][3*i+1],PlayerInfo[playerid][pVehModel][3*i+2]);
					}
				}
				SetPlayerVirtualWorld(playerid,playerid+1);
				if(PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]] != 0)
				{
				    PlayerInfo[playerid][pVehID] = CreateVehicle(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],1925.5848,-2214.4021,14.0700,179.8839,0,0,-1);
					SetGVarInt("ownerid",playerid,PlayerInfo[playerid][pVehID]);
				    SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
				    format(str,256,"SELECT vehparams%d FROM drivers WHERE drivername='%s' LIMIT 1",PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
			    	mysql_query(str);
					mysql_store_result();
					mysql_fetch_row(str);
					mysql_free_result();
			    	sscanf(str,"p<|>a<i>[16]",PlayerInfo[playerid][vParams]);
			    	SetVehicleTunning(playerid,PlayerInfo[playerid][pVehID]);
				    format(passch,48,VehicleName[PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]]-400]);
				}
				else format(passch,48,"No Vehicle");
				format(str,256,"SELECT bonuses FROM drivers WHERE drivername='%s'",DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
				mysql_query(str);
				mysql_store_result();
				mysql_fetch_row(str);
				mysql_free_result();
				sscanf(str,"p<|>ddd",PlayerInfo[playerid][iNitro],PlayerInfo[playerid][iRam],PlayerInfo[playerid][iReady]);
				new Float:flvl = PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]],Float:fexp = PlayerInfo[playerid][pExp][PlayerInfo[playerid][pSelectedDriver]];
				new Float:line = 1.28*((fexp-500*flvl*(flvl-1.0))/((500*(flvl+1.0)*flvl-500*flvl*(flvl-1.0))/100.0));
				PlayerTextDrawTextSize(playerid,DriverChooseTDPl[playerid][1],line+476.360198,2.5);
				format(str,128,"]level %d ~n~ %s ~n~ %s",PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]],passch);
				PlayerTextDrawSetString(playerid,DriverChooseTDPl[playerid][0],str);
				for(new i = 0; i < 11; i++) TextDrawShowForPlayer(playerid,DriverChooseTD[i]);
    			for(new i = 0; i < 5; i++) PlayerTextDrawShow(playerid,DriverChooseTDPl[playerid][i]);
			    SelectTextDraw(playerid,0x73B1EDFF);
 			}
		}
		else
		{
		    for(new i = 0; i < 5; i++) TextDrawShowForPlayer(playerid,RegLog[i]);
			SelectTextDraw(playerid,0x73B1EDFF);
			format(PlayerInfo[playerid][pEmail],128,"");
			RegOrLog[playerid] = true;
		}
		return 1;
	}
	if(dialogid == DIALOG_NEW_DRIVER_FR)
	{
	    if(response)
	    {
	        if(strlen(inputtext) <= 0) return ShowPlayerDialog(playerid,DIALOG_NEW_DRIVER_FR,DIALOG_STYLE_INPUT," ","You haven't entered name of your new driver.\nTry again.","Enter","Cancel");
	        if(strlen(inputtext) < 4) return ShowPlayerDialog(playerid,DIALOG_NEW_DRIVER_FR,DIALOG_STYLE_INPUT," ","Driver name is too short.\nTry again.","Enter","Cancel");
	        if(strlen(inputtext) > 12) return ShowPlayerDialog(playerid,DIALOG_NEW_DRIVER_FR,DIALOG_STYLE_INPUT," ","Driver name is too long.\nTry again.","Enter","Cancel");
	        new str[256],name[32];
	        format(str,13,inputtext);
	        if(!CheckDriverName(str,strlen(str))) return ShowPlayerDialog(playerid,DIALOG_NEW_DRIVER_FR,DIALOG_STYLE_INPUT," ","Driver's name can contain only English letters and numbers.\nSample: Driver01.","Enter","Cancel");
	        format(name,32,str);
			format(str,128,"SELECT * FROM drivers WHERE drivername='%s'",name);
			mysql_query(str);
			mysql_store_result();
			if(mysql_num_rows())
			{
				mysql_free_result();
				ShowPlayerDialog(playerid,DIALOG_NEW_DRIVER_FR,DIALOG_STYLE_INPUT," ","This Driver's name is already registered.\nTry another one.","Enter","Cancel");
				return 1;
			}
			mysql_free_result();
			PlayerInfo[playerid][pDriversNum]++;
			PlayerInfo[playerid][pSelectedDriver] = PlayerInfo[playerid][pDriversNum]-1;
			for(new i = 0; i < 15; i++) PlayerInfo[playerid][vParams][i] = 0;
			PlayerInfo[playerid][vParams][15] = -1;
			format(DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]],32,name);
			format(str,128,"INSERT INTO drivers (drivername) VALUE('%s')",DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
			mysql_query(str);
			switch(PlayerInfo[playerid][pDriversNum])
			{
				case 1: format(str,128,"UPDATE emails SET driversnum=%d, drivers='%s' WHERE email='%s'",PlayerInfo[playerid][pDriversNum],DriverName[playerid][0],PlayerInfo[playerid][pEmail]);
				case 2: format(str,256,"UPDATE emails SET driversnum=%d, drivers='%s|%s' WHERE email='%s'",PlayerInfo[playerid][pDriversNum],DriverName[playerid][0],DriverName[playerid][1],PlayerInfo[playerid][pEmail]);
				case 3: format(str,256,"UPDATE emails SET driversnum=%d, drivers='%s|%s|%s' WHERE email='%s'",PlayerInfo[playerid][pDriversNum],DriverName[playerid][0],DriverName[playerid][1],DriverName[playerid][2],PlayerInfo[playerid][pEmail]);
			}
			mysql_query(str);
			TutStep[playerid]++;
			TextDrawShowForPlayer(playerid,Tutorial[0]);
			TextDrawShowForPlayer(playerid,Tutorial[4]);
			for(new i = 8; i < 11; i++) TextDrawShowForPlayer(playerid,Tutorial[i]);
			SelectTextDraw(playerid,0x73B1EDFF);
		}
		else
		{
			if(PlayerInfo[playerid][pDriversNum] == 0) return Kick(playerid);
			new str[256];
			SetPlayerVirtualWorld(playerid,playerid+1);
			PlayerInfo[playerid][pSelectedDriver] = 0;
			for(new i = 0; i < 15; i++) PlayerInfo[playerid][vParams][i] = 0;
			PlayerInfo[playerid][vParams][15] = -1;
			if(PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]] != 0)
			{
			    format(str,256,"SELECT vehparams%d FROM drivers WHERE drivername='%s'",PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
			    mysql_query(str),mysql_store_result(),mysql_fetch_row(str),mysql_free_result();
			    sscanf(str,"p<|>a<i>[16]",PlayerInfo[playerid][vParams]);
   				PlayerInfo[playerid][pVehID] = CreateVehicle(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],1925.5848,-2214.4021,14.0700,179.8839,0,0,-1);
   				SetGVarInt("ownerid",playerid,PlayerInfo[playerid][pVehID]);
			    SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
			    SetVehicleTunning(playerid,PlayerInfo[playerid][pVehID]);
			}
			new Float:flvl = PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]],Float:fexp = PlayerInfo[playerid][pExp][PlayerInfo[playerid][pSelectedDriver]];
			new Float:line = 1.28*((fexp-500*flvl*(flvl-1.0))/((500*(flvl+1.0)*flvl-500*flvl*(flvl-1.0))/100.0));
			PlayerTextDrawTextSize(playerid,DriverChooseTDPl[playerid][1],line+476.360198,2.5);
			format(str,128,"]level %d ~n~ %s ~n~ %s",PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]],PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]]-400);
			PlayerTextDrawSetString(playerid,DriverChooseTDPl[playerid][0],str);
			for(new i = 0; i < 11; i++) TextDrawShowForPlayer(playerid,DriverChooseTD[i]);
			for(new i = 0; i < 5; i++) PlayerTextDrawShow(playerid,DriverChooseTDPl[playerid][i]);
   			SelectTextDraw(playerid,0x73B1EDFF);
		}
		return 1;
	}
	return 1;
}

public OnPlayerExitVehicle(playerid,vehicleid)
{
	if(vehicleid == PlayerInfo[playerid][pVehID])
	{
	    PutPlayerInVehicle(playerid,vehicleid,0);
	    return 0;
	}
	return 1;
}

public OnPlayerStateChange(playerid,newstate,oldstate)
{
	if(oldstate == PLAYER_STATE_DRIVER && PlayerInfo[playerid][pVehID] != INVALID_VEHICLE_ID && SafeHouseState[playerid] == SAFEHOUSE_STATE_NONE)
	{
		PutPlayerInVehicle(playerid,PlayerInfo[playerid][pVehID],0);
		CheckVehDeathTimer[playerid] = SetTimerEx("CheckForVehDeath",250+GetPlayerPing(playerid),false,"dd",playerid,PlayerInfo[playerid][pVehID]);
	}
	if(newstate == PLAYER_STATE_DRIVER) if(Audio_IsClientConnected(playerid)) Audio_StopRadio(playerid);
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(IsPlayerInVehicle(playerid,PlayerInfo[playerid][pVehID]))
	{
	    new Float:health;
	    GetVehicleHealth(PlayerInfo[playerid][pVehID],health);
	    if(health != 1000.0) SetVehicleHealth(PlayerInfo[playerid][pVehID],1000.0);
	    if(IsSpeedShown[playerid])
	    {
	        new Float:p[3],Float:sspeed,str[12],bar,vehar;
	        GetVehicleVelocity(PlayerInfo[playerid][pVehID],p[0],p[1],p[2]);
	        sspeed = 150*(p[0]*p[0]+p[1]*p[1]/*+p[2]*p[2]*/);
	        format(str,12,"%.0f",sspeed);
	        vehar = VehModelToArrayID(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]]);
	        if(sspeed >= VehiclesIndent[vehar][MSpeed]+40.0)
			{
			    if(CanBeKicked[playerid])
			    {
					SpeedKick[playerid]++;
					if(SpeedKick[playerid] == 3)
					{
					    Kick(playerid);
					    return 1;
					}
					else
					{
					    new kmes[32];
					    format(kmes,32,"[*] Speedhack. Warning %d/3.",SpeedKick[playerid]);
					    SendClientMessage(playerid,Colour_Red,kmes);
						SetVehicleVelocity(PlayerInfo[playerid][pVehID],0.0,0.0,p[2]);
						CanBeKicked[playerid] = false;
						SetTimerEx("RestoreKick",3000,false,"d",playerid);
					}
				}
			}
			PlayerTextDrawSetString(playerid,VHS[playerid][30],str);
			bar = floatround(sspeed/(VehiclesIndent[vehar][MSpeed]/30.0),floatround_round);
			if(bar > 30) bar = 30;
			if(bar != 0)
			{
			    IsSpeedBarShown[playerid][bar-1] = true;
			    PlayerTextDrawHide(playerid,VHS[playerid][bar-1]);
			    PlayerTextDrawBoxColor(playerid,VHS[playerid][bar-1],0x73B1EDFF);
			    PlayerTextDrawShow(playerid,VHS[playerid][bar-1]);
				for(new i = bar-2; i != -1; i--)
				{
	   				if(IsSpeedBarShown[playerid][i]) break;
				    IsSpeedBarShown[playerid][i] = true;
				    PlayerTextDrawHide(playerid,VHS[playerid][i]);
				    PlayerTextDrawBoxColor(playerid,VHS[playerid][i],0x73B1EDFF);
				    PlayerTextDrawShow(playerid,VHS[playerid][i]);
				}
				for(new i = bar; i < 30; i++)
				{
	   				if(!IsSpeedBarShown[playerid][i]) break;
	   				IsSpeedBarShown[playerid][i] = false;
	   				PlayerTextDrawHide(playerid,VHS[playerid][i]);
	   				PlayerTextDrawBoxColor(playerid,VHS[playerid][i],102);
	   				PlayerTextDrawShow(playerid,VHS[playerid][i]);
				}
			}
			else
			{
			    IsSpeedBarShown[playerid][0] = false;
			    PlayerTextDrawHide(playerid,VHS[playerid][0]);
   				PlayerTextDrawBoxColor(playerid,VHS[playerid][0],102);
   				PlayerTextDrawShow(playerid,VHS[playerid][0]);
   				for(new i = 1; i < 30; i++)
			    {
			        if(!IsSpeedBarShown[playerid][i]) break;
	   				IsSpeedBarShown[playerid][i] = false;
	   				PlayerTextDrawHide(playerid,VHS[playerid][i]);
	   				PlayerTextDrawBoxColor(playerid,VHS[playerid][i],102);
	   				PlayerTextDrawShow(playerid,VHS[playerid][i]);
				}
			}
		}
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && !IsPlayerInVehicle(playerid,PlayerInfo[playerid][pVehID]))
	{
	    new veh = GetPlayerVehicleID(playerid);
		new apid = GetGVarInt("ownerid",veh);
	    Kick(playerid);
	    if(GetPlayerState(apid) != PLAYER_STATE_SPECTATING) PutPlayerInVehicle(apid,veh,0);
	}
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == Text:INVALID_TEXT_DRAW)
	{
		if(JoinedInRace[playerid])
		{
		    new str[64];
		    format(str,64,"QI[%d][Locked]",RaceStartZone[playerid]);
		    if(GetGVarInt(str,JoinedJNum[playerid]) == 0) SelectTextDraw(playerid,0x73B1EDFF);
		}
		if(LookingFinishList[playerid]||LookingRep[playerid]||SafeHouseState[playerid] != SAFEHOUSE_STATE_NONE||LookTreasureReward[playerid]||RegOrLog[playerid]) SelectTextDraw(playerid,0x73B1EDFF);
		return 1;
	}
	if(clickedid == RegLog[3])
	{
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,18,false,false,false);
	    for(new i = 0; i < 5; i++) TextDrawHideForPlayer(playerid,RegLog[i]);
	    CancelSelectTextDraw(playerid);
		ShowPlayerDialog(playerid,DIALOG_LOG_LOG,DIALOG_STYLE_INPUT," ","Enter registered E-mail.","Enter","Cancel");
		RegOrLog[playerid] = false;
		return 1;
	}
	if(clickedid == RegLog[4])
	{
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,18,false,false,false);
	    for(new i = 0; i < 5; i++) TextDrawHideForPlayer(playerid,RegLog[i]);
	    CancelSelectTextDraw(playerid);
		ShowPlayerDialog(playerid,DIALOG_REG_LOG,DIALOG_STYLE_INPUT," ","Enter E-mail.\nThis E-mail will be used for password recovery and login.","Enter","Cancel");
		RegOrLog[playerid] = false;
		return 1;
	}
	if(clickedid == Tutorial[4])
	{
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,19,false,false,false);
	    if(TutStep[playerid] == 1)
	    {
	    	for(new i = 1; i < 4; i++) TextDrawHideForPlayer(playerid,Tutorial[i]);
	    	for(new i = 5; i < 8; i++) TextDrawShowForPlayer(playerid,Tutorial[i]);
	    	TutStep[playerid]++;
	    	return 1;
		}
		if(TutStep[playerid] == 2)
		{
			CancelSelectTextDraw(playerid);
			for(new i = 0; i < 11; i++) TextDrawHideForPlayer(playerid,Tutorial[i]);
			ShowPlayerDialog(playerid,DIALOG_NEW_DRIVER_FR,DIALOG_STYLE_INPUT," ","Enter your first Driver's name.","Enter","Cancel");
			return 1;
		}
		if(TutStep[playerid] == 3)
		{
		    new str[32];
            for(new i = 0; i < 11; i++) TextDrawHideForPlayer(playerid,Tutorial[i]);
            SetPlayerVirtualWorld(playerid,playerid+1);
            PlayerInfo[playerid][pVehID] = CreateVehicle(VehiclesIndent[VehSelectNum[playerid]][MI],1925.5848,-2214.4021,14.0700,179.8839,0,0,-1);
            SetGVarInt("ownerid",playerid,PlayerInfo[playerid][pVehID]);
            SetVehicleNumberPlate(PlayerInfo[playerid][pVehID],"ND4SPD");
            SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
			PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]] = 150000;
            for(new i = 0; i < 12; i++) TextDrawShowForPlayer(playerid,VehSelect[i]);
			PlayerTextDrawSetString(playerid,VehSelectPl[playerid][0],VehiclesIndent[VehSelectNum[playerid]][Name]);
			format(str,32,"$%d",VehiclesIndent[VehSelectNum[playerid]][Price]);
			PlayerTextDrawSetString(playerid,VehSelectPl[playerid][4],str);
			PlayerTextDrawTextSize(playerid,VehSelectPl[playerid][1],75.0/100.0*VehiclesIndent[VehSelectNum[playerid]][TS]/3.0+485.0,5.0);
			PlayerTextDrawTextSize(playerid,VehSelectPl[playerid][2],75.0/100.0*VehiclesIndent[VehSelectNum[playerid]][AR]/3.0+485.0,5.0);
			PlayerTextDrawTextSize(playerid,VehSelectPl[playerid][3],75.0/100.0*VehiclesIndent[VehSelectNum[playerid]][HL]/3.0+485.0,5.0);
			for(new i = 0; i < 5; i++) PlayerTextDrawShow(playerid,VehSelectPl[playerid][i]);
			PlayerTextDrawShow(playerid,MoneyInd[playerid]);
			TutStep[playerid]++;
		    return 1;
		}
		return 1;
	}
	if(clickedid == VehSelect[2])
	{
	    new str[32];
	    VehSelectNum[playerid]--;
		if(VehSelectNum[playerid] == -1) VehSelectNum[playerid] = sizeof(VehiclesIndent)-1;
		DestroyVehicle(PlayerInfo[playerid][pVehID]);
		PlayerInfo[playerid][pVehID] = CreateVehicle(VehiclesIndent[VehSelectNum[playerid]][MI],1925.5848,-2214.4021,14.0700,179.8839,0,0,-1);
		SetGVarInt("ownerid",playerid,PlayerInfo[playerid][pVehID]);
		SetVehicleNumberPlate(PlayerInfo[playerid][pVehID],"ND4SPD");
		SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
		PlayerTextDrawSetString(playerid,VehSelectPl[playerid][0],VehiclesIndent[VehSelectNum[playerid]][Name]);
		format(str,32,"$%d",VehiclesIndent[VehSelectNum[playerid]][Price]);
		PlayerTextDrawSetString(playerid,VehSelectPl[playerid][4],str);
		for(new i = 1; i < 4; i++) PlayerTextDrawHide(playerid,VehSelectPl[playerid][i]);
		PlayerTextDrawTextSize(playerid,VehSelectPl[playerid][1],75.0/100.0*VehiclesIndent[VehSelectNum[playerid]][TS]/3.0+485.0,5.0);
		PlayerTextDrawTextSize(playerid,VehSelectPl[playerid][2],75.0/100.0*VehiclesIndent[VehSelectNum[playerid]][AR]/3.0+485.0,5.0);
		PlayerTextDrawTextSize(playerid,VehSelectPl[playerid][3],75.0/100.0*VehiclesIndent[VehSelectNum[playerid]][HL]/3.0+485.0,5.0);
		for(new i = 1; i < 4; i++) PlayerTextDrawShow(playerid,VehSelectPl[playerid][i]);
		if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,18,false,false,false);
		return 1;
	}
	if(clickedid == VehSelect[3])
	{
	    new str[32];
	    VehSelectNum[playerid]++;
		if(VehSelectNum[playerid] == sizeof(VehiclesIndent)) VehSelectNum[playerid] = 0;
		DestroyVehicle(PlayerInfo[playerid][pVehID]);
		PlayerInfo[playerid][pVehID] = CreateVehicle(VehiclesIndent[VehSelectNum[playerid]][MI],1925.5848,-2214.4021,14.0700,179.8839,0,0,-1);
		SetGVarInt("ownerid",playerid,PlayerInfo[playerid][pVehID]);
		SetVehicleNumberPlate(PlayerInfo[playerid][pVehID],"ND4SPD");
		SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
		PlayerTextDrawSetString(playerid,VehSelectPl[playerid][0],VehiclesIndent[VehSelectNum[playerid]][Name]);
		format(str,32,"$%d",VehiclesIndent[VehSelectNum[playerid]][Price]);
		PlayerTextDrawSetString(playerid,VehSelectPl[playerid][4],str);
		for(new i = 1; i < 4; i++) PlayerTextDrawHide(playerid,VehSelectPl[playerid][i]);
		PlayerTextDrawTextSize(playerid,VehSelectPl[playerid][1],75.0/100.0*VehiclesIndent[VehSelectNum[playerid]][TS]/3.0+485.0,5.0);
		PlayerTextDrawTextSize(playerid,VehSelectPl[playerid][2],75.0/100.0*VehiclesIndent[VehSelectNum[playerid]][AR]/3.0+485.0,5.0);
		PlayerTextDrawTextSize(playerid,VehSelectPl[playerid][3],75.0/100.0*VehiclesIndent[VehSelectNum[playerid]][HL]/3.0+485.0,5.0);
		for(new i = 1; i < 4; i++) PlayerTextDrawShow(playerid,VehSelectPl[playerid][i]);
		if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,18,false,false,false);
		return 1;
	}
	if(clickedid == VehSelect[11])
	{
	    if(TutStep[playerid] == 4)
	    {
		    if(PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]] < VehiclesIndent[VehSelectNum[playerid]][Price])
			{
			    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,20,false,false,false);
			    SendClientMessage(playerid,Colour_Yellow,"You don't have enough money to buy this vehicle.");
				return 1;
			}
		    for(new i = 0; i < 12; i++) TextDrawHideForPlayer(playerid,VehSelect[i]);
		    for(new i = 0; i < 5; i++) PlayerTextDrawHide(playerid,VehSelectPl[playerid][i]);
		    TextDrawHideForPlayer(playerid,Lines[1]);
		    CancelSelectTextDraw(playerid);
		    new str[128];
		    PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pSelectedDriver]*3] = VehiclesIndent[VehSelectNum[playerid]][MI];
		    PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]] = 1;
		    PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]]++;
			format(str,128,"UPDATE drivers SET actvehnum=%d,vehmodels='%d',vehiclesnum=%d, money=%d WHERE drivername='%s'",PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]],
				VehiclesIndent[VehSelectNum[playerid]][MI],
				PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]],
				PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]]-VehiclesIndent[VehSelectNum[playerid]][Price],
				DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
			mysql_query(str);
		    SGivePlayerMoney(playerid,-VehiclesIndent[VehSelectNum[playerid]][Price]);
	    	if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,17,false,false,false);
		    TakePlayerInWorld(playerid);
		    SetPlayerName(playerid,DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
			for(new i = 0; i < 4; i++) TextDrawShowForPlayer(playerid,MainLineStruct[i]);
			PlayerTextDrawSetString(playerid,MainLineStructPl[playerid][0],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
			PlayerTextDrawShow(playerid,MainLineStructPl[playerid][0]);
			format(str,11,"%d",PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]);
			PlayerTextDrawSetString(playerid,MainLineStructPl[playerid][1],str);
            PlayerTextDrawShow(playerid,MainLineStructPl[playerid][1]);
            PlayerTextDrawShow(playerid,MainLineStructPl[playerid][2]);
            UpdatePlayerExpLine(playerid);
            PlayerInfo[playerid][pTreasureDays] = 1;
		 	PlayerInfo[playerid][pCollectedLastTime] = 0;
		 	PlayerInfo[playerid][trCollected] = 0;
            CreateTreasureAfterReg(playerid);
            return 1;
		}
	}
	if(clickedid == DriverChooseTD[5])
	{
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,19,false,false,false);
	    CancelSelectTextDraw(playerid);
	    new str[128],nameinf[32];
		format(str,128,"DELETE FROM drivers WHERE drivername='%s'",DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
		mysql_query(str);
		format(str,128,"");
		for(new i = 0; i < PlayerInfo[playerid][pDriversNum]; i++)
		{
		    if(i == PlayerInfo[playerid][pSelectedDriver]) continue;
		    if(i == 0)
			{
				format(nameinf,32,DriverName[playerid][i]);
				strcat(str,nameinf,128);
				continue;
			}
		    format(nameinf,32,"|%s",DriverName[playerid][i]);
		    strcat(str,nameinf,128);
		}
		format(str,128,"UPDATE emails SET driversnum=%d,drivers='%s' WHERE email='%s'",PlayerInfo[playerid][pDriversNum]-1,str,PlayerInfo[playerid][pEmail]);
		mysql_query(str);
		for(new i = PlayerInfo[playerid][pSelectedDriver]; i < PlayerInfo[playerid][pDriversNum]-1; i++)
		{
		    PlayerInfo[playerid][pLevel][i] = PlayerInfo[playerid][pLevel][i+1];
		    PlayerInfo[playerid][pExp][i] = PlayerInfo[playerid][pExp][i+1];
		    PlayerInfo[playerid][pActiveVehNum][i] = PlayerInfo[playerid][pActiveVehNum][i+1];
		    PlayerInfo[playerid][pVehiclesNum][i] = PlayerInfo[playerid][pVehiclesNum][i+1];
		    PlayerInfo[playerid][pMoney][i] = PlayerInfo[playerid][pMoney][i+1];
		    format(DriverName[playerid][i],32,DriverName[playerid][i+1]);
		    for(new j = 0; j < PlayerInfo[playerid][pVehiclesNum][i+1]; j++) PlayerInfo[playerid][pVehModel][3*i+j] = PlayerInfo[playerid][pVehModel][3*(i+1)+j];
		}
		//��������� ��������, ����������� ����� �������� �������� ��������
		PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pDriversNum]-1] = 1;
		PlayerInfo[playerid][pExp][PlayerInfo[playerid][pDriversNum]-1] = 0;
		PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pDriversNum]-1] = 0;
		PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pDriversNum]-1] = 0;
		PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pDriversNum]-1] = 150000;
		format(DriverName[playerid][PlayerInfo[playerid][pDriversNum]-1],32,"");
		for(new j = 0; j < 3; j++) PlayerInfo[playerid][pVehModel][3*(PlayerInfo[playerid][pDriversNum]-1)+j] = 0;
		//
		PlayerInfo[playerid][pDriversNum]--;
		TextDrawHideForPlayer(playerid,DriverChooseTD[10+PlayerInfo[playerid][pSelectedDriver]]);
		PlayerInfo[playerid][pSelectedDriver] = 0;
		if(PlayerInfo[playerid][pVehID] != INVALID_VEHICLE_ID)
		{
			DestroyVehicleEx(PlayerInfo[playerid][pVehID]);
			PlayerInfo[playerid][pVehID] = INVALID_VEHICLE_ID;
		}
		for(new i = 0; i < 15; i++) PlayerInfo[playerid][vParams][i] = 0;
		PlayerInfo[playerid][vParams][15] = -1;
		if(PlayerInfo[playerid][pDriversNum] == 0)
		{
		    for(new i = 0; i < 13; i++) TextDrawHideForPlayer(playerid,DriverChooseTD[i]);
	    	for(new i = 0; i < 5; i++) PlayerTextDrawHide(playerid,DriverChooseTDPl[playerid][i]);
		    TextDrawShowForPlayer(playerid,Tutorial[0]);
		    TextDrawShowForPlayer(playerid,Tutorial[4]);
    		for(new i = 5; i < 8; i++) TextDrawShowForPlayer(playerid,Tutorial[i]);
    		TutStep[playerid] = 2;
    		SelectTextDraw(playerid,0x73B1EDFF);
    		return 1;
		}
		for(new i = 0; i < 3; i++)
		{
		    PlayerTextDrawHide(playerid,DriverChooseTDPl[playerid][2+i]);
		    PlayerTextDrawSetString(playerid,DriverChooseTDPl[playerid][2+i],"Empty Driver Slot");
		    PlayerTextDrawSetSelectable(playerid,DriverChooseTDPl[playerid][2+i],false);
		}
		for(new i = 0; i < PlayerInfo[playerid][pDriversNum]; i++)
		{
		    PlayerTextDrawSetString(playerid,DriverChooseTDPl[playerid][2+i],DriverName[playerid][i]);
		    PlayerTextDrawSetSelectable(playerid,DriverChooseTDPl[playerid][2+i],true);
		}
		for(new i = 0; i < 3; i++) PlayerTextDrawShow(playerid,DriverChooseTDPl[playerid][2+i]);
		TextDrawShowForPlayer(playerid,DriverChooseTD[10+PlayerInfo[playerid][pSelectedDriver]]);
	    if(PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]] != 0)
		{
		    format(str,128,"SELECT vehparams%d FROM drivers WHERE drivername='%s'",PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
		    mysql_query(str),mysql_store_result(),mysql_fetch_row(str),mysql_free_result();
		    sscanf(str,"p<|>a<i>[16]",PlayerInfo[playerid][vParams]);
  			PlayerInfo[playerid][pVehID] = CreateVehicle(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],1925.5848,-2214.4021,14.0700,179.8839,0,0,-1);
  			SetGVarInt("ownerid",playerid,PlayerInfo[playerid][pVehID]);
	    	SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
	    	SetVehicleTunning(playerid,PlayerInfo[playerid][pVehID]);
	    	format(nameinf,32,VehicleName[PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]]-400]);
		}
		else PlayerInfo[playerid][pVehID] = INVALID_VEHICLE_ID, format(nameinf,32,"No Vehicle");
		new Float:flvl = PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]],Float:fexp = PlayerInfo[playerid][pExp][PlayerInfo[playerid][pSelectedDriver]];
		new Float:line = 1.28*((fexp-500*flvl*(flvl-1.0))/((500*(flvl+1.0)*flvl-500*flvl*(flvl-1.0))/100.0));
		PlayerTextDrawHide(playerid,DriverChooseTDPl[playerid][1]);
		PlayerTextDrawTextSize(playerid,DriverChooseTDPl[playerid][1],line+476.360198,2.5);
		PlayerTextDrawShow(playerid,DriverChooseTDPl[playerid][1]);
		format(str,128,"]level %d ~n~ %s ~n~ %s",PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]],nameinf);
		PlayerTextDrawSetString(playerid,DriverChooseTDPl[playerid][0],str);
		SelectTextDraw(playerid,0x73B1EDFF);
	    return 1;
	}
	if(clickedid == DriverChooseTD[6])
	{
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,19,false,false,false);
	    if(PlayerInfo[playerid][pDriversNum] == 3)
		{
		    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,20,false,false,false);
		    SendClientMessage(playerid,Colour_Yellow,"You can have only three drivers maximum.");
			return 1;
		}
	    if(PlayerInfo[playerid][pVehID] != INVALID_VEHICLE_ID)
		{
			DestroyVehicleEx(PlayerInfo[playerid][pVehID]);
			PlayerInfo[playerid][pVehID] = INVALID_VEHICLE_ID;
		}
	    for(new i = 0; i < 13; i++) TextDrawHideForPlayer(playerid,DriverChooseTD[i]);
	    for(new i = 0; i < 5; i++) PlayerTextDrawHide(playerid,DriverChooseTDPl[playerid][i]);
	    CancelSelectTextDraw(playerid);
	    SetPlayerVirtualWorld(playerid,0);
	    ShowPlayerDialog(playerid,DIALOG_NEW_DRIVER_FR,DIALOG_STYLE_INPUT," ","Enter your new Driver's name.","Enter","Cancel");
	    TutStep[playerid] = 2;
	    return 1;
	}
	if(clickedid == DriverChooseTD[9])
	{
	    for(new i = 0; i < 13; i++) TextDrawHideForPlayer(playerid,DriverChooseTD[i]);
	    for(new i = 0; i < 5; i++) PlayerTextDrawHide(playerid,DriverChooseTDPl[playerid][i]);
	    CancelSelectTextDraw(playerid);
		if(PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]] == 0)
		{
		    TextDrawShowForPlayer(playerid,Tutorial[0]);
			TextDrawShowForPlayer(playerid,Tutorial[4]);
			for(new i = 8; i < 11; i++) TextDrawShowForPlayer(playerid,Tutorial[i]);
			SelectTextDraw(playerid,0x73B1EDFF);
			TutStep[playerid] = 3;
			return 1;
		}
		new str[128];
		if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,17,false,false,false);
		TakePlayerInWorld(playerid);
		SetPlayerName(playerid,DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
		for(new i = 0; i < 4; i++) TextDrawShowForPlayer(playerid,MainLineStruct[i]);
		PlayerTextDrawSetString(playerid,MainLineStructPl[playerid][0],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
		format(str,12,"%d",PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]);
		PlayerTextDrawSetString(playerid,MainLineStructPl[playerid][1],str);
		format(str,32,"$%d",PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]]);
		PlayerTextDrawSetString(playerid,MoneyInd[playerid],str);
		for(new i = 0; i < 3; i++) PlayerTextDrawShow(playerid,MainLineStructPl[playerid][i]);
		PlayerTextDrawShow(playerid,MoneyInd[playerid]);
		TextDrawHideForPlayer(playerid,Lines[1]);
 		UpdatePlayerExpLine(playerid);
 		format(str,128,"SELECT treasparams FROM drivers WHERE drivername='%s'",DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
 		mysql_query(str),mysql_store_result(),mysql_fetch_row(str),mysql_free_result();
 		sscanf(str,"p<|>ddd",PlayerInfo[playerid][pTreasureDays],PlayerInfo[playerid][trCollected],PlayerInfo[playerid][pCollectedLastTime]);
 		CheckForTreasureLogin(playerid);
	    return 1;
	}
	if(clickedid == DriversListTD[28])
	{
	    new str[64],drv;
	    format(str,64,"QI[%d][DriversNum]",RaceStartZone[playerid]);
	    drv = GetGVarInt(str,JoinedJNum[playerid]);
	    if(drv == 1)
	    {
	        DeleteGVar(str,JoinedJNum[playerid]);
	        format(str,64,"QI[%d][Created]",RaceStartZone[playerid]);
	    	DeleteGVar(str,JoinedJNum[playerid]);
	    	format(str,64,"QI[%d][Locked]",RaceStartZone[playerid]);
	    	DeleteGVar(str,JoinedJNum[playerid]);
			format(str,64,"QI[%d][UntilStart]",RaceStartZone[playerid]);
			DeleteGVar(str,JoinedJNum[playerid]);
		    TextDrawHideForPlayer(playerid,DriversListTD[18]);
		    format(str,64,"QI[%d][Timer]",RaceStartZone[playerid]);
		    KillTimer(GetGVarInt(str,JoinedJNum[playerid]));
		    DeleteGVar(str,JoinedJNum[playerid]);
		    if(!AvaliableEvents[RaceStartZone[playerid]][JoinedJNum[playerid]]) AvaliableEvents[RaceStartZone[playerid]][JoinedJNum[playerid]] = true;
		}
		else
		{
		    new str1[64],step;
		    SetGVarInt(str,drv-1,JoinedJNum[playerid]);
		    drv--;
		    for(new p = 0; p < drv; p++)
			{
			    format(str,64,"QI[%d][ID][%d]",RaceStartZone[playerid],p);
			    if(GetGVarInt(str,JoinedJNum[playerid]) == playerid)
			    {
					for(new i = p; i < drv; i++)
					{
					    format(str,64,"QI[%d][ID][%d]",RaceStartZone[playerid],i);
					    format(str1,64,"QI[%d][ID][%d]",RaceStartZone[playerid],i+1);
					    SetGVarInt(str,GetGVarInt(str1,JoinedJNum[playerid]),JoinedJNum[playerid]);
						SetVehiclePos(PlayerInfo[GetGVarInt(str,JoinedJNum[playerid])][pVehID],EventXByPos[i],-185.5920,14.0179);
						SetPlayerCameraPos(GetGVarInt(str,JoinedJNum[playerid]),EventXByPos[i]-6.778739,-179.429,16.9705);
						SetPlayerCameraLookAt(GetGVarInt(str,JoinedJNum[playerid]),EventXByPos[i],-185.5920,14.0179);
						break;
					}
				}
			}
			new apid,dapid;
		    for(new i = 0; i < drv; i++)
			{
			    format(str,64,"QI[%d][ID][%d]",RaceStartZone[playerid],i);
			    apid = GetGVarInt(str,JoinedJNum[playerid]);
				ClearDriversList(apid);
				step = 1;
				for(new d = 0; d < drv; d++)
				{
				    format(str,64,"QI[%d][ID][%d]",RaceStartZone[playerid],d);
				    dapid = GetGVarInt(str,JoinedJNum[playerid]);
				    if(apid == dapid) continue;
				    format(str,32,"] level %d",PlayerInfo[dapid][pLevel][PlayerInfo[dapid][pSelectedDriver]]);
        			PlayerTextDrawHide(apid,DriversListTDPl[apid][step*2]);
				    PlayerTextDrawColor(apid,DriversListTDPl[apid][step*2],-1);
				    PlayerTextDrawShow(apid,DriversListTDPl[apid][step*2]);
				    PlayerTextDrawSetString(apid,DriversListTDPl[apid][step*2],DriverName[dapid][PlayerInfo[dapid][pSelectedDriver]]);
				    PlayerTextDrawSetString(apid,DriversListTDPl[apid][step*2+1],str);
				    step++;
				}
			}
		}
 		JoinedInRace[playerid] = false;
  		JoinedJNum[playerid] = -1;
		RaceStartZone[playerid] = -1;
		TextDrawHideForPlayer(playerid,DriversListTD[18]);
		ShowSpeedometre(playerid);
		ShowBonuses(playerid);
		for(new p = 0; p < 4; p++) TextDrawShowForPlayer(playerid,MainLineStruct[p]);
		for(new p = 0; p < 3; p++) PlayerTextDrawShow(playerid,MainLineStructPl[playerid][p]);
		TextDrawHideForPlayer(playerid,Lines[1]);
		PlayerTextDrawHide(playerid,EventTDPl[playerid][2]);
		for(new p = 0; p < 18; p++) TextDrawHideForPlayer(playerid,DriversListTD[p]);
		for(new p = 26; p < 30; p++) TextDrawHideForPlayer(playerid,DriversListTD[p]);
		for(new p = 0; p < 16; p++) PlayerTextDrawHide(playerid,DriversListTDPl[playerid][p]);
		ShowTreasureTDs(playerid);
		ClearDriversListAfterRace(playerid);
		PlayerTextDrawShow(playerid,MoneyInd[playerid]);
		SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],MAX_PLAYERS+1),SetPlayerVirtualWorld(playerid,MAX_PLAYERS+1);
		LinkVehicleToInterior(PlayerInfo[playerid][pVehID],0),SetPlayerInterior(playerid,0);
		SetVehiclePos(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][pPosInWorld][0],PlayerInfo[playerid][pPosInWorld][1],PlayerInfo[playerid][pPosInWorld][2]);
		SetVehicleZAngle(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][pPosInWorld][3]);
		SetCameraBehindPlayer(playerid);
		SetPlayerWorldTime(playerid);
		CancelSelectTextDraw(playerid);
		return 1;
	}
	if(clickedid == FinishTD[13])
	{
	    if(!LookingFinishList[playerid]) return 1;
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,19,false,false,false);
	    LookingFinishList[playerid] = false;
	    LookingRep[playerid] = true;
	    for(new i = 0; i < 8; i++)
		{
			PlayerTextDrawHide(playerid,DriversListTDPl[playerid][i*2]);
			PlayerTextDrawHide(playerid,DriversListTDPl[playerid][i*2+1]);
		}
		for(new i = 0; i < 3; i++)
		{
		    TextDrawHideForPlayer(playerid,DriversListTD[2+i*2]);
			TextDrawHideForPlayer(playerid,DriversListTD[2+i*2+1]);
			TextDrawHideForPlayer(playerid,DriversListTD[18+i]);
			TextDrawHideForPlayer(playerid,FinishTD[1+i*3]);
			TextDrawHideForPlayer(playerid,FinishTD[1+i*3+1]);
			TextDrawHideForPlayer(playerid,FinishTD[1+i*3+2]);
		}
		for(new i = 3; i < 8; i++)
		{
		    TextDrawHideForPlayer(playerid,DriversListTD[2+i*2]);
			TextDrawHideForPlayer(playerid,DriversListTD[2+i*2+1]);
			TextDrawHideForPlayer(playerid,DriversListTD[18+i]);
		}
		for(new i = 10; i < 14; i++) TextDrawHideForPlayer(playerid,FinishTD[i]);
		TextDrawHideForPlayer(playerid,FinishTD[0]);
		for(new i = 0; i < 15; i++) TextDrawShowForPlayer(playerid,RepTD[i]);
		new str[32];
		format(str,32,"%d",RewardInfo[playerid][Reputation]);
		PlayerTextDrawSetString(playerid,RepTDPl[playerid][0],str);
		format(str,32,"%d",RewardInfo[playerid][Money]);
		PlayerTextDrawSetString(playerid,RepTDPl[playerid][1],str);
		PlayerTextDrawShow(playerid,RepTDPl[playerid][0]);
		PlayerTextDrawShow(playerid,RepTDPl[playerid][1]);
		TextDrawHideForPlayer(playerid,DriversListTD[1]);
		PlayerTextDrawSetString(playerid,EventTDPl[playerid][1],"0%");
		RaceStartZone[playerid] = -1;
		JoinedJNum[playerid] = -1;
		NumPassedArea[playerid] = 0;
		return 1;
	}
	if(clickedid == RepTD[13])
	{
	    if(Audio_IsClientConnected(playerid))
		{
		    if(FinishHandle[playerid] != -1) Audio_Stop(playerid,FinishHandle[playerid]);
			Audio_Play(playerid,17,false,false,false);
			new for_rand[2] = {2,3};
			FreeroamHandle[playerid] = Audio_Play(playerid,for_rand[random(2)],false,false,false);
		}
	    LookingRep[playerid] = false;
	    for(new i = 0; i < 15; i++) TextDrawHideForPlayer(playerid,RepTD[i]);
	    PlayerTextDrawHide(playerid,RepTDPl[playerid][0]);
		PlayerTextDrawHide(playerid,RepTDPl[playerid][1]);
		TextDrawShowForPlayer(playerid,MainLineStruct[3]);
		PlayerInfo[playerid][pExp][PlayerInfo[playerid][pSelectedDriver]] += RewardInfo[playerid][Reputation];
		if(PlayerInfo[playerid][pExp][PlayerInfo[playerid][pSelectedDriver]] >= 500*(PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]+1)*PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]])
		{
			PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]++;
			new str[128];
			format(str,128,"%d",PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]);
			PlayerTextDrawSetString(playerid,MainLineStructPl[playerid][1],str);
			format(str,128,"You has reached new level. Your current level is %d.",PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]);
			SendClientMessage(playerid,Colour_Yellow,str);
			if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,20,false,false,false);
			SetPlayerScore(playerid,PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]);
		}
		UpdatePlayerExpLine(playerid);
		PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]] += RewardInfo[playerid][Money];
		SaveDriver(playerid);
		TogglePlayerControllable(playerid,true);
		SetPlayerVirtualWorld(playerid,MAX_PLAYERS+1),SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],MAX_PLAYERS+1);
		new str[32];
		format(str,32,"$%d",PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]]);
		PlayerTextDrawSetString(playerid,MoneyInd[playerid],str);
  		ShowSpeedometre(playerid);
  		ShowTreasureTDs(playerid);
		ClearDriversListAfterRace(playerid);
		ShowBonuses(playerid);
		CancelSelectTextDraw(playerid);
		return 1;
	}
	if(clickedid == SafehouseTD[17])
	{
	    SafeHouseState[playerid] = SAFEHOUSE_STATE_NONE;
	    SetPlayerWorldTime(playerid);
     	SetVehiclePos(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][pPosInWorld][0],PlayerInfo[playerid][pPosInWorld][1],PlayerInfo[playerid][pPosInWorld][2]);
		SetVehicleZAngle(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][pPosInWorld][3]);
  		TogglePlayerSpectating(playerid,false);
  		SetSpawnInfo(playerid,0,101,PlayerInfo[playerid][pPosInWorld][0],PlayerInfo[playerid][pPosInWorld][1],PlayerInfo[playerid][pPosInWorld][2],0,0,0,0,0,0,0);
  		SpawnPlayer(playerid);
		SetPlayerVirtualWorld(playerid,MAX_PLAYERS+1);
		SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],MAX_PLAYERS+1);
		if(GetGVarType("3did",PlayerInfo[playerid][pVehID]) != GLOBAL_VARTYPE_NONE)
		{
			new t3d = GetGVarInt("3did",PlayerInfo[playerid][pVehID]);
			DeleteGVar("3did",PlayerInfo[playerid][pVehID]);
			if(IsValidDynamic3DTextLabel(Text3D:t3d)) DestroyDynamic3DTextLabel(Text3D:t3d);
		}
		new Float:pp[3];
	    GetVehicleModelInfo(GetVehicleModel(PlayerInfo[playerid][pVehID]),VEHICLE_MODEL_INFO_SIZE,pp[0],pp[1],pp[2]);
        SetGVarInt("3did",_:CreateDynamic3DTextLabel(DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]],0x73B1EDFF,0.0,0.0,pp[2]/2.0+0.1,25.0,INVALID_PLAYER_ID,PlayerInfo[playerid][pVehID],0,-1,-1,-1,50.0),PlayerInfo[playerid][pVehID]);
		Streamer_RemoveArrayData(STREAMER_TYPE_3D_TEXT_LABEL,Text3D:GetGVarInt("3did",PlayerInfo[playerid][pVehID]),E_STREAMER_PLAYER_ID,playerid);
		PutPlayerInVehicle(playerid,PlayerInfo[playerid][pVehID],0);
		ShowSpeedometre(playerid);
		ShowBonuses(playerid);
		TextDrawHideForPlayer(playerid,Lines[1]);
		for(new i = 0; i < 3; i++) PlayerTextDrawShow(playerid,MainLineStructPl[playerid][i]);
		for(new i = 0; i < 4; i++) TextDrawShowForPlayer(playerid,MainLineStruct[i]);
		for(new i = 0; i < 24; i++) TextDrawHideForPlayer(playerid,SafehouseTD[i]);
		ShowTreasureTDs(playerid);
		CancelSelectTextDraw(playerid);
		if(Audio_IsClientConnected(playerid))
		{
		    Audio_Stop(playerid,SafehouseHandle[playerid]);
			Audio_Play(playerid,17,false,false,false);
			new for_rand[2] = {2,3};
			FreeroamHandle[playerid] = Audio_Play(playerid,for_rand[random(2)],false,false,false);
		}
		return 1;
	}
	if(clickedid == SafehouseTD[13])
	{
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,19,false,false,false);
	    for(new i = 0; i < 18; i++) TextDrawHideForPlayer(playerid,SafehouseTD[i]);
	    for(new i = 19; i < 24; i++) TextDrawHideForPlayer(playerid,SafehouseTD[i]);
	    for(new i = 24; i < 29; i++) TextDrawShowForPlayer(playerid,SafehouseTD[i]);
	    TextDrawShowForPlayer(playerid,SafehouseTD[1]);
	    TextDrawShowForPlayer(playerid,BackButton);
	    SafeHouseState[playerid] = SAFEHOUSE_STATE_CUSTOM;
		return 1;
	}
	if(clickedid == BackButton)
	{
	    if(SafeHouseState[playerid] == SAFEHOUSE_STATE_MAIN) return 1;
	    if(SafeHouseState[playerid] == SAFEHOUSE_STATE_CUSTOM)
	    {
	        TextDrawHideForPlayer(playerid,BackButton);
	        TextDrawHideForPlayer(playerid,SafehouseTD[1]);
	        for(new i = 24; i < 29; i++) TextDrawHideForPlayer(playerid,SafehouseTD[i]);
	        for(new i = 0; i < 18; i++) TextDrawShowForPlayer(playerid,SafehouseTD[i]);
		    for(new i = 19; i < 24; i++) TextDrawShowForPlayer(playerid,SafehouseTD[i]);
		    SafeHouseState[playerid] = SAFEHOUSE_STATE_MAIN;
		    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,22,false,false,false);
		    return 1;
		}
		if(SafeHouseState[playerid] == SAFEHOUSE_STATE_AFTERMARKET)
		{
		    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,19,false,false,false);
		    new str[64],model;
		    SafeHouseState[playerid] = SAFEHOUSE_STATE_CUSTOM;
		    switch(CustomType[playerid])
		    {
		        case CUSTOM_PLATE: { }
		        case CUSTOM_NEON:
		        {
		            if(PlayerInfo[playerid][vParams][CustomType[playerid]] != 0)
		            {
	                    Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[PlayerInfo[playerid][pVehID]][0],E_STREAMER_MODEL_ID,PlayerInfo[playerid][vParams][CustomType[playerid]]);
				     	Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[PlayerInfo[playerid][pVehID]][1],E_STREAMER_MODEL_ID,PlayerInfo[playerid][vParams][CustomType[playerid]]);
					}
					else
					{
					    DestroyDynamicObject(NeonObject[PlayerInfo[playerid][pVehID]][0]);
					    NeonObject[PlayerInfo[playerid][pVehID]][0] = INVALID_OBJECT_ID;
	                    DestroyDynamicObject(NeonObject[PlayerInfo[playerid][pVehID]][1]);
					    NeonObject[PlayerInfo[playerid][pVehID]][1] = INVALID_OBJECT_ID;
					}
				}
				default:
				{
	                format(str,64,"PI[%d][ModelID]",CustomListNum[playerid]);
		    		model = GetGVarInt(str,CustomType[playerid]);
	        		if(IsVehicleUpgradeCompatible(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],model)) RemoveVehicleComponent(PlayerInfo[playerid][pVehID],model);
	        		if(PlayerInfo[playerid][vParams][CustomType[playerid]] != 0) AddVehicleComponent(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][vParams][CustomType[playerid]]);
				}
			}
			for(new i = 0; i < 32; i++) PlayerTextDrawHide(playerid,CustomTDPl[playerid][i]);
			for(new i = 0; i < 35; i++) TextDrawHideForPlayer(playerid,CustomTD[i]);
			for(new i = 24; i < 29; i++) TextDrawShowForPlayer(playerid,SafehouseTD[i]);
 			TextDrawShowForPlayer(playerid,SafehouseTD[1]);
 			CustomType[playerid] = CUSTOM_SPOILER;
		    CustomListNum[playerid] = 0;
		    CustomLimitNum[playerid] = 0;
		    new Float:x,Float:y,Float:z;
			GetPlayerCameraPos(playerid,x,y,z);
			InterpolateCameraPos(playerid,x,y,z,SAFEHOUSE_CAMERA_MAIN,1500);
			InterpolateCameraLookAt(playerid,1925.5848,-2214.4021,14.0600,1925.5848,-2214.4021,14.0650,1500);
			return 1;
		}
		if(SafeHouseState[playerid] == SAFEHOUSE_STATE_PAINT)
		{
		    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,19,false,false,false);
            SafeHouseState[playerid] = SAFEHOUSE_STATE_CUSTOM;
            ChangeVehicleColor(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][vParams][13],PlayerInfo[playerid][vParams][14]);
			if(VehicleModelToPaintjobNum(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]]) != 0)
			{
			    if(PlayerInfo[playerid][vParams][15] == -1) ChangeVehiclePaintjob(PlayerInfo[playerid][pVehID],3);
				else ChangeVehiclePaintjob(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][vParams][15]);
			}
            for(new i = 0; i < 20; i++) TextDrawHideForPlayer(playerid,ColorTD[i]);
            for(new i = 0; i < 7; i++) PlayerTextDrawHide(playerid,ColorTDPl[playerid][i]);
            for(new i = 24; i < 29; i++) TextDrawShowForPlayer(playerid,SafehouseTD[i]);
 			TextDrawShowForPlayer(playerid,SafehouseTD[1]);
 			return 1;
		}
		if(SafeHouseState[playerid] == SAFEHOUSE_STATE_DEALER)
		{
		    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,22,false,false,false);
		    TextDrawHideForPlayer(playerid,BackButton);
	        TextDrawHideForPlayer(playerid,SafehouseTD[1]);
	        for(new i = 29; i < 35; i++) TextDrawHideForPlayer(playerid,SafehouseTD[i]);
	        for(new i = 0; i < 18; i++) TextDrawShowForPlayer(playerid,SafehouseTD[i]);
		    for(new i = 19; i < 24; i++) TextDrawShowForPlayer(playerid,SafehouseTD[i]);
			TextDrawHideForPlayer(playerid,SafehouseTD[24]);
   			SafeHouseState[playerid] = SAFEHOUSE_STATE_MAIN;
		    return 1;
		}
		if(SafeHouseState[playerid] == SAFEHOUSE_STATE_DEALER_BUY)
		{
		    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,19,false,false,false);
		    SafeHouseState[playerid] = SAFEHOUSE_STATE_DEALER;
		    DestroyVehicleEx(PlayerInfo[playerid][pVehID]);
		    PlayerInfo[playerid][pVehID] = CreateVehicle(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],1925.5848,-2214.4021,14.0700,179.8839,0,0,-1);
		    SetGVarInt("ownerid",playerid,PlayerInfo[playerid][pVehID]);
		    SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
		    SetVehicleTunning(playerid,PlayerInfo[playerid][pVehID]);
		    for(new i = 0; i < 22; i++) TextDrawHideForPlayer(playerid,VehBuyTD[i]);
		    for(new i = 0; i < 9; i++) PlayerTextDrawHide(playerid,VehBuyTDPl[playerid][i]);
		    TextDrawShowForPlayer(playerid,SafehouseTD[1]);
	    	for(new i = 29; i < 35; i++) TextDrawShowForPlayer(playerid,SafehouseTD[i]);
			TextDrawShowForPlayer(playerid,SafehouseTD[24]);
			return 1;
		}
		if(SafeHouseState[playerid] == SAFEHOUSE_STATE_DEALER_SELL)
		{
		    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,19,false,false,false);
		    if(VehListSelected[playerid]+1 != PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]])
			{
			    new str[128];
			    format(str,128,"SELECT vehparams%d FROM drivers WHERE drivername='%s' LIMIT 1",PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
		    	mysql_query(str),mysql_store_result(),mysql_fetch_row(str),mysql_free_result();
		    	sscanf(str,"p<|>a<i>[16]",PlayerInfo[playerid][vParams]);
		        DestroyVehicleEx(PlayerInfo[playerid][pVehID]);
			    PlayerInfo[playerid][pVehID] = CreateVehicle(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],1925.5848,-2214.4021,14.0700,179.8839,0,0,-1);
			    SetGVarInt("ownerid",playerid,PlayerInfo[playerid][pVehID]);
			    SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
			    SetVehicleTunning(playerid,PlayerInfo[playerid][pVehID]);
		    }
		    for(new i = 0; i < 2; i++) TextDrawHideForPlayer(playerid,VehBuyTD[i]);
			for(new i = 9; i < 21; i++) TextDrawHideForPlayer(playerid,VehBuyTD[i]);
			TextDrawHideForPlayer(playerid,VehSellTD[3]);
			for(new i = 0; i < 3; i++)
			{
				PlayerTextDrawHide(playerid,VehListTDPl[playerid][i]);
				PlayerTextDrawHide(playerid,VehBuyTDPl[playerid][5+i]);
				TextDrawHideForPlayer(playerid,VehSellTD[i]);
			}
			PlayerTextDrawHide(playerid,VehBuyTDPl[playerid][8]);
		    TextDrawShowForPlayer(playerid,SafehouseTD[1]);
   			for(new i = 29; i < 35; i++) TextDrawShowForPlayer(playerid,SafehouseTD[i]);
			TextDrawShowForPlayer(playerid,SafehouseTD[24]);
			SafeHouseState[playerid] = SAFEHOUSE_STATE_DEALER;
			return 1;
		}
		if(SafeHouseState[playerid] == SAFEHOUSE_STATE_VEH_CHANGE)
		{
		    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,22,false,false,false);
			if(VehListSelected[playerid] != PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1)
			{
			    new str[256];
			    format(str,256,"SELECT vehparams%d FROM drivers WHERE drivername='%s'",PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
				mysql_query(str),mysql_store_result(),mysql_fetch_row(str),mysql_free_result();
				sscanf(str,"p<|>a<i>[16]",PlayerInfo[playerid][vParams]);
				DestroyVehicleEx(PlayerInfo[playerid][pVehID]);
				PlayerInfo[playerid][pVehID] = CreateVehicle(PlayerInfo[playerid][pVehModel][3*PlayerInfo[playerid][pSelectedDriver]+PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1],1925.5848,-2214.4021,14.0700,179.8839,0,0,-1);
				SetGVarInt("ownerid",playerid,PlayerInfo[playerid][pVehID]);
				SetVehicleTunning(playerid,PlayerInfo[playerid][pVehID]);
				SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
			}
			for(new i = 0; i < 2; i++) TextDrawHideForPlayer(playerid,VehSelectTD[i]);
			TextDrawHideForPlayer(playerid,BackButton);
			TextDrawHideForPlayer(playerid,VehBuyTD[1]);
			for(new i = 9; i < 21; i++) TextDrawHideForPlayer(playerid,VehBuyTD[i]);
			for(new i = 0; i < 3; i++)
			{
				PlayerTextDrawHide(playerid,VehListTDPl[playerid][i]);
				PlayerTextDrawHide(playerid,VehBuyTDPl[playerid][5+i]);
			}
			TextDrawHideForPlayer(playerid,VehSellTD[VehListSelected[playerid]]);
			for(new i = 0; i < 18; i++) TextDrawShowForPlayer(playerid,SafehouseTD[i]);
		    for(new i = 19; i < 24; i++) TextDrawShowForPlayer(playerid,SafehouseTD[i]);
			SafeHouseState[playerid] = SAFEHOUSE_STATE_MAIN;
			return 1;
		}
		return 1;
	}
	if(clickedid == SafehouseTD[27])
	{
		if(SafeHouseState[playerid] == SAFEHOUSE_STATE_AFTERMARKET) return 1;
		if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,19,false,false,false);
		SafeHouseState[playerid] = SAFEHOUSE_STATE_AFTERMARKET;
		new str[64],value;
	    for(new i = 24; i < 29; i++) TextDrawHideForPlayer(playerid,SafehouseTD[i]);
	    TextDrawHideForPlayer(playerid,SafehouseTD[1]);
	    for(new i = 0; i < 3; i++) TextDrawShowForPlayer(playerid,CustomTD[i]);
	    CustomType[playerid] = CUSTOM_SPOILER;
	    CustomListNum[playerid] = 0;
	    CustomLimitNum[playerid] = 0;
	    for(new i = 0; i < 5; i++)
	    {
	        if(i > TypeBorder[CustomType[playerid]]-1) break;
	        TextDrawShowForPlayer(playerid,CustomTD[5+i]);
	        format(str,64,"PI[%d][Value]",i);
	        value = GetGVarInt(str,CustomType[playerid]);
	        format(str,64,"PI[%d][Name]",i);
			GetGVarString(str,str,64,CustomType[playerid]);
	        format(str,64,"%s~n~$%d",str,value);
	        PlayerTextDrawSetString(playerid,CustomTDPl[playerid][1+i],str);
	        PlayerTextDrawShow(playerid,CustomTDPl[playerid][1+i]);
	        format(str,64,"PI[%d][ModelID]",i);
	        if(!IsVehicleUpgradeCompatible(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],GetGVarInt(str,CustomType[playerid]))) TextDrawShowForPlayer(playerid,CustomTD[15+i]);
	        else if(i == 0) AddVehicleComponent(PlayerInfo[playerid][pVehID],GetGVarInt(str,CustomType[playerid]));
		}
		TextDrawShowForPlayer(playerid,CustomTD[10]);
		TextDrawShowForPlayer(playerid,CustomTD[20]);
		TextDrawShowForPlayer(playerid,CustomTD[21]);
		PlayerTextDrawSetString(playerid,CustomTDPl[playerid][0],CustomTypeName[0]);
		PlayerTextDrawShow(playerid,CustomTDPl[playerid][0]);
		LeftHudProccessed(playerid);
		CameraViewChange(playerid,CustomType[playerid]);
		return 1;
	}
	if(clickedid == CustomTD[20])
	{
	    if(CustomListNum[playerid] >= TypeBorder[CustomType[playerid]]-1) return 1;
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,18,false,false,false);
	    new model,value,str[64];
		switch(CustomType[playerid])
		{
		    case CUSTOM_PLATE,CUSTOM_NEON: { }
		    default:
			{
			    format(str,64,"PI[%d][ModelID]",CustomListNum[playerid]);
		     	model = GetGVarInt(str,CustomType[playerid]);
     			if(IsVehicleUpgradeCompatible(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],model)) RemoveVehicleComponent(PlayerInfo[playerid][pVehID],model);
     			if(PlayerInfo[playerid][vParams][CustomType[playerid]] != 0) AddVehicleComponent(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][vParams][CustomType[playerid]]);
			}
		}
	    CustomListNum[playerid]++;
	    if(CustomListNum[playerid] == 1) TextDrawShowForPlayer(playerid,CustomTD[4]);
	    if(CustomListNum[playerid] >= TypeBorder[CustomType[playerid]]-1) TextDrawHideForPlayer(playerid,CustomTD[20]);
	    CustomLimitNum[playerid]++;
	    if(CustomLimitNum[playerid] > 4)
	    {
	        for(new i = CustomListNum[playerid]-4, b = 0; b < 5; i++,b++)
	        {
	            format(str,64,"PI[%d][Value]",i);
	            value = GetGVarInt(str,CustomType[playerid]);
	            format(str,64,"PI[%d][Name]",i);
	            GetGVarString(str,str,64,CustomType[playerid]);
	            format(str,64,"%s~n~$%d",str,value);
	            PlayerTextDrawSetString(playerid,CustomTDPl[playerid][1+b],str);
	            switch(CustomType[playerid])
				{
				    case CUSTOM_PLATE: { }
				    case CUSTOM_NEON:
				    {
				        format(str,64,"PI[%d][ModelID]",CustomListNum[playerid]);
				     	model = GetGVarInt(str,CustomType[playerid]);
				     	Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[PlayerInfo[playerid][pVehID]][0],E_STREAMER_MODEL_ID,model);
				     	Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[PlayerInfo[playerid][pVehID]][1],E_STREAMER_MODEL_ID,model);
					}
				    default:
					{
					    format(str,64,"PI[%d][ModelID]",i);
	            		model = GetGVarInt(str,CustomType[playerid]);
						TextDrawHideForPlayer(playerid,CustomTD[15+b]);
						if(!IsVehicleUpgradeCompatible(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],model)) TextDrawShowForPlayer(playerid,CustomTD[15+b]);
						else if(b == 4) AddVehicleComponent(PlayerInfo[playerid][pVehID],model);
					}
				}
			}
			CustomLimitNum[playerid] = 4;
		}
		else
		{
		    TextDrawHideForPlayer(playerid,CustomTD[10+CustomLimitNum[playerid]-1]);
		    TextDrawShowForPlayer(playerid,CustomTD[10+CustomLimitNum[playerid]]);
			switch(CustomType[playerid])
			{
			    case CUSTOM_PLATE: { }
				case CUSTOM_NEON:
				{
				    format(str,64,"PI[%d][ModelID]",CustomListNum[playerid]);
			     	model = GetGVarInt(str,CustomType[playerid]);
			     	Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[PlayerInfo[playerid][pVehID]][0],E_STREAMER_MODEL_ID,model);
			     	Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[PlayerInfo[playerid][pVehID]][1],E_STREAMER_MODEL_ID,model);
				}
			    default:
				{
				    format(str,64,"PI[%d][ModelID]",CustomListNum[playerid]);
			     	model = GetGVarInt(str,CustomType[playerid]);
	     			if(IsVehicleUpgradeCompatible(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],model)) AddVehicleComponent(PlayerInfo[playerid][pVehID],model);
	     			else if(PlayerInfo[playerid][vParams][CustomType[playerid]] != 0) AddVehicleComponent(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][vParams][CustomType[playerid]]);
				}
			}
		}
		return 1;
	}
	if(clickedid == CustomTD[4])
	{
	    if(CustomListNum[playerid] == 0) return 1;
	    new model,value,str[64];
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,18,false,false,false);
		switch(CustomType[playerid])
		{
		    case CUSTOM_PLATE,CUSTOM_NEON: { }
		    default:
			{
			    format(str,64,"PI[%d][ModelID]",CustomListNum[playerid]);
		     	model = GetGVarInt(str,CustomType[playerid]);
     			if(IsVehicleUpgradeCompatible(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],model)) RemoveVehicleComponent(PlayerInfo[playerid][pVehID],model);
     			if(PlayerInfo[playerid][vParams][CustomType[playerid]] != 0) AddVehicleComponent(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][vParams][CustomType[playerid]]);
			}
		}
	    CustomListNum[playerid]--;
	    if(CustomListNum[playerid] == 0) TextDrawHideForPlayer(playerid,CustomTD[4]);
	    if(CustomListNum[playerid] == TypeBorder[CustomType[playerid]]-2) TextDrawShowForPlayer(playerid,CustomTD[20]);
	    CustomLimitNum[playerid]--;
	    if(CustomLimitNum[playerid] < 0)
	    {
	        for(new i = CustomListNum[playerid], b = 0; b < 5; i++,b++)
	        {
	            format(str,64,"PI[%d][Value]",i);
	            value = GetGVarInt(str,CustomType[playerid]);
	            format(str,64,"PI[%d][Name]",i);
	            GetGVarString(str,str,64,CustomType[playerid]);
	            format(str,64,"%s~n~$%d",str,value);
	            PlayerTextDrawSetString(playerid,CustomTDPl[playerid][1+b],str);
	            switch(CustomType[playerid])
				{
				    case CUSTOM_PLATE: { }
				    case CUSTOM_NEON:
				    {
		      			format(str,64,"PI[%d][ModelID]",CustomListNum[playerid]);
		  				model = GetGVarInt(str,CustomType[playerid]);
		     			Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[PlayerInfo[playerid][pVehID]][0],E_STREAMER_MODEL_ID,model);
				     	Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[PlayerInfo[playerid][pVehID]][1],E_STREAMER_MODEL_ID,model);
					}
				    default:
					{
					    format(str,64,"PI[%d][ModelID]",i);
	            		model = GetGVarInt(str,CustomType[playerid]);
						TextDrawHideForPlayer(playerid,CustomTD[15+b]);
						if(!IsVehicleUpgradeCompatible(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],model)) TextDrawShowForPlayer(playerid,CustomTD[15+b]);
						else if(b == 0) AddVehicleComponent(PlayerInfo[playerid][pVehID],model);
					}
				}
			}
			CustomLimitNum[playerid] = 0;
		}
		else
		{
		    TextDrawHideForPlayer(playerid,CustomTD[10+CustomLimitNum[playerid]+1]);
		    TextDrawShowForPlayer(playerid,CustomTD[10+CustomLimitNum[playerid]]);
			switch(CustomType[playerid])
			{
			    case CUSTOM_PLATE: { }
				case CUSTOM_NEON:
				{
				    format(str,64,"PI[%d][ModelID]",CustomListNum[playerid]);
			     	model = GetGVarInt(str,CustomType[playerid]);
			     	Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[PlayerInfo[playerid][pVehID]][0],E_STREAMER_MODEL_ID,model);
			     	Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[PlayerInfo[playerid][pVehID]][1],E_STREAMER_MODEL_ID,model);
				}
			    default:
				{
				    format(str,64,"PI[%d][ModelID]",CustomListNum[playerid]);
			     	model = GetGVarInt(str,CustomType[playerid]);
	     			if(IsVehicleUpgradeCompatible(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],model)) AddVehicleComponent(PlayerInfo[playerid][pVehID],model);
	     			else if(PlayerInfo[playerid][vParams][CustomType[playerid]] != 0) AddVehicleComponent(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][vParams][CustomType[playerid]]);
				}
			}
		}
		return 1;
	}
	if(clickedid == CustomTD[2])
	{
	    if(CustomType[playerid] == CUSTOM_LIGHT) return 1;
	    new str[64],model,value;
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,18,false,false,false);
	    switch(CustomType[playerid])
	    {
	        case CUSTOM_PLATE: { }
	        case CUSTOM_NEON:
	        {
	            if(PlayerInfo[playerid][vParams][CustomType[playerid]] != 0)
	            {
                    Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[PlayerInfo[playerid][pVehID]][0],E_STREAMER_MODEL_ID,PlayerInfo[playerid][vParams][CustomType[playerid]]);
			     	Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[PlayerInfo[playerid][pVehID]][1],E_STREAMER_MODEL_ID,PlayerInfo[playerid][vParams][CustomType[playerid]]);
				}
				else
				{
				    DestroyDynamicObject(NeonObject[PlayerInfo[playerid][pVehID]][0]);
				    NeonObject[PlayerInfo[playerid][pVehID]][0] = INVALID_OBJECT_ID;
                    DestroyDynamicObject(NeonObject[PlayerInfo[playerid][pVehID]][1]);
				    NeonObject[PlayerInfo[playerid][pVehID]][1] = INVALID_OBJECT_ID;
				}
			}
			default:
			{
                format(str,64,"PI[%d][ModelID]",CustomListNum[playerid]);
	    		model = GetGVarInt(str,CustomType[playerid]);
        		if(IsVehicleUpgradeCompatible(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],model)) RemoveVehicleComponent(PlayerInfo[playerid][pVehID],model);
        		if(PlayerInfo[playerid][vParams][CustomType[playerid]] != 0) AddVehicleComponent(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][vParams][CustomType[playerid]]);
			}
		}
	    CustomType[playerid]++;
	    PlayerTextDrawSetString(playerid,CustomTDPl[playerid][0],CustomTypeName[CustomType[playerid]]);
	    if(CustomType[playerid] == 1) TextDrawShowForPlayer(playerid,CustomTD[3]);
	    if(CustomType[playerid] == CUSTOM_LIGHT) TextDrawHideForPlayer(playerid,CustomTD[2]);
	    TextDrawHideForPlayer(playerid,CustomTD[10+CustomLimitNum[playerid]]);
	    TextDrawShowForPlayer(playerid,CustomTD[10]);
	    TextDrawHideForPlayer(playerid,CustomTD[4]);
	    TextDrawShowForPlayer(playerid,CustomTD[20]);
	    CustomListNum[playerid] = 0;
	    CustomLimitNum[playerid] = 0;
	    for(new i = 0; i < 5; i++)
		{
		    TextDrawHideForPlayer(playerid,CustomTD[5+i]);
	        PlayerTextDrawHide(playerid,CustomTDPl[playerid][1+i]);
	        TextDrawHideForPlayer(playerid,CustomTD[15+i]);
		}
		for(new i = 0; i < 5; i++)
	    {
	        if(i > TypeBorder[CustomType[playerid]]-1) break;
	        TextDrawShowForPlayer(playerid,CustomTD[5+i]);
	        format(str,64,"PI[%d][Value]",i);
	        value = GetGVarInt(str,CustomType[playerid]);
	        format(str,64,"PI[%d][Name]",i);
			GetGVarString(str,str,64,CustomType[playerid]);
	        format(str,64,"%s~n~$%d",str,value);
	        PlayerTextDrawSetString(playerid,CustomTDPl[playerid][1+i],str);
	        PlayerTextDrawShow(playerid,CustomTDPl[playerid][1+i]);
	        switch(CustomType[playerid])
	        {
	            case CUSTOM_PLATE: { }
	            case CUSTOM_NEON:
	            {
	                if(i == 0)
	                {
	                    format(str,64,"PI[%d][ModelID]",CustomListNum[playerid]);
	    				model = GetGVarInt(str,CustomType[playerid]);
		                if(NeonObject[PlayerInfo[playerid][pVehID]][0] == INVALID_OBJECT_ID)
		                {
		                    new arid = VehModelToArrayID(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]]);
	                        NeonObject[PlayerInfo[playerid][pVehID]][0] = CreateDynamicObject(model,0,0,0,0,0,0,-1,-1,-1,150.0);
	                        AttachDynamicObjectToVehicle(NeonObject[PlayerInfo[playerid][pVehID]][0],PlayerInfo[playerid][pVehID],NeonOffset[arid][0],NeonOffset[arid][1],NeonOffset[arid][2],0.0,0.0,0.0);
	                        NeonObject[PlayerInfo[playerid][pVehID]][1] = CreateDynamicObject(model,0,0,0,0,0,0,-1,-1,-1,150.0);
	                        AttachDynamicObjectToVehicle(NeonObject[PlayerInfo[playerid][pVehID]][1],PlayerInfo[playerid][pVehID],-NeonOffset[arid][0],NeonOffset[arid][1],NeonOffset[arid][2],0.0,0.0,0.0);
	                        Streamer_Update(playerid);
						}
						else
						{
						    Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[PlayerInfo[playerid][pVehID]][0],E_STREAMER_MODEL_ID,model);
			     			Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[PlayerInfo[playerid][pVehID]][1],E_STREAMER_MODEL_ID,model);
						}
					}
				}
				default:
				{
	        		format(str,64,"PI[%d][ModelID]",i);
	        		model = GetGVarInt(str,CustomType[playerid]);
	        		if(!IsVehicleUpgradeCompatible(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],model)) TextDrawShowForPlayer(playerid,CustomTD[15+i]);
	        		else if(i == 0) AddVehicleComponent(PlayerInfo[playerid][pVehID],model);
				}
			}
		}
		CameraViewChange(playerid,CustomType[playerid]);
		return 1;
	}
	if(clickedid == CustomTD[3])
	{
	    if(CustomType[playerid] == CUSTOM_SPOILER) return 1;
	    new str[64],model,value;
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,18,false,false,false);
	    switch(CustomType[playerid])
	    {
	        case CUSTOM_PLATE: { }
	        case CUSTOM_NEON:
	        {
	            if(PlayerInfo[playerid][vParams][CustomType[playerid]] != 0)
	            {
                    Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[PlayerInfo[playerid][pVehID]][0],E_STREAMER_MODEL_ID,PlayerInfo[playerid][vParams][CustomType[playerid]]);
			     	Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[PlayerInfo[playerid][pVehID]][1],E_STREAMER_MODEL_ID,PlayerInfo[playerid][vParams][CustomType[playerid]]);
				}
				else
				{
				    DestroyDynamicObject(NeonObject[PlayerInfo[playerid][pVehID]][0]);
				    NeonObject[PlayerInfo[playerid][pVehID]][0] = INVALID_OBJECT_ID;
                    DestroyDynamicObject(NeonObject[PlayerInfo[playerid][pVehID]][1]);
				    NeonObject[PlayerInfo[playerid][pVehID]][1] = INVALID_OBJECT_ID;
				}
			}
			default:
			{
                format(str,64,"PI[%d][ModelID]",CustomListNum[playerid]);
	    		model = GetGVarInt(str,CustomType[playerid]);
        		if(IsVehicleUpgradeCompatible(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],model)) RemoveVehicleComponent(PlayerInfo[playerid][pVehID],model);
        		if(PlayerInfo[playerid][vParams][CustomType[playerid]] != 0) AddVehicleComponent(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][vParams][CustomType[playerid]]);
			}
		}
	    CustomType[playerid]--;
	    PlayerTextDrawSetString(playerid,CustomTDPl[playerid][0],CustomTypeName[CustomType[playerid]]);
	    if(CustomType[playerid] == 0) TextDrawHideForPlayer(playerid,CustomTD[3]);
	    if(CustomType[playerid] == CUSTOM_LIGHT-1) TextDrawShowForPlayer(playerid,CustomTD[2]);
	    TextDrawHideForPlayer(playerid,CustomTD[10+CustomLimitNum[playerid]]);
	    TextDrawShowForPlayer(playerid,CustomTD[10]);
	    TextDrawHideForPlayer(playerid,CustomTD[4]);
	    TextDrawShowForPlayer(playerid,CustomTD[20]);
	    CustomListNum[playerid] = 0;
	    CustomLimitNum[playerid] = 0;
	    for(new i = 0; i < 5; i++)
		{
		    TextDrawHideForPlayer(playerid,CustomTD[5+i]);
	        PlayerTextDrawHide(playerid,CustomTDPl[playerid][1+i]);
	        TextDrawHideForPlayer(playerid,CustomTD[15+i]);
		}
		for(new i = 0; i < 5; i++)
	    {
	        if(i > TypeBorder[CustomType[playerid]]-1) break;
	        TextDrawShowForPlayer(playerid,CustomTD[5+i]);
	        format(str,64,"PI[%d][Value]",i);
	        value = GetGVarInt(str,CustomType[playerid]);
	        format(str,64,"PI[%d][Name]",i);
			GetGVarString(str,str,64,CustomType[playerid]);
	        format(str,64,"%s~n~$%d",str,value);
	        PlayerTextDrawSetString(playerid,CustomTDPl[playerid][1+i],str);
	        PlayerTextDrawShow(playerid,CustomTDPl[playerid][1+i]);
	        switch(CustomType[playerid])
	        {
	            case CUSTOM_PLATE: { }
	            case CUSTOM_NEON:
	            {
	                if(i == 0)
	                {
	                    format(str,64,"PI[%d][ModelID]",CustomListNum[playerid]);
	    				model = GetGVarInt(str,CustomType[playerid]);
		                if(NeonObject[PlayerInfo[playerid][pVehID]][0] == INVALID_OBJECT_ID)
		                {
		                    new arid = VehModelToArrayID(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]]);
	                        NeonObject[PlayerInfo[playerid][pVehID]][0] = CreateDynamicObject(model,0,0,0,0,0,0,-1,-1,-1,150.0);
	                        AttachDynamicObjectToVehicle(NeonObject[PlayerInfo[playerid][pVehID]][0],PlayerInfo[playerid][pVehID],NeonOffset[arid][0],NeonOffset[arid][1],NeonOffset[arid][2],0.0,0.0,0.0);
	                        NeonObject[PlayerInfo[playerid][pVehID]][1] = CreateDynamicObject(model,0,0,0,0,0,0,-1,-1,-1,150.0);
	                        AttachDynamicObjectToVehicle(NeonObject[PlayerInfo[playerid][pVehID]][1],PlayerInfo[playerid][pVehID],-NeonOffset[arid][0],NeonOffset[arid][1],NeonOffset[arid][2],0.0,0.0,0.0);
	                        Streamer_Update(playerid);
						}
						else
						{
						    Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[PlayerInfo[playerid][pVehID]][0],E_STREAMER_MODEL_ID,model);
			     			Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[PlayerInfo[playerid][pVehID]][1],E_STREAMER_MODEL_ID,model);
						}
					}
				}
				default:
				{
	        		format(str,64,"PI[%d][ModelID]",i);
	        		model = GetGVarInt(str,CustomType[playerid]);
	        		if(!IsVehicleUpgradeCompatible(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],model)) TextDrawShowForPlayer(playerid,CustomTD[15+i]);
	        		else if(i == 0) AddVehicleComponent(PlayerInfo[playerid][pVehID],model);
				}
			}
		}
		CameraViewChange(playerid,CustomType[playerid]);
		return 1;
	}
	if(clickedid == CustomTD[21])
	{
	    new str[64],value,model;
		switch(CustomType[playerid])
		{
			case CUSTOM_PLATE:
			{
				if(PlayerInfo[playerid][vParams][CustomType[playerid]] == CustomListNum[playerid])
				{
				    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,20,false,false,false);
					SendClientMessage(playerid,Colour_Orange,"* This lic plate has been already installed on your vehicle.");
					return 1;
				}
			}
			default:
			{
				format(str,64,"PI[%d][ModelID]",CustomListNum[playerid]);
				model = GetGVarInt(str,CustomType[playerid]);
				if(PlayerInfo[playerid][vParams][CustomType[playerid]] == model)
				{
				    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,20,false,false,false);
					SendClientMessage(playerid,Colour_Orange,"* This component has been already installed on your vehicle.");
					return 1;
				}
			}
		}
	    format(str,64,"PI[%d][Value]",CustomListNum[playerid]);
     	value = GetGVarInt(str,CustomType[playerid]);
      	if(PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]] < value)
  		{
			if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,20,false,false,false);
		  	SendClientMessage(playerid,Colour_Orange,"* You don't have enough money.");
		  	return 1;
		}
	    switch(CustomType[playerid])
	    {
	        case CUSTOM_PLATE:
	        {
				format(str,64,"PI[%d][Name]",CustomListNum[playerid]);
				GetGVarString(str,str,64,CustomType[playerid]);
				SetVehicleNumberPlate(PlayerInfo[playerid][pVehID],str);
				PlayerInfo[playerid][vParams][CUSTOM_PLATE] = CustomListNum[playerid];
                SendClientMessage(playerid,Colour_Orange,"* License plate installed. You'll see it after rejoining the server (But everyone will see it after this moment).");
			}
			case CUSTOM_NEON:
			{
	            format(str,64,"PI[%d][ModelID]",CustomListNum[playerid]);
	            model = GetGVarInt(str,CustomType[playerid]);
	            PlayerInfo[playerid][vParams][CUSTOM_NEON] = model;
			}
			default:
			{
			    format(str,64,"PI[%d][ModelID]",CustomListNum[playerid]);
	            model = GetGVarInt(str,CustomType[playerid]);
	            if(!IsVehicleUpgradeCompatible(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],model))
             	{
             	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,20,false,false,false);
				 	SendClientMessage(playerid,Colour_Orange,"* This component can't be installed on your vehicle.");
				 	return 1;
				}
                PlayerInfo[playerid][vParams][CustomType[playerid]] = model;
			}
		}
		SGivePlayerMoney(playerid,-value);
		format(str,64,"PI[%d][Name]",CustomListNum[playerid]);
		GetGVarString(str,str,64,CustomType[playerid]);
		format(str,64,"%s: %s",CustomTypeHudName[CustomType[playerid]],str);
		PlayerTextDrawSetString(playerid,CustomTDPl[playerid][19+CustomType[playerid]],str);
		switch(CustomType[playerid])
		{
		    case CUSTOM_PLATE: { }
		    default:
			{
			    PlayerTextDrawHide(playerid,CustomTDPl[playerid][6+CustomType[playerid]]);
				PlayerTextDrawSetPreviewModel(playerid,CustomTDPl[playerid][6+CustomType[playerid]],PlayerInfo[playerid][vParams][CustomType[playerid]]);
				PlayerTextDrawShow(playerid,CustomTDPl[playerid][6+CustomType[playerid]]);
			}
		}
		TextDrawShowForPlayer(playerid,CustomTD[22+CustomType[playerid]]);
		PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
		SafeTunning(playerid);
		return 1;
	}
	if(CustomTD[22] <= clickedid <= CustomTD[34])
	{
	    PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
	    new i = _:clickedid - _:CustomTD[22];
     	if(PlayerInfo[playerid][vParams][i] == 0) return 1;
      	new str[64];
       	switch(i)
        {
        	case CUSTOM_PLATE:
         	{
          		SetVehicleNumberPlate(PlayerInfo[playerid][pVehID],"ND4SPD");
				SendClientMessage(playerid,Colour_Yellow,"License Plate was resetted to default.");
				format(str,64,"%s: ND4SPD",CustomTypeHudName[i]);
				PlayerTextDrawSetString(playerid,CustomTDPl[playerid][19+i],str);
			}
			case CUSTOM_NEON:
			{
   				if(CustomType[playerid] != i)
		    	{
					DestroyDynamicObject(NeonObject[PlayerInfo[playerid][pVehID]][0]),NeonObject[PlayerInfo[playerid][pVehID]][0] = INVALID_OBJECT_ID;
					DestroyDynamicObject(NeonObject[PlayerInfo[playerid][pVehID]][1]),NeonObject[PlayerInfo[playerid][pVehID]][1] = INVALID_OBJECT_ID;
				}
				format(str,64,"%s: NIS",CustomTypeHudName[i]);
				PlayerTextDrawSetString(playerid,CustomTDPl[playerid][19+i],str);
				PlayerTextDrawHide(playerid,CustomTDPl[playerid][6+i]);
				PlayerTextDrawSetPreviewModel(playerid,CustomTDPl[playerid][6+i],18631);
				PlayerTextDrawShow(playerid,CustomTDPl[playerid][6+i]);
			}
			default:
			{
   				if(CustomType[playerid] != i) RemoveVehicleComponent(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][vParams][i]);
			    else
			    {
					new model;
					format(str,64,"PI[%d][ModelID]",CustomListNum[playerid]);
					model = GetGVarInt(str,i);
					if(PlayerInfo[playerid][vParams][i] != model)
					{
	    				if(!IsVehicleUpgradeCompatible(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],model)) RemoveVehicleComponent(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][vParams][i]);
					}
				}
				format(str,64,"%s: NIS",CustomTypeHudName[i]);
				PlayerTextDrawSetString(playerid,CustomTDPl[playerid][19+i],str);
				PlayerTextDrawHide(playerid,CustomTDPl[playerid][6+i]);
				PlayerTextDrawSetPreviewModel(playerid,CustomTDPl[playerid][6+i],18631);
				PlayerTextDrawShow(playerid,CustomTDPl[playerid][6+i]);
			}
		}
		PlayerInfo[playerid][vParams][i] = 0;
		TextDrawHideForPlayer(playerid,CustomTD[22+i]);
		SafeTunning(playerid);
		return 1;
	}
	if(clickedid == SafehouseTD[28])
	{
	    if(SafeHouseState[playerid] == SAFEHOUSE_STATE_PAINT) return 1;
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,19,false,false,false);
		SafeHouseState[playerid] = SAFEHOUSE_STATE_PAINT;
	    for(new i = 24; i < 29; i++) TextDrawHideForPlayer(playerid,SafehouseTD[i]);
	    TextDrawHideForPlayer(playerid,SafehouseTD[1]);
	    for(new i = 0; i < 11; i++) TextDrawShowForPlayer(playerid,ColorTD[i]);
	    new curcol;
	    for(new i = 0; i < 2; i++)
	    {
			curcol = PlayerInfo[playerid][vParams][13+i];
			PlayerTextDrawColor(playerid, ColorTDPl[playerid][2+3*i], RGBArray[curcol]);
			curcol--;
			if(curcol < 0) curcol = 255;
			PlayerTextDrawColor(playerid, ColorTDPl[playerid][1+3*i], RGBArray[curcol]);
			curcol += 2;
			if(curcol > 255) curcol = 0;
			PlayerTextDrawColor(playerid, ColorTDPl[playerid][3+3*i], RGBArray[curcol]);
		}
		for(new i = 0; i < 6; i++) PlayerTextDrawShow(playerid,ColorTDPl[playerid][1+i]);
		for(new i = 0, b = VehicleModelToPaintjobNum(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]])+1; i < b; i++) TextDrawShowForPlayer(playerid,ColorTD[11+i]);
		VinylJob[playerid] = PlayerInfo[playerid][vParams][15]+1;
		TextDrawShowForPlayer(playerid,ColorTD[16+VinylJob[playerid]]);
		PrimaryColor[playerid] = PlayerInfo[playerid][vParams][13];
		SecondaryColor[playerid] = PlayerInfo[playerid][vParams][14];
		RepaintValue[playerid] = 0;
		ChangedPrimaryColor[playerid] = false;
		ChangedSecondaryColor[playerid] = false;
		ChangedVinylJob[playerid] = false;
		PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],"$0");
		PlayerTextDrawShow(playerid,ColorTDPl[playerid][0]);
		TextDrawShowForPlayer(playerid,ColorTD[15]);
		return 1;
		
	}
	if(clickedid == ColorTD[5])
	{
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,18,false,false,false);
	    PlayerTextDrawHide(playerid,ColorTDPl[playerid][1]);
	    PlayerTextDrawColor(playerid,ColorTDPl[playerid][1],RGBArray[PrimaryColor[playerid]]);
	    PlayerTextDrawShow(playerid,ColorTDPl[playerid][1]);
	    PrimaryColor[playerid]++;
	    if(PrimaryColor[playerid] > 255) PrimaryColor[playerid] = 0;
	    PlayerTextDrawHide(playerid,ColorTDPl[playerid][2]);
	    PlayerTextDrawColor(playerid,ColorTDPl[playerid][2],RGBArray[PrimaryColor[playerid]]);
	    PlayerTextDrawShow(playerid,ColorTDPl[playerid][2]);
	    new curcol = PrimaryColor[playerid]+1;
	    if(curcol > 255) curcol = 0;
	    PlayerTextDrawHide(playerid,ColorTDPl[playerid][3]);
	    PlayerTextDrawColor(playerid,ColorTDPl[playerid][3],RGBArray[curcol]);
	    PlayerTextDrawShow(playerid,ColorTDPl[playerid][3]);
	    if(PrimaryColor[playerid] == PlayerInfo[playerid][vParams][13])
		{
		    new str[32];
			RepaintValue[playerid] -= PAINT_VALUE;
			ChangedPrimaryColor[playerid] = false;
			format(str,32,"$%d",RepaintValue[playerid]);
			PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
		}
	    else if(!ChangedPrimaryColor[playerid])
	    {
	        new str[32];
	        ChangedPrimaryColor[playerid] = true;
	        RepaintValue[playerid] += PAINT_VALUE;
	        format(str,32,"$%d",RepaintValue[playerid]);
			PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
		}
		ChangeVehicleColor(PlayerInfo[playerid][pVehID],PrimaryColor[playerid],SecondaryColor[playerid]);
	    return 1;
	}
	if(clickedid == ColorTD[6])
	{
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,18,false,false,false);
	    PlayerTextDrawHide(playerid,ColorTDPl[playerid][3]);
	    PlayerTextDrawColor(playerid,ColorTDPl[playerid][3],RGBArray[PrimaryColor[playerid]]);
	    PlayerTextDrawShow(playerid,ColorTDPl[playerid][3]);
	    PrimaryColor[playerid]--;
	    if(PrimaryColor[playerid] < 0) PrimaryColor[playerid] = 255;
	    PlayerTextDrawHide(playerid,ColorTDPl[playerid][2]);
	    PlayerTextDrawColor(playerid,ColorTDPl[playerid][2],RGBArray[PrimaryColor[playerid]]);
	    PlayerTextDrawShow(playerid,ColorTDPl[playerid][2]);
	    new curcol = PrimaryColor[playerid]-1;
	    if(curcol < 0) curcol = 255;
	    PlayerTextDrawHide(playerid,ColorTDPl[playerid][1]);
	    PlayerTextDrawColor(playerid,ColorTDPl[playerid][1],RGBArray[curcol]);
	    PlayerTextDrawShow(playerid,ColorTDPl[playerid][1]);
	    if(PrimaryColor[playerid] == PlayerInfo[playerid][vParams][13])
		{
		    new str[32];
			RepaintValue[playerid] -= PAINT_VALUE;
			ChangedPrimaryColor[playerid] = false;
			format(str,32,"$%d",RepaintValue[playerid]);
			PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
		}
	    else if(!ChangedPrimaryColor[playerid])
	    {
	        new str[32];
	        ChangedPrimaryColor[playerid] = true;
	        RepaintValue[playerid] += PAINT_VALUE;
	        format(str,32,"$%d",RepaintValue[playerid]);
			PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
		}
		ChangeVehicleColor(PlayerInfo[playerid][pVehID],PrimaryColor[playerid],SecondaryColor[playerid]);
	    return 1;
	}
	if(clickedid == ColorTD[7])
	{
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,18,false,false,false);
	    PlayerTextDrawHide(playerid,ColorTDPl[playerid][4]);
	    PlayerTextDrawColor(playerid,ColorTDPl[playerid][4],RGBArray[SecondaryColor[playerid]]);
	    PlayerTextDrawShow(playerid,ColorTDPl[playerid][4]);
	    SecondaryColor[playerid]++;
	    if(SecondaryColor[playerid] > 255) SecondaryColor[playerid] = 0;
	    PlayerTextDrawHide(playerid,ColorTDPl[playerid][5]);
	    PlayerTextDrawColor(playerid,ColorTDPl[playerid][5],RGBArray[SecondaryColor[playerid]]);
	    PlayerTextDrawShow(playerid,ColorTDPl[playerid][5]);
	    new curcol = SecondaryColor[playerid]+1;
	    if(curcol > 255) curcol = 0;
	    PlayerTextDrawHide(playerid,ColorTDPl[playerid][6]);
	    PlayerTextDrawColor(playerid,ColorTDPl[playerid][6],RGBArray[curcol]);
	    PlayerTextDrawShow(playerid,ColorTDPl[playerid][6]);
	    if(SecondaryColor[playerid] == PlayerInfo[playerid][vParams][14])
		{
		    new str[32];
			RepaintValue[playerid] -= PAINT_VALUE;
			ChangedSecondaryColor[playerid] = false;
			format(str,32,"$%d",RepaintValue[playerid]);
			PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
		}
	    else if(!ChangedSecondaryColor[playerid])
	    {
	        new str[32];
	        ChangedSecondaryColor[playerid] = true;
	        RepaintValue[playerid] += PAINT_VALUE;
	        format(str,32,"$%d",RepaintValue[playerid]);
			PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
		}
		ChangeVehicleColor(PlayerInfo[playerid][pVehID],PrimaryColor[playerid],SecondaryColor[playerid]);
	    return 1;
	}
	if(clickedid == ColorTD[8])
	{
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,18,false,false,false);
	    PlayerTextDrawHide(playerid,ColorTDPl[playerid][6]);
	    PlayerTextDrawColor(playerid,ColorTDPl[playerid][6],RGBArray[SecondaryColor[playerid]]);
	    PlayerTextDrawShow(playerid,ColorTDPl[playerid][6]);
	    SecondaryColor[playerid]--;
	    if(SecondaryColor[playerid] < 0) SecondaryColor[playerid] = 255;
	    PlayerTextDrawHide(playerid,ColorTDPl[playerid][5]);
	    PlayerTextDrawColor(playerid,ColorTDPl[playerid][5],RGBArray[SecondaryColor[playerid]]);
	    PlayerTextDrawShow(playerid,ColorTDPl[playerid][5]);
	    new curcol = SecondaryColor[playerid]-1;
	    if(curcol < 0) curcol = 255;
	    PlayerTextDrawHide(playerid,ColorTDPl[playerid][4]);
	    PlayerTextDrawColor(playerid,ColorTDPl[playerid][4],RGBArray[curcol]);
	    PlayerTextDrawShow(playerid,ColorTDPl[playerid][4]);
	    if(SecondaryColor[playerid] == PlayerInfo[playerid][vParams][14])
		{
		    new str[32];
			RepaintValue[playerid] -= PAINT_VALUE;
			ChangedSecondaryColor[playerid] = false;
			format(str,32,"$%d",RepaintValue[playerid]);
			PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
		}
	    else if(!ChangedSecondaryColor[playerid])
	    {
	        new str[32];
	        ChangedSecondaryColor[playerid] = true;
	        RepaintValue[playerid] += PAINT_VALUE;
	        format(str,32,"$%d",RepaintValue[playerid]);
			PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
		}
		ChangeVehicleColor(PlayerInfo[playerid][pVehID],PrimaryColor[playerid],SecondaryColor[playerid]);
	    return 1;
	}
	if(ColorTD[11] <= clickedid <= ColorTD[14])
	{
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,18,false,false,false);
	    new i = _:clickedid - _:ColorTD[11];
     	if(i == VinylJob[playerid]) return 1;
      	new curvin = PlayerInfo[playerid][vParams][15]+1;
		TextDrawHideForPlayer(playerid,ColorTD[16+VinylJob[playerid]]);
		if(curvin == i)
		{
			if(ChangedVinylJob[playerid])
 			{
  				new str[32];
    			RepaintValue[playerid] -= VYNIL_VALUE;
      			format(str,32,"$%d",RepaintValue[playerid]);
				PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
				ChangedVinylJob[playerid] = false;
				if(i == 0) ChangeVehiclePaintjob(PlayerInfo[playerid][pVehID],3);
				else ChangeVehiclePaintjob(PlayerInfo[playerid][pVehID],curvin-1);
			}
		}
		else
		{
  			if(!ChangedVinylJob[playerid])
  			{
				new str[32];
 				RepaintValue[playerid] += VYNIL_VALUE;
   				format(str,32,"$%d",RepaintValue[playerid]);
				PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],str);
				ChangedVinylJob[playerid] = true;
				if(i == 0) ChangeVehiclePaintjob(PlayerInfo[playerid][pVehID],3);
				else ChangeVehiclePaintjob(PlayerInfo[playerid][pVehID],i-1);
			}
			else
			{
   				if(i == 0) ChangeVehiclePaintjob(PlayerInfo[playerid][pVehID],3);
				else ChangeVehiclePaintjob(PlayerInfo[playerid][pVehID],i-1);
			}
		}
		TextDrawShowForPlayer(playerid,ColorTD[16+i]);
		VinylJob[playerid] = i;
		return 1;
	}
	if(clickedid == ColorTD[15])
	{
	    if(RepaintValue[playerid] == 0 && !ChangedVinylJob[playerid]) return SendClientMessage(playerid,Colour_Orange,"* Nothing to apply.");
	    if(PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]] < RepaintValue[playerid]) return SendClientMessage(playerid,Colour_Orange,"* You don't have enough money.");
	    SGivePlayerMoney(playerid,-RepaintValue[playerid]);
	    PlayerInfo[playerid][vParams][13] = PrimaryColor[playerid];
	    PlayerInfo[playerid][vParams][14] = SecondaryColor[playerid];
	    PlayerInfo[playerid][vParams][15] = VinylJob[playerid]-1;
		if(ChangedPrimaryColor[playerid]) ChangedPrimaryColor[playerid] = false;
		if(ChangedSecondaryColor[playerid]) ChangedSecondaryColor[playerid] = false;
		if(ChangedVinylJob[playerid]) ChangedVinylJob[playerid] = false;
		RepaintValue[playerid] = 0;
		PlayerTextDrawSetString(playerid,ColorTDPl[playerid][0],"$0");
		PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
		SafeTunning(playerid);
		return 1;
	}
	if(clickedid == SafehouseTD[15])
	{
	    if(SafeHouseState[playerid] == SAFEHOUSE_STATE_DEALER) return 1;
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,19,false,false,false);
	    for(new i = 0; i < 18; i++) TextDrawHideForPlayer(playerid,SafehouseTD[i]);
	    for(new i = 19; i < 24; i++) TextDrawHideForPlayer(playerid,SafehouseTD[i]);
	    TextDrawShowForPlayer(playerid,SafehouseTD[24]);
	    TextDrawShowForPlayer(playerid,SafehouseTD[1]);
	    for(new i = 29; i < 35; i++) TextDrawShowForPlayer(playerid,SafehouseTD[i]);
	    TextDrawShowForPlayer(playerid,BackButton);
	    SafeHouseState[playerid] = SAFEHOUSE_STATE_DEALER;
	    return 1;
	}
	if(clickedid == SafehouseTD[31])
	{
	    if(SafeHouseState[playerid] == SAFEHOUSE_STATE_DEALER_BUY) return 1;
		new str[64];
		if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,19,false,false,false);
		SafeHouseState[playerid] = SAFEHOUSE_STATE_DEALER_BUY;
  		TextDrawHideForPlayer(playerid,SafehouseTD[1]);
    	for(new i = 29; i < 35; i++) TextDrawHideForPlayer(playerid,SafehouseTD[i]);
		TextDrawHideForPlayer(playerid,SafehouseTD[24]);
		for(new i = 0; i < 2; i++) TextDrawShowForPlayer(playerid,VehBuyTD[i]);
		TextDrawShowForPlayer(playerid,VehBuyTD[3]);
		for(new i = 9; i < 22; i++) TextDrawShowForPlayer(playerid,VehBuyTD[i]);
		VehListArray[playerid] = 0;
		VehListArrayLimit[playerid] = 0;
		for(new i = 0; i < 5; i++)
		{
		    format(str,64,"%s",VehiclesIndent[VehListArray[playerid]+i][Name]);
			PlayerTextDrawSetString(playerid,VehBuyTDPl[playerid][i],str);
			PlayerTextDrawShow(playerid,VehBuyTDPl[playerid][i]);
		}
		TextDrawShowForPlayer(playerid,VehBuyTD[4]);
		format(str,64,"$%d",VehiclesIndent[VehListArray[playerid]][Price]);
		PlayerTextDrawSetString(playerid,VehBuyTDPl[playerid][8],str);
		PlayerTextDrawShow(playerid,VehBuyTDPl[playerid][8]);
  		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][5], 515.5+0.86*(VehiclesIndent[VehListArray[playerid]][TS]/3.0),0.0);
  		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][6], 515.5+0.86*(VehiclesIndent[VehListArray[playerid]][AR]/3.0),0.0);
  		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][7], 515.5+0.86*(VehiclesIndent[VehListArray[playerid]][HL]/3.0),0.0);
  		for(new i = 0; i < 3; i++) PlayerTextDrawShow(playerid,VehBuyTDPl[playerid][5+i]);
		DestroyVehicleEx(PlayerInfo[playerid][pVehID]);
		PlayerInfo[playerid][pVehID] = CreateVehicle(VehiclesIndent[VehListArray[playerid]][MI],1925.5848,-2214.4021,14.0700,179.8839,0,0,-1);
		SetGVarInt("ownerid",playerid,PlayerInfo[playerid][pVehID]);
		SetVehicleNumberPlate(PlayerInfo[playerid][pVehID],"ND4SPD");
		SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
  		return 1;
	}
	if(clickedid == VehBuyTD[3])
	{
	    if(VehListArray[playerid] == sizeof(VehiclesIndent)-1) return 1;
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,18,false,false,false);
	    VehListArray[playerid]++;
	    if(VehListArray[playerid] == sizeof(VehiclesIndent)-1) TextDrawHideForPlayer(playerid,VehBuyTD[3]);
	    if(VehListArray[playerid] == 1) TextDrawShowForPlayer(playerid,VehBuyTD[2]);
	    if(VehListArrayLimit[playerid] == 4)
	    {
	        new str[64];
	        for(new i = VehListArray[playerid]-4, b = 0; i < VehListArray[playerid]+1; i++,b++)
	        {
	            format(str,64,"%s",VehiclesIndent[i][Name]);
				PlayerTextDrawSetString(playerid,VehBuyTDPl[playerid][b],str);
			}
		}
		else
		{
		    TextDrawHideForPlayer(playerid,VehBuyTD[4+VehListArrayLimit[playerid]]);
			VehListArrayLimit[playerid]++;
			TextDrawShowForPlayer(playerid,VehBuyTD[4+VehListArrayLimit[playerid]]);
		}
		DestroyVehicle(PlayerInfo[playerid][pVehID]);
		PlayerInfo[playerid][pVehID] = CreateVehicle(VehiclesIndent[VehListArray[playerid]][MI],1925.5848,-2214.4021,14.0700,179.8839,0,0,-1);
		SetGVarInt("ownerid",playerid,PlayerInfo[playerid][pVehID]);
		SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
		for(new i = 0; i < 3; i++) PlayerTextDrawHide(playerid,VehBuyTDPl[playerid][5+i]);
		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][5], 515.5+0.86*(VehiclesIndent[VehListArray[playerid]][TS]/3.0),0.0);
  		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][6], 515.5+0.86*(VehiclesIndent[VehListArray[playerid]][AR]/3.0),0.0);
  		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][7], 515.5+0.86*(VehiclesIndent[VehListArray[playerid]][HL]/3.0),0.0);
  		for(new i = 0; i < 3; i++) PlayerTextDrawShow(playerid,VehBuyTDPl[playerid][5+i]);
  		new str[32];
  		format(str,32,"$%d",VehiclesIndent[VehListArray[playerid]][Price]);
		PlayerTextDrawSetString(playerid,VehBuyTDPl[playerid][8],str);
		return 1;
	}
    if(clickedid == VehBuyTD[2])
	{
	    if(VehListArray[playerid] == 0) return 1;
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,18,false,false,false);
	    VehListArray[playerid]--;
	    if(VehListArray[playerid] == 0) TextDrawHideForPlayer(playerid,VehBuyTD[2]);
	    if(VehListArray[playerid] == sizeof(VehiclesIndent)-2) TextDrawShowForPlayer(playerid,VehBuyTD[3]);
	    if(VehListArrayLimit[playerid] == 0)
	    {
	        new str[64];
	        for(new i = VehListArray[playerid], b = 0; i < VehListArray[playerid]+5; i++,b++)
	        {
	            format(str,64,"%s",VehiclesIndent[i][Name]);
				PlayerTextDrawSetString(playerid,VehBuyTDPl[playerid][b],str);
			}
		}
		else
		{
			TextDrawHideForPlayer(playerid,VehBuyTD[4+VehListArrayLimit[playerid]]);
			VehListArrayLimit[playerid]--;
			TextDrawShowForPlayer(playerid,VehBuyTD[4+VehListArrayLimit[playerid]]);
		}
		DestroyVehicle(PlayerInfo[playerid][pVehID]);
		PlayerInfo[playerid][pVehID] = CreateVehicle(VehiclesIndent[VehListArray[playerid]][MI],1925.5848,-2214.4021,14.0700,179.8839,0,0,-1);
		SetGVarInt("ownerid",playerid,PlayerInfo[playerid][pVehID]);
		SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
		for(new i = 0; i < 3; i++) PlayerTextDrawHide(playerid,VehBuyTDPl[playerid][5+i]);
		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][5], 515.5+0.86*(VehiclesIndent[VehListArray[playerid]][TS]/3.0),0.0);
  		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][6], 515.5+0.86*(VehiclesIndent[VehListArray[playerid]][AR]/3.0),0.0);
  		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][7], 515.5+0.86*(VehiclesIndent[VehListArray[playerid]][HL]/3.0),0.0);
  		for(new i = 0; i < 3; i++) PlayerTextDrawShow(playerid,VehBuyTDPl[playerid][5+i]);
  		new str[32];
  		format(str,32,"$%d",VehiclesIndent[VehListArray[playerid]][Price]);
		PlayerTextDrawSetString(playerid,VehBuyTDPl[playerid][8],str);
		return 1;
	}
	if(clickedid == VehBuyTD[21])
	{
	    if(PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]] == 3)
		{
		    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,20,false,false,false);
		    SendClientMessage(playerid,Colour_Yellow,"* You already have three vehicles. Sell one of them.");
		    return 1;
		}
	    if(PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]] < VehiclesIndent[VehListArray[playerid]][Price])
	    {
	        if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,20,false,false,false);
		    SendClientMessage(playerid,Colour_Yellow,"* You don't have enough money.");
		    return 1;
		}
		SGivePlayerMoney(playerid,-VehiclesIndent[VehListArray[playerid]][Price]);
		PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]]++;
        PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]] = PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]];
        PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pSelectedDriver]*3+PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1] = VehiclesIndent[VehListArray[playerid]][MI];
        for(new i = 0; i < 15; i++) PlayerInfo[playerid][vParams][i] = 0;
		PlayerInfo[playerid][vParams][15] = -1;
		PlayerPlaySound(playerid,1149,0.0,0.0,0.0);
		SendClientMessage(playerid,Colour_Green,"* New vehicle has been bought. Now you drive this one.");
        SaveVehicles(playerid);
        return 1;
	}
	if(clickedid == SafehouseTD[32])
	{
	    if(SafeHouseState[playerid] == SAFEHOUSE_STATE_DEALER_SELL) return 1;
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,19,false,false,false);
		SafeHouseState[playerid] = SAFEHOUSE_STATE_DEALER_SELL;
  		TextDrawHideForPlayer(playerid,SafehouseTD[1]);
    	for(new i = 29; i < 35; i++) TextDrawHideForPlayer(playerid,SafehouseTD[i]);
		TextDrawHideForPlayer(playerid,SafehouseTD[24]);
		for(new i = 0; i < 2; i++) TextDrawShowForPlayer(playerid,VehBuyTD[i]);
		for(new i = 9; i < 21; i++) TextDrawShowForPlayer(playerid,VehBuyTD[i]);
		TextDrawShowForPlayer(playerid,VehSellTD[3]);
		new arid;
		for(new i = 0; i < 3; i++)
		{
		    if(i < PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]])
			{
			    arid = VehModelToArrayID(PlayerInfo[playerid][pVehModel][3*PlayerInfo[playerid][pSelectedDriver]+i]);
				PlayerTextDrawSetString(playerid,VehListTDPl[playerid][i],VehiclesIndent[arid][Name]);
				PlayerTextDrawSetSelectable(playerid,VehListTDPl[playerid][i],true);
			}
		    else
			{
				PlayerTextDrawSetString(playerid,VehListTDPl[playerid][i],"Empty Car Slot");
				PlayerTextDrawSetSelectable(playerid,VehListTDPl[playerid][i],false);
			}
			PlayerTextDrawShow(playerid,VehListTDPl[playerid][i]);
		}
		arid = VehModelToArrayID(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]]);
		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][5], 515.5+0.86*(VehiclesIndent[arid][TS]/3.0),0.0);
  		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][6], 515.5+0.86*(VehiclesIndent[arid][AR]/3.0),0.0);
  		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][7], 515.5+0.86*(VehiclesIndent[arid][HL]/3.0),0.0);
  		for(new i = 0; i < 3; i++) PlayerTextDrawShow(playerid,VehBuyTDPl[playerid][5+i]);
  		TextDrawShowForPlayer(playerid,VehSellTD[PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1]);
  		new str[32];
  		format(str,32,"$%d",VehiclesIndent[arid][Price]/100*70);
  		PlayerTextDrawSetString(playerid,VehBuyTDPl[playerid][8],str);
  		PlayerTextDrawShow(playerid,VehBuyTDPl[playerid][8]);
  		VehListSelected[playerid] = PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1;
  		return 1;
	}
	if(clickedid == VehSellTD[3])
	{
	    if(PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]] == 1)
	    {
	        if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,20,false,false,false);
		    SendClientMessage(playerid,Colour_Yellow,"* You can't sell your only one vehicle.");
		    return 1;
		}
		new arid,str[256];
		arid = VehModelToArrayID(PlayerInfo[playerid][pVehModel][VehListSelected[playerid]+3*PlayerInfo[playerid][pSelectedDriver]]);
		PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]] += VehiclesIndent[arid][Price]/100*70;
		format(str,32,"$%d",PlayerInfo[playerid][pMoney]);
		PlayerTextDrawSetString(playerid,MoneyInd[playerid],str);
		PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]]--;
		for(new i = VehListSelected[playerid]; i < PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]]; i++)
		{
		    PlayerInfo[playerid][pVehModel][3*PlayerInfo[playerid][pSelectedDriver]+i] = PlayerInfo[playerid][pVehModel][3*PlayerInfo[playerid][pSelectedDriver]+i+1];
		    format(str,256,"UPDATE drivers SET vehparams%d=vehparams%d WHERE drivername='%s'",i+1,i+2,DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
		    mysql_query(str);
		}
		if(VehListSelected[playerid]+1 > PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]])
		{
		    TextDrawHideForPlayer(playerid,VehSellTD[VehListSelected[playerid]]);
			VehListSelected[playerid] = PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]]-1;
			TextDrawShowForPlayer(playerid,VehSellTD[VehListSelected[playerid]]);
		}
		if(PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]] > PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]]) PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]] = PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]];
		switch(PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]])
		{
		    case 1: format(str,256,"UPDATE drivers SET money=%d, vehiclesnum=1, actvehnum=%d, vehmodels='%d' WHERE drivername='%s'",PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]],PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]],PlayerInfo[playerid][pVehModel][3*PlayerInfo[playerid][pSelectedDriver]],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
		    case 2: format(str,256,"UPDATE drivers SET money=%d, vehiclesnum=2, actvehnum=%d, vehmodels='%d|%d' WHERE drivername='%s'",PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]],PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]],PlayerInfo[playerid][pVehModel][3*PlayerInfo[playerid][pSelectedDriver]],PlayerInfo[playerid][pVehModel][3*PlayerInfo[playerid][pSelectedDriver]+1],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
		}
		mysql_query(str);
		format(str,256,"SELECT vehparams%d FROM drivers WHERE drivername='%s'",VehListSelected[playerid]+1,DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
		mysql_query(str),mysql_store_result(),mysql_fetch_row(str),mysql_free_result();
		sscanf(str,"p<|>a<i>[16]",PlayerInfo[playerid][vParams]);
		DestroyVehicleEx(PlayerInfo[playerid][pVehID]);
		PlayerInfo[playerid][pVehID] = CreateVehicle(PlayerInfo[playerid][pVehModel][3*PlayerInfo[playerid][pSelectedDriver]+VehListSelected[playerid]],1925.5848,-2214.4021,14.0700,179.8839,0,0,-1);
		SetGVarInt("ownerid",playerid,PlayerInfo[playerid][pVehID]);
		SetVehicleTunning(playerid,PlayerInfo[playerid][pVehID]);
		SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
		for(new i = 0; i < 3; i++)
		{
			PlayerTextDrawHide(playerid,VehBuyTDPl[playerid][5+i]);
		    if(i < PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]])
		    {
                arid = VehModelToArrayID(PlayerInfo[playerid][pVehModel][i+3*PlayerInfo[playerid][pSelectedDriver]]);
                PlayerTextDrawSetString(playerid,VehListTDPl[playerid][i],VehiclesIndent[arid][Name]);
			}
			else
			{
			    PlayerTextDrawHide(playerid,VehListTDPl[playerid][i]);
			    PlayerTextDrawSetSelectable(playerid,VehListTDPl[playerid][i],false);
                PlayerTextDrawSetString(playerid,VehListTDPl[playerid][i],"Empty Car Slot");
                PlayerTextDrawShow(playerid,VehListTDPl[playerid][i]);
			}
		}
		arid = VehModelToArrayID(PlayerInfo[playerid][pVehModel][VehListSelected[playerid]+3*PlayerInfo[playerid][pSelectedDriver]]);
		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][5], 515.5+0.86*(VehiclesIndent[arid][TS]/3.0),0.0);
  		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][6], 515.5+0.86*(VehiclesIndent[arid][AR]/3.0),0.0);
  		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][7], 515.5+0.86*(VehiclesIndent[arid][HL]/3.0),0.0);
  		for(new i = 0; i < 3; i++) PlayerTextDrawShow(playerid,VehBuyTDPl[playerid][5+i]);
  		format(str,32,"$%d",VehiclesIndent[arid][Price]/100*70);
  		PlayerTextDrawSetString(playerid,VehBuyTDPl[playerid][8],str);
  		if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,20,false,false,false);
    	SendClientMessage(playerid,Colour_Yellow,"* Vehicle has been sold.");
		return 1;
	}
	if(clickedid == SafehouseTD[12])
	{
	    if(SafeHouseState[playerid] == SAFEHOUSE_STATE_VEH_CHANGE) return 1;
	    SafeHouseState[playerid] = SAFEHOUSE_STATE_VEH_CHANGE;
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,19,false,false,false);
	    for(new i = 0; i < 18; i++) TextDrawHideForPlayer(playerid,SafehouseTD[i]);
	    for(new i = 19; i < 24; i++) TextDrawHideForPlayer(playerid,SafehouseTD[i]);
	    for(new i = 0; i < 2; i++) TextDrawShowForPlayer(playerid,VehSelectTD[i]);
		TextDrawShowForPlayer(playerid,BackButton);
		TextDrawShowForPlayer(playerid,VehBuyTD[1]);
		for(new i = 9; i < 21; i++) TextDrawShowForPlayer(playerid,VehBuyTD[i]);
		new arid;
		for(new i = 0; i < 3; i++)
		{
		    if(i < PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]])
			{
			    arid = VehModelToArrayID(PlayerInfo[playerid][pVehModel][3*PlayerInfo[playerid][pSelectedDriver]+i]);
				PlayerTextDrawSetString(playerid,VehListTDPl[playerid][i],VehiclesIndent[arid][Name]);
				PlayerTextDrawSetSelectable(playerid,VehListTDPl[playerid][i],true);
			}
		    else
			{
				PlayerTextDrawSetString(playerid,VehListTDPl[playerid][i],"Empty Car Slot");
				PlayerTextDrawSetSelectable(playerid,VehListTDPl[playerid][i],false);
			}
			PlayerTextDrawShow(playerid,VehListTDPl[playerid][i]);
		}
		arid = VehModelToArrayID(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]]);
		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][5], 515.5+0.86*(VehiclesIndent[arid][TS]/3.0),0.0);
  		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][6], 515.5+0.86*(VehiclesIndent[arid][AR]/3.0),0.0);
  		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][7], 515.5+0.86*(VehiclesIndent[arid][HL]/3.0),0.0);
  		for(new i = 0; i < 3; i++) PlayerTextDrawShow(playerid,VehBuyTDPl[playerid][5+i]);
  		TextDrawShowForPlayer(playerid,VehSellTD[PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1]);
  		VehListSelected[playerid] = PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1;
  		return 1;
	}
	if(clickedid == VehSelectTD[1])
	{
	    if(SafeHouseState[playerid] == SAFEHOUSE_STATE_MAIN) return 1;
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,22,false,false,false);
		if(VehListSelected[playerid] != PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1)
		{
		    new str[256];
		    PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]] = VehListSelected[playerid]+1;
		    format(str,256,"UPDATE drivers SET actvehnum=%d WHERE drivername='%s'",PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
		    mysql_query(str);
		}
		for(new i = 0; i < 2; i++) TextDrawHideForPlayer(playerid,VehSelectTD[i]);
		TextDrawHideForPlayer(playerid,BackButton);
		TextDrawHideForPlayer(playerid,VehBuyTD[1]);
		for(new i = 9; i < 21; i++) TextDrawHideForPlayer(playerid,VehBuyTD[i]);
		for(new i = 0; i < 3; i++)
		{
			PlayerTextDrawHide(playerid,VehListTDPl[playerid][i]);
			PlayerTextDrawHide(playerid,VehBuyTDPl[playerid][5+i]);
		}
		TextDrawHideForPlayer(playerid,VehSellTD[VehListSelected[playerid]]);
		for(new i = 0; i < 18; i++) TextDrawShowForPlayer(playerid,SafehouseTD[i]);
	    for(new i = 19; i < 24; i++) TextDrawShowForPlayer(playerid,SafehouseTD[i]);
		SafeHouseState[playerid] = SAFEHOUSE_STATE_MAIN;
		return 1;
	}
	if(clickedid == TreasureTD[39])
	{
	    CancelSelectTextDraw(playerid);
	    if(Audio_IsClientConnected(playerid))
		{
			Audio_Play(playerid,17,false,false,false);
			new for_rand[2] = {2,3};
			FreeroamHandle[playerid] = Audio_Play(playerid,for_rand[random(2)],false,false,false);
		}
	    LookTreasureReward[playerid] = false;
	    for(new i = 0; i < 15; i++) TextDrawHideForPlayer(playerid,RepTD[i]);
	    PlayerTextDrawHide(playerid,RepTDPl[playerid][0]);
		PlayerTextDrawHide(playerid,RepTDPl[playerid][1]);
		TextDrawHideForPlayer(playerid,TreasureTD[39]);
		PlayerInfo[playerid][pExp][PlayerInfo[playerid][pSelectedDriver]] += RewardInfo[playerid][Reputation];
		if(PlayerInfo[playerid][pExp][PlayerInfo[playerid][pSelectedDriver]] >= 500*(PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]+1)*PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]])
		{
			PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]++;
			new str[128];
			format(str,128,"%d",PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]);
			PlayerTextDrawSetString(playerid,MainLineStructPl[playerid][1],str);
			format(str,128,"You has reached new level. Your current level is %d.",PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]);
			SendClientMessage(playerid,Colour_Yellow,str);
			if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,20,false,false,false);
			SetPlayerScore(playerid,PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]);
		}
		PlayerInfo[playerid][iNitro] += 10;
		PlayerInfo[playerid][iRam] += 10;
		PlayerInfo[playerid][iReady] += 10;
		UpdatePlayerExpLine(playerid);
		SaveDriver(playerid);
		TogglePlayerControllable(playerid,true);
		SetPlayerVirtualWorld(playerid,MAX_PLAYERS+1),SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],MAX_PLAYERS+1);
		SGivePlayerMoney(playerid,RewardInfo[playerid][Money]);
  		ShowSpeedometre(playerid);
  		ShowTreasureTDs(playerid);
		ShowBonuses(playerid);
		new str[128];
		format(str,128,"UPDATE drivers SET treasparams='%d|15|1' WHERE drivername='%s'",PlayerInfo[playerid][pTreasureDays],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
		mysql_query(str);
		return 1;
	}
	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(DriverChooseTDPl[playerid][2] <= playertextid <= DriverChooseTDPl[playerid][4])
	{
	    new i = _:playertextid-_:DriverChooseTDPl[playerid][2];
	    if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,18,false,false,false);
	    if(PlayerInfo[playerid][pSelectedDriver] == i) return 1;
	    new str[128],nameinf[48];
		TextDrawHideForPlayer(playerid,DriverChooseTD[10+PlayerInfo[playerid][pSelectedDriver]]);
		PlayerInfo[playerid][pSelectedDriver] = i;
		if(PlayerInfo[playerid][pVehID] != INVALID_VEHICLE_ID)
		{
			DestroyVehicleEx(PlayerInfo[playerid][pVehID]);
			PlayerInfo[playerid][pVehID] = INVALID_VEHICLE_ID;
		}
	    if(PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]] != 0)
		{
  			PlayerInfo[playerid][pVehID] = CreateVehicle(PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]],1925.5848,-2214.4021,14.0700,179.8839,0,0,-1);
  			SetGVarInt("ownerid",playerid,PlayerInfo[playerid][pVehID]);
	    	SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
	    	format(str,128,"SELECT vehparams%d FROM drivers WHERE drivername='%s' LIMIT 1",PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
	    	mysql_query(str),mysql_store_result(),mysql_fetch_row(str),mysql_free_result();
	    	sscanf(str,"p<|>a<i>[16]",PlayerInfo[playerid][vParams]);
	    	SetVehicleTunning(playerid,PlayerInfo[playerid][pVehID]);
	    	format(nameinf,48,VehicleName[PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]]-1+3*PlayerInfo[playerid][pSelectedDriver]]-400]);
		}
		else PlayerInfo[playerid][pVehID] = INVALID_VEHICLE_ID, format(nameinf,32,"No Vehicle");
		format(str,128,"SELECT bonuses FROM drivers WHERE drivername='%s'",DriverName[playerid][i]);
		mysql_query(str),mysql_store_result(),mysql_fetch_row(str),mysql_free_result();
		sscanf(str,"p<|>ddd",PlayerInfo[playerid][iNitro],PlayerInfo[playerid][iRam],PlayerInfo[playerid][iReady]);
		new Float:flvl = PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]],Float:fexp = PlayerInfo[playerid][pExp][PlayerInfo[playerid][pSelectedDriver]];
		new Float:line = 1.28*((fexp-500*flvl*(flvl-1.0))/((500*(flvl+1.0)*flvl-500*flvl*(flvl-1.0))/100.0));
		PlayerTextDrawHide(playerid,DriverChooseTDPl[playerid][1]);
		PlayerTextDrawTextSize(playerid,DriverChooseTDPl[playerid][1],line+476.360198,2.5);
		PlayerTextDrawShow(playerid,DriverChooseTDPl[playerid][1]);
		format(str,128,"]level %d ~n~ %s ~n~ %s",PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]],nameinf);
		PlayerTextDrawSetString(playerid,DriverChooseTDPl[playerid][0],str);
		TextDrawShowForPlayer(playerid,DriverChooseTD[10+PlayerInfo[playerid][pSelectedDriver]]);
		return 1;
	}
	if(VehListTDPl[playerid][0] <= playertextid <= VehListTDPl[playerid][2])
	{
		new i = _:playertextid-_:VehListTDPl[playerid][0];
		if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,18,false,false,false);
  		if(VehListSelected[playerid] == i) return 1;
    	new str[256],arid;
     	TextDrawHideForPlayer(playerid,VehSellTD[VehListSelected[playerid]]);
      	TextDrawShowForPlayer(playerid,VehSellTD[i]);
		VehListSelected[playerid] = i;
		format(str,256,"SELECT vehparams%d FROM drivers WHERE drivername='%s'",i+1,DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
		mysql_query(str),mysql_store_result(),mysql_fetch_row(str),mysql_free_result();
		sscanf(str,"p<|>a<i>[16]",PlayerInfo[playerid][vParams]);
		DestroyVehicleEx(PlayerInfo[playerid][pVehID]);
		PlayerInfo[playerid][pVehID] = CreateVehicle(PlayerInfo[playerid][pVehModel][3*PlayerInfo[playerid][pSelectedDriver]+i],1925.5848,-2214.4021,14.0700,179.8839,0,0,-1);
		SetGVarInt("ownerid",playerid,PlayerInfo[playerid][pVehID]);
		SetVehicleTunning(playerid,PlayerInfo[playerid][pVehID]);
		SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
		arid = VehModelToArrayID(PlayerInfo[playerid][pVehModel][3*PlayerInfo[playerid][pSelectedDriver]+i]);
		for(new p = 0; p < 3; p++) PlayerTextDrawHide(playerid,VehBuyTDPl[playerid][5+p]);
		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][5], 515.5+0.86*(VehiclesIndent[arid][TS]/3.0),0.0);
		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][6], 515.5+0.86*(VehiclesIndent[arid][AR]/3.0),0.0);
		PlayerTextDrawTextSize(playerid, VehBuyTDPl[playerid][7], 515.5+0.86*(VehiclesIndent[arid][HL]/3.0),0.0);
		for(new p = 0; p < 3; p++) PlayerTextDrawShow(playerid,VehBuyTDPl[playerid][5+p]);
		if(SafeHouseState[playerid] == SAFEHOUSE_STATE_DEALER_SELL)
		{
			format(str,32,"$%d",VehiclesIndent[arid][Price]/100*70);
			PlayerTextDrawSetString(playerid,VehBuyTDPl[playerid][8],str);
		}
		return 1;
	}
	return 1;
}

public OnPlayerText(playerid,text[])
{
	if(InGame[playerid])
	{
	    if(PlayerInfo[playerid][pChatRoom] == -1)
		{
			SendClientMessage(playerid,Colour_Red,"[*] You have been muted.");
			return 0;
		}
	    if(Iter_Count(ChatRoom[PlayerInfo[playerid][pChatRoom]]) != 0)
	    {
	        new str[128],bool:pr = true,ttext[96],li = 0;
			for(new i = 0; (i < 95) && (i < strlen(text)); i++)
			{
   				if(text[i] == ' ')
			    {
       				if(pr) continue;
			        else
			        {
						ttext[li] = text[i];
						pr = true;
						li++;
					}
				}
				else
				{
					ttext[li] = text[i];
					li++;
					pr = false;
				}
			}
			ttext[li] = '\0';
			if(!strlen(ttext)) return 0;
	        format(str,128,"{A9353E}[{85E4CC}%s{A9353E}]: %s",DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]],ttext);
	        foreach(new i : ChatRoom[PlayerInfo[playerid][pChatRoom]]) SendClientMessage(i,-1,str);
		}
	}
	return 0;
}

public OnVehicleDeath(vehicleid,killerid)
{
	SetGVarInt("dead",1,vehicleid);
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
    SetGVarInt("dead",0,vehicleid);
	return 1;
}

public OnPlayerDeath(playerid,killerid,reason)
{
	Kick(playerid);
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	printf("OnVehicleMod(%d, %d, %d)",playerid, vehicleid, componentid);
	if(playerid != INVALID_PLAYER_ID)
	{
	    if(componentid == 1010)
	    {
	        if(GetVehicleComponentInSlot(vehicleid,CARMODTYPE_NITRO) != 1010)
			{
				if(PlayerInfo[playerid][tNitro] != -1) return 1;
				else return 0;
			}
			else return 0;
		}
		else return 0;
	}
	return 1;
}

public OnEnterExitModShop(playerid, enterexit, interiorid)
{
	Kick(playerid);
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	if(playerid != INVALID_PLAYER_ID)
	{
		if(PlayerInfo[playerid][vParams][15] != paintjobid)
		{
			if(PlayerInfo[playerid][vParams][15] == -1) ChangeVehiclePaintjob(vehicleid,3);
			else ChangeVehiclePaintjob(vehicleid,PlayerInfo[playerid][vParams][15]);
		}
	}
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	if(playerid != INVALID_PLAYER_ID)
	{
	    if(PlayerInfo[playerid][vParams][13] != color1 || PlayerInfo[playerid][vParams][14] != color1) ChangeVehicleColor(vehicleid,color1,color2);
	}
	return 1;
}

public OnRconLoginAttempt( ip[], password[], success )
{
	if(!success)
	{
	    new str[64];
	    format(str,64,"banip %s",ip);
	    SendRconCommand(str);
	}
	return 1;
}

public OnPlayerEnterDynamicArea(playerid,areaid)
{
	if(RaceInfo[0][AreaID] <= areaid <= RaceInfo[MAX_RACES-1][AreaID])
	{
	    if(InFreeRoam[playerid])
	    {
	        new str[64];
			if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,6,false,false,false);
			for(new i = 0; i < 4; i++) TextDrawShowForPlayer(playerid,RaceTD[i]);
			if(PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]] >= RaceInfo[areaid-RaceInfo[0][AreaID]][Level])
   			{
			   	for(new i = 4; i < 12; i++) TextDrawShowForPlayer(playerid,RaceTD[i]);
				RaceStartZone[playerid] = areaid-RaceInfo[0][AreaID];
			}
			else for(new i = 12; i < 14; i++) TextDrawShowForPlayer(playerid,RaceTD[i]);
			format(str,64,"%s~n~%s",RaceInfo[areaid-RaceInfo[0][AreaID]][Type],RaceInfo[areaid-RaceInfo[0][AreaID]][Name]);
			PlayerTextDrawSetString(playerid,RaceTDPl[playerid][0],str);
			format(str,64,"] level %d~n~%d km~n~%d drivers",RaceInfo[areaid-RaceInfo[0][AreaID]][Level],RaceInfo[areaid-RaceInfo[0][AreaID]][Dist],RaceInfo[areaid-RaceInfo[0][AreaID]][MaxDrivers]);
			PlayerTextDrawSetString(playerid,RaceTDPl[playerid][1],str);
			for(new i = 0; i < 2; i++) PlayerTextDrawShow(playerid,RaceTDPl[playerid][i]);
		}
		return 1;
	}
	if((WaterArea <= areaid <= SfLake) && IsPlayerInVehicle(playerid,PlayerInfo[playerid][pVehID]))
	{
	    if((IsPlayerInDynamicArea(playerid,Digger)||IsPlayerInDynamicArea(playerid,Airport)||IsPlayerInDynamicArea(playerid,Trails)) && areaid == WaterArea) return 1;
	    else
	    {
	        new Float:v[3];
	        GetVehiclePos(PlayerInfo[playerid][pVehID],v[0],v[1],v[2]);
	        SetVehiclePos(PlayerInfo[playerid][pVehID],v[0],v[1],-150.0);
		}
		return 1;
	}
	if((Digger <= areaid <= Trails) && IsPlayerInVehicle(playerid,PlayerInfo[playerid][pVehID])) return 1;
	if(InRace[playerid])
	{
	    new str[64],str1[64],drv,apid,narea;
		format(str,64,"EI[%d][Started]",RaceStartZone[playerid]);
		if(GetGVarInt(str,JoinedJNum[playerid]))
		{
		    format(str,64,"EI[%d][DriversNum]",RaceStartZone[playerid]);
		    drv = GetGVarInt(str,JoinedJNum[playerid]);
			if(!strcmp(RaceInfo[RaceStartZone[playerid]][Type],"Sprint",true))
			{
				if(EventArea[playerid] < areaid)
				{
				    NumPassedArea[playerid]++;
				    for(new p = 0; p < drv; p++)
				    {
				        format(str,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],p);
				        narea = GetGVarInt(str,JoinedJNum[playerid]);
				        format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],p);
				        apid = GetGVarInt(str,JoinedJNum[playerid]);
				        if(areaid > narea && apid != playerid)
						{
						    for(new pp = 0; pp < drv; pp++)
						    {
						        format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],pp);
						        apid = GetGVarInt(str,JoinedJNum[playerid]);
						        if(apid == playerid)
						        {
						            for(new s = pp; s > p; s--)
						            {
						                format(str1,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],s-1);
						                format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],s);
						                SetGVarInt(str,GetGVarInt(str1,JoinedJNum[playerid]),JoinedJNum[playerid]);
						                format(str1,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],s-1);
						                format(str,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],s);
						                SetGVarInt(str,GetGVarInt(str1,JoinedJNum[playerid]),JoinedJNum[playerid]);
										format(str,64,"EI[%d][RacerName][%d]",RaceStartZone[playerid],s-1);
										GetGVarString(str,str,64,JoinedJNum[playerid]);
										format(str1,64,"EI[%d][RacerName][%d]",RaceStartZone[playerid],s);
										SetGVarString(str1,str,JoinedJNum[playerid]);
						                format(str,12,"%d/%d",s+1,drv);
						                format(str1,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],s);
						                apid = GetGVarInt(str1,JoinedJNum[playerid]);
						                PlayerTextDrawSetString(apid,EventTDPl[apid][0],str);
									}
									format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],p);
									SetGVarInt(str,playerid,JoinedJNum[playerid]);
									format(str,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],p);
		       						SetGVarInt(str,areaid,JoinedJNum[playerid]);
		       						format(str,64,"EI[%d][RacerName][%d]",RaceStartZone[playerid],p);
		       						SetGVarString(str,DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]],JoinedJNum[playerid]);
		       						format(str,12,"%d/%d",p+1,drv);
		       						PlayerTextDrawSetString(playerid,EventTDPl[playerid][0],str);
									UpdatePlaceTDForEvent(RaceStartZone[playerid],JoinedJNum[playerid]);
						            break;
								}
							}
							break;
						}
						else
						{
							if(apid == playerid)
							{
							    format(str,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],p);
							    SetGVarInt(str,areaid,JoinedJNum[playerid]);
								break;
							}
						}
					}
					if(WrongWay[playerid])
					{
						HidePlayerBrick(playerid);
						WrongWay[playerid] = false;
		    		}
				}
				if(EventArea[playerid] > areaid)
				{
				    NumPassedArea[playerid]--;
				    for(new p = 0; p < drv; p++)
				    {
				        format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],p);
				        apid = GetGVarInt(str,JoinedJNum[playerid]);
				        if(apid == playerid && p != drv-1)
				        {
				            for(new ap = p; ap < drv; ap++)
				            {
				                format(str,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],ap);
				                narea = GetGVarInt(str,JoinedJNum[playerid]);
				                if(narea > areaid)
				                {
				                    format(str1,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],p+1);
				                    format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],p);
				                    SetGVarInt(str,GetGVarInt(str1,JoinedJNum[playerid]),JoinedJNum[playerid]);
				                    format(str1,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],p+1);
				                    format(str,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],p);
				                    SetGVarInt(str,GetGVarInt(str1,JoinedJNum[playerid]),JoinedJNum[playerid]);
									format(str,64,"EI[%d][RacerName][%d]",RaceStartZone[playerid],p+1);
									GetGVarString(str,str,64,JoinedJNum[playerid]);
									format(str1,64,"EI[%d][RacerName][%d]",RaceStartZone[playerid],p);
									SetGVarString(str1,str,JoinedJNum[playerid]);
		              				format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],p+1);
		              				SetGVarInt(str,playerid,JoinedJNum[playerid]);
		              				format(str,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],p+1);
		              				SetGVarInt(str,areaid,JoinedJNum[playerid]);
									format(str,64,"EI[%d][RacerName][%d]",RaceStartZone[playerid],p+1);
									SetGVarString(str,DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]],JoinedJNum[playerid]);
		       						format(str,12,"%d/%d",p+2,drv);
		       						PlayerTextDrawSetString(playerid,EventTDPl[playerid][0],str);
		       						format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],p);
		       						apid = GetGVarInt(str,JoinedJNum[playerid]);
		       						format(str,12,"%d/%d",p+1,drv);
		       						PlayerTextDrawSetString(apid,EventTDPl[apid][0],str);
		                            UpdatePlaceTDForEvent(RaceStartZone[playerid],JoinedJNum[playerid]);
									break;
								}
							}
							break;
						}
					}
					if(!WrongWay[playerid])
					{
						ShowPlayerBrick(playerid);
						WrongWay[playerid] = true;
		    		}
				}
				EventArea[playerid] = areaid;
				new stt[12];
				format(stt,12,"%.0f%%",floatdiv(NumPassedArea[playerid],floatdiv(RaceInfo[RaceStartZone[playerid]][AreaNum],100.0)));
				PlayerTextDrawSetString(playerid,EventTDPl[playerid][1],stt);
				if(areaid == RaceInfo[RaceStartZone[playerid]][FinishArea])
				{
				    for(new i = 0; i < drv; i++)
				    {
				        format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],i);
				        apid = GetGVarInt(str,JoinedJNum[playerid]);
				        if(apid == playerid)
				        {
				            if(i == 0)
							{
							    format(str,64,"EI[%d][Time]",RaceStartZone[playerid]);
								if(GetGVarInt(str,JoinedJNum[playerid]) > 60) SetGVarInt(str,60,JoinedJNum[playerid]);
							}
				            format(str,64,"EI[%d][AtFinish][%d]",RaceStartZone[playerid],i);
				            SetGVarInt(str,1,JoinedJNum[playerid]);
				            format(str,64,"EI[%d][FinishTime][%d]",RaceStartZone[playerid],i);
				            SetGVarInt(str,GetTickCount(),JoinedJNum[playerid]);
				            format(str,64,"EI[%d][LeavedPlayers]",RaceStartZone[playerid]);
				            SetGVarInt(str,GetGVarInt(str,JoinedJNum[playerid])+1,JoinedJNum[playerid]);
				            InRace[playerid] = false;
				            TogglePlayerControllable(playerid,false);
				            SetPlayerVirtualWorld(playerid,playerid+1),SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
				            LookingFinishList[playerid] = true;
							for(new t = 0; t < 3; t++) TextDrawHideForPlayer(playerid,EventTD[t]);
							HideBonuses(playerid);
							for(new t = 0; t < 5; t++) PlayerTextDrawHide(playerid,EventTDPl[playerid][t]);
							TextDrawShowForPlayer(playerid,FinishTD[0]);
							TextDrawShowForPlayer(playerid,DriversListTD[1]);
							for(new t = 10; t < 14; t++) TextDrawShowForPlayer(playerid,FinishTD[t]);
							for(new t = 0; t < 8; t++)
							{
							    if(t < drv) PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][t*2],"Waiting...");
							    else PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][t*2],"Empty slot");
							    TextDrawShowForPlayer(playerid,DriversListTD[2+t*2]);
							    TextDrawShowForPlayer(playerid,DriversListTD[2+t*2+1]);
							}
							for(new t = 0; t < 16; t++)
							{
								if(t%2 == 0 && t <= i) PlayerTextDrawColor(playerid,DriversListTDPl[playerid][t],-1);
								PlayerTextDrawShow(playerid,DriversListTDPl[playerid][t]);
							}
							TextDrawShowForPlayer(playerid,DriversListTD[18+i]);
							format(str,64,"EI[%d][EventTimeStart]",RaceStartZone[playerid]);
							new time = GetGVarInt(str,JoinedJNum[playerid]);
							format(str,64,"EI[%d][FinishTime][%d]",RaceStartZone[playerid],i);
							time = (GetGVarInt(str,JoinedJNum[playerid])-time)/1000;
							format(str,64,"%02d:%02d",time/60,time-(time/60)*60);
							PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][i*2+1],str);
							PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][i*2],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
							for(new p = 0; p <= i; p++)
							{
							    if(p < 3)
								{
									TextDrawHideForPlayer(playerid,DriversListTD[2+p*2]);
									TextDrawHideForPlayer(playerid,DriversListTD[2+p*2+1]);
									TextDrawShowForPlayer(playerid,FinishTD[1+p*3]);
									TextDrawShowForPlayer(playerid,FinishTD[1+p*3+1]);
									TextDrawShowForPlayer(playerid,FinishTD[1+p*3+2]);
								}
								if(i != p)
								{
								    format(str,64,"EI[%d][FinishTime][%d]",RaceStartZone[playerid],i);
								    time = GetGVarInt(str,JoinedJNum[playerid]);
								    format(str,64,"EI[%d][FinishTime][%d]",RaceStartZone[playerid],p);
								    time = (time-GetGVarInt(str,JoinedJNum[playerid]))/1000;
									format(str,64,"-%02d:%02d",time/60,time-(time/60)*60);
									PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][p*2+1],str);
									format(str,64,"EI[%d][RacerName][%d]",RaceStartZone[playerid],p);
									GetGVarString(str,str,64,JoinedJNum[playerid]);
									PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][p*2],str);
									format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],p);
									apid = GetGVarInt(str,JoinedJNum[playerid]);
									if(LookingFinishList[apid] && RaceStartZone[apid] == RaceStartZone[playerid] && JoinedJNum[apid] == JoinedJNum[playerid])
									{
										format(str,64,"+%02d:%02d",time/60,time-(time/60)*60);
									    PlayerTextDrawSetString(apid,DriversListTDPl[apid][i*2+1],str);
									    PlayerTextDrawSetString(apid,DriversListTDPl[apid][i*2],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
									    if(i < 3)
									    {
									        TextDrawHideForPlayer(apid,DriversListTD[2+i*2]);
											TextDrawHideForPlayer(apid,DriversListTD[2+i*2+1]);
											TextDrawShowForPlayer(apid,FinishTD[1+i*3]);
											TextDrawShowForPlayer(apid,FinishTD[1+i*3+1]);
											TextDrawShowForPlayer(apid,FinishTD[1+i*3+2]);
										}
										PlayerTextDrawHide(apid,DriversListTDPl[apid][i*2]);
									    PlayerTextDrawColor(apid,DriversListTDPl[apid][i*2],-1);
									    PlayerTextDrawShow(apid,DriversListTDPl[apid][i*2]);
									}
								}
				            }
				            HideSpeedometre(playerid);
				            if(Audio_IsClientConnected(playerid))
				            {
					            Audio_Stop(playerid,EventHandle[playerid]);
								FinishHandle[playerid] = Audio_Play(playerid,14,false,false,false);
							}
							if(NumPassedArea[playerid] >= RaceInfo[RaceStartZone[playerid]][AreaNum])
							{
								RewardInfo[playerid][Reputation] = 50*drv+100*(drv-i)+75*PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]];
								RewardInfo[playerid][Money] = 35*drv+65*(drv-i)+30*PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]];
							}
							else
							{
							    RewardInfo[playerid][Reputation] = 0;
								RewardInfo[playerid][Money] = 0;
							}
		                    SelectTextDraw(playerid,0x73B1EDFF);
		                    format(str,64,"EI[%d][LeavedPlayers]",RaceStartZone[playerid]);
		                    SetGVarInt(str,GetGVarInt(str,JoinedJNum[playerid])+1,JoinedJNum[playerid]);
							if(i >= drv-1) ClearEventAndJoin(RaceStartZone[playerid],JoinedJNum[playerid]);
                			break;
						}
					}
				}
				return 1;
			}
			if(!strcmp(RaceInfo[RaceStartZone[playerid]][Type],"Circuit",true))
			{
			    if(areaid-EventArea[playerid] == 1) //player moves right to next DA.
			    {
			        for(new p = 0; p < drv; p++)
			        {
			            format(str,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],p);
			            narea = GetGVarInt(str,JoinedJNum[playerid]);
						format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],p);
						apid = GetGVarInt(str,JoinedJNum[playerid]);
           				if(areaid+RaceInfo[RaceStartZone[playerid]][AreaNum]*(CurLap[playerid]-1) > narea && apid != playerid)
						{
						    for(new pp = 0; pp < drv; pp++)
						    {
						        format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],pp);
						        apid = GetGVarInt(str,JoinedJNum[playerid]);
						        if(apid == playerid)
						        {
						            for(new s = pp; s > p; s--)
						            {
						                format(str1,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],s);
						                format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],s-1);
						                SetGVarInt(str1,GetGVarInt(str,JoinedJNum[playerid]),JoinedJNum[playerid]);
                                        format(str1,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],s);
						                format(str,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],s-1);
						                SetGVarInt(str1,GetGVarInt(str,JoinedJNum[playerid]),JoinedJNum[playerid]);
                                        format(str1,64,"EI[%d][RacerName][%d]",RaceStartZone[playerid],s);
						                format(str,64,"EI[%d][RacerName][%d]",RaceStartZone[playerid],s-1);
						                GetGVarString(str,str,64,JoinedJNum[playerid]);
						                SetGVarString(str1,str,JoinedJNum[playerid]);
						                format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],s);
						                apid = GetGVarInt(str,JoinedJNum[playerid]);
						                format(str,12,"%d/%d",s+1,drv);
						                PlayerTextDrawSetString(apid,EventTDPl[apid][0],str);
									}
									format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],p);
									SetGVarInt(str,playerid,JoinedJNum[playerid]);
									format(str,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],p);
									SetGVarInt(str,areaid+RaceInfo[RaceStartZone[playerid]][AreaNum]*(CurLap[playerid]-1),JoinedJNum[playerid]);
									format(str,64,"EI[%d][RacerName][%d]",RaceStartZone[playerid],p);
									SetGVarString(str,DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]],JoinedJNum[playerid]);
		       						format(str,12,"%d/%d",p+1,drv);
		       						PlayerTextDrawSetString(playerid,EventTDPl[playerid][0],str);
									UpdatePlaceTDForEvent(RaceStartZone[playerid],JoinedJNum[playerid]);
						            break;
								}
							}
							break;
						}
						else
						{
							if(apid == playerid)
							{
								format(str,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],p);
								SetGVarInt(str,areaid+RaceInfo[RaceStartZone[playerid]][AreaNum]*(CurLap[playerid]-1),JoinedJNum[playerid]);
							    break;
							}
						}
					}
					EventArea[playerid] = areaid;
					if(WrongWay[playerid])
					{
						HidePlayerBrick(playerid);
						WrongWay[playerid] = false;
    				}
					if(areaid == RaceInfo[RaceStartZone[playerid]][FinishArea])
					{
						CurLap[playerid]++;
						format(str,12,"%d/%d Lap",CurLap[playerid],RaceInfo[RaceStartZone[playerid]][Laps]);
						PlayerTextDrawSetString(playerid,EventTDPl[playerid][1],str);
					}
					if(CurLap[playerid] > RaceInfo[RaceStartZone[playerid]][Laps])
					{
					    for(new i = 0; i < drv; i++)
					    {
					        format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],i);
					        apid = GetGVarInt(str,JoinedJNum[playerid]);
					        if(apid == playerid)
					        {
					            if(i == 0)
								{
								    format(str,64,"EI[%d][Time]",RaceStartZone[playerid]);
									if(GetGVarInt(str,JoinedJNum[playerid]) > 60) SetGVarInt(str,60,JoinedJNum[playerid]);
								}
					            format(str,64,"EI[%d][AtFinish][%d]",RaceStartZone[playerid],i);
					            SetGVarInt(str,1,JoinedJNum[playerid]);
					            format(str,64,"EI[%d][FinishTime][%d]",RaceStartZone[playerid],i);
					            SetGVarInt(str,GetTickCount(),JoinedJNum[playerid]);
					            format(str,64,"EI[%d][LeavedPlayers]",RaceStartZone[playerid]);
					            SetGVarInt(str,GetGVarInt(str,JoinedJNum[playerid])+1,JoinedJNum[playerid]);
					            InRace[playerid] = false;
					            TogglePlayerControllable(playerid,false);
					            SetPlayerVirtualWorld(playerid,playerid+1),SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
					            LookingFinishList[playerid] = true;
								for(new t = 0; t < 3; t++) TextDrawHideForPlayer(playerid,EventTD[t]);
								HideBonuses(playerid);
								for(new t = 0; t < 5; t++) PlayerTextDrawHide(playerid,EventTDPl[playerid][t]);
								TextDrawShowForPlayer(playerid,FinishTD[0]);
								TextDrawShowForPlayer(playerid,DriversListTD[1]);
								for(new t = 10; t < 14; t++) TextDrawShowForPlayer(playerid,FinishTD[t]);
								for(new t = 0; t < 8; t++)
								{
								    if(t < drv) PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][t*2],"Waiting...");
								    else PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][t*2],"Empty slot");
								    TextDrawShowForPlayer(playerid,DriversListTD[2+t*2]);
								    TextDrawShowForPlayer(playerid,DriversListTD[2+t*2+1]);
								}
								for(new t = 0; t < 16; t++)
								{
									if(t%2 == 0 && t <= i) PlayerTextDrawColor(playerid,DriversListTDPl[playerid][t],-1);
									PlayerTextDrawShow(playerid,DriversListTDPl[playerid][t]);
								}
								TextDrawShowForPlayer(playerid,DriversListTD[18+i]);
								format(str,64,"EI[%d][EventTimeStart]",RaceStartZone[playerid]);
								new time = GetGVarInt(str,JoinedJNum[playerid]);
								format(str,64,"EI[%d][FinishTime][%d]",RaceStartZone[playerid],i);
								time = (GetGVarInt(str,JoinedJNum[playerid])-time)/1000;
								format(str,64,"%02d:%02d",time/60,time-(time/60)*60);
								PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][i*2+1],str);
								PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][i*2],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
								for(new p = 0; p <= i; p++)
								{
								    if(p < 3)
									{
										TextDrawHideForPlayer(playerid,DriversListTD[2+p*2]);
										TextDrawHideForPlayer(playerid,DriversListTD[2+p*2+1]);
										TextDrawShowForPlayer(playerid,FinishTD[1+p*3]);
										TextDrawShowForPlayer(playerid,FinishTD[1+p*3+1]);
										TextDrawShowForPlayer(playerid,FinishTD[1+p*3+2]);
									}
									if(i != p)
									{
									    format(str,64,"EI[%d][FinishTime][%d]",RaceStartZone[playerid],i);
									    time = GetGVarInt(str,JoinedJNum[playerid]);
									    format(str,64,"EI[%d][FinishTime][%d]",RaceStartZone[playerid],p);
									    time = (time-GetGVarInt(str,JoinedJNum[playerid]))/1000;
										format(str,64,"-%02d:%02d",time/60,time-(time/60)*60);
										PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][p*2+1],str);
										format(str,64,"EI[%d][RacerName][%d]",RaceStartZone[playerid],p);
										GetGVarString(str,str,64,JoinedJNum[playerid]);
										PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][p*2],str);
										format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],p);
										apid = GetGVarInt(str,JoinedJNum[playerid]);
										if(LookingFinishList[apid] && RaceStartZone[apid] == RaceStartZone[playerid] && JoinedJNum[apid] == JoinedJNum[playerid])
										{
											format(str,64,"+%02d:%02d",time/60,time-(time/60)*60);
										    PlayerTextDrawSetString(apid,DriversListTDPl[apid][i*2+1],str);
										    PlayerTextDrawSetString(apid,DriversListTDPl[apid][i*2],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
										    if(i < 3)
										    {
										        TextDrawHideForPlayer(apid,DriversListTD[2+i*2]);
												TextDrawHideForPlayer(apid,DriversListTD[2+i*2+1]);
												TextDrawShowForPlayer(apid,FinishTD[1+i*3]);
												TextDrawShowForPlayer(apid,FinishTD[1+i*3+1]);
												TextDrawShowForPlayer(apid,FinishTD[1+i*3+2]);
											}
											PlayerTextDrawHide(apid,DriversListTDPl[apid][i*2]);
										    PlayerTextDrawColor(apid,DriversListTDPl[apid][i*2],-1);
										    PlayerTextDrawShow(apid,DriversListTDPl[apid][i*2]);
										}
									}
					            }
					            HideSpeedometre(playerid);
					            if(Audio_IsClientConnected(playerid))
					            {
						            Audio_Stop(playerid,EventHandle[playerid]);
									FinishHandle[playerid] = Audio_Play(playerid,14,false,false,false);
								}
								RewardInfo[playerid][Reputation] = 50*drv+100*(drv-i)+75*PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]];
								RewardInfo[playerid][Money] = 35*drv+65*(drv-i)+30*PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]];
			                    SelectTextDraw(playerid,0x73B1EDFF);
			                    format(str,64,"EI[%d][LeavedPlayers]",RaceStartZone[playerid]);
			                    SetGVarInt(str,GetGVarInt(str,JoinedJNum[playerid])+1,JoinedJNum[playerid]);
								if(i >= drv-1) ClearEventAndJoin(RaceStartZone[playerid],JoinedJNum[playerid]);
					            break;
							}
						}
					}
			    }
			    else
			    {
			        if(areaid-EventArea[playerid] < 0)
			        {
						if(EventArea[playerid] == RaceInfo[RaceStartZone[playerid]][FinishArea] && areaid == FirstRaceArea[RaceStartZone[playerid]]) //player moves right, last DA which he passed is finish area
						{
						    for(new p = 0; p < drv; p++)
					        {
					            format(str,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],p);
					            narea = GetGVarInt(str,JoinedJNum[playerid]);
								format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],p);
								apid = GetGVarInt(str,JoinedJNum[playerid]);
		           				if(areaid+RaceInfo[RaceStartZone[playerid]][AreaNum]*(CurLap[playerid]-1) > narea && apid != playerid)
								{
								    for(new pp = 0; pp < drv; pp++)
								    {
								        format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],pp);
								        apid = GetGVarInt(str,JoinedJNum[playerid]);
								        if(apid == playerid)
								        {
								            for(new s = pp; s > p; s--)
								            {
								                format(str1,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],s);
								                format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],s-1);
								                SetGVarInt(str1,GetGVarInt(str,JoinedJNum[playerid]),JoinedJNum[playerid]);
		                                        format(str1,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],s);
								                format(str,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],s-1);
								                SetGVarInt(str1,GetGVarInt(str,JoinedJNum[playerid]),JoinedJNum[playerid]);
		                                        format(str1,64,"EI[%d][RacerName][%d]",RaceStartZone[playerid],s);
								                format(str,64,"EI[%d][RacerName][%d]",RaceStartZone[playerid],s-1);
								                GetGVarString(str,str,64,JoinedJNum[playerid]);
								                SetGVarString(str1,str,JoinedJNum[playerid]);
								                format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],s);
								                apid = GetGVarInt(str,JoinedJNum[playerid]);
								                format(str,12,"%d/%d",s+1,drv);
								                PlayerTextDrawSetString(apid,EventTDPl[apid][0],str);
											}
											format(str,64,"EI[%d][PIDPlace][%d]",RaceStartZone[playerid],p);
											SetGVarInt(str,playerid,JoinedJNum[playerid]);
											format(str,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],p);
											SetGVarInt(str,areaid+RaceInfo[RaceStartZone[playerid]][AreaNum]*(CurLap[playerid]-1),JoinedJNum[playerid]);
											format(str,64,"EI[%d][RacerName][%d]",RaceStartZone[playerid],p);
											SetGVarString(str,DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]],JoinedJNum[playerid]);
				       						format(str,12,"%d/%d",p+1,drv);
				       						PlayerTextDrawSetString(playerid,EventTDPl[playerid][0],str);
											UpdatePlaceTDForEvent(RaceStartZone[playerid],JoinedJNum[playerid]);
								            break;
										}
									}
									break;
								}
								else
								{
									if(apid == playerid)
									{
										format(str,64,"EI[%d][AreaPlace][%d]",RaceStartZone[playerid],p);
										SetGVarInt(str,areaid+RaceInfo[RaceStartZone[playerid]][AreaNum]*(CurLap[playerid]-1),JoinedJNum[playerid]);
									    break;
									}
								}
							}
							EventArea[playerid] = areaid;
							if(WrongWay[playerid])
							{
								HidePlayerBrick(playerid);
								WrongWay[playerid] = false;
				    		}
						}
						else
						{
							if(areaid-EventArea[playerid] == -1) //player moves wrong to previous DA than he passed
							{
							    if(!WrongWay[playerid])
								{
									ShowPlayerBrick(playerid);
									WrongWay[playerid] = true;
							    }
							}
						}
					}
					else
					{
						if(areaid-EventArea[playerid] > 1) //player passed first area, but has returned to finish area or moved to previous DA belong finish DA. Wrong moving
						{
						    if(areaid != RaceInfo[RaceStartZone[playerid]][FinishArea] && EventArea[playerid] != FirstRaceArea[RaceStartZone[playerid]]-1)
						    {
	                        	if(!WrongWay[playerid])
								{
									ShowPlayerBrick(playerid);
									WrongWay[playerid] = true;
							    }
							}
						}
						else
						{
						    if(areaid == EventArea[playerid])
						    {
						        if(WrongWay[playerid])
								{
									HidePlayerBrick(playerid);
									WrongWay[playerid] = false;
			    				}
							}
						}
					}
				}
			}
		}
		return 1;
	}
	if(PlayerInfo[playerid][trCollected] != 15)
	{
	    if(PlayerInfo[playerid][trArea][0] <= areaid <= PlayerInfo[playerid][trArea][15-PlayerInfo[playerid][trCollected]-1])
		{
		    for(new i = 0; i < 15-PlayerInfo[playerid][trCollected]; i++)
			{
			    if(PlayerInfo[playerid][trArea][i] == areaid)
			    {
					PlayerInfo[playerid][trCollected]++;
					DestroyDynamicMapIcon(PlayerInfo[playerid][trIcon][i]);
					DestroyDynamicObject(PlayerInfo[playerid][trObj][i*2]);
					DestroyDynamicObject(PlayerInfo[playerid][trObj][i*2+1]);
					DestroyDynamicArea(PlayerInfo[playerid][trArea][i]);
					if(PlayerInfo[playerid][trCollected] != 15)
					{
						for(new b = i; b < 15-PlayerInfo[playerid][trCollected]; b++)
						{
						    PlayerInfo[playerid][trIcon][b] = PlayerInfo[playerid][trIcon][b+1];
						    PlayerInfo[playerid][trObj][b*2] = PlayerInfo[playerid][trObj][(b+1)*2];
						    PlayerInfo[playerid][trObj][b*2+1] = PlayerInfo[playerid][trObj][(b+1)*2+1];
						    PlayerInfo[playerid][trArea][b] = PlayerInfo[playerid][trArea][b+1];
						}
						if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,23,false,false,false);
						new str[128];
						format(str,12,"%d/15",PlayerInfo[playerid][trCollected]);
						PlayerTextDrawSetString(playerid,TreasureTDPl[playerid][0],str);
						format(str,128,"UPDATE drivers SET treasparams='%d|%d|0' WHERE drivername='%s'",PlayerInfo[playerid][pTreasureDays],PlayerInfo[playerid][trCollected],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
						mysql_query(str);
					}
					else
					{
					    PlayerInfo[playerid][pCollectedLastTime] = 1;
					    HideBonuses(playerid);
					    HideTreasureTDs(playerid);
					    HideSpeedometre(playerid);
						if(Audio_IsClientConnected(playerid))
						{
							if(FreeroamHandle[playerid] != -1) Audio_Stop(playerid,FreeroamHandle[playerid]);
							Audio_Play(playerid,24,false,false,false);
						}
						TogglePlayerControllable(playerid,false);
						SetPlayerVirtualWorld(playerid,playerid+1),SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],playerid+1);
						for(new b = 35; b < 39; b++) TextDrawShowForPlayer(playerid,TreasureTD[b]);
						TreasureTimer[playerid] = SetTimerEx("TreasureReward",2500,false,"d",playerid);
						LookTreasureReward[playerid] = true;
						RewardInfo[playerid][Reputation] = PlayerInfo[playerid][pTreasureDays]*50;
						RewardInfo[playerid][Money] = PlayerInfo[playerid][pTreasureDays]*100;
					}
					break;
				}
			}
			return 1;
		}
	}
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid,areaid)
{
	if(RaceInfo[0][AreaID] <= areaid <= RaceInfo[MAX_RACES-1][AreaID])
	{
	    new rid = areaid-RaceInfo[0][AreaID];
	    if(JoinedInRace[playerid]) return 1;
	    if(InFreeRoam[playerid] && JoinTimer[playerid] == -1)
	    {
			if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,7,false,false,false);
			for(new i = 0; i < 4; i++) TextDrawHideForPlayer(playerid,RaceTD[i]);
			if(PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]] >= RaceInfo[rid][Level])
   			{
			   	for(new i = 4; i < 12; i++) TextDrawHideForPlayer(playerid,RaceTD[i]);
			   	RaceStartZone[playerid] = -1;
			}
			else
   			{
			   	for(new i = 12; i < 14; i++) TextDrawHideForPlayer(playerid,RaceTD[i]);
			}
			for(new i = 0; i < 2; i++) PlayerTextDrawHide(playerid,RaceTDPl[playerid][i]);
			return 1;
		}
  		if(JoinTimer[playerid] != -1)
	    {
	        KillTimer(JoinTimer[playerid]);
	    	JoinTimer[playerid] = -1;
		    CancelSeconds[playerid] = 0;
			JoinedJNum[playerid] = -1;
			for(new i = 0; i < 16; i++) TextDrawHideForPlayer(playerid,RaceTD[i]);
			for(new i = 0; i < 3; i++) PlayerTextDrawHide(playerid,RaceTDPl[playerid][i]);
		}
	}
	return 1;
}

public Audio_OnClientDisconnect(playerid)
{
	if(FullConnect[playerid]) SendClientMessage(playerid,Colour_Orange,"[*] Connection with AP server has been lost. Trying to connect again...");
	else PlayerTextDrawSetString(playerid,TextCon[playerid],"Unexpected problem~n~Reconnecting...");
	return 1;
}

public Audio_OnClientConnect(playerid)
{
    if(FullConnect[playerid])
    {
        SendClientMessage(playerid,Colour_Orange,"[*] Reconnection to AP server...");
        return 1;
	}
	KillTimer(APCheckTimer[playerid]);
	APCheckTimer[playerid] = -1;
	PlayerTextDrawSetString(playerid,TextCon[playerid],"Connected.~n~File transferring is~n~started");
	return 1;
}
	
public Audio_OnTransferFile(playerid, file[], current, total, result)
{
	if(!HasValidVersion[playerid]) return 1;
	if(FullConnect[playerid])
	{
	    if(current == total) SendClientMessage(playerid,Colour_Orange,"[*] Connection to AP server enstablished");
		return 1;
	}
	new str[128], Float:percent = Float:current/Float:total*100.0;
	switch(result)
	{
	    case 0,1: format(str,128,"File transferring~n~%.0f%%",percent);
	    case 2: format(str,128,"File checking~n~%.0f%%",percent);
	    case 3: format(str,128,"Error transferring~n~%.0f%%",percent);
	}
	PlayerTextDrawSetString(playerid,TextCon[playerid],str);
	if(current == total)
	{
	    FullConnect[playerid] = true;
	    PlayerTextDrawDestroy(playerid,TextCon[playerid]);
		TextDrawHideForPlayer(playerid,BoxCon);
	    EnterInServer[playerid] = true;
	    MoveCameraTimer[playerid] = SetTimerEx("MoveCamera",0,false,"d",playerid);
	    Streamer_Update(playerid);
	    SetTimerEx("PlayMainTheme",50,false,"d",playerid);
	    for(new i = 0; i < sizeof(WelcomeTDs); i++) TextDrawShowForPlayer(playerid,WelcomeTDs[i]);
	    return 1;
	}
	return 1;
}

public Audio_OnStop(playerid, handleid)
{
	if(EffectHandle[playerid] == handleid)
	{
	    EffectHandle[playerid] = -1;
	    MainThemeHandle[playerid] = Audio_Play(playerid,1,false,true,false);
	    return 1;
	}
	if(FreeroamHandle[playerid] == handleid)
	{
		FreeroamHandle[playerid] = -1;
		return 1;
	}
	if(EventHandle[playerid] == handleid)
	{
	    if(InRace[playerid] && !LookingFinishList[playerid]) EventHandle[playerid] = Audio_Play(playerid,TracksArray[random(sizeof(TracksArray))],false,false,false);
		else EventHandle[playerid] = -1;
		return 1;
	}
	if(FinishHandle[playerid] == handleid)
	{
		FinishHandle[playerid] = -1;
		return 1;
	}
	if(SafehouseHandle[playerid] == handleid)
	{
	    SafehouseHandle[playerid] = -1;
	    return 1;
	}
	return 1;
}

public MoveCamera(playerid)
{
	InterpolateCameraPos(playerid,1925.5848+Radius*floatsin(CameraMoveAngle[playerid],degrees),-2214.4021+Radius*-floatcos(CameraMoveAngle[playerid],degrees),14.0700,1925.5848+Radius*floatsin(CameraMoveAngle[playerid]+45,degrees),-2214.4021+Radius*-floatcos(CameraMoveAngle[playerid]+45,degrees),14.0700,5000,CAMERA_MOVE);
	InterpolateCameraLookAt(playerid,1925.5848+Radius*floatsin(CameraMoveAngle[playerid]+180,degrees),-2214.4021+Radius*-floatcos(CameraMoveAngle[playerid]+180,degrees),14.0700,1925.5848+Radius*floatsin(CameraMoveAngle[playerid]+225,degrees),-2214.4021+Radius*-floatcos(CameraMoveAngle[playerid]+225,degrees),14.0700,5000,CAMERA_MOVE);
	CameraMoveAngle[playerid] = CameraMoveAngle[playerid]+45;
	if(CameraMoveAngle[playerid] == 360) CameraMoveAngle[playerid] = 0;
	return MoveCameraTimer[playerid] = SetTimerEx("MoveCamera",5000,false,"d",playerid);
}

public PlayMainTheme(playerid)
{
	Audio_Play(playerid,15,false,false,false);
	return 1;
}

public CheckForAP(playerid)
{
    APCheckTimer[playerid] = -1;
	if(Audio_IsClientConnected(playerid)) return 1;
	//PlayerTextDrawSetString(playerid,TextCon[playerid],"Unable to connect~n~AP server.~n~Disconnecting");
	SendClientMessage(playerid,Colour_Yellow,"[*] Unable to connect AP server. No additional sounds for you...");
 	FullConnect[playerid] = true;
  	PlayerTextDrawDestroy(playerid,TextCon[playerid]);
	TextDrawHideForPlayer(playerid,BoxCon);
 	EnterInServer[playerid] = true;
  	MoveCameraTimer[playerid] = SetTimerEx("MoveCamera",0,false,"d",playerid);
   	Streamer_Update(playerid);
    for(new i = 0; i < sizeof(WelcomeTDs); i++) TextDrawShowForPlayer(playerid,WelcomeTDs[i]);
	return 1;
}

public SGivePlayerMoney(playerid,amount)
{
	new str[32];
	PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]] += amount;
	format(str,32,"$%d",PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]]);
	PlayerTextDrawSetString(playerid,MoneyInd[playerid],str);
	return 1;
}

public UpdatePlayerExpLine(playerid)
{
	new Float:linel,Float:exp = PlayerInfo[playerid][pExp],Float:lvl = PlayerInfo[playerid][pLevel];
	linel = 241.0*((exp-500.0*lvl*(lvl-1.0))/(500.0*(lvl+1.0)*lvl-500.0*lvl*(lvl-1.0)));
	PlayerTextDrawHide(playerid,MainLineStructPl[playerid][2]);
	PlayerTextDrawTextSize(playerid,MainLineStructPl[playerid][2],linel+167.0,6.0);
	PlayerTextDrawShow(playerid,MainLineStructPl[playerid][2]);
	return 1;
}

public TakePlayerInWorld(playerid)
{
	SetPlayerWorldTime(playerid);
	if(MoveCameraTimer[playerid] != -1) KillTimer(MoveCameraTimer[playerid]),MoveCameraTimer[playerid] = -1;
    new rand = random(sizeof(VehPlaces));
   	SetVehiclePos(PlayerInfo[playerid][pVehID],VehPlaces[rand][0],VehPlaces[rand][1],VehPlaces[rand][2]);
    SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],MAX_PLAYERS+1);
    if(GetGVarType("3did",PlayerInfo[playerid][pVehID]) != GLOBAL_VARTYPE_NONE)
	{
		new t3d = GetGVarInt("3did",PlayerInfo[playerid][pVehID]);
		DeleteGVar("3did",PlayerInfo[playerid][pVehID]);
		if(IsValidDynamic3DTextLabel(Text3D:t3d)) DestroyDynamic3DTextLabel(Text3D:t3d);
	}
	new Float:pp[3];
 	GetVehicleModelInfo(GetVehicleModel(PlayerInfo[playerid][pVehID]),VEHICLE_MODEL_INFO_SIZE,pp[0],pp[1],pp[2]);
  	SetGVarInt("3did",_:CreateDynamic3DTextLabel(DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]],0x73B1EDFF,0.0,0.0,pp[2]/2.0+0.1,25.0,INVALID_PLAYER_ID,PlayerInfo[playerid][pVehID],0,-1,-1,-1,50.0),PlayerInfo[playerid][pVehID]);
	Streamer_RemoveArrayData(STREAMER_TYPE_3D_TEXT_LABEL,Text3D:GetGVarInt("3did",PlayerInfo[playerid][pVehID]),E_STREAMER_PLAYER_ID,playerid);
	SetGVarInt("dead",0,PlayerInfo[playerid][pVehID]);
	TogglePlayerSpectating(playerid,false);
	SetSpawnInfo(playerid,0,101,0,0,0,0,0,0,0,0,0,0);
	SpawnPlayer(playerid);
	SetPlayerVirtualWorld(playerid,MAX_PLAYERS+1);
	PutPlayerInVehicle(playerid,PlayerInfo[playerid][pVehID],0);
	SetVehicleZAngle(PlayerInfo[playerid][pVehID],VehPlaces[rand][3]);
	SetCameraBehindPlayer(playerid);
	if(Audio_IsClientConnected(playerid))
	{
	    new for_rand[2] = {2,3};
	    Audio_Stop(playerid,MainThemeHandle[playerid]),MainThemeHandle[playerid] = 0;
		FreeroamHandle[playerid] = Audio_Play(playerid,for_rand[random(2)],false,false,false);
	}
	InGame[playerid] = true;
	InFreeRoam[playerid] = true;
	CanFlip[playerid] = true;
	ShowSpeedometre(playerid);
    ShowBonuses(playerid);
    Iter_Add(ChatRoom[PlayerInfo[playerid][pChatRoom]],playerid);
    SendClientMessage(playerid,Colour_Orange,"You have been connected to Global chat room. Type '/changeroom (GLOBAL/RU/EN/DE)' to change room.");
	new str[32];
	format(str,64,"%d player(s) in chat room.",Iter_Count(ChatRoom[CHAT_GLOBAL])-1);
	SendClientMessage(playerid,Colour_Orange,str);
	SetPlayerScore(playerid,PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]]);
	return 1;
}

public CheckForSymbols(text[],len)
{
	for(new i = 0; i < len; i++)
	{
	    if((text[i] >= 'a' && 'z' >= text[i]) || (text[i] >= 'A' && 'Z' >= text[i]) || (text[i] >= '0' && '9' >= text[i])) continue;
	    else return 0;
	}
	return 1;
}

public SaveDriver(playerid)
{
	new str[128];
	format(str,128,"UPDATE drivers SET money=%d,exp=%d,level=%d WHERE drivername='%s'",PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]],PlayerInfo[playerid][pExp][PlayerInfo[playerid][pSelectedDriver]],PlayerInfo[playerid][pLevel][PlayerInfo[playerid][pSelectedDriver]],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
	mysql_query(str);
	return 1;
}

public RestoreNitroItem(playerid)
{
	if(!InGame[playerid]) return 1;
	if(PlayerInfo[playerid][iNitro] == 0) return 1;
	PlayerTextDrawHide(playerid,BonusesPl[playerid][0]);
	PlayerTextDrawColor(playerid,BonusesPl[playerid][0],16777215);
	new bool:ns = true;
	if(LookingFinishList[playerid]||LookingRep[playerid]||JoinedInRace[playerid]||SafeHouseState[playerid] != SAFEHOUSE_STATE_NONE||LookTreasureReward[playerid]) ns = false;
	if(ns)
	{
		PlayerTextDrawShow(playerid,BonusesPl[playerid][0]);
		CanUseNitroItem[playerid] = true;
		if(CanUseRamItem[playerid])
		{
		    if(PlayerInfo[playerid][iReady] != 0 && PlayerInfo[playerid][tReady] == -1)
		    {
			    PlayerTextDrawHide(playerid,BonusesPl[playerid][4]);
			    PlayerTextDrawColor(playerid,BonusesPl[playerid][4],0x00000055);
			    PlayerTextDrawShow(playerid,BonusesPl[playerid][4]);
			    CanUseReadyItem[playerid] = false;
			}
		}
	}
	PlayerInfo[playerid][tNitro] = -1;
	return 1;
}

public RemoveNitro(playerid)
{
	RemoveVehicleComponent(PlayerInfo[playerid][pVehID],1010);
	return 1;
}

public RemoveRam(playerid)
{
	if(RamObject[PlayerInfo[playerid][pVehID]] != INVALID_OBJECT_ID)
	{
	    DestroyDynamicObject(RamObject[PlayerInfo[playerid][pVehID]]);
	    RamObject[PlayerInfo[playerid][pVehID]] = INVALID_OBJECT_ID;
	}
	return 1;
}

public RestoreRamItem(playerid)
{
	if(!InGame[playerid]) return 1;
	if(PlayerInfo[playerid][iRam] == 0) return 1;
	PlayerTextDrawHide(playerid,BonusesPl[playerid][2]);
	PlayerTextDrawColor(playerid,BonusesPl[playerid][2],-5963521);
	new bool:ns = true;
	if(LookingFinishList[playerid]||LookingRep[playerid]||JoinedInRace[playerid]||SafeHouseState[playerid] != SAFEHOUSE_STATE_NONE||LookTreasureReward[playerid]) ns = false;
	if(ns)
	{
		PlayerTextDrawShow(playerid,BonusesPl[playerid][2]);
		CanUseRamItem[playerid] = true;
		if(CanUseNitroItem[playerid])
		{
		    if(PlayerInfo[playerid][iReady] != 0 && PlayerInfo[playerid][tReady] == -1)
		    {
			    PlayerTextDrawHide(playerid,BonusesPl[playerid][4]);
			    PlayerTextDrawColor(playerid,BonusesPl[playerid][4],0x00000055);
			    PlayerTextDrawShow(playerid,BonusesPl[playerid][4]);
			    CanUseReadyItem[playerid] = false;
			}
		}
	}
	PlayerInfo[playerid][tRam] = -1;
	return 1;
}

public RestoreReadyItem(playerid)
{
	if(!InGame[playerid]) return 1;
	if(PlayerInfo[playerid][iReady] == 0) return 1;
	PlayerTextDrawHide(playerid,BonusesPl[playerid][4]);
	if(!CanUseNitroItem[playerid]||!CanUseRamItem[playerid]) PlayerTextDrawColor(playerid,BonusesPl[playerid][4],16711935);
	new bool:ns = true;
	if(LookingFinishList[playerid]||LookingRep[playerid]||JoinedInRace[playerid]||SafeHouseState[playerid] != SAFEHOUSE_STATE_NONE||LookTreasureReward[playerid]) ns = false;
	if(ns)
	{
		PlayerTextDrawShow(playerid,BonusesPl[playerid][4]);
		CanUseReadyItem[playerid] = true;
	}
	PlayerInfo[playerid][tReady] = -1;
	return 1;
}

public RotateRacesLights()
{
    new Float:z;
	GlobalPov = GlobalPov + 45.0;
	if(GlobalPov == 360.0) GlobalPov = 0.0;
	for(new i = 0; i < MAX_RACES; i++)
	{
	    for(new j = 0; j < 8; j++)
	    {
	        Streamer_GetFloatData(STREAMER_TYPE_OBJECT,RaceInfo[i][Light][j],E_STREAMER_Z,z);
	  		MoveDynamicObject(RaceInfo[i][Light][j],RaceInfo[i][X]+rad_by_line[j]*floatsin(GlobalPov,degrees),RaceInfo[i][Y]+rad_by_line[j]*-floatcos(GlobalPov,degrees),z,speed_by_line[j]);
			Streamer_GetFloatData(STREAMER_TYPE_OBJECT,RaceInfo[i][Light][j+16],E_STREAMER_Z,z);
			MoveDynamicObject(RaceInfo[i][Light][j+16],RaceInfo[i][X]+rad_by_line[j]*floatsin(GlobalPov+180.0,degrees),RaceInfo[i][Y]+rad_by_line[j]*-floatcos(GlobalPov+180.0,degrees),z,speed_by_line[j]);
			if(j != 0)
			{
			    Streamer_GetFloatData(STREAMER_TYPE_OBJECT,RaceInfo[i][Light][j+16-2*j],E_STREAMER_Z,z);
			    MoveDynamicObject(RaceInfo[i][Light][j+16-2*j],RaceInfo[i][X]+rad_by_line[j]*floatsin(GlobalPov+180.0,degrees),RaceInfo[i][Y]+rad_by_line[j]*-floatcos(GlobalPov+180.0,degrees),z,speed_by_line[j]);
			    Streamer_GetFloatData(STREAMER_TYPE_OBJECT,RaceInfo[i][Light][j+32-2*j],E_STREAMER_Z,z);
			    MoveDynamicObject(RaceInfo[i][Light][j+32-2*j],RaceInfo[i][X]+rad_by_line[j]*floatsin(GlobalPov,degrees),RaceInfo[i][Y]+rad_by_line[j]*-floatcos(GlobalPov,degrees),z,speed_by_line[j]);
			}
		}
	}
	return 1;
}

public WaitJoin(playerid)
{
	CancelSeconds[playerid]--;
	if(CancelSeconds[playerid] == -1)
	{
		KillTimer(JoinTimer[playerid]);
		JoinTimer[playerid] = -1;
		JoinedJNum[playerid] = -1;
		PlayerTextDrawHide(playerid,RaceTDPl[playerid][2]);
		for(new i = 14; i < 16; i++) TextDrawHideForPlayer(playerid,RaceTD[i]);
		for(new i = 8; i < 10; i++) TextDrawShowForPlayer(playerid,RaceTD[i]);
		return 1;
	}
	new str[32];
	format(str,32,"Cancel in 0:%02d",CancelSeconds[playerid]);
	PlayerTextDrawSetString(playerid,RaceTDPl[playerid][2],str);
	return 1;
}

public StartCountDown(raceid,index)
{
	new str[64];
	format(str,64,"QI[%d][DriversNum]",raceid);
	new drv = GetGVarInt(str,index);
	if(drv <= 0)
	{
	    format(str,64,"QI[%d][Created]",raceid);
		DeleteGVar(str,index);
		format(str,64,"QI[%d][Locked]",raceid);
		DeleteGVar(str,index);
		format(str,64,"QI[%d][UntilStart]",raceid);
		DeleteGVar(str,index);
		format(str,64,"QI[%d][DriversNum]",raceid);
		DeleteGVar(str,index);
		format(str,64,"QI[%d][Timer]",raceid);
		KillTimer(GetGVarInt(str,index));
		DeleteGVar(str,index);
		if(!AvaliableEvents[raceid][index]) AvaliableEvents[raceid][index] = true;
		return 1;
	}
	format(str,64,"QI[%d][UntilStart]",raceid);
	new sec = GetGVarInt(str,index);
	SetGVarInt(str,sec-1,index);
	if(sec-1 == 10)
	{
		AvaliableEvents[raceid][index] = false;
	    format(str,64,"QI[%d][Locked]",raceid);
	    SetGVarInt(str,1,index);
	    new apid;
		for(new i = 0; i < drv; i++)
		{
		    format(str,64,"QI[%d][ID][%d]",raceid,i);
		    apid = GetGVarInt(str,index);
		    TextDrawHideForPlayer(apid,DriversListTD[28]);
			CancelSelectTextDraw(apid);
			TogglePlayerControllable(apid,false);
		}
	}
	if(sec-1 == -1)
	{
		if(drv < MINIMUM_DRIVERS)
		{
		    format(str,64,"QI[%d][ID][0]",raceid);
		    new playerid = GetGVarInt(str,index);
      		JoinedInRace[playerid] = false;
        	JoinedJNum[playerid] = -1;
			RaceStartZone[playerid] = -1;
			ShowSpeedometre(playerid);
			ShowBonuses(playerid);
			ShowTreasureTDs(playerid);
			for(new p = 0; p < 4; p++) TextDrawShowForPlayer(playerid,MainLineStruct[p]);
			for(new p = 0; p < 3; p++) PlayerTextDrawShow(playerid,MainLineStructPl[playerid][p]);
			TextDrawHideForPlayer(playerid,DriversListTD[18]);
			TextDrawHideForPlayer(playerid,Lines[1]);
			PlayerTextDrawHide(playerid,EventTDPl[playerid][2]);
			for(new p = 0; p < 18; p++) TextDrawHideForPlayer(playerid,DriversListTD[p]);
			for(new p = 26; p < 30; p++) TextDrawHideForPlayer(playerid,DriversListTD[p]);
			for(new p = 0; p < 16; p++) PlayerTextDrawHide(playerid,DriversListTDPl[playerid][p]);
			ClearDriversListAfterRace(playerid);
			PlayerTextDrawShow(playerid,MoneyInd[playerid]);
			SetVehicleVirtualWorld(PlayerInfo[playerid][pVehID],MAX_PLAYERS+1),SetPlayerVirtualWorld(playerid,MAX_PLAYERS+1);
			LinkVehicleToInterior(PlayerInfo[playerid][pVehID],0),SetPlayerInterior(playerid,0);
			SetVehiclePos(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][pPosInWorld][0],PlayerInfo[playerid][pPosInWorld][1],PlayerInfo[playerid][pPosInWorld][2]);
			SetVehicleZAngle(PlayerInfo[playerid][pVehID],PlayerInfo[playerid][pPosInWorld][3]);
			SetCameraBehindPlayer(playerid);
			SetPlayerWorldTime(playerid);
			TogglePlayerControllable(playerid,true);
			format(str,64,"QI[%d][Created]",raceid);
			DeleteGVar(str,index);
			format(str,64,"QI[%d][Locked]",raceid);
			DeleteGVar(str,index);
			format(str,64,"QI[%d][UntilStart]",raceid);
			DeleteGVar(str,index);
			format(str,64,"QI[%d][DriversNum]",raceid);
			DeleteGVar(str,index);
			SendClientMessage(playerid,Colour_Yellow,"Exit from queue. Not enough drivers.");
			if(Audio_IsClientConnected(playerid)) Audio_Play(playerid,20,false,false,false);
			if(!AvaliableEvents[raceid][index]) AvaliableEvents[raceid][index] = true;
		    //cancel race start
		}
		else
		{
		    new str1[64],apid;
			for(new i = 0; i < drv; i++)
			{
			    format(str,64,"QI[%d][ID][%d]",raceid,i);
			    format(str1,64,"EI[%d][ID][%d]",raceid,i);
			    apid = GetGVarInt(str,index);
			    DeleteGVar(str,index);
			    SetGVarInt(str1,apid,index);
			    SetPlayerWorldTime(apid);
			    RepairVehicle(PlayerInfo[apid][pVehID]);
				SetVehiclePos(PlayerInfo[apid][pVehID],RaceInfo[raceid][SpawnPos][i*4],RaceInfo[raceid][SpawnPos][i*4+1],RaceInfo[raceid][SpawnPos][i*4+2]);
				SetVehicleZAngle(PlayerInfo[apid][pVehID],RaceInfo[raceid][SpawnPos][i*4+3]);
				SetVehicleVirtualWorld(PlayerInfo[apid][pVehID],EVENT_WORLD+raceid*MAX_JOINS+index),SetPlayerVirtualWorld(apid,EVENT_WORLD+raceid*MAX_JOINS+index);
				LinkVehicleToInterior(PlayerInfo[apid][pVehID],0),SetPlayerInterior(apid,0);
				SetCameraBehindPlayer(apid);
				TogglePlayerControllable(apid,false);
				PlayerTextDrawHide(apid,EventTDPl[apid][2]);
				for(new p = 0; p < 19; p++) TextDrawHideForPlayer(apid,DriversListTD[p]);
				for(new p = 26; p < 30; p++) TextDrawHideForPlayer(apid,DriversListTD[p]);
				for(new p = 0; p < 16; p++) PlayerTextDrawHide(apid,DriversListTDPl[apid][p]);
				ClearDriversListAfterRace(apid);
				InRace[apid] = true;
				if(Audio_IsClientConnected(apid)) if(FreeroamHandle[apid] != 0) Audio_Stop(apid,FreeroamHandle[apid]);
			}
			format(str,64,"EI[%d][CDSeconds]",raceid);
			SetGVarInt(str,3,index);
			format(str,64,"EI[%d][DriversNum]",raceid);
			SetGVarInt(str,drv,index);
			format(str,64,"EI[%d][Timer]",raceid);
			SetGVarInt(str,SetTimerEx("StartCountDownEv",3000,false,"dd",raceid,index),index);
		}
		format(str,64,"QI[%d][UntilStart]",raceid);
		DeleteGVar(str,index);
		format(str,64,"QI[%d][DriversNum]",raceid);
		DeleteGVar(str,index);
		format(str,64,"QI[%d][Timer]",raceid);
		KillTimer(GetGVarInt(str,index));
		DeleteGVar(str,index);
		return 1;
	}
	new apid;
	for(new i = 0; i < drv; i++)
	{
	    format(str,64,"QI[%d][ID][%d]",raceid,i);
	    apid = GetGVarInt(str,index);
		format(str,64,"0:%02d",sec);
		PlayerTextDrawSetString(apid,EventTDPl[apid][2],str);
	}
	return 1;
}

public ClearDriversList(playerid)
{
	for(new i = 1; i < 8; i++)
	{
	    PlayerTextDrawHide(playerid,DriversListTDPl[playerid][i*2]);
	    PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][i*2],"Waiting...");
		PlayerTextDrawColor(playerid,DriversListTDPl[playerid][i*2],0x6D6766FF);
		PlayerTextDrawShow(playerid,DriversListTDPl[playerid][i*2]);
  		PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][i*2+1]," ");
	}
	return 1;
}

public StartCountDownEv(raceid,index)
{
	new str[64],drv;
	format(str,64,"EI[%d][DriversNum]",raceid);
	drv = GetGVarInt(str,index);
	format(str,64,"EI[%d][CDSeconds]",raceid);
	new sec = GetGVarInt(str,index),apid;
	switch(sec)
	{
	    case 3:
	    {
	        for(new i = 0; i < drv; i++)
	        {
	            format(str,64,"EI[%d][ID][%d]",raceid,i);
	            apid = GetGVarInt(str,index);
	            TextDrawShowForPlayer(apid,CDTD[0]);
	            TextDrawShowForPlayer(apid,CDTD[1]);
	            TextDrawShowForPlayer(apid,CDTD[2]);
	            TextDrawShowForPlayer(apid,CDTD[3]);
	            TextDrawShowForPlayer(apid,CDTD[4]);
	            if(Audio_IsClientConnected(apid)) Audio_Play(apid,13,false,false,false);
			}
			format(str,64,"EI[%d][Timer]",raceid);
			SetGVarInt(str,SetTimerEx("StartCountDownEv",1000,true,"dd",raceid,index),index);
		}
		case 2:
		{
		    for(new i = 0; i < drv; i++)
	        {
	            format(str,64,"EI[%d][ID][%d]",raceid,i);
	            apid = GetGVarInt(str,index);
                TextDrawHideForPlayer(apid,CDTD[4]);
                TextDrawShowForPlayer(apid,CDTD[5]);
                if(Audio_IsClientConnected(apid)) Audio_Play(apid,13,false,false,false);
			}
		}
		case 1:
		{
		    for(new i = 0; i < drv; i++)
	        {
	            format(str,64,"EI[%d][ID][%d]",raceid,i);
	            apid = GetGVarInt(str,index);
                TextDrawHideForPlayer(apid,CDTD[5]);
                TextDrawShowForPlayer(apid,CDTD[6]);
                if(Audio_IsClientConnected(apid)) Audio_Play(apid,13,false,false,false);
			}
		}
		case 0:
		{
		    for(new i = 0; i < drv; i++)
	        {
	            format(str,64,"EI[%d][ID][%d]",raceid,i);
	            apid = GetGVarInt(str,index);
                TextDrawHideForPlayer(apid,CDTD[6]);
                TextDrawShowForPlayer(apid,CDTD[7]);
                if(Audio_IsClientConnected(apid)) Audio_Play(apid,13,false,false,false);
			}
		}
		case -1:
		{
		    new text[128],str1[32],pos[12];
		    format(str,64,"EI[%d][EventTimeStart]",raceid);
			SetGVarInt(str,GetTickCount(),index);
		    for(new i = 0; i < drv; i++)
	        {
				format(str,64,"EI[%d][ID][%d]",raceid,i);
				apid = GetGVarInt(str,index);
				DeleteGVar(str,index);
				format(str1,32,"%d %s~n~",i+1,DriverName[apid][PlayerInfo[apid][pSelectedDriver]]);
				strcat(text,str1,128);
				format(str,64,"EI[%d][RacerName][%d]",raceid,i);
				SetGVarString(str,DriverName[apid][PlayerInfo[apid][pSelectedDriver]],index);
                if(Audio_IsClientConnected(apid)) EventHandle[apid] = Audio_Play(apid,TracksArray[random(sizeof(TracksArray))],false,false,false);
                format(str,64,"EI[%d][AreaPlace][%d]",raceid,i);
				SetGVarInt(str,FirstRaceArea[raceid]-1,index);
				format(str,64,"EI[%d][PIDPlace][%d]",raceid,i);
                SetGVarInt(str,apid,index);
                EventArea[apid] = FirstRaceArea[raceid]-1;
				PlayerTextDrawShow(apid,MoneyInd[apid]);
				for(new t = 0; t < 3; t++)
				{
					PlayerTextDrawShow(apid,MainLineStructPl[apid][t]);
					TextDrawShowForPlayer(apid,MainLineStruct[t]);
				}
    			TextDrawHideForPlayer(apid,CDTD[0]);
	            TextDrawHideForPlayer(apid,CDTD[1]);
	            TextDrawHideForPlayer(apid,CDTD[2]);
	            TextDrawHideForPlayer(apid,CDTD[3]);
	            TextDrawHideForPlayer(apid,CDTD[7]);
	            TextDrawHideForPlayer(apid,Lines[1]);
	            SetVehiclePos(PlayerInfo[apid][pVehID],RaceInfo[raceid][SpawnPos][i*4],RaceInfo[raceid][SpawnPos][i*4+1],RaceInfo[raceid][SpawnPos][i*4+2]);
				SetVehicleZAngle(PlayerInfo[apid][pVehID],RaceInfo[raceid][SpawnPos][i*4+3]);
	            ShowSpeedometre(apid);
				JoinedInRace[apid] = false;
				ShowBonuses(apid);
				TextDrawShowForPlayer(apid,EventTD[0]);
				TextDrawShowForPlayer(apid,EventTD[1]);
				TextDrawShowForPlayer(apid,EventTD[2]);
				PlayerTextDrawShow(apid,EventTDPl[apid][3]);
				PlayerTextDrawShow(apid,EventTDPl[apid][4]);
				format(pos,12,"%d/%d",i+1,drv);
				PlayerTextDrawSetString(apid,EventTDPl[apid][0],pos);
				format(str,64,"%02d:%02d",RaceInfo[raceid][RaceTime]/60,RaceInfo[raceid][RaceTime]-(RaceInfo[raceid][RaceTime]/60)*60);
				PlayerTextDrawSetString(apid,EventTDPl[apid][3],str);
				if(!strcmp(RaceInfo[raceid][Type],"Sprint",true)) PlayerTextDrawSetString(apid,EventTDPl[apid][1],"0%");
				if(!strcmp(RaceInfo[raceid][Type],"Circuit",true))
				{
				    CurLap[apid] = 1;
					format(pos,12,"1/%d Lap",RaceInfo[raceid][Laps]);
					PlayerTextDrawSetString(apid,EventTDPl[apid][1],pos);
				}
				for(new p = 0; p < 5; p++)
				{
					if(p == 2) continue;
					PlayerTextDrawShow(apid,EventTDPl[apid][p]);
				}
				TogglePlayerControllable(apid,true);
			}
			for(new i = 0; i < drv; i++)
			{
			    format(str,64,"EI[%d][PIDPlace][%d]",raceid,i);
				apid = GetGVarInt(str,index);
				PlayerTextDrawSetString(apid,EventTDPl[apid][4],text);
				format(str,64,"%02d:%02d",RaceInfo[raceid][RaceTime]/60,RaceInfo[raceid][RaceTime]-(RaceInfo[raceid][RaceTime]/60)*60);
				PlayerTextDrawSetString(apid,EventTDPl[apid][3],str);
			}
			format(str,64,"EI[%d][Time]",raceid);
			SetGVarInt(str,RaceInfo[raceid][RaceTime],index);
			format(str,64,"EI[%d][CDSeconds]",raceid);
			DeleteGVar(str,index);
			format(str,64,"EI[%d][Started]",raceid);
			SetGVarInt(str,1,index);
			format(str,64,"EI[%d][Timer]",raceid);
			KillTimer(GetGVarInt(str,index));
			SetGVarInt(str,SetTimerEx("EventTime",1000,true,"dd",raceid,index),index);
			return 1;
		}
	}
	format(str,64,"EI[%d][CDSeconds]",raceid);
	SetGVarInt(str,sec-1,index);
	return 1;
}

public EventTime(raceid,index)
{
	new str[64],apid,drv,sec;
	format(str,64,"EI[%d][Time]",raceid);
	sec = GetGVarInt(str,index);
	format(str,64,"EI[%d][DriversNum]",raceid);
	drv = GetGVarInt(str,index);
	if(sec == -1)
	{
	    new time;
		for(new i = 0; i < drv; i++)
		{
		    format(str,64,"EI[%d][PIDPlace][%d]",raceid,i);
		    apid = GetGVarInt(str,index);
		    format(str,64,"EI[%d][AtFinish][%d]",raceid,i);
			if(GetGVarInt(str,index))
			{
			    if(RaceStartZone[apid] == raceid && JoinedJNum[apid] == index)
			    {
			        if(LookingFinishList[apid])
			        {
				        for(new t = i+1; t < drv; t++)
				        {
				            format(str,64,"EI[%d][AtFinish][%d]",raceid,t);
				            if(GetGVarInt(str,index)) continue;
	           				PlayerTextDrawHide(apid,DriversListTDPl[apid][t*2]);
				            PlayerTextDrawColor(apid,DriversListTDPl[apid][t*2],-1);
				            format(str,64,"EI[%d][RacerName][%d]",raceid,t);
				            GetGVarString(str,str,64,index);
	               			PlayerTextDrawSetString(apid,DriversListTDPl[apid][t*2],str);
	                  		PlayerTextDrawShow(apid,DriversListTDPl[apid][t*2]);
	                    	PlayerTextDrawSetString(apid,DriversListTDPl[apid][t*2+1],"DNF");
						}
					}
				}
			}
			else
			{
			    if(RaceStartZone[apid] == raceid && JoinedJNum[apid] == index)
			    {
			        InRace[apid] = false;
           			TogglePlayerControllable(apid,false);
	            	SetPlayerVirtualWorld(apid,apid+1),SetVehicleVirtualWorld(PlayerInfo[apid][pVehID],apid+1);
		            LookingFinishList[apid] = true;
					for(new t = 0; t < 3; t++) TextDrawHideForPlayer(apid,EventTD[t]);
					if(WrongWay[apid])
					{
						HidePlayerBrick(apid);
						WrongWay[apid] = false;
    				}
					HideBonuses(apid);
					HideSpeedometre(apid);
					for(new t = 0; t < 5; t++) PlayerTextDrawHide(apid,EventTDPl[apid][t]);
					TextDrawShowForPlayer(apid,FinishTD[0]);
					TextDrawShowForPlayer(apid,DriversListTD[1]);
					for(new t = 10; t < 14; t++) TextDrawShowForPlayer(apid,FinishTD[t]);
			    	for(new t = 0; t < 8; t++)
			    	{
			    	    if(t < drv)
			    	    {
			    	        format(str,64,"EI[%d][AtFinish][%d]",raceid,t);
			    	        if(GetGVarInt(str,index))
			    	        {
			    	            if(t < 3)
			    	            {
				    	            TextDrawShowForPlayer(apid,FinishTD[1+t*3]);
									TextDrawShowForPlayer(apid,FinishTD[1+t*3+1]);
									TextDrawShowForPlayer(apid,FinishTD[1+t*3+2]);
								}
								else
								{
								    TextDrawShowForPlayer(apid,DriversListTD[2+t*2]);
									TextDrawShowForPlayer(apid,DriversListTD[2+t*2+1]);
								}
								format(str,64,"EI[%d][FinishTime][%d]",raceid,t);
								time =	GetGVarInt(str,index);
								format(str,64,"EI[%d][EventTimeStart]",raceid);
								time = (time-GetGVarInt(str,index))/1000;
								format(str,64,"%02d:%02d",time/60,time-(time/60)*60);
								PlayerTextDrawSetString(apid,DriversListTDPl[apid][2*t+1],str);
							}
							else
							{
								PlayerTextDrawSetString(apid,DriversListTDPl[apid][2*t+1],"DNF");
								TextDrawShowForPlayer(apid,DriversListTD[2+t*2]);
								TextDrawShowForPlayer(apid,DriversListTD[2+t*2+1]);
							}
							PlayerTextDrawColor(apid,DriversListTDPl[apid][2*t],-1);
							format(str,64,"EI[%d][RacerName][%d]",raceid,t);
							GetGVarString(str,str,64,index);
							PlayerTextDrawSetString(apid,DriversListTDPl[apid][2*t],str);
						}
						else
						{
						    TextDrawShowForPlayer(apid,DriversListTD[2+t*2]);
							TextDrawShowForPlayer(apid,DriversListTD[2+t*2+1]);
							PlayerTextDrawSetString(apid,DriversListTDPl[apid][2*t],"Empty Slot");
						}
						PlayerTextDrawShow(apid,DriversListTDPl[apid][2*t]);
						PlayerTextDrawShow(apid,DriversListTDPl[apid][2*t+1]);
					}
					TextDrawShowForPlayer(apid,DriversListTD[18+i]);
					if(Audio_IsClientConnected(apid)) Audio_Stop(apid,EventHandle[apid]);
					RewardInfo[apid][Reputation] = 0;
					RewardInfo[apid][Money] = 0;
     				SelectTextDraw(apid,0x73B1EDFF);
				}
			}
		}
		format(str,64,"EI[%d][Timer]",raceid);
		KillTimer(GetGVarInt(str,index));
		ClearEventAndJoin(raceid,index);
		if(!AvaliableEvents[raceid][index]) AvaliableEvents[raceid][index] = true;
		return 1;
	}
	format(str,64,"EI[%d][Time]",raceid);
	SetGVarInt(str,sec-1,index);
	for(new i = 0; i < drv; i++)
	{
	    format(str,64,"EI[%d][PIDPlace][%d]",raceid,i);
	    apid = GetGVarInt(str,index);
	    format(str,12,"%02d:%02d",sec/60,sec-(sec/60)*60);
	    PlayerTextDrawSetString(apid,EventTDPl[apid][3],str);
	}
	return 1;
}

public HideBonuses(playerid)
{
    for(new i = 0; i < 21; i++) TextDrawHideForPlayer(playerid,Bonuses[i]);
	for(new i = 0; i < 6; i++) PlayerTextDrawHide(playerid,BonusesPl[playerid][i]);
	CanUseNitroItem[playerid] = false;
	CanUseRamItem[playerid] = false;
	CanUseReadyItem[playerid] = false;
	return 1;
}

public ShowBonuses(playerid)
{
    for(new i = 0; i < 21; i++) TextDrawShowForPlayer(playerid,Bonuses[i]);
	for(new i = 0; i < 6; i++) PlayerTextDrawShow(playerid,BonusesPl[playerid][i]);
	new str[12];
	PlayerTextDrawHide(playerid,BonusesPl[playerid][0]);
	if(PlayerInfo[playerid][iNitro] != 0 && PlayerInfo[playerid][tNitro] == -1)
	{
     	PlayerTextDrawColor(playerid,BonusesPl[playerid][0],16777215);
		CanUseNitroItem[playerid] = true;
	}
	else PlayerTextDrawColor(playerid,BonusesPl[playerid][0],0x00000055);
	PlayerTextDrawShow(playerid,BonusesPl[playerid][0]);
	format(str,12,"%d",PlayerInfo[playerid][iNitro]);
	PlayerTextDrawSetString(playerid,BonusesPl[playerid][1],str);
	PlayerTextDrawHide(playerid,BonusesPl[playerid][2]);
	if(PlayerInfo[playerid][iRam] != 0 && PlayerInfo[playerid][tRam] == -1)
	{
	    PlayerTextDrawColor(playerid,BonusesPl[playerid][2],-5963521);
	    CanUseRamItem[playerid] = true;
	}
	else PlayerTextDrawColor(playerid,BonusesPl[playerid][2],0x00000055);
	PlayerTextDrawShow(playerid,BonusesPl[playerid][2]);
	format(str,12,"%d",PlayerInfo[playerid][iRam]);
	PlayerTextDrawSetString(playerid,BonusesPl[playerid][3],str);
	PlayerTextDrawHide(playerid,BonusesPl[playerid][4]);
	if(PlayerInfo[playerid][iReady] != 0 && PlayerInfo[playerid][tReady] != -1)
	{
	    if(!CanUseNitroItem[playerid]||!CanUseRamItem[playerid])
	    {
	        PlayerTextDrawColor(playerid,BonusesPl[playerid][4],16711935);
	        CanUseReadyItem[playerid] = true;
		}
		else PlayerTextDrawColor(playerid,BonusesPl[playerid][4],0x00000055);
	}
	else PlayerTextDrawColor(playerid,BonusesPl[playerid][4],0x00000055);
	PlayerTextDrawShow(playerid,BonusesPl[playerid][4]);
	format(str,12,"%d",PlayerInfo[playerid][iReady]);
	PlayerTextDrawSetString(playerid,BonusesPl[playerid][5],str);
	return 1;
}

public ClearDriversListAfterRace(playerid)
{
	for(new i = 0; i < 8; i++)
	{
	    PlayerTextDrawColor(playerid,DriversListTDPl[playerid][i*2],0x6D6766FF);
	    PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][i*2],"Waiting...");
	    PlayerTextDrawSetString(playerid,DriversListTDPl[playerid][i*2+1]," ");
	}
	return 1;
}

public HideSpeedometre(playerid)
{
	IsSpeedShown[playerid] = false;
	for(new i = 0; i < 31; i++) PlayerTextDrawHide(playerid,VHS[playerid][i]);
	TextDrawHideForPlayer(playerid,VHS_Main[0]);
    TextDrawHideForPlayer(playerid,VHS_Main[1]);
    return 1;
}

public ShowSpeedometre(playerid)
{
	IsSpeedShown[playerid] = true;
	for(new i = 0; i < 31; i++) PlayerTextDrawShow(playerid,VHS[playerid][i]);
	TextDrawShowForPlayer(playerid,VHS_Main[0]);
    TextDrawShowForPlayer(playerid,VHS_Main[1]);
    return 1;
}

public ClearEventAndJoin(raceid,index)
{
	if(raceid == -1 || index == -1)
	{
	    printf("ClearEventAndJoin(%d,%d) error! Restarting...",raceid,index);
	    SendRconCommand("gmx");
	    return 1;
	}
    new str[64];
    for(new i = 0; i < 8; i++)
    {
        format(str,64,"EI[%d][PIDPlace][%d]",raceid,i);
        DeleteGVar(str,index);
        format(str,64,"EI[%d][AreaPlace][%d]",raceid,i);
        DeleteGVar(str,index);
        format(str,64,"EI[%d][FinishTime][%d]",raceid,i);
        DeleteGVar(str,index);
        format(str,64,"EI[%d][AtFinish][%d]",raceid,i);
        DeleteGVar(str,index);
        format(str,64,"EI[%d][RacerName][%d]",raceid,i);
        DeleteGVar(str,index);
	}
	format(str,64,"EI[%d][DriversNum]",raceid);
    DeleteGVar(str,index);
	format(str,64,"EI[%d][EventTimeStart]",raceid);
	DeleteGVar(str,index);
	format(str,64,"EI[%d][Time]",raceid);
	DeleteGVar(str,index);
	format(str,64,"EI[%d][Started]",raceid);
	DeleteGVar(str,index);
	format(str,64,"EI[%d][LeavedPlayers]",raceid);
	DeleteGVar(str,index);
	format(str,64,"QI[%d][Created]",raceid);
	DeleteGVar(str,index);
	format(str,64,"QI[%d][Locked]",raceid);
	DeleteGVar(str,index);
	format(str,64,"QI[%d][DriversNum]",raceid);
	DeleteGVar(str,index);
	if(!AvaliableEvents[raceid][index]) AvaliableEvents[raceid][index] = true;
  	return 1;
}

public UpdatePlaceTDForEvent(raceid,index)
{
    new str[128],st[32],drv,apid;
	format(st,32,"EI[%d][DriversNum]",raceid);
	drv = GetGVarInt(st,index);
 	for(new i = 0; i < drv; i++)
	{
	    format(st,32,"EI[%d][RacerName][%d]",raceid,i);
	    GetGVarString(st,st,32,index);
 		format(st,32,"%d %s~n~",i+1,st);
		strcat(str,st,128);
	}
	for(new i = 0; i < drv; i++)
	{
	    format(st,32,"EI[%d][PIDPlace][%d]",raceid,i);
	    apid = GetGVarInt(st,index);
		PlayerTextDrawSetString(apid,EventTDPl[apid][4],str);
	}
	return 1;
}

public HidePlayerBrick(playerid)
{
	for(new i = 0; i < 4; i++) TextDrawHideForPlayer(playerid,Brick[i]);
	return 1;
}

public ShowPlayerBrick(playerid)
{
	for(new i = 0; i < 4; i++) TextDrawShowForPlayer(playerid,Brick[i]);
	return 1;
}

public ForcePlayerCameraSafehouse(playerid)
{
    SetPlayerCameraPos(playerid,SAFEHOUSE_CAMERA_MAIN);
	SetPlayerCameraLookAt(playerid,1925.5848,-2214.4021,14.0700);
	Streamer_UpdateEx(playerid,SAFEHOUSE_CAMERA_MAIN,playerid,-1);
	SetVehiclePos(PlayerInfo[playerid][pVehID],1925.5848,-2214.4021,14.0700);
	return 1;
}

public VehModelToArrayID(model)
{
	switch(model)
	{
	    case 401: return 0;
		case 402: return 1;
		case 404: return 2;
		case 405: return 3;
		case 410: return 4;
		case 411: return 5;
		case 412: return 6;
		case 419: return 7;
		case 421: return 8;
		case 426: return 9;
		case 429: return 10;
		case 436: return 11;
		case 439: return 12;
		case 445: return 13;
		case 451: return 14;
		case 458: return 15;
		case 466: return 16;
		case 467: return 17;
		case 474: return 18;
		case 475: return 19;
		case 477: return 20;
		case 479: return 21;
		case 480: return 22;
		case 491: return 23;
		case 492: return 24;
		case 496: return 25;
		case 500: return 26;
		case 506: return 27;
		case 507: return 28;
		case 516: return 29;
		case 517: return 30;
		case 518: return 31;
		case 526: return 32;
		case 527: return 33;
		case 529: return 34;
		case 533: return 35;
		case 534: return 36;
		case 535: return 37;
		case 536: return 38;
		case 540: return 39;
		case 541: return 40;
		case 542: return 41;
		case 545: return 42;
		case 546: return 43;
		case 547: return 44;
		case 549: return 45;
		case 550: return 46;
		case 551: return 47;
		case 555: return 48;
		case 558: return 49;
		case 559: return 50;
		case 560: return 51;
		case 561: return 52;
		case 562: return 53;
		case 565: return 54;
		case 566: return 55;
		case 576: return 56;
		case 580: return 57;
		case 585: return 58;
		case 587: return 59;
		case 589: return 60;
		case 600: return 61;
		case 602: return 62;
		case 603: return 63;
	}
	return -1;
}

public CameraViewChange(playerid,id)
{
	new Float:x,Float:y,Float:z;
	GetPlayerCameraPos(playerid,x,y,z);
	switch(id)
	{
	    case CUSTOM_SPOILER,CUSTOM_EXHAUST,CUSTOM_RBUMPER: InterpolateCameraPos(playerid,x,y,z,SAFEHOUSE_CAMERA_BACK,1500);
	    case CUSTOM_NEON,CUSTOM_WHEEL,CUSTOM_SIDESKIRT: InterpolateCameraPos(playerid,x,y,z,SAFEHOUSE_CAMERA_LEFTSIDE_ANGLE,1500);
	    case CUSTOM_INTAKE,CUSTOM_HOOD,CUSTOM_FBUMPER,CUSTOM_VENT,CUSTOM_LIGHT,CUSTOM_PLATE: InterpolateCameraPos(playerid,x,y,z,SAFEHOUSE_CAMERA_MAIN,1500);
	}
	InterpolateCameraLookAt(playerid,1925.5848,-2214.4021,14.0600,1925.5848,-2214.4021,14.0650,1500);
	return 1;
}

public LeftHudProccessed(playerid)
{
	new str[64];
	for(new i = 0; i < 13; i++)
	{
		if(PlayerInfo[playerid][vParams][i] != 0)
		{
		    if(i == CUSTOM_PLATE) { }
			else
			{
				PlayerTextDrawSetPreviewModel(playerid,CustomTDPl[playerid][6+i],PlayerInfo[playerid][vParams][i]);
		    	format(str,64,"PI[%d][Name]",PartModelToArrayID(PlayerInfo[playerid][vParams][i]));
		    	GetGVarString(str,str,64,i);
		    	format(str,64,"%s: %s",CustomTypeHudName[i],str);
				PlayerTextDrawSetString(playerid,CustomTDPl[playerid][19+i],str);
			}
			TextDrawShowForPlayer(playerid,CustomTD[22+i]);
		}
		else
		{
		    if(i == CUSTOM_PLATE) { }
			else
			{
				PlayerTextDrawSetPreviewModel(playerid,CustomTDPl[playerid][6+i],18631);
				format(str,64,"%s: NIS",CustomTypeHudName[i]);
				PlayerTextDrawSetString(playerid,CustomTDPl[playerid][19+i],str);
			}
		}
		if(i == CUSTOM_PLATE)
		{
		    format(str,64,"PI[%d][Name]",PlayerInfo[playerid][vParams][i]);
			GetGVarString(str,str,64,i);
			format(str,64,"%s: %s",CustomTypeHudName[i],str);
			PlayerTextDrawSetString(playerid,CustomTDPl[playerid][19+i],str);
		}
		PlayerTextDrawShow(playerid,CustomTDPl[playerid][6+i]);
		PlayerTextDrawShow(playerid,CustomTDPl[playerid][19+i]);
	}
	return 1;
}

public SetVehicleTunning(playerid,vehid)
{
	new str[32];
	for(new i = 0; i < 13; i++)
	{
	    switch(i)
	    {
	        case CUSTOM_PLATE:
	        {
	            format(str,32,"PI[%d][Name]",PlayerInfo[playerid][vParams][i]);
	            GetGVarString(str,str,32,i);
	            SetVehicleNumberPlate(vehid,str);
			}
			case CUSTOM_NEON:
			{
			    if(PlayerInfo[playerid][vParams][i] != 0)
			    {
			        new arid = VehModelToArrayID(GetVehicleModel(vehid));
				    if(NeonObject[vehid][0] != INVALID_OBJECT_ID)
				    {
				        for(new j = 0; j < 2; j++) Streamer_SetIntData(STREAMER_TYPE_OBJECT,NeonObject[vehid][j],E_STREAMER_MODEL_ID,PlayerInfo[playerid][vParams][i]);
						Streamer_SetFloatData(STREAMER_TYPE_OBJECT,NeonObject[vehid][0],E_STREAMER_ATTACH_OFFSET_X,NeonOffset[arid][0]);
						Streamer_SetFloatData(STREAMER_TYPE_OBJECT,NeonObject[vehid][0],E_STREAMER_ATTACH_OFFSET_Y,NeonOffset[arid][1]);
						Streamer_SetFloatData(STREAMER_TYPE_OBJECT,NeonObject[vehid][0],E_STREAMER_ATTACH_OFFSET_Z,NeonOffset[arid][2]);
						Streamer_SetFloatData(STREAMER_TYPE_OBJECT,NeonObject[vehid][1],E_STREAMER_ATTACH_OFFSET_X,-NeonOffset[arid][0]);
						Streamer_SetFloatData(STREAMER_TYPE_OBJECT,NeonObject[vehid][1],E_STREAMER_ATTACH_OFFSET_Y,NeonOffset[arid][1]);
						Streamer_SetFloatData(STREAMER_TYPE_OBJECT,NeonObject[vehid][1],E_STREAMER_ATTACH_OFFSET_Z,NeonOffset[arid][2]);
					}
					else
					{
			 			NeonObject[vehid][0] = CreateDynamicObject(PlayerInfo[playerid][vParams][i],0,0,0,0,0,0,-1,-1,-1,150.0);
   						AttachDynamicObjectToVehicle(NeonObject[vehid][0],vehid,NeonOffset[arid][0],NeonOffset[arid][1],NeonOffset[arid][2],0.0,0.0,0.0);
                		NeonObject[vehid][1] = CreateDynamicObject(PlayerInfo[playerid][vParams][i],0,0,0,0,0,0,-1,-1,-1,150.0);
               			AttachDynamicObjectToVehicle(NeonObject[vehid][1],vehid,-NeonOffset[arid][0],NeonOffset[arid][1],NeonOffset[arid][2],0.0,0.0,0.0);
                  		Streamer_Update(playerid);
					}
				}
				else
				{
				    if(NeonObject[vehid][0] != INVALID_OBJECT_ID)
				    {
				        for(new j = 0; j < 2; j++)
						{
							DestroyDynamicObject(NeonObject[vehid][j]);
							NeonObject[vehid][j] = INVALID_OBJECT_ID;
						}
					}
				}
			}
			default:
			{
	    		if(PlayerInfo[playerid][vParams][i] != 0) AddVehicleComponent(vehid,PlayerInfo[playerid][vParams][i]);
			}
		}
	}
	ChangeVehicleColor(vehid,PlayerInfo[playerid][vParams][13],PlayerInfo[playerid][vParams][14]);
	if(PlayerInfo[playerid][vParams][15] != -1) ChangeVehiclePaintjob(vehid,PlayerInfo[playerid][vParams][15]);
	return 1;
}

public SafeTunning(playerid)
{
	new str[256];
	format(str,256,"UPDATE drivers SET vehparams%d='%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d',money=%d WHERE drivername='%s' LIMIT 1",PlayerInfo[playerid][pActiveVehNum][PlayerInfo[playerid][pSelectedDriver]],
	PlayerInfo[playerid][vParams][0],PlayerInfo[playerid][vParams][1],PlayerInfo[playerid][vParams][2],
	PlayerInfo[playerid][vParams][3],PlayerInfo[playerid][vParams][4],PlayerInfo[playerid][vParams][5],
	PlayerInfo[playerid][vParams][6],PlayerInfo[playerid][vParams][7],PlayerInfo[playerid][vParams][8],
	PlayerInfo[playerid][vParams][9],PlayerInfo[playerid][vParams][10],PlayerInfo[playerid][vParams][11],
	PlayerInfo[playerid][vParams][12],PlayerInfo[playerid][vParams][13],PlayerInfo[playerid][vParams][14],PlayerInfo[playerid][vParams][15],
	PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
	mysql_query(str);
	return 1;
}

public PartModelToArrayID(modelid)
{
	switch(modelid)
	{
	    case 1000: return 0;
		case 1001: return 1;
		case 1002: return 2;
		case 1003: return 3;
		case 1014: return 4;
		case 1015: return 5;
		case 1016: return 6;
		case 1023: return 7;
		case 1049: return 8;
		case 1050: return 9;
		case 1058: return 10;
		case 1060: return 11;
		case 1138: return 12;
		case 1139: return 13;
		case 1147: return 14;
		case 1146: return 15;
		case 1162: return 16;
		case 1158: return 17;
		case 1164: return 18;
		case 1163: return 19;
		case 1004: return 0;
		case 1005: return 1;
		case 1011: return 2;
		case 1012: return 3;
		case 1025: return 0;
		case 1073: return 1;
		case 1074: return 2;
		case 1075: return 3;
		case 1076: return 4;
		case 1077: return 5;
		case 1078: return 6;
		case 1079: return 7;
		case 1080: return 8;
		case 1081: return 9;
		case 1082: return 10;
		case 1083: return 11;
		case 1084: return 12;
		case 1085: return 13;
		case 1096: return 14;
		case 1097: return 15;
		case 1098: return 16;
		case 18647: return 0;
		case 18648: return 1;
		case 18649: return 2;
		case 18650: return 3;
		case 18651: return 4;
		case 18652: return 5;
		case 1006: return 0;
		case 1032: return 1;
		case 1033: return 2;
		case 1038: return 3;
		case 1035: return 4;
		case 1054: return 5;
		case 1053: return 6;
		case 1055: return 7;
		case 1061: return 8;
		case 1067: return 9;
		case 1068: return 10;
		case 1088: return 11;
		case 1091: return 12;
		case 1103: return 0;
		case 1128: return 1;
		case 1130: return 2;
		case 1131: return 3;
		case 1007: return 0;
		case 1026: return 1;
		case 1031: return 2;
		case 1036: return 3;
		case 1041: return 4;
		case 1047: return 5;
		case 1048: return 6;
		case 1056: return 7;
		case 1057: return 8;
		case 1069: return 9;
		case 1070: return 10;
		case 1090: return 11;
		case 1095: return 12;
		case 1042: return 13;
		case 1122: return 14;
		case 1124: return 15;
		case 1102: return 16;
		case 1108: return 17;
		case 1118: return 18;
		case 1119: return 19;
		case 1018: return 0;
		case 1019: return 1;
		case 1020: return 2;
		case 1021: return 3;
		case 1022: return 4;
		case 1028: return 5;
		case 1029: return 6;
		case 1034: return 7;
		case 1037: return 8;
		case 1046: return 9;
		case 1045: return 10;
		case 1064: return 11;
		case 1059: return 12;
		case 1065: return 13;
		case 1066: return 14;
		case 1092: return 15;
		case 1089: return 16;
		case 1043: return 17;
		case 1044: return 18;
		case 1105: return 19;
		case 1104: return 20;
		case 1114: return 21;
		case 1113: return 22;
		case 1127: return 23;
		case 1126: return 24;
		case 1132: return 25;
		case 1129: return 26;
		case 1135: return 27;
		case 1136: return 28;
		case 1153: return 0;
		case 1152: return 1;
		case 1155: return 2;
		case 1157: return 3;
		case 1160: return 4;
		case 1173: return 5;
		case 1166: return 6;
		case 1165: return 7;
		case 1169: return 8;
		case 1170: return 9;
		case 1171: return 10;
		case 1172: return 11;
		case 1117: return 12;
		case 1174: return 13;
		case 1175: return 14;
		case 1179: return 15;
		case 1185: return 16;
		case 1182: return 17;
		case 1181: return 18;
		case 1189: return 19;
		case 1188: return 20;
		case 1191: return 21;
		case 1190: return 22;
		case 1141: return 0;
		case 1140: return 1;
		case 1149: return 2;
		case 1148: return 3;
		case 1150: return 4;
		case 1151: return 5;
		case 1154: return 6;
		case 1156: return 7;
		case 1159: return 8;
		case 1161: return 9;
		case 1168: return 10;
		case 1167: return 11;
		case 1176: return 12;
		case 1177: return 13;
		case 1180: return 14;
		case 1178: return 15;
		case 1184: return 16;
		case 1183: return 17;
		case 1187: return 18;
		case 1186: return 19;
		case 1192: return 20;
		case 1193: return 21;
		case 1143: return 0;
		case 1145: return 1;
		case 1013: return 0;
		case 1024: return 1;
	}
	return -1;
}

public VehicleModelToPaintjobNum(modelid)
{
	switch(modelid)
	{
	    case 483: return 1;
	    case 575: return 2;
	    case 534..536,558..562,565,567,576: return 3;
	}
	return 0;
}
/*public Int2Ip(value,str[],lenght)
{
	format(str,lenght,"%i.%i.%i.%i",(value >>> 24), ((value >>> 16) & 255), ((value >>> 8) & 255), (value & 255));
	return 1;
}*/

public SaveVehicles(playerid)
{
	new str[256];
	switch(PlayerInfo[playerid][pVehiclesNum][PlayerInfo[playerid][pSelectedDriver]])
	{
	    case 2: format(str,256,"UPDATE drivers SET money=%d, vehiclesnum=2, vehmodels='%d|%d', actvehnum=2, vehparams2=DEFAULT WHERE drivername='%s'",
			PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]],PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pSelectedDriver]*3],PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pSelectedDriver]*3+1],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
		case 3: format(str,256,"UPDATE drivers SET money=%d, vehiclesnum=3, vehmodels='%d|%d|%d', actvehnum=3, vehparams3=DEFAULT WHERE drivername='%s'",
			PlayerInfo[playerid][pMoney][PlayerInfo[playerid][pSelectedDriver]],PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pSelectedDriver]*3],PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pSelectedDriver]*3+1],PlayerInfo[playerid][pVehModel][PlayerInfo[playerid][pSelectedDriver]*3+2],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
	}
	mysql_query(str);
	return 1;
}

public CheckForVehDeath(playerid,vehicleid)
{
	if(GetGVarInt("dead",vehicleid) == 1)
	{
	    new Float:v[4];
	    GetPlayerPos(playerid,v[0],v[1],v[2]),GetPlayerFacingAngle(playerid,v[3]);
	    SetVehicleToRespawn(vehicleid);
	    SetVehiclePos(vehicleid,v[0],v[1],v[2]),SetVehicleZAngle(vehicleid,v[3]);
	    SetVehicleTunning(playerid,vehicleid);
	    SetVehicleVirtualWorld(vehicleid,GetPlayerVirtualWorld(playerid));
	    PutPlayerInVehicle(playerid,vehicleid,0);
	}
	CheckVehDeathTimer[playerid] = -1;
	return 1;
}

public CheckForTreasureLogin(playerid)
{
	new str[128],data[12],days;
	format(str,128,"SELECT lastlogin FROM drivers WHERE drivername='%s'",DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
	mysql_query(str),mysql_store_result(),mysql_fetch_row(data),mysql_free_result();
	format(str,128,"SELECT TO_DAYS(CURDATE())-TO_DAYS('%s')",data);
	mysql_query(str),mysql_store_result(),mysql_fetch_row(data),mysql_free_result();
	days = strval(data);
	format(str,128,"UPDATE drivers SET lastlogin=CURDATE() WHERE drivername='%s'",DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
	mysql_query(str);
	if(days != 0)
	{
	    if(days == 1)
		{
		    if(PlayerInfo[playerid][pCollectedLastTime] == 1) PlayerInfo[playerid][pTreasureDays]++;
		    else PlayerInfo[playerid][pTreasureDays] = 1;
		}
	    else PlayerInfo[playerid][pTreasureDays] = 1;
	    PlayerInfo[playerid][trCollected] = 0;
		PlayerInfo[playerid][pCollectedLastTime] = 0;
		format(str,128,"UPDATE drivers SET treasparams='%d|%d|%d' WHERE drivername='%s'",PlayerInfo[playerid][pTreasureDays],PlayerInfo[playerid][trCollected],PlayerInfo[playerid][pCollectedLastTime],DriverName[playerid][PlayerInfo[playerid][pSelectedDriver]]);
		mysql_query(str);
	    new tra[15];
	    RandomTreasureArray(tra,15);
    	for(new i = 0; i < 15; i++)
    	{
     		PlayerInfo[playerid][trIcon][i] = CreateDynamicMapIcon(TreasurePos[tra[i]][0],TreasurePos[tra[i]][1],TreasurePos[tra[i]][2],0,0x00FF00FF,MAX_PLAYERS+1,-1,playerid,200.0);
    		Streamer_SetIntData(STREAMER_TYPE_MAP_ICON,PlayerInfo[playerid][trIcon][i],E_STREAMER_STYLE,MAPICON_LOCAL_CHECKPOINT);
			PlayerInfo[playerid][trObj][i*2] = CreateDynamicObject(19092,TreasurePos[tra[i]][0],TreasurePos[tra[i]][1],TreasurePos[tra[i]][2]+3.0,0,-110.0,0,MAX_PLAYERS+1,-1,playerid,150.0);
 			PlayerInfo[playerid][trObj][i*2+1] = CreateDynamicObject(19297,TreasurePos[tra[i]][0],TreasurePos[tra[i]][1],TreasurePos[tra[i]][2]+3.0,0,0,0,MAX_PLAYERS+1,-1,playerid,150.0);
    		PlayerInfo[playerid][trArea][i] = CreateDynamicSphere(TreasurePos[tra[i]][0],TreasurePos[tra[i]][1],TreasurePos[tra[i]][2],10.0,MAX_PLAYERS+1,-1,playerid);
		}
		for(new i = 0; i < 35; i++) TextDrawShowForPlayer(playerid,TreasureTD[i]);
		format(str,12,"%d/15",PlayerInfo[playerid][trCollected]);
		PlayerTextDrawSetString(playerid,TreasureTDPl[playerid][0],str);
		for(new i = 0; i < 2; i++) PlayerTextDrawShow(playerid,TreasureTDPl[playerid][i]);
	}
	else
	{
	    if(PlayerInfo[playerid][trCollected] != 15)
	    {
	        new tra[15];
	        RandomTreasureArray(tra,15-PlayerInfo[playerid][trCollected]);
		    for(new i = 0; i < 15-PlayerInfo[playerid][trCollected]; i++)
		    {
		        PlayerInfo[playerid][trIcon][i] = CreateDynamicMapIcon(TreasurePos[tra[i]][0],TreasurePos[tra[i]][1],TreasurePos[tra[i]][2],0,0x00FF00FF,MAX_PLAYERS+1,-1,playerid,200.0);
	        	Streamer_SetIntData(STREAMER_TYPE_MAP_ICON,PlayerInfo[playerid][trIcon][i],E_STREAMER_STYLE,MAPICON_LOCAL_CHECKPOINT);
				PlayerInfo[playerid][trObj][i*2] = CreateDynamicObject(19092,TreasurePos[tra[i]][0],TreasurePos[tra[i]][1],TreasurePos[tra[i]][2]+3.0,0,-110.0,0,MAX_PLAYERS+1,-1,playerid,150.0);
		        PlayerInfo[playerid][trObj][i*2+1] = CreateDynamicObject(19297,TreasurePos[tra[i]][0],TreasurePos[tra[i]][1],TreasurePos[tra[i]][2]+3.0,0,0,0,MAX_PLAYERS+1,-1,playerid,150.0);
		        PlayerInfo[playerid][trArea][i] = CreateDynamicSphere(TreasurePos[tra[i]][0],TreasurePos[tra[i]][1],TreasurePos[tra[i]][2],10.0,MAX_PLAYERS+1,-1,playerid);
			}
			for(new i = 0; i < 35; i++) TextDrawShowForPlayer(playerid,TreasureTD[i]);
			format(str,12,"%d/15",PlayerInfo[playerid][trCollected]);
			PlayerTextDrawSetString(playerid,TreasureTDPl[playerid][0],str);
			for(new i = 0; i < 2; i++) PlayerTextDrawShow(playerid,TreasureTDPl[playerid][i]);
		}
		else ShowTreasureTDs(playerid);
	}
	format(str,12,"DAY %d",PlayerInfo[playerid][pTreasureDays]);
	PlayerTextDrawSetString(playerid,TreasureTDPl[playerid][1],str);
	return 1;
}

public CreateTreasureAfterReg(playerid)
{
    new tra[15];
    RandomTreasureArray(tra,15);
	for(new i = 0; i < 15; i++)
	{
		PlayerInfo[playerid][trIcon][i] = CreateDynamicMapIcon(TreasurePos[tra[i]][0],TreasurePos[tra[i]][1],TreasurePos[tra[i]][2],0,0x00FF00FF,MAX_PLAYERS+1,-1,playerid,200.0);
		Streamer_SetIntData(STREAMER_TYPE_MAP_ICON,PlayerInfo[playerid][trIcon][i],E_STREAMER_STYLE,MAPICON_LOCAL_CHECKPOINT);
		PlayerInfo[playerid][trObj][i*2] = CreateDynamicObject(19092,TreasurePos[tra[i]][0],TreasurePos[tra[i]][1],TreasurePos[tra[i]][2]+3.0,0,-110.0,0,MAX_PLAYERS+1,-1,playerid,150.0);
		PlayerInfo[playerid][trObj][i*2+1] = CreateDynamicObject(19297,TreasurePos[tra[i]][0],TreasurePos[tra[i]][1],TreasurePos[tra[i]][2]+3.0,0,0,0,MAX_PLAYERS+1,-1,playerid,150.0);
		PlayerInfo[playerid][trArea][i] = CreateDynamicSphere(TreasurePos[tra[i]][0],TreasurePos[tra[i]][1],TreasurePos[tra[i]][2],10.0,MAX_PLAYERS+1,-1,playerid);
	}
	new str[32];
	for(new i = 0; i < 35; i++) TextDrawShowForPlayer(playerid,TreasureTD[i]);
	format(str,12,"%d/15",PlayerInfo[playerid][trCollected]);
	PlayerTextDrawSetString(playerid,TreasureTDPl[playerid][0],str);
	format(str,12,"DAY %d",PlayerInfo[playerid][pTreasureDays]);
	PlayerTextDrawSetString(playerid,TreasureTDPl[playerid][1],str);
	for(new i = 0; i < 2; i++) PlayerTextDrawShow(playerid,TreasureTDPl[playerid][i]);
	return 1;
}

public ShowTreasureTDs(playerid)
{
	if(PlayerInfo[playerid][trCollected] != 15)
	{
		for(new i = 0; i < 35; i++) TextDrawShowForPlayer(playerid,TreasureTD[i]);
		PlayerTextDrawShow(playerid,TreasureTDPl[playerid][0]);
	}
	else for(new i = 19; i < 35; i++) TextDrawShowForPlayer(playerid,TreasureTD[i]);
	PlayerTextDrawShow(playerid,TreasureTDPl[playerid][1]);
	return 1;
}

public HideTreasureTDs(playerid)
{
    for(new i = 0; i < 35; i++) TextDrawHideForPlayer(playerid,TreasureTD[i]);
	for(new i = 0; i < 2; i++) PlayerTextDrawHide(playerid,TreasureTDPl[playerid][i]);
	return 1;
}

public TreasureReward(playerid)
{
    for(new b = 35; b < 39; b++) TextDrawHideForPlayer(playerid,TreasureTD[b]);
	for(new i = 0; i < 15; i++) TextDrawShowForPlayer(playerid,RepTD[i]);
	TextDrawHideForPlayer(playerid,RepTD[13]);
	TextDrawShowForPlayer(playerid,TreasureTD[39]);
	new str[32];
	format(str,32,"%d",RewardInfo[playerid][Reputation]);
	PlayerTextDrawSetString(playerid,RepTDPl[playerid][0],str);
	format(str,32,"%d",RewardInfo[playerid][Money]);
	PlayerTextDrawSetString(playerid,RepTDPl[playerid][1],str);
	PlayerTextDrawShow(playerid,RepTDPl[playerid][0]);
	PlayerTextDrawShow(playerid,RepTDPl[playerid][1]);
	SelectTextDraw(playerid,0x73B1EDFF);
	SendClientMessage(playerid,Colour_Yellow,"Also, +10 nitro, ready and ram items.");
	return 1;
}

public AC_OnCheatDetected(playerid, type, extraint, Float:extrafloat, extraint2)
{
	switch(type)
	{
	    case CHEAT_JETPACK: Kick(playerid);
	    case CHEAT_WEAPON: ResetPlayerWeapons(playerid);
		case CHEAT_HEALTHARMOUR:
		{
		    SetPlayerHealth(playerid,100.0);
		    SetPlayerArmour(playerid,0.0);
		}
	}
	return 1;
}

public RestoreFlip(playerid)
{
	CanFlip[playerid] = true;
	FlipTimer[playerid] = -1;
	return 1;
}

public DestroyVehicleEx(vehicleid)
{
	DeleteGVar("ownerid",vehicleid);
	if(NeonObject[vehicleid][0] != INVALID_OBJECT_ID)
	{
 		DestroyDynamicObject(NeonObject[vehicleid][0]);
 		NeonObject[vehicleid][0] = INVALID_OBJECT_ID;
   		DestroyDynamicObject(NeonObject[vehicleid][1]);
   		NeonObject[vehicleid][1] = INVALID_OBJECT_ID;
	}
	if(GetGVarType("3did",vehicleid) != GLOBAL_VARTYPE_NONE)
	{
		new t3d = GetGVarInt("3did",vehicleid);
		DeleteGVar("3did",vehicleid);
		if(IsValidDynamic3DTextLabel(Text3D:t3d)) DestroyDynamic3DTextLabel(Text3D:t3d);
	}
	DestroyVehicle(vehicleid);
	return 1;
}

public TimeChange()
{
	new gh,h,m;
	if(TimeForward)
	{
		GlobMin += 7;
		if(GlobMin == 420) TimeForward = false;
	}
	else
	{
	    GlobMin -= 7;
	    if(GlobMin == 0) TimeForward = true;
	}
	m = GlobMin%60;
	h = (GlobMin-m)/60;
	gh = 22+h;
	if(gh > 23) gh = gh - 24;
	SetWorldTime(gh);
	foreach(new i : Player)
	{
		if(InGame[i] && SafeHouseState[i] == SAFEHOUSE_STATE_NONE)
		{
			if((!JoinedInRace[i] && InRace[i])||(JoinedInRace[i] && InRace[i])||(!JoinedInRace[i] && !InRace[i])) SetPlayerTime(i,gh,m);
			else
			{
			    SetPlayerTime(i,0,0);
				continue;
			}
		}
		else
		{
		    SetPlayerTime(i,0,0);
			continue;
		}
	}
	return 1;
}

public SetPlayerWorldTime(playerid)
{
    new gh,h,m;
    m = GlobMin%60;
	h = (GlobMin-m)/60;
	gh = 22+h;
	if(gh > 23) gh = gh - 24;
	SetPlayerTime(playerid,gh,m);
	return 1;
}

public RandomTreasureArray(array[],trnum)
{
    new numm,i = 0,bool:fd;
    while(i < trnum)
    {
        fd = false;
        numm = random(sizeof(TreasurePos));
        if(i == 0)
        {
            array[i] = numm;
            i++;
        }
        else
        {
            for(new j = 0; j < i; j++)
            {
                if(array[j] == numm)
                {
                    fd = true;
                    break;
                }
            }
            if(!fd)
            {
                array[i] = numm;
                i++;
            }
        }
    }
    return 1;
}

public CheckEmail(str[],size)
{
	new fp[32],sp[32];
	if(sscanf(str,"p<@>s[32]s[32]",fp,sp)) return 0;
	new bool:dg = false;
	for(new i = 0; i < size; i++)
	{
	    if('a' <= str[i] <= 'z' || 'A' <= str[i] <= 'Z' || '0' <= str[i] <= '9' ||  str[i] == '-' || str[i] == '.' || str[i] == '_') continue;
	    else
		{
		    if(str[i] == '@')
		    {
		        if(!dg)
		        {
		            dg = true;
		            continue;
				}
				else return 0;
			}
			else return 0;
		}
	}
	return 1;
}

public CheckDriverName(str[],size)
{
	for(new i = 0; i < size; i++)
	{
	    if('a' <= str[i] <= 'z' || 'A' <= str[i] <= 'Z' || '0' <= str[i] <= '9') continue;
	    else return 0;
	}
	return 1;
}

public RestoreKick(playerid)
{
	CanBeKicked[playerid] = true;
	KickTimer[playerid] = -1;
	return 1;
}
