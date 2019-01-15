--[[
	アバター設定
	５：カラー設定（処理）
--]]

local sys_lock=true;
local t=Def.ActorFrame{};
local av_tmp={unpack(c_getenvg('av'))};
local select_part=c_getenvg('select_part');
local select_style=c_getenvg('select_style');
local select_save=c_getenvg('select_save');
local select_color=1;
local col_rgb_str='#000000';
local AVA_Style=1;
local AVA_BHiar=2;
local AVA_Face= 3;
local AVA_Eye1= 4;
local AVA_Eye2= 5;
local AVA_Mouth=6;
local AVA_MHiar=7;
local AVA_SHiar=8;
local AVA_FHiar=9;
local AVA_AHiar=10;
local AVA_Brow =11;
local AVA_Acce1=12;
local AVA_Acce2=13;
local AVA_Save =14;
local hair=false;
local style_col=false;
local index=1;
if select_part==AVA_BHiar then
	index=AVA_BHiar_COL;
	hair=true;
elseif select_part==AVA_Face then
	index=AVA_Face_COL_N+2*select_style;
	style_col=true;
elseif select_part==AVA_Eye1 then
	index=AVA_Eye_COL_N+3*select_style;
	style_col=true;
elseif select_part==AVA_Eye2 then
	index=AVA_Eye_COL_N+3*select_style;
	style=true;
elseif select_part==AVA_MHiar then
	index=AVA_MHiar_COL;
	hair=true;
elseif select_part==AVA_SHiar then
	index=AVA_SHiar_COL;
	hair=true;
elseif select_part==AVA_FHiar then
	index=AVA_FHiar_COL;
	hair=true;
elseif select_part==AVA_AHiar then
	index=AVA_AHiar_COL;
	hair=true;
elseif select_part==AVA_Acce1 then
	index=AVA_Acce1_COL;
elseif select_part==AVA_Acce2 then
	index=AVA_Acce2_COL;
end;
col_rgb_str=av_tmp[index];
local col_r=string.sub(col_rgb_str,2,3);
local col_g=string.sub(col_rgb_str,4,5);
local col_b=string.sub(col_rgb_str,6,7);
if col_r=='' then col_r='00'; end;
if col_g=='' then col_g='00'; end;
if col_b=='' then col_b='00'; end;
col_r=math.floor(tonumber(string.format('%d','0x'..col_r))/25.5+0.1);
col_g=math.floor(tonumber(string.format('%d','0x'..col_g))/25.5+0.1);
col_b=math.floor(tonumber(string.format('%d','0x'..col_b))/25.5+0.1);
local col_rgb={
	col_r,
	col_g,
	col_b
};

t[#t+1]=Def.ActorFrame{
	OnCommand=function(self)
		MESSAGEMAN:Broadcast("Set",{Col=select_color,RGB=col_rgb,Hair_Col=hair,Style_Col=style_col});
		self:queuecommand("UnLockKey");
	end;
	UnLockKeyCommand=function(self)
		sys_lock=false;
		self:queuecommand("Set");
	end;
	KeyDownMessageCommand=function(self,params)
		if not sys_lock then
			if C_GetKey(PLAYER_1,"Start") or C_GetKey(PLAYER_2,"Start") then
				if select_color==4 then
					local common_color='#'..string.format('%02x',math.floor(col_rgb[1]*255/10+0.1))
							..string.format('%02x',math.floor(col_rgb[2]*255/10+0.1))
							..string.format('%02x',math.floor(col_rgb[3]*255/10+0.1));
					if hair then
						av_tmp[AVA_BHiar_COL]=common_color;
						av_tmp[AVA_MHiar_COL]=common_color;
						av_tmp[AVA_SHiar_COL]=common_color;
						av_tmp[AVA_FHiar_COL]=common_color;
						av_tmp[AVA_AHiar_COL]=common_color;
					elseif style_col then
						if index>=AVA_Eye_COL_N then
							av_tmp[AVA_Eye_COL_N]=common_color;
							av_tmp[AVA_Eye_COL_W]=common_color;
							av_tmp[AVA_Eye_COL_L]=common_color;
						else
							av_tmp[AVA_Face_COL_N]=common_color;
							av_tmp[AVA_Face_COL_W]=common_color;
							av_tmp[AVA_Face_COL_L]=common_color;
						end;
					end;
				end;
				self:queuecommand("Start");
				self:queuecommand("NextScreen1");
			elseif C_GetKey(PLAYER_1,"Back") or C_GetKey(PLAYER_2,"Back") then
				self:queuecommand("CancelPlay");
				self:queuecommand("BackScreen1");
			else
				if C_GetKey(PLAYER_1,"Up") or C_GetKey(PLAYER_2,"Up") then
					select_color=select_color-1;
					if select_color<1 then select_color=(hair or style_col) and 4 or 3; end;
					MESSAGEMAN:Broadcast("Set",{Col=select_color,RGB=col_rgb,Hair_Col=hair,Style_Col=style_col});
					self:queuecommand("Sound1Play");
				end;
				if C_GetKey(PLAYER_1,"Down") or C_GetKey(PLAYER_2,"Down") then
					select_color=select_color+1;
					if select_color>((hair or style_col) and 4 or 3) then select_color=1; end;
					MESSAGEMAN:Broadcast("Set",{Col=select_color,RGB=col_rgb,Hair_Col=hair,Style_Col=style_col});
					self:queuecommand("Sound1Play");
				end;
				if C_GetKey(PLAYER_1,"Left") or C_GetKey(PLAYER_2,"Left") then
					if select_color<4 then
						col_rgb[select_color]=col_rgb[select_color]-1;
						if col_rgb[select_color]<0 then col_rgb[select_color]=10; end;
						av_tmp[index]='#'..string.format('%02x',math.floor(col_rgb[1]*255/10+0.1))
							..string.format('%02x',math.floor(col_rgb[2]*255/10+0.1))
							..string.format('%02x',math.floor(col_rgb[3]*255/10+0.1));
						MESSAGEMAN:Broadcast("Set",{Col=select_color,RGB=col_rgb,Hair_Col=hair,Style_Col=style_col});
						self:queuecommand("Sound2Play");
					end;
				end;
				if C_GetKey(PLAYER_1,"Right") or C_GetKey(PLAYER_2,"Right") then
					if select_color<4 then
						col_rgb[select_color]=col_rgb[select_color]+1;
						if col_rgb[select_color]>10 then col_rgb[select_color]=0; end;
						av_tmp[index]='#'..string.format('%02x',math.floor(col_rgb[1]*255/10+0.1))
							..string.format('%02x',math.floor(col_rgb[2]*255/10+0.1))
							..string.format('%02x',math.floor(col_rgb[3]*255/10+0.1));
						MESSAGEMAN:Broadcast("Set",{Col=select_color,RGB=col_rgb,Hair_Col=hair,Style_Col=style_col});
						self:queuecommand("Sound2Play");
					end;
				end;
			end;
		end;
	end;
	BackScreen1Command=function(self)
		self:sleep(0.5);
		self:queuecommand("BackScreen2");
	end;
	BackScreen2Command=function(self)
		C_SetPrevScreen();
	end;
	NextScreen1Command=function(self)
		self:sleep(0.5);
		self:queuecommand("NextScreen2");
	end;
	NextScreen2Command=function(self)
		if av_tmp then
			c_setenvg('av',{unpack(av_tmp)});
		end;
		C_SetPrevScreen();
	end;
	SetMessageCommand=function(self)
		MESSAGEMAN:Broadcast("AvatarChanged",{id=1,av=av_tmp,t=select_style});
	end;
	-- [ja] 決定 
	LoadActor(THEME:GetPathS("Common","start")) .. {
		OnCommand=cmd(playcommand,'Start');
		StartMessageCommand=function(self)
			self:stop();
			self:play();
		end;
	};
	LoadActor(THEME:GetPathS("MusicWheel","change")) .. {
		Sound1PlayCommand=function(self)
			self:stop();
			self:play();
		end;
	};
	LoadActor(THEME:GetPathS("Common","value")) .. {
		Sound2PlayCommand=function(self)
			self:stop();
			self:play();
		end;
	};
	LoadActor(THEME:GetPathS("Common","Cancel")) .. {
		CancelPlayCommand=function(self)
			self:stop();
			self:play();
		end;
	};
	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,0,0,0,0);
		BackScreen1Command=cmd(linear,0.4;diffusealpha,1);
		NextScreen1Command=cmd(playcommand,'BackScreen1');
	};
};

return t;