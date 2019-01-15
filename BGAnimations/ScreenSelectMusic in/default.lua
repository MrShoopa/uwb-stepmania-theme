local t=Def.ActorFrame{};
t[#t+1]=DrillSelectMusic_in();
t[#t+1]=EXF_ScreenSelectMusic();

if not IsDrill() and not GAMESTATE:IsCourseMode() then
SetGroupInfo();
local EXFChk=false;
local CreatedSortText=getenv("CreatedSortText",CreatedSortText) or false;

	t[#t+1]=Def.Actor{
		InitCommand=function(self)
			local f=SaveFile(THEME:GetCurrentThemeDirectory().."Other/SongManager waieiGroupSort.txt");
			local Preferred="";
				local groups={};
				groups=SONGMAN:GetSongGroupNames();
				--[ja] ABC順に並び替え 
				table.sort(groups,
					function(a,b)
						return (string.upper(a) < string.upper(b))
					end);
				for i=1,#groups do
					Preferred=Preferred.."---"..groups[i].."\r\n";
					local songs={};
					songs=SONGMAN:GetSongsInGroup(groups[i]);
					if #songs>0 then
						local song_inf={};
						for j=1,#songs do
							song_inf[j]={
								fol=string.upper(GetSong2Folder(songs[j])),
								name=string.upper(songs[j]:GetTranslitFullTitle())
							};
							song_inf[j].name=string.gsub(song_inf[j].name,"-","ﾟ-");
							song_inf[j].name=string.gsub(song_inf[j].name,"+","ﾟ+");
							song_inf[j].name=string.gsub(song_inf[j].name,"*","ﾟ*");
							song_inf[j].name=string.gsub(song_inf[j].name,"/","ﾟ/");
						end;
						local sortlist_f=GetGroupParameter(groups[i],"sortlist_front");
						local sortlist_r=GetGroupParameter(groups[i],"sortlist_rear");
						if sortlist_r=="" then
							sortlist_r=GetGroupParameter(groups[i],"atendlist");
						end;
						if sortlist_f=="*" or sortlist_r=="*" then
							--[ja] フォルダ名順に並び替え 
							table.sort(song_inf,
								function(a,b)
									return (a.fol < b.fol)
								end);
						elseif sortlist_f=="" and sortlist_r=="" then
							--[ja] ABC順に並び替え 
							table.sort(song_inf,
								function(a,b)
									return (a.name < b.name)
								end);
						else
							--[ja] ABC順に並び替え後、任意の順番に並び替え 
							table.sort(song_inf,
								function(a,b)
									return (a.name < b.name)
								end);
							local tmp={};
							local spl_f=split(":",string.upper(sortlist_f));
							local spl_r=split(":",string.upper(sortlist_r));
							local find_f=":"..string.upper(sortlist_f)..":";
							local find_r=":"..string.upper(sortlist_r)..":";
							local index=0;
							for k=1,#spl_f do
								for j=1,#song_inf do
									if spl_f[k]==song_inf[j].fol then
										index=index+1;
										tmp[index]=song_inf[j];
									end;
								end;
							end;
							for j=1,#song_inf do
								if not string.find(find_f,":"..song_inf[j].fol..":",0,true)
									and not string.find(find_r,":"..song_inf[j].fol..":",0,true) then
									index=index+1;
									tmp[index]=song_inf[j];
								end;
							end;
							for k=1,#spl_r do
								if not string.find(find_f,":"..spl_r[k]..":",0,true) then
									for j=1,#song_inf do
										if spl_r[k]==song_inf[j].fol then
											index=index+1;
											tmp[index]=song_inf[j];
										end;
									end;
								end;
							end;
							song_inf=tmp;
						end;
						for j=1,#song_inf do
							Preferred=Preferred..groups[i].."/"..song_inf[j].fol.."/\r\n";
						end;
					end;
				end;
			f:Write(""..Preferred);
			CloseFile(f);
			SONGMAN:SetPreferredSongs("waieiGroupSort");
			--[==[
			if not CreatedSortText then
				local group=grData[""..grSys["Selected"].."-Path"];
				local num_group=tonumber(group);
				local song_stat={};
				local Preferred="";
				local f=SaveFile(THEME:GetCurrentThemeDirectory().."Other/SongManager SortSong.txt");
				local songs={};
				local difs={};	--[ja] DifAll用
				local sortmode=grSortMode[grSys["Sort"]];
				if sortmode~="group" then
					local songs_tmp=SONGMAN:GetAllSongs();
					for i=1,#songs_tmp do
						local chk_flag=false;
						if FILEMAN:DoesFileExist(songs_tmp[i]:GetSongFilePath()) then
--							or FILEMAN:DoesFileExist(string.gsub(songs_tmp[i]:GetSongFilePath(),".ssc",".sm")) then
							if sortmode=="title" then
								local ltitle=string.lower(songs_tmp[i]:GetTranslitFullTitle());
								if (group=="num" and string.find(ltitle,"^%d.*"))
									or (group=="other" and not string.find(ltitle,"^%d.*")
										and not string.find(ltitle,"^%u.*") and not string.find(ltitle,"^%l.*"))
									or string.find(ltitle,"^"..group..".*") then
									songs[#songs+1]=songs_tmp[i];
									chk_flag=true;
								end;
							elseif sortmode=="artist" then
								local lartist=string.lower(songs_tmp[i]:GetTranslitArtist());
								if (group=="num" and string.find(lartist,"^%d.*"))
									or (group=="other" and not string.find(lartist,"^%d.*")
										and not string.find(lartist,"^%u.*") and not string.find(lartist,"^%l.*"))
									or string.find(lartist,"^"..group..".*") then
									songs[#songs+1]=songs_tmp[i];
									chk_flag=true;
								end;
							elseif sortmode=="maxbpm" then
								if songs_tmp[i]:IsDisplayBpmSecret()
									or songs_tmp[i]:IsDisplayBpmRandom() then
									if group=="501" then
										songs[#songs+1]=songs_tmp[i];
										chk_flag=true;
									end;
								else
									local bpms=songs_tmp[i]:GetDisplayBpms();
									local _bpm=math.floor(math.max(math.min(bpms[2],10000),0)/20);
									if num_group==_bpm then
										songs[#songs+1]=songs_tmp[i];
										chk_flag=true;
									end;
								end;
							elseif sortmode=="minbpm" then
								if songs_tmp[i]:IsDisplayBpmSecret()
									or songs_tmp[i]:IsDisplayBpmRandom() then
									if group=="501" then
										songs[#songs+1]=songs_tmp[i];
										chk_flag=true;
									end;
								else
									local bpms=songs_tmp[i]:GetDisplayBpms();
									local _bpm=math.floor(math.max(math.min(bpms[1],10000),0)/20);
									if num_group==_bpm then
										songs[#songs+1]=songs_tmp[i];
										chk_flag=true;
									end;
								end;
							elseif sortmode=="songlen" then
								local len=math.floor(math.max(math.min(songs_tmp[i]:MusicLengthSeconds(),5000),0)/10);
								if num_group==len then
									songs[#songs+1]=songs_tmp[i];
									chk_flag=true;
								end;
							elseif sortmode=="difall" then
								local _tmp="-"..songs_tmp[i]:GetDisplayFullTitle().."-"..songs_tmp[i]:GetGroupName();
								for d=1,6 do
									if songs_tmp[i]:HasStepsTypeAndDifficulty(_STEPSTYPE(),Difficulty[d]) then
										local st=songs_tmp[i]:GetOneSteps(_STEPSTYPE(),Difficulty[d]);
										local dif=math.min(math.max(sgSys["Dif-"..Difficulty[d].._tmp],1),100);
										if num_group==dif then
											songs[#songs+1]=songs_tmp[i];
											difs[#difs+1]=d;
											chk_flag=true;
										end;
									end;
								end;
							elseif sortmode=="difbeg" then
								if songs_tmp[i]:HasStepsTypeAndDifficulty(_STEPSTYPE(),Difficulty[1]) then
									local st=songs_tmp[i]:GetOneSteps(_STEPSTYPE(),Difficulty[1]);
									local dif=math.min(math.max(sgSys["Dif-"..Difficulty[1].."-"..songs_tmp[i]:GetDisplayFullTitle().."-"..songs_tmp[i]:GetGroupName()],1),100);
									if num_group==dif then
										songs[#songs+1]=songs_tmp[i];
										chk_flag=true;
									end;
								end;
							elseif sortmode=="difbas" then
								if songs_tmp[i]:HasStepsTypeAndDifficulty(_STEPSTYPE(),Difficulty[2]) then
									local st=songs_tmp[i]:GetOneSteps(_STEPSTYPE(),Difficulty[2]);
									local dif=math.min(math.max(sgSys["Dif-"..Difficulty[2].."-"..songs_tmp[i]:GetDisplayFullTitle().."-"..songs_tmp[i]:GetGroupName()],1),100);
									if num_group==dif then
										songs[#songs+1]=songs_tmp[i];
										chk_flag=true;
									end;
								end;
							elseif sortmode=="difdif" then
								if songs_tmp[i]:HasStepsTypeAndDifficulty(_STEPSTYPE(),Difficulty[3]) then
									local st=songs_tmp[i]:GetOneSteps(_STEPSTYPE(),Difficulty[3]);
									local dif=math.min(math.max(sgSys["Dif-"..Difficulty[3].."-"..songs_tmp[i]:GetDisplayFullTitle().."-"..songs_tmp[i]:GetGroupName()],1),100);
									if num_group==dif then
										songs[#songs+1]=songs_tmp[i];
										chk_flag=true;
									end;
								end;
							elseif sortmode=="difexp" then
								if songs_tmp[i]:HasStepsTypeAndDifficulty(_STEPSTYPE(),Difficulty[4]) then
									local st=songs_tmp[i]:GetOneSteps(_STEPSTYPE(),Difficulty[4]);
									local dif=math.min(math.max(sgSys["Dif-"..Difficulty[4].."-"..songs_tmp[i]:GetDisplayFullTitle().."-"..songs_tmp[i]:GetGroupName()],1),100);
									if num_group==dif then
										songs[#songs+1]=songs_tmp[i];
										chk_flag=true;
									end;
								end;
							elseif sortmode=="difcha" then
								if songs_tmp[i]:HasStepsTypeAndDifficulty(_STEPSTYPE(),Difficulty[5]) then
									local st=songs_tmp[i]:GetOneSteps(_STEPSTYPE(),Difficulty[5]);
									local dif=math.min(math.max(sgSys["Dif-"..Difficulty[5].."-"..songs_tmp[i]:GetDisplayFullTitle().."-"..songs_tmp[i]:GetGroupName()],1),100);
									if num_group==dif then
										songs[#songs+1]=songs_tmp[i];
										chk_flag=true;
									end;
								end;
							end;
						end;
					end;
				else
					if IsGroupMode() then
						songs=SONGMAN:GetSongsInGroup(group);
					else
						songs=SONGMAN:GetAllSongs();
					end;
				end;
				if #songs>0 then
					local song_inf={};
					for j=1,#songs do
						local bpms=songs[j]:GetDisplayBpms();
						local _fol=string.upper(GetSong2Folder(songs[j]))
						local transtitle=string.upper(songs[j]:GetTranslitFullTitle()).."  ".._fol;
						transtitle=string.gsub(transtitle,"-","~-");
						transtitle=string.gsub(transtitle,"+","~+");
						transtitle=string.gsub(transtitle,"*","~*");
						transtitle=string.gsub(transtitle,"/","~/");
						if grSortMode[grSys["Sort"]]=="artist" then
							song_inf[j]={
								song=songs[j],
								fol=_fol,
								name=string.upper(songs[j]:GetTranslitArtist()).." -"..transtitle
							};
						elseif grSortMode[grSys["Sort"]]=="maxbpm" then
							song_inf[j]={
								song=songs[j],
								fol=_fol,
								name=((group=="501") and transtitle or string.format("%09.2f",bpms[2]).."-"..transtitle)
							};
						elseif grSortMode[grSys["Sort"]]=="minbpm" then
							song_inf[j]={
								song=songs[j],
								fol=_fol,
								name=((group=="501") and transtitle or string.format("%09.2f",bpms[2]).."-"..transtitle)
							};
						elseif grSortMode[grSys["Sort"]]=="songlen" then
							song_inf[j]={
								song=songs[j],
								fol=_fol,
								name=string.format("%07.2f",songs[j]:MusicLengthSeconds()).."-"..transtitle
							};
						elseif grSortMode[grSys["Sort"]]=="difall" then
							if songs[j]:HasStepsTypeAndDifficulty(_STEPSTYPE(),Difficulty[difs[j]]) then
								local st=songs[j]:GetOneSteps(_STEPSTYPE(),Difficulty[difs[j]]);
								local dif=math.min(math.max(sgSys["Dif-"..Difficulty[difs[j]].."-"..songs[j]:GetDisplayFullTitle().."-"..songs[j]:GetGroupName()],1),100);
								if tonumber(group)==dif then
								song_inf[j]={
									song=songs[j],
									fol=_fol,
									name=difs[j].."."..dif.."-"..transtitle
								};
								end;
							end;
						else
							song_inf[j]={
								song=songs[j],
								fol=_fol,
								name=transtitle
							};
						end;
					end;
					if grSortMode[grSys["Sort"]]=="group" then
						local groups=SONGMAN:GetSongGroupNames();
						if not IsGroupMode() then
							table.sort(groups,
								function(a,b)
									return (a < b)
								end);
						end;
						local max=IsGroupMode() and 1 or #groups;
						for g=1,max do
							if not IsGroupMode() then
								group=groups[g];
								Preferred=Preferred.."---"..group.."/\r\n";
							end;
							local sortlist_f=GetGroupParameter(group,"sortlist_front");
							local sortlist_r=GetGroupParameter(group,"sortlist_rear");
							if sortlist_r=="" then
								sortlist_r=GetGroupParameter(group,"atendlist");
							end;
							if sortlist_f=="*" or sortlist_r=="*" then
								--[ja] フォルダ名順に並び替え 
								table.sort(song_inf,
									function(a,b)
										return (a.fol < b.fol)
									end);
							elseif sortlist_f=="" and sortlist_r=="" then
								--[ja] ABC順に並び替え 
								table.sort(song_inf,
									function(a,b)
										return (a.name < b.name)
									end);
							else
								--[ja] ABC順に並び替え後、任意の順番に並び替え 
								table.sort(song_inf,
									function(a,b)
										return (a.name < b.name)
									end);
								local tmp={};
								local spl_f=split(":",string.upper(sortlist_f));
								local spl_r=split(":",string.upper(sortlist_r));
								local find_f=":"..string.upper(sortlist_f)..":";
								local find_r=":"..string.upper(sortlist_r)..":";
								local index=0;
								for k=1,#spl_f do
									for j=1,#song_inf do
										if spl_f[k]==song_inf[j].fol then
											index=index+1;
											tmp[index]=song_inf[j];
										end;
									end;
								end;
								for j=1,#song_inf do
									if not string.find(find_f,":"..song_inf[j].fol..":",0,true)
										and not string.find(find_r,":"..song_inf[j].fol..":",0,true) then
										index=index+1;
										tmp[index]=song_inf[j];
									end;
								end;
								for k=1,#spl_r do
									if not string.find(find_f,":"..spl_r[k]..":",0,true) then
										for j=1,#song_inf do
											if spl_r[k]==song_inf[j].fol then
												index=index+1;
												tmp[index]=song_inf[j];
											end;
										end;
									end;
								end;
								song_inf=tmp;
							end;
							if not IsGroupMode() then
								for i=1,#song_inf do
									Preferred=Preferred..groups[g].."/"..song_inf[i].fol.."/\r\n";
								end;
							end;
						end;
					else
						--[ja] ABC順に並び替え 
						table.sort(song_inf,
							function(a,b)
								return (a.name < b.name)
							end);
					end;
					if IsGroupMode() then
						for j=1,#song_inf do
							Preferred=Preferred..song_inf[j].song:GetGroupName().."/"..song_inf[j].fol.."/\r\n";
						end;
					end;
				end;
				f:Write(""..Preferred);
				CloseFile(f);
				--setenv("song_stat",song_stat);
				--setenv("song_update",true);
				EXFChk=true;
				CreatedSortText=true
				setenv("CreatedSortText",CreatedSortText);
			end;
			--]==]
		end;
	};

	t[#t+1]=Def.Actor{
		InitCommand=function(self)
			local Preferred="";
		--	SONGMAN:SetPreferredSongs("SortSong");
		end;
	};
end;
if not IsDrill() and not IsEXFolder() then
	if not GAMESTATE:IsCourseMode() then
		t[#t+1]=Def.Actor{
			OnCommand=function(self)
				ResetAnnouncer();
				SOUND:PlayAnnouncer("select music intro");
			end;
		};
	else
		t[#t+1]=Def.Actor{
			OnCommand=function(self)
				ResetAnnouncer();
				SOUND:PlayAnnouncer("select course intro");
			end;
		};
	end;
elseif IsEXFolder() then
	t[#t+1]=Def.Actor{
		OnCommand=function(self)
			ResetAnnouncer();
		end;
	};
end;
t[#t+1]=Def.Quad{
	InitCommand=cmd(Center;zoomtowidth,SCREEN_WIDTH+2;diffuse,color("#2080FF");blend,'BlendMode_Add';);
	OnCommand=cmd(diffusealpha,1;zoomtoheight,0;linear,0.3;diffusealpha,0;zoomtoheight,SCREEN_HEIGHT+2;);
};

return t;
