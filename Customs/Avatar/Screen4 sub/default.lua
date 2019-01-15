--[[
	アバター設定
	４：エディット（処理）
--]]

local sys_lock=true;
local t=Def.ActorFrame{};

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
local color={	-- [ja] 色の変更 
	false,	--style
	true,	--bhair
	true,	--face
	true,	--eye1
	false,	--eye2
	false,	--mouth
	true,	--mhair
	true,	--shair
	true,	--fhair
	true,	--ahair
	false,	--brow
	true,	--acce1
	true,	--acce2
	false	--save
};
local max={		-- [ja] 左右の切り替え数 
	2,	--style
	5,	--bhair
	3,	--face
	8,	--eye1
	3,	--eye2
	12,	--mouth
	4,	--mhair
	3,	--shair
	7,	--fhair
	4,	--ahair
	3,	--brow
	12,	--acce1
	12,	--acce2
	2	--save
};
local part_max=#color;

local av=c_getenvg('av');
local av_file=c_getenvg('av_file');
local select_part=c_getenvg('select_part');
local select_style=c_getenvg('select_style');
local select_save=c_getenvg('select_save');

local function setPreviewFace(avatar,part,add)
	if avatar then
		if part==AVA_Style then
			select_style=select_style+add;
			if select_style<0 then select_style=max[AVA_Style]; end;
			if select_style>max[AVA_Style] then select_style=0; end;
		elseif part==AVA_Save then
			select_save=select_save+add;
			if select_save<0 then select_save=max[AVA_Save]; end;
			if select_save>max[AVA_Save] then select_save=0; end;
		else
			local index=0;
			local maximum=0;
			if part==AVA_BHiar then
				index=AVA_BHiar_NUM;
				maximum=max[AVA_BHiar];
				minimum=0;
			elseif part==AVA_Face then
				index=AVA_Face_NUM_N+2*select_style;
				maximum=max[AVA_Face];
				minimum=0;
			elseif part==AVA_Eye1 then
				index=AVA_Eye_NUM1_N+3*select_style;
				maximum=max[AVA_Eye1];
			elseif part==AVA_Eye2 then
				index=AVA_Eye_NUM2_N+3*select_style;
				maximum=max[AVA_Eye2];
				minimum=0;
			elseif part==AVA_Mouth then
				index=AVA_Mouth_NUM_N+select_style;
				maximum=max[AVA_Mouth];
				minimum=0;
			elseif part==AVA_MHiar then
				index=AVA_MHiar_NUM;
				maximum=max[AVA_MHiar];
				minimum=0;
			elseif part==AVA_SHiar then
				index=AVA_SHiar_NUM;
				maximum=max[AVA_SHiar];
				minimum=0;
			elseif part==AVA_FHiar then
				index=AVA_FHiar_NUM;
				maximum=max[AVA_FHiar];
				minimum=0;
			elseif part==AVA_AHiar then
				index=AVA_AHiar_NUM;
				maximum=max[AVA_AHiar];
				minimum=0;
			elseif part==AVA_Brow then
				index=AVA_Brow_NUM_N+select_style;
				maximum=max[AVA_Brow];
				minimum=0;
			elseif part==AVA_Acce1 then
				index=AVA_Acce1_NUM;
				maximum=max[AVA_Acce1];
				minimum=0;
			elseif part==AVA_Acce2 then
				index=AVA_Acce2_NUM;
				maximum=max[AVA_Acce2];
				minimum=0;
			end;
			avatar[index]=avatar[index]+add;
			if avatar[index]<minimum then avatar[index]=maximum; end;
			if avatar[index]>maximum then avatar[index]=minimum; end;
		end;
	end;
end;

t[#t+1]=Def.ActorFrame{
	OnCommand=function(self)
		MESSAGEMAN:Broadcast("Set",{Part=select_part,Style=select_style,Save=select_save});
		self:sleep(EXF_BEGIN_WAIT());
		self:queuecommand("UnLockKey");
	end;
	UnLockKeyCommand=function(self)
		sys_lock=false;
		--SetAvatarTable(select_style,av);
		self:queuecommand("Set");
	end;
	KeyDownMessageCommand=function(self,params)
		if not sys_lock then
			if C_GetKey(PLAYER_1,"Start") or C_GetKey(PLAYER_2,"Start") then
				if select_part==AVA_Save then
					sys_lock=true;
					MESSAGEMAN:Broadcast("Start");
				elseif select_part==AVA_Style or select_part==AVA_Mouth
					 or select_part==AVA_Brow then
					select_part=AVA_Save;
					select_save=0;
					MESSAGEMAN:Broadcast("Set",{Part=select_part,Style=select_style,Save=select_save});
					self:queuecommand("Sound1Play");
				else
					sys_lock=true;
					c_setenvg('av',av);
					c_setenvg('select_part',select_part);
					c_setenvg('select_style',select_style);
					c_setenvg('select_save',select_save);
					C_SetNextScreen();
				end;
			elseif C_GetKey(PLAYER_1,"Back") or C_GetKey(PLAYER_2,"Back") then
				select_part=AVA_Save;
				select_save=2;
				MESSAGEMAN:Broadcast("Set",{Part=select_part,Style=select_style,Save=select_save});
				self:queuecommand("Sound1Play");
			else
				if C_GetKey(PLAYER_1,"Up") or C_GetKey(PLAYER_2,"Up") then
					select_part=select_part-1;
					if select_part<1 then select_part=part_max; end;
					MESSAGEMAN:Broadcast("Set",{Part=select_part,Style=select_style,Save=select_save});
					self:queuecommand("Sound1Play");
				end;
				if C_GetKey(PLAYER_1,"Down") or C_GetKey(PLAYER_2,"Down") then
					select_part=select_part+1;
					if select_part>part_max then select_part=1; end;
					MESSAGEMAN:Broadcast("Set",{Part=select_part,Style=select_style,Save=select_save});
					self:queuecommand("Sound1Play");
				end;
				if C_GetKey(PLAYER_1,"Left") or C_GetKey(PLAYER_2,"Left") then
					setPreviewFace(av,select_part,-1);
					MESSAGEMAN:Broadcast("Set",{Part=select_part,Style=select_style,Save=select_save});
					self:queuecommand("Sound2Play");
				end;
				if C_GetKey(PLAYER_1,"Right") or C_GetKey(PLAYER_2,"Right") then
					setPreviewFace(av,select_part,1);
					MESSAGEMAN:Broadcast("Set",{Part=select_part,Style=select_style,Save=select_save});
					self:queuecommand("Sound2Play");
				end;
			end;
		end;
	end;
	StartMessageCommand=function(self)
		local filename=GetFileNameFormPath(av_file);
		local savename="";
		if filename[1]~="" then
			local b=GetTextBlock(av_file,'main');
			savename=GetBlockPrm(b,'name');
		end;
		if filename[1]~="" and select_save==0 then
		-- [ja] 上書き 
			SaveAvatar(av,savename,filename[1],true);
		elseif (filename[1]=="" and select_save==0)
			or select_save==1 then
	--[[
	ToDo:保存 
	--]]
		-- [ja] 名前を付けて 
			c_setenvg('av',av);
			c_setenvg('av_file',av_file);
			c_setenvg('av_name',savename);
			C_SetScreenNumber(6);
		end;
		self:sleep(0.4);
		self:queuecommand("NextScreen");
	end;
	NextScreenCommand=function(self)
		C_SetScreenNumber(1);
	end;
	SetMessageCommand=function(self)
		MESSAGEMAN:Broadcast("AvatarChanged",{id=1,av=av,t=select_style});
	end;
	-- [ja] 決定 
	LoadActor(THEME:GetPathS("Common","start")) .. {
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
	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,0,0,0,0);
		StartMessageCommand=cmd(linear,0.4;diffusealpha,1);
	};
};

return t;