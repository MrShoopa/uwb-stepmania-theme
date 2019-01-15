function SetSongIni(song)
	local SongIni={};
	if not GAMESTATE:IsCourseMode() then
		local s_ini=song:GetSongDir().."song.ini";
		if FILEMAN:DoesFileExist(s_ini) then
			local f=OpenFile(s_ini);
			SongIni["EXF_Title"]=GetFileParameter(f,"displayexftitle");
			SongIni["EXF_SubTitle"]=GetFileParameter(f,"displayexfsubtitle");
			SongIni["EXF_Artist"]=GetFileParameter(f,"displayexfartist");
			SongIni["FC_Color"]=GetFileParameter(f,"fccolor");
			SongIni["W1FC_Color"]=GetFileParameter(f,"w1fccolor");
			SongIni["W2FC_Color"]=GetFileParameter(f,"w2fccolor");
			SongIni["W3FC_Color"]=GetFileParameter(f,"w3fccolor");
			SongIni["W4FC_Color"]=GetFileParameter(f,"w4fccolor");
			SongIni["CLEARED_Text"]=GetFileParameter(f,"clearedtext");
			CloseFile(f);
		end;
	end;
	setenv("SongIni",SongIni);
end;
