local t=Def.ActorFrame{};

if PREFSMAN:GetPreference("ShowLyrics") then
	t[#t+1]=Def.ActorFrame{
		LyricSet();
	};
end;

return t;