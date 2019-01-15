local id,av_tmp,ava_type=...;
local folder="0827/";
local av={unpack(av_tmp)};
local t=Def.ActorFrame{};
ava_type=ava_type or AVATAR_NORMAL;
t[#t+1]=Def.ActorFrame{
	OnCommand=function(self)
		MESSAGEMAN:Broadcast('AvatarChanged',{id=id,t=ava_type,av=av});
	end;
	AvatarChangedMessageCommand=function(self,params)
		if params and params.id==id then
			if params.av then
				av=params.av;
			end;
			ava_type=params.t;
			if #av>0 then
				self:visible(true);
				self:playcommand('PartsChang');
			else
				self:visible(false);
			end;
		end;
	end;
	LoadActor(folder..'1-back_hair')..{
		InitCommand=function(self)
			self:animate(false);
		end;
		PartsChangCommand=function(self)
			if (av[AVA_BHiar_NUM]~=0) then
				(cmd(visible,true;setstate,av[AVA_BHiar_NUM]-1;
					diffuse,color(av[AVA_BHiar_COL])))(self);
			else
				self:visible(false);
			end;
		end;
	};
	LoadActor(folder..'2-face')..{
		InitCommand=function(self)
			self:animate(false);
		end;
		PartsChangCommand=function(self)
			(cmd(diffuse,color(av[AVA_Face_COL_N+2*ava_type])))(self);
		end;
	};
	LoadActor(folder..'2-face')..{
		InitCommand=function(self)
			self:animate(false);
		end;
		PartsChangCommand=function(self)
			if (av[AVA_Face_NUM_N+2*ava_type]~=0) then
				(cmd(visible,true;setstate,av[AVA_Face_NUM_N+2*ava_type]))(self);
			else
				self:visible(false);
			end;
		end;
	};
	LoadActor(folder..'3-eye')..{
		InitCommand=function(self)
			self:animate(false);
			self:y(32);
		end;
		PartsChangCommand=function(self)
			if (av[AVA_Eye_NUM1_N+3*ava_type]~=0) and (av[AVA_Eye_NUM1_N+3*ava_type]<5) then
				(cmd(visible,true;
					setstate,(av[AVA_Eye_NUM1_N+3*ava_type]-1)))(self);
			elseif (av[AVA_Eye_NUM1_N+3*ava_type]>=5) then
				(cmd(visible,true;
					setstate,(av[AVA_Eye_NUM1_N+3*ava_type]-5)*5+4;))(self);
			else
				self:visible(false);
			end;
		end;
	};
	LoadActor(folder..'3-eye')..{
		InitCommand=function(self)
			self:animate(false);
			self:y(32);
		end;
		PartsChangCommand=function(self)
			if (av[AVA_Eye_NUM1_N+3*ava_type]~=0) and (av[AVA_Eye_NUM1_N+3*ava_type]<5) then
				(cmd(visible,true;
					setstate,(av[AVA_Eye_NUM1_N+3*ava_type]-1)+5;diffuse,color(av[AVA_Eye_COL_N+3*ava_type])))(self);
			else
				self:visible(false);
			end;
		end;
	};
	LoadActor(folder..'3-eye')..{
		InitCommand=function(self)
			self:animate(false);
			self:y(32);
		end;
		PartsChangCommand=function(self)
			if (av[AVA_Eye_NUM2_N+3*ava_type]~=0) and (av[AVA_Eye_NUM1_N+3*ava_type]~=0) and (av[AVA_Eye_NUM1_N+3*ava_type]<5) then
				(cmd(visible,true;
					setstate,(av[AVA_Eye_NUM1_N+3*ava_type]-1)+10+(av[AVA_Eye_NUM2_N+3*ava_type]-1)*5))(self);
			else
				self:visible(false);
			end;
		end;
	};
	LoadActor(folder..'4-mouth')..{
		InitCommand=function(self)
			self:animate(false);
			self:y(48);
		end;
		PartsChangCommand=function(self)
			if (av[AVA_Mouth_NUM_N+ava_type]~=0) then
				(cmd(visible,true;setstate,(av[AVA_Mouth_NUM_N+ava_type]-1)))(self);
			else
				self:visible(false);
			end;
		end;
	};
	LoadActor(folder..'5-main_hair')..{
		InitCommand=function(self)
			self:animate(false);
		end;
		PartsChangCommand=function(self)
			if (av[AVA_MHiar_NUM]~=0) then
				(cmd(visible,true;setstate,(av[AVA_MHiar_NUM]-1);
					diffuse,color(av[AVA_MHiar_COL])))(self);
			else
				self:visible(false);
			end;
		end;
	};
	LoadActor(folder..'6-side_hair')..{
		InitCommand=function(self)
			self:animate(false);
		end;
		PartsChangCommand=function(self)
			if (av[AVA_SHiar_NUM]~=0) then
				(cmd(visible,true;setstate,(av[AVA_SHiar_NUM]-1);
					diffuse,color(av[AVA_SHiar_COL])))(self);
			else
				self:visible(false);
			end;
		end;
	};
	LoadActor(folder..'7-flont_hair')..{
		InitCommand=function(self)
			self:animate(false);
		end;
		PartsChangCommand=function(self)
			if (av[AVA_FHiar_NUM]~=0) then
				(cmd(visible,true;setstate,(av[AVA_FHiar_NUM]-1);
					diffuse,color(av[AVA_FHiar_COL])))(self);
			else
				self:visible(false);
			end;
		end;
	};
	LoadActor(folder..'9-brow')..{
		InitCommand=function(self)
			self:animate(false);
		end;
		PartsChangCommand=function(self)
			if (av[AVA_Brow_NUM_N+ava_type]~=0) then
				(cmd(visible,true;setstate,(av[AVA_Brow_NUM_N+ava_type]-1)))(self);
			else
				self:visible(false);
			end;
		end;
	};
	LoadActor(folder..'10-accessory')..{
		InitCommand=function(self)
			self:animate(false);
		end;
		PartsChangCommand=function(self)
			if (av[AVA_Acce1_NUM]~=0) then
				(cmd(visible,true;setstate,(av[AVA_Acce1_NUM]-1);
					diffuse,color(av[AVA_Acce1_COL])))(self);
			else
				self:visible(false);
			end;
		end;
	};
	LoadActor(folder..'8-accent_hair')..{
		InitCommand=function(self)
			self:animate(false);
		end;
		PartsChangCommand=function(self)
			if (av[AVA_AHiar_NUM]~=0) then
				(cmd(visible,true;setstate,(av[AVA_AHiar_NUM]-1);
					diffuse,color(av[AVA_AHiar_COL])))(self);
			else
				self:visible(false);
			end;
		end;
	};
	LoadActor(folder..'10-accessory')..{
		InitCommand=function(self)
			self:animate(false);
		end;
		PartsChangCommand=function(self)
			if (av[AVA_Acce2_NUM]~=0) then
				(cmd(visible,true;setstate,(av[AVA_Acce2_NUM]-1);
					diffuse,color(av[AVA_Acce2_COL])))(self);
			else
				self:visible(false);
			end;
		end;
	};
};
return t;