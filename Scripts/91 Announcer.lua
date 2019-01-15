function InputCurrentAnnouncer()
	local an=ANNOUNCER:GetCurrentAnnouncer();
	setenv("Announcers",an);
	return an;
end;

function MuteAnnouncer()
	if not getenv("Announcers") or getenv("Announcers")=="" then
		InputCurrentAnnouncer();
	end;
	ANNOUNCER:SetCurrentAnnouncer("");
end;

function ResetAnnouncer()
	if getenv("Announcers") then
		ANNOUNCER:SetCurrentAnnouncer(getenv("Announcers"));
		setenv("Announcers",nil)
	end;
end;
