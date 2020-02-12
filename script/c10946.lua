--遅れてきた獣
function c10946.initial_effect(c)
	c:SetSPSummonOnce(10946)
	c:EnableReviveLimit()
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c10946.sprcon)
	e0:SetOperation(c10946.sprop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c10946.xyzcon)
	e1:SetOperation(c10946.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c10946.splimit)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON)
	e4:SetOperation(c10946.limop)
	c:RegisterEffect(e4)
end

function c10946.mfilter(c,xyzc)
	return c:GetFlagEffect(10946)~=0 and c:IsCanBeXyzMaterial(xyzc)
end
function c10946.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(c10946.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c10946.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and mg:GetCount()>0
end
function c10946.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local c=e:GetHandler()
	local g=nil
	local sg=Group.CreateGroup()
	local xyzg=Group.CreateGroup()
	if og then
		g=og
		local tc=og:GetFirst()
	else
		local mg=nil
		if og then
			mg=og:Filter(c10946.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c10946.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		end
		local ct=mg:GetCount()
		xyzg:Merge(mg)
	end
	local xtc=xyzg:GetFirst()
	while xtc do
		local mg=xtc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(c,mg)
		end
		xtc=xyzg:GetNext()
	end
	c:SetMaterial(xyzg)
	Duel.Overlay(c,xyzg)
end

function c10946.sprcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10946.cxfilter,1,nil,e:GetHandler()) and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c10946.cxfilter(c,xyzc)
	return c:IsSetCard(0xf1) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_XYZ)
		and c:GetSummonType()==SUMMON_TYPE_XYZ and c:IsCanBeXyzMaterial(xyzc)
end
function c10946.sprop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c10946.cxfilter,nil,c)
	local mt=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=g:GetFirst()
	if tc:IsControler(1-tp) and mt<=0 then return end
	if g:GetCount()>0 and Duel.GetFlagEffect(tp,10946)==0 and Duel.SelectYesNo(tp,aux.Stringid(10946,0)) then
		Duel.ConfirmCards(1-tp,c)
		while tc do
			if tc:GetFlagEffect(10946)==0 then
				tc:RegisterFlagEffect(10946,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			end
			tc=g:GetNext()
		end
		if Duel.XyzSummon(tp,c,nil)~=0 then
			Duel.RegisterFlagEffect(tp,10946,RESET_PHASE+PHASE_END,0,1)
		end
	end
end

function c10946.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or (bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and se:GetHandler():IsCode(10946))
end
function c10946.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then return end
	Duel.SetChainLimitTillChainEnd(c10946.chlimit)
end
function c10946.chlimit(e,rp,tp)
	return e:IsActiveType(TYPE_TRAP) and e:GetHandler():IsType(TYPE_COUNTER)
end
