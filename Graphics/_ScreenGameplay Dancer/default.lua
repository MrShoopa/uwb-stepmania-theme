--[[
    Comment Language : Ja
    ゲーム画面 ダンサー
--]]

-- ダンサー表示
local t = Def.ActorFrame{};

local ch={};
local ch_pn = {};
local ch_add = 2;			-- ランダムで追加するキャラ数
local ch_master = 0;	    -- プレイヤーキャラ以外の基準となる譜面（0＝グローバルBPM）
if (GAMESTATE:IsPlayerEnabled(PLAYER_1) and not GAMESTATE:IsPlayerEnabled(PLAYER_2)) then
	ch_master = PLAYER_1;
elseif not (GAMESTATE:IsPlayerEnabled(PLAYER_1) and GAMESTATE:IsPlayerEnabled(PLAYER_2)) then
	ch_master = PLAYER_2;
end;
for i=1,2 do
	if GAMESTATE:IsPlayerEnabled('PlayerNumber_P'..i) then
		local tmp_ch = GAMESTATE:GetCharacter('PlayerNumber_P'..i);
		if tmp_ch and tmp_ch:GetModelPath()~='' then
			ch[#ch+1]       = tmp_ch;
			ch_pn[#ch_pn+1] = 'PlayerNumber_P'..i;
		end;
	end;
end;
-- [ja] 追加ダンサー（ランダム）
if ch_add>0 then
	for i=1,ch_add do
		for r=1,3 do	-- [ja] 動作しないキャラが選択された時のため一応3回チェック
			local tmp_ch = CHARMAN:GetRandomCharacter();
			if tmp_ch and tmp_ch:GetModelPath()~='' then
				ch[#ch+1]       = tmp_ch;
				ch_pn[#ch_pn+1] = ch_master;
				break;
			end;
		end;
	end;
end;
-- [ja] 3Dダンサーが0人の場合はreturn
if #ch<=0 then
	return t;
end;
-- [ja] プレイヤーダンサーが中央に行くように調整する
if #ch>2 then
	if (#ch%2)==1 then
		-- [ja] ダンサー数が奇数
		if ch_pn[2] == ch_master then	-- [ja] SINGLE
			local tmp_cnt = math.floor(#ch/2)+1;
			local tmp_ch = ch[tmp_cnt];
			local tmp_pn = ch_pn[tmp_cnt];
			ch[tmp_cnt]    = ch[1];
			ch_pn[tmp_cnt] = ch_pn[1];
			ch[1]    = tmp_ch;
			ch_pn[1] = tmp_pn;
		else							-- [ja] VERSUS
			local tmp_cnt = math.floor(#ch/2);
			local tmp_ch = ch[tmp_cnt];
			local tmp_pn = ch_pn[tmp_cnt];
			ch[tmp_cnt]    = ch[1];
			ch_pn[tmp_cnt] = ch_pn[1];
			ch[1]    = tmp_ch;
			ch_pn[1] = tmp_pn;
			tmp_ch = ch[tmp_cnt+2];
			tmp_pn = ch_pn[tmp_cnt+2];
			ch[tmp_cnt]    = ch[2];
			ch_pn[tmp_cnt] = ch_pn[2];
			ch[2]    = tmp_ch;
			ch_pn[2] = tmp_pn;
		end;
	else
		-- [ja] ダンサー数が偶数
		local tmp_cnt = math.floor(#ch/2);
		local tmp_ch = ch[tmp_cnt];
		local tmp_pn = ch_pn[tmp_cnt];
		ch[tmp_cnt]    = ch[1];
		ch_pn[tmp_cnt] = ch_pn[1];
		ch[1]    = tmp_ch;
		ch_pn[1] = tmp_pn;
		if ch_pn[2] ~= ch_master then	-- [ja] VERSUS
			tmp_ch = ch[tmp_cnt+1];
			tmp_pn = ch_pn[tmp_cnt+1];
			ch[tmp_cnt]    = ch[2];
			ch_pn[tmp_cnt] = ch_pn[2];
			ch[2]    = tmp_ch;
			ch_pn[2] = tmp_pn;
		end;
	end;
end;


local c = Def.ActorFrame{
	FOV=60;
	OnCommand=function(self)
		self:Center();
		self:horizalign(center);
		self:rotationx(15);
	end;
};

-- [ja] キャラクターの隙間
local ch_space = math.min(700, #ch*200) / #ch;

-- [ja] 鏡面反射を先に描画する
for i=0,#ch-1 do
    -- [ja] 鏡面反射
    c[#c+1] = LoadActor(
            THEME:GetPathG("_ScreenGameplay","Dancer/Character"),
            i, ch_pn[i+1], ch[i+1], true, nil)..{
        OnCommand = cmd(
            x, -ch_space * (#ch/2) + ch_space * i + ch_space / 2;
            y, 100;
        );
    };
end;

-- [ja] 床
c[#c+1] = Def.ActorFrame{
    
	OnCommand = cmd(
        rotationx, -90;
        y, 100;
        diffusealpha, 0.5
    );
    
	LoadActor( THEME:GetPathG('_Gameplay','BGA'), _SONG() )..{
		OnCommand=cmd( zoom, 800 / SCREEN_WIDTH );
	};
	Def.Quad{
		OnCommand = cmd(
            zoomto, 800, 800;
            diffuse, 0, 0, 0, 0.5;
        );
	};
};

-- [ja] キャラクター本体
for i = 0, #ch-1 do
    c[#c+1] = 
        LoadActor(
            THEME:GetPathG("_ScreenGameplay","Dancer/Character"),
            i + #ch, ch_pn[i+1], ch[i+1], false, i )..{
        OnCommand=cmd(
            x, -ch_space * (#ch/2) + ch_space * i + ch_space / 2;
            y, 100;
        );
    };
end;
t[#t+1] = Def.Quad{
    OnCommand=cmd(
        zoomto, SCREEN_WIDTH+1, SCREEN_HEIGHT+1;
        Center;
        diffuse, 0, 0, 0, 0;
        linear, 0.3;
        diffusealpha, 0.5
    );
};
t[#t+1]=c..{
	ChChangeAnimeMessageCommand=function(self)
		local rnd_z = math.random(512) - 256;
		self:finishtweening();
		self:z(rnd_z);
		self:rotationy((math.random(720) - 360) * 2);
		self:linear(15);
		self:rotationy(0);
		self:z(2 * rnd_z);
	end;
};

-- [ja] カメラアップデート
--[[
local dtOld = 0;    -- DeltaTime
local dt = 0;
local wait = 1.0/60;
local sgStart = _SONG2():GetFirstBeat();
local function update(self,delta)
	dt = dt + delta;
	if dt - dtOld > wait then
		dtOld = dt;
	end;
end;

t.InitCommand=function(self)
	self:SetUpdateFunction(update);
end;
--]]

return t;