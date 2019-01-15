local t = Def.ActorFrame{};
local c=TC_GetColor("Wheel Mode");
local difcolor=GetUserPref_Theme("UserDifficultyColor");
local difname=GetUserPref_Theme("UserDifficultyName");
t[#t+1]=Def.ActorFrame{
	SetCommand=function(self,params)
		if params then
			local g="";
			local gn=0;
			local n='';
			--[=[
			for i=1,SONGMAN:GetNumSongGroups() do
				if grData[""..i.."-Path"]==params.Text then
					gn=i;
					break;
				end;
			end;
			if grData then
				g=grData[""..gn.."-Jacket"];
				if not g or g=="" then
					g=grData[""..gn.."-Banner"];
				end;
				if not g or g=="" then
					-- call fallback
					g=THEME:GetPathG("Common","fallback jacket");
				end;
			else
				g=THEME:GetPathG("Common","fallback jacket");
			end;
			local gc;
			if string.find(grSortMode[grSys["Sort"]],"^dif.*") then
				gc=ColorLightTone2(grSys["Color-"..grSortMode[grSys["Sort"]]]);
			else
				gc=color("#ffffff");
			end;
			--]=]
			if string.find(params.Label,'Beginner',0,true) then
				g=TC_GetPath('SortJacket','Difficulty');
				gc=_DifficultyLightCOLOR2(difcolor,'Difficulty_Beginner');
				n=string.gsub(params.Label,'Begginer',_DifficultyNAME2(difname,'Difficulty_Beginner'));
			elseif string.find(params.Label,'Easy',0,true) then
				g=TC_GetPath('SortJacket','Difficulty');
				gc=_DifficultyLightCOLOR2(difcolor,'Difficulty_Easy');
				n=string.gsub(params.Label,'Easy',_DifficultyNAME2(difname,'Difficulty_Easy'));
			elseif string.find(params.Label,'Medium',0,true) then
				g=TC_GetPath('SortJacket','Difficulty');
				gc=_DifficultyLightCOLOR2(difcolor,'Difficulty_Medium');
				n=string.gsub(params.Label,'Medium',_DifficultyNAME2(difname,'Difficulty_Medium'));
			elseif string.find(params.Label,'Hard',0,true) then
				g=TC_GetPath('SortJacket','Difficulty');
				gc=_DifficultyLightCOLOR2(difcolor,'Difficulty_Hard');
				n=string.gsub(params.Label,'Hard',_DifficultyNAME2(difname,'Difficulty_Hard'));
			elseif string.find(params.Label,'Challenge',0,true) then
				g=TC_GetPath('SortJacket','Difficulty');
				gc=_DifficultyLightCOLOR2(difcolor,'Difficulty_Challenge');
				n=string.gsub(params.Label,'Challenge',_DifficultyNAME2(difname,'Difficulty_Challenge'));
			else
				gc=color("#ffffff");
				n=params.Label;
				if string.find(params.Label,THEME:GetString('MusicWheel','PreferredText'),0,true) then
					g=TC_GetPath('SortJacket','Group');
				elseif string.find(params.Label,THEME:GetString('MusicWheel','TitleText'),0,true) then
					g=TC_GetPath('SortJacket','Title');
				elseif string.find(params.Label,THEME:GetString('MusicWheel','ArtistText'),0,true) then
					g=TC_GetPath('SortJacket','Artist');
				elseif string.find(params.Label,THEME:GetString('MusicWheel','BpmText'),0,true) then
					g=TC_GetPath('SortJacket','BPM');
				elseif string.find(params.Label,THEME:GetString('MusicWheel','LengthText'),0,true) then
					g=TC_GetPath('SortJacket','Time');
				else
					g=TC_GetPath('SortJacket','Fallback');
				end;
			end;

			local tc_paramas={};
			tc_paramas["Index"]=params.DrawIndex-math.round(tonumber(THEME:GetMetric("MusicWheel","NumWheelItems"))/2);
			tc_paramas["Label"]=n;
			tc_paramas["Color"]=c;
			tc_paramas["Graphic"]=g;
			tc_paramas["GraphicColor"]=gc;
			tc_paramas["NumSongs"]=0;
			tc_paramas["GroupName"]="仮置き";
			TC_SetWheelFolder(params,tc_paramas);
		end;
	end;
	LoadActor(TC_GetPath("Wheel","Mode"));
};
return t;