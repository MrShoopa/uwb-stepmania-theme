--[ja] ファイルから読み取る情報。何度も呼ぶと重いのでローカル変数で作っておく 
local i=...;
local c=Color("Black");
local g="";
local folder="";
local wheelmode=GetWheelMode();
local title={};
local artist="";

local t = Def.ActorFrame{};
t[#t+1]=Def.ActorFrame{
	OnCommand=cmd(playcommand,"Set");
	SetCommand=function(self)
		local cnt=GetEXFSongA(i+GetEXFCurrentSong());
		local song=GetEXFSongState_Song(cnt);
		if song then
			folder=song:GetSongDir();
			title[2]=GetEXFSongState_SubTitle(cnt);
			if title[2]=="" then
				local song_title=SplitTitle(GetEXFSongState_Title(cnt));
				title[1]=song_title[1];
				title[2]=song_title[2];
			else
				title[1]=GetEXFSongState_Title(cnt);
			end;
			artist=GetEXFSongState_Artist(cnt);
			local n_group=""..song:GetGroupName();
			local n_song=string.lower(GetSong2Folder(song));
			local menucolor=GetSongs_str(n_group.."/"..n_song,'color');
			local metertype=GetSongs_str(n_group.."/"..n_song,'metertype');
			if GetEXFSongState_Color(cnt) then
				c=GetEXFSongState_Color(cnt);
			else
				if not menucolor then
					if IsBossColor(song,metertype) then
						c=Color("Red");
					else
						c=waieiColor("WheelDefault");
					end;
				else
					c=menucolor;
				end;
			end;
			local fall_bg=THEME:GetPathG("Common fallback","background");
			local fall_bn=THEME:GetPathG("Common fallback","banner");

			local tmp={};
			g=GetEXFSongState_Jacket(cnt);
			ty=3;
			if i==0 then
				local SongInf={};
				SongInf["Title"]=title[1];
				SongInf["SubTitle"]=title[2];
				SongInf["Artist"]=artist;
				setenv("SongInf",SongInf);
			end;
			local tc_paramas={};
			tc_paramas["Index"]=i;
			tc_paramas["Song"]=song;
			tc_paramas["Title"]=title[1];
			tc_paramas["SubTitle"]=title[2];
			tc_paramas["Artist"]=artist;
			tc_paramas["MeterType"]=metertype;
			tc_paramas["Color"]=c;
			tc_paramas["Graphic"]=g;
			TC_SetWheelSong(i,tc_paramas);
		end;
	end;
	LoadActor(TC_GetPath("Wheel","Song"),i);
};
return t;