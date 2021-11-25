#include <sourcemod>
#include <sdktools>

public Plugin myinfo = {
	name = "Model meme",
	author = "Joe",
	version = "1.0.0",
	description = "Meme models you bitch",
	url = "https://www.google.com/"
};

/*
char models_ct[][] = {
	"models/player/ct_urban.mdl",
	"models/player/ct_gsg9.mdl",
	"models/player/ct_sas.mdl",
	"models/player/ct_gign.mdl"
};

char models_t[][] = {
	"models/player/t_phoenix.mdl",
	"models/player/t_leet.mdl",
	"models/player/t_arctic.mdl",
	"models/player/t_guerilla.mdl"
};
*/

ArrayList playermodels;

public OnPluginStart()
{
	// TODO: Add command to list models & and a menu to change model...
	playermodels = new ArrayList(128);
	if (!loadmodels(playermodels, "configs/modelmeme.txt"))
		SetFailState("[MODELMEME] Failed to load configs/modelmeme.txt");

	HookEvent("player_spawn", EventPlayerSpawn, EventHookMode_Post);
}

bool loadmodels(ArrayList models, char[] filename)
{
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, PLATFORM_MAX_PATH, filename);
	File f = OpenFile(path, "r");
	if (!f) return false;
	char buf[128];
	while (f.ReadLine(buf, sizeof(buf)))
	{
		TrimString(buf);
		if (buf[0] == '#' || (buf[0] == '/' && buf[1] == '/'))
			continue;
		if (!FileExists(buf, true, NULL_STRING))
			continue;
		int len = strlen(buf);
		if (len < 5 || !StrEqual(buf[len-4], ".mdl", false))
			continue;
		models.PushString(buf);
		PrecacheModel(buf, true);
	}
	return true;
}

Action EventPlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	if (playermodels.Length > 0)
	{
		char buf[128];
		playermodels.GetString(GetRandomInt(0, playermodels.Length-1), buf, sizeof(buf));
		SetEntityModel(GetClientOfUserId(event.GetInt("userid")), buf);
	}
	return Plugin_Continue;
}
