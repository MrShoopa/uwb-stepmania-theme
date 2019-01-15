-- [ja] アバター関連 

AVA_BHiar_NUM=		1;
AVA_BHiar_COL=		2;
AVA_Face_NUM_N=		3;
AVA_Face_COL_N=		4;
AVA_Face_NUM_W=		5;
AVA_Face_COL_W=		6;
AVA_Face_NUM_L=		7;
AVA_Face_COL_L=		8;
AVA_Eye_NUM1_N=		9;
AVA_Eye_COL_N=		10;
AVA_Eye_NUM2_N=		11;
AVA_Eye_NUM1_W=		12;
AVA_Eye_COL_W=		13;
AVA_Eye_NUM2_W=		14;
AVA_Eye_NUM1_L=		15;
AVA_Eye_COL_L=		16;
AVA_Eye_NUM2_L=		17;
AVA_Mouth_NUM_N=	18;
AVA_Mouth_NUM_W=	19;
AVA_Mouth_NUM_L=	20;
AVA_MHiar_NUM=		21;
AVA_MHiar_COL=		22;
AVA_SHiar_NUM=		23;
AVA_SHiar_COL=		24;
AVA_FHiar_NUM=		25;
AVA_FHiar_COL=		26;
AVA_AHiar_NUM=		27;
AVA_AHiar_COL=		28;
AVA_Brow_NUM_N=		29;
AVA_Brow_NUM_W=		30;
AVA_Brow_NUM_L=		31;
AVA_Acce1_NUM=		32;
AVA_Acce1_COL=		33;
AVA_Acce2_NUM=		34;
AVA_Acce2_COL=		35;

AVATAR_NORMAL= 	0;
AVATAR_WIN= 	1;
AVATAR_LOSE= 	2;

function GetAvatar(file)
	local avatar={};
	if file and FILEMAN:DoesFileExist(file) then
		local block=GetTextBlock(file,'main');
		local block_n=GetTextBlock(file,'normal');
		local block_w=GetTextBlock(file,'win');
		local block_l=GetTextBlock(file,'lose');
		avatar=GetAvatar_Core(block,block_n,block_w,block_l);
	end;
	return avatar;
end;

function GetPlayerAvatar(pn)
	local avatar={};
	local dir=(pn==PLAYER_1) and PROFILEMAN:GetProfileDir('ProfileSlot_Player1') or PROFILEMAN:GetProfileDir('ProfileSlot_Player2');
	if dir~='' then
		local block=GetTextBlock(dir..'waieiSettings.ini','main');
		local avatar_file=GetBlockPrm(block,'avatar');
		if avatar_file~='' then
			avatar=GetAvatar('Save/waiei/Avatars/'..avatar_file);
		end;
	end;
	return avatar;
end;

function GetDefaultAvatar()
	local block={
		'BackHair=0,#6699cc;',
		'FlontHair=1,#6699cc;',
		'SideHair=1,#6699cc;',
		'MainHair=1,#6699cc;',
		'AccentHair=0,#6699cc;',
		'Accessory1=0,#ffffff;',
		'Accessory2=0,#ffffff;'
	};
	local block_n={
		'Face=1,#ffe5b2;',
		'Eye=1,#6699cc,1;',
		'Mouth=1;',
		'Brow=1;'
	};
	local block_w={
		'Face=1,#ffe5b2;',
		'Eye=5,#6699cc,1;',
		'Mouth=2;',
		'Brow=1;'
	};
	local block_l={
		'Face=1,#ffe5b2;',
		'Eye=1,#6699cc,1;',
		'Mouth=8;',
		'Brow=3;'
	};
	return GetAvatar_Core(block,block_n,block_w,block_l);
end;

function GetAvatar_Core(block,block_n,block_w,block_l)
	local avatar={};
	if block~="" then
		local prm=split(',',GetBlockPrm(block,'BackHair'));
		avatar[AVA_BHiar_NUM]=tonumber(prm[1]);
		avatar[AVA_BHiar_COL]=prm[2];
		
		prm=split(',',GetBlockPrm(block_n,'Face'));
		avatar[AVA_Face_NUM_N]=tonumber(prm[1]);
		avatar[AVA_Face_COL_N]=prm[2];
		prm=split(',',GetBlockPrm(block_w,'Face'));
		avatar[AVA_Face_NUM_W]=tonumber(prm[1]);
		avatar[AVA_Face_COL_W]=prm[2];
		prm=split(',',GetBlockPrm(block_l,'Face'));
		avatar[AVA_Face_NUM_L]=tonumber(prm[1]);
		avatar[AVA_Face_COL_L]=prm[2];
		
		prm=split(',',GetBlockPrm(block_n,'Eye'));
		avatar[AVA_Eye_NUM1_N]=tonumber(prm[1]);
		avatar[AVA_Eye_COL_N]=prm[2];
		avatar[AVA_Eye_NUM2_N]=tonumber(prm[3]);
		prm=split(',',GetBlockPrm(block_w,'Eye'));
		avatar[AVA_Eye_NUM1_W]=tonumber(prm[1]);
		avatar[AVA_Eye_COL_W]=prm[2];
		avatar[AVA_Eye_NUM2_W]=tonumber(prm[3]);
		prm=split(',',GetBlockPrm(block_l,'Eye'));
		avatar[AVA_Eye_NUM1_L]=tonumber(prm[1]);
		avatar[AVA_Eye_COL_L]=prm[2];
		avatar[AVA_Eye_NUM2_L]=tonumber(prm[3]);
		
		prm=split(',',GetBlockPrm(block_n,'Mouth'));
		avatar[AVA_Mouth_NUM_N]=tonumber(prm[1]);
		prm=split(',',GetBlockPrm(block_w,'Mouth'));
		avatar[AVA_Mouth_NUM_W]=tonumber(prm[1]);
		prm=split(',',GetBlockPrm(block_l,'Mouth'));
		avatar[AVA_Mouth_NUM_L]=tonumber(prm[1]);
		
		prm=split(',',GetBlockPrm(block,'MainHair'));
		avatar[AVA_MHiar_NUM]=tonumber(prm[1]);
		avatar[AVA_MHiar_COL]=prm[2];
		
		prm=split(',',GetBlockPrm(block,'SideHair'));
		avatar[AVA_SHiar_NUM]=tonumber(prm[1]);
		avatar[AVA_SHiar_COL]=prm[2];
		
		prm=split(',',GetBlockPrm(block,'FlontHair'));
		avatar[AVA_FHiar_NUM]=tonumber(prm[1]);
		avatar[AVA_FHiar_COL]=prm[2];
		
		prm=split(',',GetBlockPrm(block,'AccentHair'));
		avatar[AVA_AHiar_NUM]=tonumber(prm[1]);
		avatar[AVA_AHiar_COL]=prm[2];
		
		prm=split(',',GetBlockPrm(block_n,'Brow'));
		avatar[AVA_Brow_NUM_N]=tonumber(prm[1]);
		prm=split(',',GetBlockPrm(block_w,'Brow'));
		avatar[AVA_Brow_NUM_W]=tonumber(prm[1]);
		prm=split(',',GetBlockPrm(block_l,'Brow'));
		avatar[AVA_Brow_NUM_L]=tonumber(prm[1]);
		
		prm=split(',',GetBlockPrm(block,'Accessory1'));
		avatar[AVA_Acce1_NUM]=tonumber(prm[1]);
		avatar[AVA_Acce1_COL]=prm[2];
		
		prm=split(',',GetBlockPrm(block,'Accessory2'));
		avatar[AVA_Acce2_NUM]=tonumber(prm[1]);
		avatar[AVA_Acce2_COL]=prm[2];
	end;
	return {unpack(avatar)};
end;

function SaveAvatar(avatar,name,filename,uwagaki)
	local fileData='';
	fileData=fileData..'[main]\r\n';
	fileData=fileData..'waiei='..GetThemeVersionInformation("Date")..';\r\n';
	fileData=fileData..'Name='..name..';\r\n';
	fileData=fileData..'BackHair='..avatar[AVA_BHiar_NUM]..','..avatar[AVA_BHiar_COL]..';\r\n';
	fileData=fileData..'FlontHair='..avatar[AVA_FHiar_NUM]..','..avatar[AVA_FHiar_COL]..';\r\n';
	fileData=fileData..'SideHair='..avatar[AVA_SHiar_NUM]..','..avatar[AVA_SHiar_COL]..';\r\n';
	fileData=fileData..'MainHair='..avatar[AVA_MHiar_NUM]..','..avatar[AVA_MHiar_COL]..';\r\n';
	fileData=fileData..'AccentHair='..avatar[AVA_AHiar_NUM]..','..avatar[AVA_AHiar_COL]..';\r\n';
	fileData=fileData..'Accessory1='..avatar[AVA_Acce1_NUM]..','..avatar[AVA_Acce1_COL]..';\r\n';
	fileData=fileData..'Accessory2='..avatar[AVA_Acce2_NUM]..','..avatar[AVA_Acce2_COL]..';\r\n';
	fileData=fileData..'\r\n';
	fileData=fileData..'[normal]\r\n';
	fileData=fileData..'Face='..avatar[AVA_Face_NUM_N]..','..avatar[AVA_Face_COL_N]..';\r\n';
	fileData=fileData..'Eye='..avatar[AVA_Eye_NUM1_N]..','..avatar[AVA_Eye_COL_N]..','..avatar[AVA_Eye_NUM2_N]..';\r\n';
	fileData=fileData..'Mouth='..avatar[AVA_Mouth_NUM_N]..';\r\n';
	fileData=fileData..'Brow='..avatar[AVA_Brow_NUM_N]..';\r\n';
	fileData=fileData..'\r\n';
	fileData=fileData..'[win]\r\n';
	fileData=fileData..'Face='..avatar[AVA_Face_NUM_W]..','..avatar[AVA_Face_COL_W]..';\r\n';
	fileData=fileData..'Eye='..avatar[AVA_Eye_NUM1_W]..','..avatar[AVA_Eye_COL_W]..','..avatar[AVA_Eye_NUM2_W]..';\r\n';
	fileData=fileData..'Mouth='..avatar[AVA_Mouth_NUM_W]..';\r\n';
	fileData=fileData..'Brow='..avatar[AVA_Brow_NUM_W]..';\r\n';
	fileData=fileData..'\r\n';
	fileData=fileData..'[lose]\r\n';
	fileData=fileData..'Face='..avatar[AVA_Face_NUM_L]..','..avatar[AVA_Face_COL_L]..';\r\n';
	fileData=fileData..'Eye='..avatar[AVA_Eye_NUM1_L]..','..avatar[AVA_Eye_COL_L]..','..avatar[AVA_Eye_NUM2_L]..';\r\n';
	fileData=fileData..'Mouth='..avatar[AVA_Mouth_NUM_L]..';\r\n';
	fileData=fileData..'Brow='..avatar[AVA_Brow_NUM_L]..';\r\n';
	if not uwagaki then
		if FILEMAN:DoesFileExist('Save/waiei/Avatars/'..filename..'.ini') then
			local n=1;
			while FILEMAN:DoesFileExist('Save/waiei/Avatars/'..filename..string.format('%02d',n)..'.ini') do
				n=n+1;
			end;
			filename=filename..string.format('%02d',n);
		end;
	end;
	local f=SaveFile('Save/waiei/Avatars/'..filename..'.ini');
	f:Write(fileData);
	CloseFile(f);
end;

function GetNoImageAvatar(key)
	local ret=THEME:GetPathG('','_blank');
	if key=='hiscore' then
		ret=THEME:GetPathG('_Avatar','graphics/noimage/hiscore');
	elseif tonumber(key)>=1 and tonumber(key)<=9 then
		ret=THEME:GetPathG('_Avatar','graphics/noimage/rival'..key);
	else
	end
	return ret;
end;
