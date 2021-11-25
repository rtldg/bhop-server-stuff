#include <sourcemod>
#include <shavit>

int thing1 = 5;
int thing2 = 28;

int GetMinutesTillServerRestart()
{
	int time = GetTime();
	char fuck[3];
	FormatTime(fuck, sizeof(fuck), "%H", time);
	int hours = StringToInt(fuck);
	FormatTime(fuck, sizeof(fuck), "%M", time);
	int minutes = StringToInt(fuck);
	return (((hours < thing1) ? thing1 : thing2) - hours) * 60 - minutes;
}

public void OnPluginStart()
{
	CreateTimer(60.0, Timer_RestartMessage, 0, TIMER_REPEAT);
}

char thing[][] = {
	"FF0000",
	"00FF00",
	"0000FF"
};

Action Timer_RestartMessage(Handle timer, any data)
{
	int minutes = GetMinutesTillServerRestart();
	if (minutes < 25)
		for (int i = 0; i < 3; i++)
			Shavit_PrintToChatAll("\x07%sServer restarts in %d minutes", thing[i], minutes);
	return Plugin_Continue;
}