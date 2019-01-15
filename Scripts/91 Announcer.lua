local announcer="";

function GetCurrentAnnouncer()
	announcer=ANNOUNCER:GetCurrentAnnouncer();
	return announcer;
end;

function MuteAnnouncer()
	if not announcer or announcer=="" then
		announcer = GetCurrentAnnouncer();
	end;
	ANNOUNCER:SetCurrentAnnouncer("");
end;

function ResetAnnouncer()
	if announcer and announcer~="" then
		ANNOUNCER:SetCurrentAnnouncer(announcer);
		announcer="";
	end;
end;
