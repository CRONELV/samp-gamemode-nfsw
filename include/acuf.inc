/*  SA-MP Compatible Upgrades Function's
 *
 *		Version: 1.2
 *
 *  (c) Copyright 2011, AirKite
 */
 
#if defined _acuf_included
	#endinput
#endif
#define _acuf_included

/*
native IsVehicleUpgradeCompatible(model,componentid);
*/

stock IsVehicleUpgradeCompatible(model,componentid)
{
	switch(model)
	{
		case 400:
		{
			switch(componentid)
			{
				case 1008,1009,1010,1013,1018,1019,1020,1021,1024,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,
					1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 401:
		{
			switch(componentid)
			{
				case 1001,1003,1004,1005,1006,1007,1008,1009,1010,1013,1017,1019,1020,1025,1073,1074,1075,1076,1077,1078,
					1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,1098,1142,1143,1144: return 1;
			}
		}
		case 404:
		{
			switch(componentid)
			{
				case 1000,1002,1007,1008,1009,1010,1013,1016,1017,1019,1020,1021,1025,1073,1074,1075,1076,1077,1078,1079,
					1080,1081,1082,1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 405:
		{
			switch(componentid)
			{
				case 1000,1001,1008,1009,1010,1014,1018,1019,1020,1021,1023,1025,1073,1074,1075,1076,1077,1078,1079,1080,
					1081,1082,1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 410:
		{
			switch(componentid)
			{
				case 1001,1003,1007,1008,1009,1010,1013,1017,1019,1020,1021,1023,1024,1025,1073,1074,1075,1076,1077,1078,
					1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 415:
		{
			switch(componentid)
			{
				case 1001,1003,1007,1008,1009,1010,1017,1018,1019,1023,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,
					1082,1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 418:
		{
			switch(componentid)
			{
				case 1002,1006,1008,1009,1010,1016,1020,1021,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,
					1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 420:
		{
			switch(componentid)
			{
				case 1001,1003,1004,1005,1008,1009,1010,1019,1021,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,
					1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 421:
		{
			switch(componentid)
			{
				case 1000,1008,1009,1010,1014,1016,1018,1019,1020,1021,1023,1025,1073,1074,1075,1076,1077,1078,1079,1080,
					1081,1082,1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 422:
		{
			switch(componentid)
			{
				case 1007,1008,1009,1010,1013,1017,1019,1020,1021,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,
					1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 426:
		{
			switch(componentid)
			{
				case 1001,1003,1004,1005,1006,1008,1009,1010,1019,1021,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,
					1082,1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 436:
		{
			switch(componentid)
			{
				case 1001,1003,1006,1007,1008,1009,1010,1013,1017,1019,1020,1021,1022,1025,1073,1074,1075,1076,1077,1078,
					1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 439:
		{
			switch(componentid)
			{
				case 1001,1003,1007,1008,1009,1010,1013,1017,1023,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,
					1083,1084,1085,1087,1096,1097,1098,1142,1143,1144,1145: return 1;
			}
		}
		case 477:
		{
			switch(componentid)
			{
				case 1006,1007,1008,1009,1010,1017,1018,1019,1020,1021,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,
					1082,1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 478:
		{
			switch(componentid)
			{
				case 1004,1005,1008,1009,1010,1012,1013,1020,1021,1022,1024,1025,1073,1074,1075,1076,1077,1078,1079,1080,
					1081,1082,1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 489:
		{
			switch(componentid)
			{
				case 1000,1002,1004,1005,1006,1008,1009,1010,1013,1016,1018,1019,1020,1024,1025,1073,1074,1075,1076,1077,
					1078,1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 491:
		{
			switch(componentid)
			{
				case 1003,1007,1008,1009,1010,1014,1017,1018,1019,1020,1021,1023,1025,1073,1074,1075,1076,1077,1078,1079,
					1080,1081,1082,1083,1084,1085,1087,1096,1097,1098,1142,1143,1144,1145: return 1;
			}
		}
		case 492:
		{
			switch(componentid)
			{
				case 1000,1004,1005,1006,1008,1009,1010,1016,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,
					1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 496:
		{
			switch(componentid)
			{
				case 1001,1002,1003,1006,1007,1008,1009,1010,1011,1017,1019,1020,1023,1025,1073,1074,1075,1076,1077,1078,
					1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,1098,1142,1143: return 1;
			}
		}
		case 500:
		{
			switch(componentid)
			{
				case 1008,1009,1010,1013,1019,1020,1021,1024,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,
					1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 516:
		{
			switch(componentid)
			{
				case 1000,1002,1004,1007,1008,1009,1010,1015,1016,1017,1018,1019,1020,1021,1025,1073,1074,1075,1076,1077,
					1078,1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 517:
		{
			switch(componentid)
			{
				case 1002,1003,1007,1008,1009,1010,1016,1017,1018,1019,1020,1023,1025,1073,1074,1075,1076,1077,1078,1079,
					1080,1081,1082,1083,1084,1085,1087,1096,1097,1098,1142,1143,1144,1145: return 1;
			}
		}
		case 518:
		{
			switch(componentid)
			{
				case 1001,1003,1005,1006,1007,1008,1009,1010,1013,1017,1018,1020,1023,1025,1073,1074,1075,1076,1077,1078,
					1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,1098,1142,1143,1144,1145: return 1;
			}
		}
		case 527:
		{
			switch(componentid)
			{
				case 1001,1007,1008,1009,1010,1014,1015,1017,1018,1020,1021,1025,1073,1074,1075,1076,1077,1078,1079,1080,
					1081,1082,1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 529:
		{
			switch(componentid)
			{
				case 1001,1003,1006,1007,1008,1009,1010,1011,1012,1017,1018,1019,1020,1023,1025,1073,1074,1075,1076,1077,
					1078,1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 534:
		{
			switch(componentid)
			{
				case 1008,1009,1010,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,
					1098,1100,1101,1106,1122,1123,1124,1125,1126,1127,1178,1179,1180,1185: return 1;
			}
		}
		case 535:
		{
			switch(componentid)
			{
				case 1008,1009,1010,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,
					1098,1109,1110,1113,1114,1115,1116,1117,1118,1119,1120,1121: return 1;
			}
		}
		case 536:
		{
			switch(componentid)
			{
				case 1008,1009,1010,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,
					1098,1103,1104,1105,1107,1108,1128,1181,1182,1183,1184: return 1;
			}
		}
		case 540:
		{
			switch(componentid)
			{
				case 1001,1004,1006,1007,1008,1009,1010,1017,1018,1019,1020,1023,1024,1025,1073,1074,1075,1076,1077,1078,
					1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,1098,1142,1143,1144,1145: return 1;
			}
		}
		case 542:
		{
			switch(componentid)
			{
				case 1008,1009,1010,1014,1015,1018,1019,1020,1021,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,
					1083,1084,1085,1087,1096,1097,1098,1144,1145: return 1;
			}
		}
		case 546:
		{
			switch(componentid)
			{
				case 1001,1002,1004,1006,1007,1008,1009,1010,1017,1018,1019,1023,1024,1025,1073,1074,1075,1076,1077,1078,
					1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,1098,1142,1143,1144,1145: return 1;
			}
		}
		case 547:
		{
			switch(componentid)
			{
				case 1000,1003,1008,1009,1010,1016,1018,1019,1020,1021,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,
					1082,1083,1084,1085,1087,1096,1097,1098,1142,1143: return 1;
			}
		}
		case 549:
		{
			switch(componentid)
			{
				case 1001,1003,1007,1008,1009,1010,1011,1012,1017,1018,1019,1020,1023,1025,1073,1074,1075,1076,1077,1078,
					1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,1098,1142,1143,1144,1145: return 1;
			}
		}
		case 550:
		{
			switch(componentid)
			{
				case 1001,1003,1004,1005,1006,1008,1009,1010,1018,1019,1020,1023,1025,1073,1074,1075,1076,1077,1078,1079,
					1080,1081,1082,1083,1084,1085,1087,1096,1097,1098,1142,1143,1144,1145: return 1;
			}
		}
		case 551:
		{
			switch(componentid)
			{
				case 1002,1003,1005,1006,1008,1009,1010,1016,1018,1019,1020,1021,1023,1025,1073,1074,1075,1076,1077,1078,
					1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 558:
		{
			switch(componentid)
			{
				case 1008,1009,1010,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1087,1088,1089,
					1090,1091,1092,1093,1094,1095,1096,1097,1098,1163,1164,1165,1166,1167,1168: return 1;
			}
		}
		case 559:
		{
			switch(componentid)
			{
				case 1008,1009,1010,1025,1065,1066,1067,1068,1069,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,
					1081,1082,1083,1084,1085,1087,1096,1097,1098,1158,1159,1160,1161,1162,1173: return 1;
			}
		}
		case 560:
		{
			switch(componentid)
			{
				case 1008,1009,1010,1025,1026,1027,1028,1029,1030,1031,1032,1033,1073,1074,1075,1076,1077,1078,1079,1080,
					1081,1082,1083,1084,1085,1087,1096,1097,1098,1138,1139,1140,1141,1169,1170: return 1;
			}
		}
		case 561:
		{
			switch(componentid)
			{
				case 1008,1009,1010,1025,1055,1056,1057,1058,1059,1060,1061,1062,1063,1064,1073,1074,1075,1076,1077,1078,
					1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,1098,1154,1155,1156,1157: return 1;
			}
		}
		case 562:
		{
			switch(componentid)
			{
				case 1008,1009,1010,1025,1034,1035,1036,1037,1038,1039,1040,1041,1073,1074,1075,1076,1077,1078,1079,1080,
					1081,1082,1083,1084,1085,1087,1096,1097,1098,1146,1147,1148,1149,1171,1172: return 1;
			}
		}
		case 565:
		{
			switch(componentid)
			{
				case 1008,1009,1010,1025,1045,1046,1047,1048,1049,1050,1051,1052,1053,1054,1073,1074,1075,1076,1077,1078,
					1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,1098,1150,1151,1152,1153: return 1;
			}
		}
		case 567:
		{
			switch(componentid)
			{
				case 1008,1009,1010,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,
					1098,1102,1129,1130,1131,1132,1133,1186,1187,1188,1189: return 1;
			}
		}
		case 575:
		{
			switch(componentid)
			{
				case 1008,1009,1010,1025,1042,1043,1044,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,
					1087,1096,1097,1098,1099,1174,1175,1176,1177: return 1;
			}
		}
		case 576:
		{
			switch(componentid)
			{
				case 1008,1009,1010,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,
					1098,1134,1135,1136,1137,1190,1191,1192,1193: return 1;
			}
		}
		case 580:
		{
			switch(componentid)
			{
				case 1001,1006,1007,1008,1009,1010,1017,1018,1020,1023,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,
					1082,1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 585:
		{
			switch(componentid)
			{
				case 1001,1003,1006,1007,1008,1009,1010,1013,1017,1018,1019,1020,1023,1025,1073,1074,1075,1076,1077,1078,
					1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,1098,1142,1143,1144,1145: return 1;
			}
		}
		case 589:
		{
			switch(componentid)
			{
				case 1000,1004,1005,1006,1007,1008,1009,1010,1013,1016,1017,1018,1020,1024,1025,1073,1074,1075,1076,1077,
					1078,1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,1098,1144,1145: return 1;
			}
		}
		case 600:
		{
			switch(componentid)
			{
				case 1004,1005,1006,1007,1008,1009,1010,1013,1017,1018,1020,1022,1025,1073,1074,1075,1076,1077,1078,1079,
					1080,1081,1082,1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
		case 603:
		{
			switch(componentid)
			{
				case 1001,1006,1007,1008,1009,1010,1017,1018,1019,1020,1023,1024,1025,1073,1074,1075,1076,1077,1078,1079,
					1080,1081,1082,1083,1084,1085,1087,1096,1097,1098,1142,1143,1144,1145: return 1;
			}
		}
		case 402,403,406..409,411..414,416,419,423,424,427..429,431..435,437,438,440..445,448,450,451,455..459,461..463,
			466..468,470,471,474,475,479..486,490,494,495,498,499,502..510,514,515,521..526,528,530..533,541,552,543..545,554..557,
				566,568,578,571..574,579,581..584,586..588,591,594,596..599,601,602,604..611:
		{
			switch(componentid)
			{
				case 1008,1009,1010,1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1087,1096,1097,1098: return 1;
			}
		}
	}
	return 0;
}