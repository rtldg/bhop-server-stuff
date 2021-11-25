#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "sm_bring",
	author = "AAA",
	description = "Go to a player or teleport a player to you",
	version = "1.0.0.0",
	url = ""
};

public void OnPluginStart()
{
	RegAdminCmd("sm_bring", Command_Bring, ADMFLAG_ROOT, "Teleport a player to you");
}

public Action Command_Bring(int client, int args)
{
	if (client == 0)
	{
		return Plugin_Handled;
	}

	if (args < 1)
	{
		ReplyToCommand(client, "Usage: sm_bring <player>");
		return Plugin_Handled;
	}
	
	char sArgs[MAX_TARGET_LENGTH];
	GetCmdArgString(sArgs, MAX_TARGET_LENGTH);

	int target = FindTarget(client, sArgs, false, false);

	if(target == -1)
	{
		return Plugin_Handled;
	}

	if (target == client)
	{
		ReplyToCommand(client, "Can't bring self");
		return Plugin_Handled;
	}

	float empty[3];
	float destination[3], angles[3];

	GetClientEyeAngles(client, angles);
	GetClientAbsOrigin(client, destination);
	destination[2] += 1.0;

	TeleportEntity(target, destination, angles, empty);
	return Plugin_Handled;
}
