#include <sourcemod>
#include <smlib/arrays>
#include <smlib/entities>
#include <shavit>

ConVar sv_client_predict = null;

bool g_bIsLeader[MAXPLAYERS + 1];
bool g_bIsFollower[MAXPLAYERS + 1];
int  g_myLeader[MAXPLAYERS + 1];

ArrayList g_hCongaLines[MAXPLAYERS + 1];
ArrayList g_hCongaFrames[MAXPLAYERS + 1];
ArrayList g_hCongaAngles[MAXPLAYERS + 1];
float g_vLastPos[MAXPLAYERS + 1][3];

public void OnPluginStart()
{
	RegConsoleCmd("sm_conga", SM_Conga, "Join or start a conga line!");
	
	HookEvent("player_death", Event_PlayerDeath);

	sv_client_predict = FindConVar("sv_client_predict");
	sv_client_predict.IntValue = -1;
	
	RegConsoleCmd("sm_ctest", SM_Test);
}

public Action SM_Test(int client, int args)
{
	PrintToChat(client, "%d", GetArraySize(g_hCongaFrames[client]));
}

public void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	
	if(client != 0)
	{
		if(g_bIsLeader[client] == true)
		{
			if(!IsFakeClient(client))
				RemoveAndUpdateLeader(client);
		}
		else if(g_bIsFollower[client] == true)
		{
			RemoveFollower(client);
		}
	}
}

public void Shavit_OnReplayStart(int client)
{
	StartCongaLine(client);
}

// public void OnClientConnected(int client)
// {
// 	if (IsFakeClient(client))
// 		StartCongaLine(client);
// }

public void OnClientDisconnect(int client)
{
	if(g_bIsFollower[client] == true)
	{
		RemoveFollower(client);
	}
	else if(g_bIsLeader[client] == true)
	{
		RemoveAndUpdateLeader(client);
	}
	
	g_bIsLeader[client]   = false;
	g_bIsFollower[client] = false;
}

public Action SM_Conga(int client, int args)
{
	if(IsPlayerAlive(client))
	{
		Menu menu = new Menu(Menu_Conga);
		menu.SetTitle("Conga menu");
		
		if(g_bIsLeader[client] || g_bIsFollower[client])
		{
			menu.AddItem("leave", "Leave conga line");
		}
		else
		{
			// Start your own
			menu.AddItem("start", "Start a conga line");
			
			// .. or join from list of leaders
			char sInfo[16], sDisplay[64];
			for(int leader = 1; leader <= MaxClients; leader++)
			{
				if(IsClientInGame(leader) && IsPlayerAlive(leader) && g_bIsLeader[leader] && GetArraySize(g_hCongaFrames[leader]) > 13)
				{
					IntToString(GetClientUserId(leader), sInfo, sizeof(sInfo));
					FormatEx(sDisplay, sizeof(sDisplay), "Conga with %N", leader);
					menu.AddItem(sInfo, sDisplay);
				}
			}
		}
		
		menu.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		PrintToChat(client, "[Conga] - You must be alive to conga.");
	}
	
	return Plugin_Handled;
}

public int Menu_Conga(Menu menu, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
		char sInfo[32];
		menu.GetItem(param2, sInfo, sizeof(sInfo));
		
		if(StrEqual(sInfo, "start")) // Start a conga line
		{
			StartCongaLine(param1);
		}
		else if(StrEqual(sInfo, "leave")) // Leave current conga line
		{
			if(g_bIsLeader[param1])
			{
				RemoveAndUpdateLeader(param1);
			}
			else if(g_bIsFollower[param1])
			{
				RemoveFollower(param1);
			}
		}
		else // Join a conga line
		{
			int leader = GetClientOfUserId(StringToInt(sInfo));
			
			if(leader != 0)
			{
				JoinCongaLine(param1, leader);
			}
			else
			{
				PrintToChat(param1, "[Conga] - The leader of the conga line you selected left the game.");
			}
		}
	}
}

void StartCongaLine(int client)
{
	if(g_hCongaLines[client] == INVALID_HANDLE)
	{
		g_hCongaLines[client]  = CreateArray();
		g_hCongaFrames[client] = CreateArray(3);
		g_hCongaAngles[client] = CreateArray(3);
	}
	
	ClearArray(g_hCongaLines[client]);
	ClearArray(g_hCongaFrames[client]);
	ClearArray(g_hCongaAngles[client]);
	
	g_bIsLeader[client] = true;
	if (!IsFakeClient(client))
		PrintToChat(client, "[Conga] - You are now a conga line leader.");
}

public Action Shavit_OnStartPre(int client)
{
	if(g_bIsFollower[client] == true)
	{
		return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

void JoinCongaLine(int client, int leader)
{
	PushArrayCell(g_hCongaLines[leader], client);
	
	Shavit_StopTimer(client);
	g_bIsFollower[client] = true;
	g_myLeader[client]    = leader;
	sv_client_predict.ReplicateToClient(client, "0");
}

// Remove the leader (client) from the conga line and transfer leadership to 2nd in line
void RemoveAndUpdateLeader(int client)
{
	int iSize = GetArraySize(g_hCongaLines[client]);
	
	if(iSize > 0)
	{
		int newLeader = GetArrayCell(g_hCongaLines[client], 0);
		g_bIsFollower[newLeader] = false;
		StartCongaLine(newLeader);
		
		if(iSize > 1)
		{
			int follower;
			for(int idx = 1; idx < iSize; idx++)
			{
				follower = GetArrayCell(g_hCongaLines[client], idx);
				PushArrayCell(g_hCongaLines[newLeader], follower);
				g_myLeader[follower] = newLeader;
			}
		}
	}
	else
	{
		g_bIsLeader[client] = false;
	}
	
	ClearArray(g_hCongaLines[client]);
}

void RemoveFollower(int client)
{
	int iSize = GetArraySize(g_hCongaLines[g_myLeader[client]]);
	
	for(int idx; idx < iSize; idx++)
	{
		if(GetArrayCell(g_hCongaLines[g_myLeader[client]], idx) == client)
		{
			RemoveFromArray(g_hCongaLines[g_myLeader[client]], idx);
			break;
		}
	}
	
	g_bIsFollower[client] = false;
	sv_client_predict.ReplicateToClient(client, "-1");
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[3])
{
	if(g_bIsLeader[client] == true)
	{
		float vPos[3];
		Entity_GetAbsOrigin(client, vPos);
		
		if(IsPositionDifferent(vPos, g_vLastPos[client]))
		{
			RecordCongaFrame(client);
		}
		
		Array_Copy(vPos, g_vLastPos[client], sizeof(g_vLastPos[]));
	}
	else if(g_bIsFollower[client])
	{
		int placeInCongaLine = GetFollowerPlaceInLine(client);
		
		if(placeInCongaLine != -1)
		{
			int iSize = GetArraySize(g_hCongaFrames[g_myLeader[client]]);
			
			// 1 / 1 * 40
			int frameInCongaLine = iSize - RoundToNearest(float(placeInCongaLine) / float(GetArraySize(g_hCongaLines[g_myLeader[client]])) * float(iSize));
			
			float vCurrentPos[3];
			Entity_GetAbsOrigin(client, vCurrentPos);
			
			float vPos[3];
			GetArrayArray(g_hCongaFrames[g_myLeader[client]], frameInCongaLine, vPos, sizeof(vPos));

			float ang[3];
			GetArrayArray(g_hCongaAngles[g_myLeader[client]], frameInCongaLine, ang, sizeof(ang));

			Entity_GetAbsOrigin(g_myLeader[client], vPos);
			GetClientEyeAngles(g_myLeader[client], ang);

			if(false && GetVectorDistance(vPos, vCurrentPos) > 50.0)
			{
				TeleportEntity(client, vPos, ang, NULL_VECTOR);
			}
			else
			{
				float vVel[3];
				//MakeVectorFromPoints(vCurrentPos, vPos, vVel);
				//ScaleVector(vVel, 1.0/GetTickInterval());
				GetEntPropVector(g_myLeader[client], Prop_Data, "m_vecVelocity", vVel);
				TeleportEntity(client, vPos, ang, vVel);
			}
		}
	}
}

void RecordCongaFrame(int client)
{
	float vPos[3];
	Entity_GetAbsOrigin(client, vPos);
	float ang[3];
	GetClientEyeAngles(client, ang);

	int fExpectedDistance = 70;
	float fVel = GetClientVelocity(client, true, true, true);
	float fTickInterval = GetTickInterval();

	// 40 / (Velocity * GetTickInterval)
	while(GetArraySize(g_hCongaFrames[client]) > RoundToNearest(fExpectedDistance / (fVel * fTickInterval)) * (GetArraySize(g_hCongaLines[client]) + 1))
	{
		if (!GetArraySize(g_hCongaFrames[client]))
			break;
		RemoveFromArray(g_hCongaFrames[client], 0);
		RemoveFromArray(g_hCongaAngles[client], 0);
	}

	PushArrayArray(g_hCongaFrames[client], vPos);
	PushArrayArray(g_hCongaAngles[client], ang);
}

bool IsPositionDifferent(const float vPos[3], const float vPos2[3])
{
	for(int idx; idx < 3; idx++)
	{
		if(FloatAbs(vPos[idx] - vPos2[idx]) > 0.0001)
		{
			return true;
		}
	}
	
	return false;
}

int GetFollowerPlaceInLine(int client)
{
	int iSize = GetArraySize(g_hCongaLines[g_myLeader[client]]);
	
	for(int idx; idx < iSize; idx++)
	{
		if(GetArrayCell(g_hCongaLines[g_myLeader[client]], idx) == client)
		{
			return idx + 1;
		}
	}
	
	return -1;
}

float GetClientVelocity(int client, bool UseX, bool UseY, bool UseZ)
{
	float vVel[3];
	
	if(UseX)
	{
		vVel[0] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[0]");
	}
	
	if(UseY)
	{
		vVel[1] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[1]");
	}
	
	if(UseZ)
	{
		vVel[2] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[2]");
	}
	
	return GetVectorLength(vVel);
}
