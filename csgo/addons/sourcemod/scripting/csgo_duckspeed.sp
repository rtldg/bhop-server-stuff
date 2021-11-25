public Action OnPlayerRunCmd(int client, int &buttons)
{
	if (buttons & IN_DUCK)
	{
		SetEntPropFloat(client, Prop_Send, "m_flDuckSpeed", 8.0);
	}
}
