local function tablecopy(t)
	local new = {}
	for k, v in pairs(t) do new[k] = v end
	return new
end;

-- [ja] 情報読み込み 
local grData={};
grData=getenv("grData");

local grSys={};
grSys=getenv("grSys");

-- [ja] システム的にキー操作を受け付けるタイミング 
local sys_key=false;
-- [ja] キャンセルボタンを押し続けているか確認用変数 
local sys_backcnt=0;
-- [ja] 決定ボタンを押してからの時間確認用変数 
local sys_startcnt=0;
-- [ja] 現在選択中の番号（1～数） 
if not grSys["Selected"] then
	grSys["Selected"]=1;
end;
local sys_selgroup=grSys["Select_Now-"..grSortMode[grSys["Sort"]]];

local tmp_grData=tablecopy(grData);
local tmp_grSys=tablecopy(grSys);
local tmp_selgroup=sys_selgroup;

setenv("group_flag","overlay");
setenv("group_chg",false);	-- [ja] 難易度または曲が変わったときに飛ばすメッセージ用 
setenv("sys_selected",false); -- [ja] 決定ボタン押下時 
setenv("sys_move","nil");
local sys_offcommand=false;	-- [ja] OffCommand実行時にtrue

local snd_cancel=false;
local snd_start=false;
local snd_chggroup=false;
local snd_chgsort=false;
local flg_cancel=false;

local t=Def.ActorFrame{};
-- [ja] サウンドとキー操作　
t[#t+1] = Def.ActorFrame {
	MenuTimer=50;
	OnCommand=function(self)
		self:sleep(0.2);
		self:queuecommand("KeyUnLock");
	end;
	KeyUnLockCommand=function(self)
		sys_key=true;
	end;
	CodeCommand=function(self,params)
		if sys_key and GAMESTATE:IsHumanPlayer(params.PlayerNumber) and sys_extype~="song" then
			local p=(params.PlayerNumber==PLAYER_1) and 1 or 2;
			grSys["Move"]="nil";
			if params.Name == 'BackD' then
				snd_cancel=true;
			elseif params.Name=="BackU" and sys_backcnt>0 then
				sys_backcnt=0;
			elseif params.Name=="Start" and not sys_offcommand then
				setenv("sys_selected",true);
				grSys["Selected"]=sys_selgroup;
				snd_start=true;
			elseif params.Name == 'Up' and sys_startcnt==0 then
				grSys["Sort"]=grSys["Sort"]-1;
				grSys["Move"]="down";
				if grSys["Sort"]<=0 then grSys["Sort"]=#grSortMode; end;
			elseif params.Name == 'Down' and sys_startcnt==0 then
				grSys["Sort"]=grSys["Sort"]+1;
				grSys["Move"]="up";
				if grSys["Sort"]>#grSortMode then grSys["Sort"]=1; end;
			elseif params.Name == 'Left' and sys_startcnt==0 then
				sys_selgroup=sys_selgroup-1;
				if sys_selgroup<=0 then
					sys_selgroup=grData["Max"];
				end;
				grSys["Select_Now-"..grSortMode[grSys["Sort"]]]=sys_selgroup;
				snd_chggroup=true;
				grSys["Move"]="left";
			elseif params.Name == 'Right' and sys_startcnt==0 then
				sys_selgroup=sys_selgroup+1;
				if sys_selgroup>grData["Max"] then
					sys_selgroup=1;
				end;
				grSys["Select_Now-"..grSortMode[grSys["Sort"]]]=sys_selgroup;
				snd_chggroup=true;
				grSys["Move"]="right";
			end;
			if (params.Name == 'Up' or params.Name == 'Down') and sys_startcnt==0 then
				if grSortMode[grSys["Sort"]]=="title" then
					grData=getenv("grTitle");
				elseif grSortMode[grSys["Sort"]]=="artist" then
					grData=getenv("grArtist");
				elseif grSortMode[grSys["Sort"]]=="maxbpm" then
					grData=getenv("grMaxBpm");
				elseif grSortMode[grSys["Sort"]]=="minbpm" then
					grData=getenv("grMinBpm");
				elseif grSortMode[grSys["Sort"]]=="songlen" then
					grData=getenv("grSongLen");
				elseif grSortMode[grSys["Sort"]]=="difall" then
					grData=getenv("grDifAll");
				elseif grSortMode[grSys["Sort"]]=="difbeg" then
					grData=getenv("grDifBeg");
				elseif grSortMode[grSys["Sort"]]=="difbas" then
					grData=getenv("grDifBas");
				elseif grSortMode[grSys["Sort"]]=="difdif" then
					grData=getenv("grDifDif");
				elseif grSortMode[grSys["Sort"]]=="difexp" then
					grData=getenv("grDifExp");
				elseif grSortMode[grSys["Sort"]]=="difcha" then
					grData=getenv("grDifCha");
				else
					grData=getenv("grGroup");
				end;
				sys_selgroup=grSys["Select_Now-"..grSortMode[grSys["Sort"]]];
				snd_chgsort=true;
			end;
			grSys["Selected"]=sys_selgroup;
			setenv("grData",grData);
			setenv("grSys",grSys);
			MESSAGEMAN:Broadcast("ChangeGroup");
		end;
	end;
	OffCommand=function(self)
		sys_key=false;
		--[[
			ここで次画面への設定 
		--]]
		self:sleep(0.4);
		self:queuecommand("NextScreen");
	end;
	NextScreenCommand=function(self)
		setenv("grSys",grSys);
		setenv("grData",grData);
		setenv("grSys_reload",true);
		SCREENMAN:GetTopScreen():Cancel();	-- [ja] 直接SelectMusicを呼び出すとオーバーレイ状態で切り替わるのでCancelを使う 
	end;
	LoadActor(THEME:GetPathG("_Loading/loading","in"));
	--[[
	LoadFont("Common Normal")..{
		InitCommand=cmd(Center;settext,"Now Loading";
			diffuse,1,1,1,1;strokecolor,0,0,0,1;diffusealpha,0;);
		OffCommand=cmd(linear,0.2;diffusealpha,1);
	};
	--]]
};
-- [ja] 決定 
t[#t+1] = LoadActor(THEME:GetPathS("Common","start")) .. {
	Name="SND_START";
	PlayCommand=function(self)
		self:stop();
		self:play();
		snd_start=false;					
	end;
};
t[#t+1] = LoadActor(THEME:GetPathS("Common","value")) .. {
	Name="SND_CHGDIF";
	PlayCommand=function(self)
		self:stop();
		self:play();
		snd_chgsort=false;
	end;
};
t[#t+1] = LoadActor(THEME:GetPathS("Common","Cancel")) .. {
	Name="SND_CANCEL";
	PlayCommand=function(self)
		sys_key=false;
		self:finishtweening();
		self:stop();
		self:play();
		snd_cancel=false;
		--KillGroup();
		self:sleep(0.5);
		self:queuecommand("CancelScreen");
	end;
	CancelScreenCommand=function(self)
	--	grData=tablecopy(tmp_grData);
	--	grSys=tablecopy(tmp_grSys);
		setenv("sys_selgroup",tmp_selgroup);
		setenv("grSys",tmp_grSys);
		setenv("grData",tmp_grData);
		grSys=getenv("grSys");
		setenv("grSys_reload",true);
		SCREENMAN:GetTopScreen():Cancel();
	end;
};
t[#t+1] = LoadActor(THEME:GetPathS("MusicWheel","change")) .. {
	Name="SND_CHGSONG";
	PlayCommand=function(self)
		self:stop();
		self:play();
		snd_chggroup=false;
	end;
};
t[#t+1]=LoadActor(THEME:GetPathG("_Loading/loading","in")) .. {
	Name="LOADING";
};

setenv("SelMusicTimer",45);
local oTime=0;
local nTime=oTime;
local wait=1.0/60;
local ms=0;
local function update(self,dt)
	ms=ms+dt;
	if PREFSMAN:GetPreference("MenuTimer") then
		setenv("SelMusicTimer",getenv("SelMusicTimer")-dt);
	end;
	if getenv("SelMusicTimer")<=0 and not getenv("sys_selected") then
		setenv("sys_selected",true);
		snd_start=true;
	end;
	local nTime=ms;
	-- [ja] 1回分の処理 
	if nTime-oTime>wait then
		--		_SYS(grData[""..sys_selgroup.."-Name"].."/"..grData[""..sys_selgroup.."-Songs"].." Songs")
		if sys_backcnt>0 and ms>EXF_BEGIN_WAIT()+0.5 then
			sys_backcnt=sys_backcnt-1;
			if sys_backcnt<=0 then
				snd_cancel=true;
			end;
		end;
		if getenv("sys_selected") and not sys_offcommand then
			sys_offcommand=true;
			self:queuecommand("Off");
		end;
		oTime=oTime+wait;
	end;
	if snd_cancel then
		local c_snd=self:GetChild("SND_CANCEL");
		c_snd:queuecommand("Play");
		c_snd=self:GetChild("LOADING");
		c_snd:queuecommand("Off");
	end;
	if snd_start then
		local c_snd=self:GetChild("SND_START");
		c_snd:queuecommand("Play");
	end;
	if snd_chgsort then
		local c_snd=self:GetChild("SND_CHGDIF");
		c_snd:queuecommand("Play");
	end;
	if snd_chggroup then
		local c_snd=self:GetChild("SND_CHGSONG");
		c_snd:queuecommand("Play");
		setenv("sys_selgroup",sys_selgroup);
		setenv("group_chg",true);
	end;
end;

t.InitCommand=cmd(SetUpdateFunction,update);

return t;