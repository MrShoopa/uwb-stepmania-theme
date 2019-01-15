local i,charaName=...;

local ANIME_Rest="Rest.bones.txt";
local ANIME_Warm="WarmUp0001.bones.txt";
local ANIME_Dance1="Dance0002.bones.txt";
local ANIME_Dance2="Dance0007.bones.txt";
local ANIME_Dance3="Dance0008.bones.txt";
-- [ja] キャラクター情報取得 
local charalist={};
local charaPath='../../../../Characters/'..charaName..'/';
local r=math.random(charaCnt);
local CH=charaPath[r];
local f=GetTextBlock('./Characters/'..charaName..'/character.ini','character');
local CH_COMMAND=GetBlockPrm(f,'initcommand');
local BASE_BPM=120.0;
local P1_Player=GetSidePlayer(PLAYER_1);	-- [ja] 99 waiei.luaで定義 
local P2_Player=GetSidePlayer(PLAYER_2);
local P1_Steps=GAMESTATE:GetCurrentSteps(P1_Player);
local P2_Steps=GAMESTATE:GetCurrentSteps(P2_Player);
local P1_Timing;
local P1_Stops;
local P1_StopPos={};
local P1_StopLen={};
local P1_StopCnt=1;
local P1_Delays;
local P1_DelayPos={};
local P1_DelayLen={};
local P1_DelayCnt=1;
if P1_Steps then
	P1_Timing=P1_Steps:GetTimingData();
	P1_Stops=P1_Timing:GetStops();
	for s=1,#P1_Stops do
		P1_StopPos[s]=tonumber(split("=",P1_Stops[s])[1]);
		P1_StopLen[s]=tonumber(split("=",P1_Stops[s])[2]);
	end;
	P1_Delays=P1_Timing:GetDelays();
	for s=1,#P1_Delays do
		P1_DelayPos[s]=tonumber(split("=",P1_Delays[s])[1]);
		P1_DelayLen[s]=tonumber(split("=",P1_Delays[s])[2]);
	end;
end;
local P2_Timing;
local P2_Stops;
local P2_StopPos={};
local P2_StopLen={};
local P2_StopCnt=1;
local P2_Delays;
local P2_DelayPos={};
local P2_DelayLen={};
local P2_DelayCnt=1;
if P2_Steps then
	P2_Timing=P2_Steps:GetTimingData();
	P2_Stops=P2_Timing:GetStops();
	for s=1,#P2_Stops do
		P2_StopPos[s]=tonumber(split("=",P2_Stops[s])[1]);
		P2_StopLen[s]=tonumber(split("=",P2_Stops[s])[2]);
	end;
	P2_Delays=P2_Timing:GetDelays();
	for s=1,#P2_Delays do
		P2_DelayPos[s]=tonumber(split("=",P2_Delays[s])[1]);
		P2_DelayLen[s]=tonumber(split("=",P2_Delays[s])[2]);
	end;
end;
local sg_nowBPM={0.0,0.0,0.0};
local flag_ready=false;
local flag_go=false;
local flag_start=false;
local cm_cnt=-1;			--[ja] カメラ切り替えフラグ
local sg_cnt=-1;	--[ja] アニメーション切り替え用フラグ 
local sg_anime=0;	--[ja] アニメーション番号 
local pos_x=0;
local pos_z=-4;
local song=_SONG2();
local start = song:GetFirstBeat();

local dt_=0;
local dt=0;
local wait=1.0/60;
local function update(self,delta)
	dt=dt+delta;
	if dt-dt_>wait then
		dt_=dt;
		local mus_sec=GAMESTATE:GetSongPosition():GetMusicSeconds();
		local sg_pos=GAMESTATE:GetSongPosition();
		local sg_bpm={0.0,0.0,0.0};
		sg_bpm[1]=(sg_pos:GetCurBPS())*60;
		if sg_pos:GetDelay() or sg_pos:GetFreeze() then
			sg_bpm[1]=0.0;
		end;
		if P1_Timing then
			local beat=P1_Timing:GetBeatFromElapsedTime(mus_sec);
			sg_bpm[2]=P1_Timing:GetBPMAtBeat(beat);
			if P1_StopCnt<=#P1_Stops
				and beat>=P1_StopPos[P1_StopCnt] then
				if mus_sec<=P1_Timing:GetElapsedTimeFromBeat(P1_StopPos[P1_StopCnt])+P1_StopLen[P1_StopCnt] then
					sg_bpm[2]=0.0;
				else
					P1_StopCnt=P1_StopCnt+1;
				end;
			end;
			if P1_DelayCnt<=#P1_Delays
				and beat>=P1_DelayPos[P1_DelayCnt] then
				if mus_sec<=P1_Timing:GetElapsedTimeFromBeat(P1_DelayPos[P1_DelayCnt])+P1_DelayLen[P1_DelayCnt] then
					sg_bpm[2]=0.0;
				else
					P1_DelayCnt=P1_DelayCnt+1;
				end;
			end;
		else
			sg_bpm[2]=(sg_pos:GetCurBPS())*60;
		end;
		if P2_Timing then
			local beat=P2_Timing:GetBeatFromElapsedTime(mus_sec);
			sg_bpm[3]=P2_Timing:GetBPMAtBeat(beat);
			if P2_StopCnt<=#P2_Stops
				and beat>=P2_StopPos[P2_StopCnt] then
				if mus_sec<=P2_Timing:GetElapsedTimeFromBeat(P2_StopPos[P2_StopCnt])+P2_StopLen[P2_StopCnt] then
					sg_bpm[3]=0.0;
				else
					P2_StopCnt=P2_StopCnt+1;
				end;
			end;
			if P2_DelayCnt<=#P2_Delays
				and beat>=P2_DelayPos[P2_DelayCnt] then
				if mus_sec<=P2_Timing:GetElapsedTimeFromBeat(P2_DelayPos[P2_DelayCnt])+P2_DelayLen[P2_DelayCnt] then
					sg_bpm[3]=0.0;
				else
					P2_DelayCnt=P2_DelayCnt+1;
				end;
			end;
		else
			sg_bpm[3]=(sg_pos:GetCurBPS())*60;
		end;
		if not flag_ready and sg_pos:GetSongBeat()+12>start then
			self:queuecommand("Ready");
			flag_ready=true;
		end;
		if not flag_go and sg_pos:GetSongBeat()+8>start then
			self:queuecommand("Go");
			flag_go=true;
		end;
		if not flag_start and sg_pos:GetSongBeat()>start then
			self:queuecommand("Go");
			flag_start=true;
		end;
		if sg_nowBPM[i]~=sg_bpm[i] then
			self:queuecommand("ChangeBPM");
			sg_nowBPM[i]=sg_bpm[i];
		end;
		local anime_cnt=math.floor((sg_pos:GetSongBeat())/32);
		local camera_cnt=math.floor((sg_pos:GetSongBeat())/16);
		if flag_start then
			if camera_cnt>cm_cnt then
				self:queuecommand("ChangeCamera");
				cm_cnt=camera_cnt;
			end;
			if anime_cnt>sg_cnt[i] then
				sg_anime[i]=math.floor(math.random(3)+0.99);
				self:queuecommand("ChangeAnime");
				sg_cnt[i]=anime_cnt;
			end;
		end;
	end;
end;
local def_y=0;
local t=Def.ActorFrame{
	ChangeCameraMessageCommand=function(self)
		def_y=(def_y+90+math.random(180))%360;
		self:rotationy(def_y);
	end;
	ChangeAnimeCommand=function(self)
	end;
};

if CH~="<OFF>" then
	t[#t+1]=Def.ActorFrame{
		InitCommand=function(self)
			if CH_COMMAND~='' then
				self:playcommand('Init2');
			end;
		end;
		Init2Command=loadstring("return cmd("..CH_COMMAND..");")();
		OnCommand=function(self)
			self:basezoomy((mr-1)*2-1);
		end;
		Def.Model{
			Meshes=CH.."model.txt",
			Materials=CH.."model.txt",
			Bones=ANIME_Rest,
			InitCommand=function(self)
				self:backfacecull(false);
				self:diffusecolor(color("#1a1a1a"));
				self:x(pos_x);
				self:z(pos_z);
			end;
			ChangeBPMCommand=function(self)
				self:rate(sg_nowBPM[i]/BASE_BPM);
			end;
			ReadyCommand=function(self)
				self:visible(false);
			end;
		};
		Def.Model{
			Meshes=CH.."model.txt",
			Materials=CH.."model.txt",
			Bones=ANIME_Warm,
			InitCommand=function(self)
				self:visible(false);
				self:backfacecull(false);
				self:diffusecolor(color("#1a1a1a"));
				self:x(pos_x);
				self:z(pos_z);
			end;
			ChangeBPMCommand=function(self)
				self:rate(sg_nowBPM[i]/BASE_BPM);
			end;
			ReadyCommand=function(self)
				self:visible(true);
			end;
			GoCommand=function(self)
				self:linear(1.0);
				self:diffusecolor(1.0,1.0,1.0,1.0);
			end;
			ChangeAnimeCommand=function(self)
				self:visible(false);
			end;
		};
		Def.Model{
			Meshes=CH.."model.txt",
			Materials=CH.."model.txt",
			Bones=ANIME_Dance1,
			InitCommand=function(self)
				self:visible(false);
				self:backfacecull(false);
				self:x(pos_x);
				self:z(pos_z);
			end;
			ChangeBPMCommand=function(self)
				self:rate(sg_nowBPM[i]/BASE_BPM);
			end;
			ChangeAnimeCommand=function(self)
				self:visible(sg_anime[i]==1);
			end;
		};
		Def.Model{
			Meshes=CH.."model.txt",
			Materials=CH.."model.txt",
			Bones=ANIME_Dance2,
			InitCommand=function(self)
				self:visible(false);
				self:backfacecull(false);
				self:x(pos_x);
				self:z(pos_z);
			end;
			ChangeBPMCommand=function(self)
				self:rate(sg_nowBPM[i]/BASE_BPM);
			end;
			ChangeAnimeCommand=function(self)
				self:visible(sg_anime[i]==2);
			end;
		};
		Def.Model{
			Meshes=CH.."model.txt",
			Materials=CH.."model.txt",
			Bones=ANIME_Dance3,
			InitCommand=function(self)
				self:visible(false);
				self:backfacecull(false);
				self:x(pos_x);
				self:z(pos_z);
			end;
			ChangeBPMCommand=function(self)
				self:rate(sg_nowBPM[i]/BASE_BPM);
			end;
			ChangeAnimeCommand=function(self)
				self:visible(sg_anime[i]==3);
			end;
		};
	};
end;

t.InitCommand=function(self)
	self:fov(90);
	self:Center();
	self:y(SCREEN_HEIGHT*6/7-100);
	self:rotationy(180);
	self:zoomz(1);
	self:zoom(14);
	self:rotationx(30);
	self:SetUpdateFunction(update);
end;
	
return t;