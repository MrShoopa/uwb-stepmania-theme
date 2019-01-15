-- [ja] 画面の切り替えや効果音関係をこっちにまとめた 
-- [ja] 音の再生はupdate関数から 

local sys_lock=true;
local sys_start=false;
local key_back=false;

local t = Def.ActorFrame{};

local song;
-- [ja] InitはIntroのほうでやっているので不要 
SetEXFCurrentSongA(1);
song=GetEXFSongState_Song(GetEXFCurrentSong());
SetEXFPlayerSteps(song);
t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		if GetEXFTotalSongs()<1 then
			--SCREENMAN:GetTopScreen():Cancel();
			KillEXFolder();
			SCREENMAN:SetNewScreen("ScreenSelectMusic");
		end;
		if GetEXFType()=="Song" then
			local song;
			if GetEXFSongState_Random(1)=="" then
				song=GetEXFSongState_Song(1);
			else
				song=GetFolder2Song(GetEXFGroupName(),GetEXFSongState_Random(1));
			end;
			-- [ja] フラグ設定 
			if GetEXFStage()>0 then
				SetEXFState("Ex"..GetEXFStage().."GamePlay");
			end;
			SetEXFPlayerSteps(song);
			SCREENMAN:SetNewScreen("ScreenStageInformation");
		else
			SOUND:PlayAnnouncer("select music intro");
		end;
		self:linear(EXF_BEGIN_WAIT());
		sys_lock=false;
		MESSAGEMAN:Broadcast("BeforeSetSong",{Move="Init"});
	end;
	CodeCommand=function(self,params)
		if not sys_lock then
			if not sys_start then
				if params.Name=="Back" then
					key_back=true;
					self:playcommand("Back");
				elseif params.Name=="BackRelease" then
					key_back=false;
					self:playcommand("Back");
				elseif params.Name=="Start" then
					sys_start=true;
					-- [ja] ランダム時はここで曲をすり替え 
					if GetEXFSongState_Random(GetEXFCurrentSong())=="" then
						song=GetEXFSongState_Song(GetEXFCurrentSong());
					else
						song=EXF_GetFolder2Song(GetEXFGroupName(),GetEXFSongState_Random(GetEXFCurrentSong()));
						if not song then
							song=GetEXFSongState_Song(GetEXFCurrentSong());
						end;
					end;
					SetEXFPlayerSteps(song);
					--
					MESSAGEMAN:Broadcast("Start");
				elseif params.Name=="Left" then
					SetEXFCurrentSongR(-1);
					MESSAGEMAN:Broadcast("BeforeSetSong",{Move="Left"});
				elseif params.Name=="Right" then
					SetEXFCurrentSongR(1);
					MESSAGEMAN:Broadcast("BeforeSetSong",{Move="Right"});
				elseif params.Name=="Up" then
					local move='None';
					if not ChangeEXFDifficulty(GetEXFCurrentSong(),params.PlayerNumber,-1) then
						move="Silent";
					end;
					self:queuecommand("SetSong");
					MESSAGEMAN:Broadcast("BeforeSetSong",{Move=move});
				elseif params.Name=="Down" then
					local move='None';
					if not ChangeEXFDifficulty(GetEXFCurrentSong(),params.PlayerNumber,1) then
						move="Silent";
					end;
					MESSAGEMAN:Broadcast("BeforeSetSong",{Move=move});
				end;
			else
				if params.Name=="Start" then
					sys_lock=true;
					MESSAGEMAN:Broadcast("Start2");
				end;
			end;
		end;
	end;
	BeforeSetSongMessageCommand=function(self,params)
		song=GetEXFSongState_Song(GetEXFCurrentSong());
		SetEXFPlayerSteps(song);
		MESSAGEMAN:Broadcast("SetSong",{Move=params.Move,Song=song});
	end;
	StartMessageCommand=function(self)
		self:sleep(0.4);
		self:queuecommand("NextScreen");
	end;
	NextScreenCommand=function(self)
		-- [ja] フラグ設定 
		if GetEXFStage()>0 then
			SetEXFState("Ex"..GetEXFStage().."GamePlay");
		end;
		-- ------
		if not sys_lock then
			SCREENMAN:SetNewScreen("ScreenStageInformation");
		else
			SCREENMAN:SetNewScreen("ScreenPlayerOptions");
		end;
	end;
	BackCommand=function(self)
		self:finishtweening();
		if key_back then
			self:sleep(0.5);
			self:queuecommand("Cancel");
		end;
	end;
	CancelCommand=function(self)
		if not sys_lock then
			sys_lock=true;
			self:finishtweening();
			SCREENMAN:GetTopScreen():Cancel();
		end;
	end;
	-- [ja] 決定 
	LoadActor(THEME:GetPathS("Common","start")) .. {
		StartMessageCommand=function(self)
			self:stop();
			self:play();
		end;
		Start2MessageCommand=cmd(playcommand,"Start");
	};
	LoadActor(THEME:GetPathS("Common","value")) .. {
		SetSongMessageCommand=function(self,params)
			if params.Move and
				params.Move=="None" then
				self:stop();
				self:play();
			end;
		end;
	};
	LoadActor(THEME:GetPathS("MusicWheel","change")) .. {
		SetSongMessageCommand=function(self,params)
			if params.Move and
				params.Move=="Left" or
				params.Move=="Right" then
				self:stop();
				self:play();
			end;
		end;
	};
	LoadActor(THEME:GetPathB("ScreenSelectExMusic","background/background"))..{
		InitCommand=function(self)
			local sys_group=GetEXFGroupName();
			local sys_stage=GetEXFStage();
			local bg=GetGroupParameter(sys_group,"Extra"..sys_stage.."BackGround");
			if bg=="" or (not FILEMAN:DoesFileExist("/Songs/"..sys_group.."/"..bg) 
				and not FILEMAN:DoesFileExist("/AdditionalSongs/"..sys_group.."/"..bg)) then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;
		OnCommand=cmd(diffusealpha,1.0;sleep,0.5;linear,0.5;diffusealpha,0);
	};
};

return t;