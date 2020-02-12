--サラの蟲惑魔
function c10457.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(10457)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c10457.imcon)
	e1:SetValue(c10457.efilter)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10457,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCost(c10457.spcost)
	e2:SetTarget(c10457.sptg)
	e2:SetOperation(c10457.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(10457,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetTarget(c10457.nstg)
	e3:SetOperation(c10457.nsop)
	c:RegisterEffect(e3)
	--disable spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c10457.sumlimit)
	c:RegisterEffect(e4)
	--effect limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_TRIGGER)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c10457.actfilter)
	c:RegisterEffect(e5)
	--special summon rule
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10457,2))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetCondition(c10457.chcon)
	e6:SetOperation(c10457.chop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(10457,2))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetRange(LOCATION_EXTRA)
	e7:SetCode(EVENT_BE_BATTLE_TARGET)
	e7:SetCondition(c10457.atcon)
	e7:SetOperation(c10457.atop)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SPSUMMON_PROC)
	e8:SetRange(LOCATION_EXTRA)
	e8:SetCondition(c10457.xyzcon)
	e8:SetOperation(c10457.xyzop)
	e8:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e8)
	--spsummon condition
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	e9:SetValue(c10457.splimit)
	c:RegisterEffect(e9)
	--act limit
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_SPSUMMON)
	e10:SetOperation(c10457.limop)
	c:RegisterEffect(e10)
end

function c10457.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c10457.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end

function c10457.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)  end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10457.spfilter(c,e,tp)
	return c:IsSetCard(0x108a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10457.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10457.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10457.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10457.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c10457.nsfilter(c)
	return c:IsSetCard(0x108a) and c:IsSummonable(true,nil)
end
function c10457.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10457.nsfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10457.nsop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c10457.nsfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.Summon(tp,tc,true,nil)
	end
end

function c10457.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x108a)
end

function c10457.actfilter(e,c)
	return not c:IsSetCard(0x108a)
end

function c10457.cfilter(c,xyzc,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x108a) and not c:IsType(TYPE_XYZ)
		and c:IsCanBeXyzMaterial(xyzc) and c:IsFaceup()
end
function c10457.chcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c10457.cfilter,1,nil,c,tp) and Duel.IsChainNegatable(ev) and re:GetHandler():IsRelateToEffect(re)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c10457.xyzfilter(c,xyzc)
	return not c:IsType(TYPE_TOKEN) and (c:IsCanBeXyzMaterial(xyzc) or not c:IsType(TYPE_MONSTER))
end
function c10457.xyzfilter2(c)
	return not c:IsType(TYPE_TOKEN)
end
function c10457.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(c10457.xyzfilter,nil,c)
	local g2=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(c10457.xyzfilter2,nil)
	if Duel.GetFlagEffect(tp,10457)==0 and g:GetCount()>0 and g:GetCount()==g2:GetCount() and rc:IsRelateToEffect(re)
		and Duel.IsChainNegatable(ev) and Duel.SelectYesNo(tp,aux.Stringid(10457,3)) then
		Duel.ConfirmCards(1-tp,c)
		Duel.RegisterFlagEffect(tp,10457,RESET_PHASE+PHASE_END,0,1)
		if Duel.NegateEffect(ev) then
			rc:CancelToGrave()
			g:AddCard(rc)
			local tc=g:GetFirst()
			while tc do
				local og=tc:GetOverlayGroup()
				if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				tc:RegisterFlagEffect(10457,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1) 	
				tc=g:GetNext()
			end
			Duel.XyzSummon(tp,c,nil)
		end
	end
end

function c10457.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() and tc:IsSetCard(0x108a) and not tc:IsType(TYPE_TOKEN) and not tc:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c10457.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToEffect(e) and a:IsAttackable() and not a:IsStatus(STATUS_ATTACK_CANCELED)
		and a:IsCanBeXyzMaterial(c) and d:IsCanBeXyzMaterial(c)
		and not d:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(10457,3)) then
		Duel.ConfirmCards(1-tp,c)
		if Duel.NegateAttack() then
			local g=Group.FromCards(a,d)
			local tc=g:GetFirst()
			while tc do
				local og=tc:GetOverlayGroup()
				if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end	
				tc:RegisterFlagEffect(10457,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1) 	
				tc=g:GetNext()
			end
			Duel.XyzSummon(tp,c,nil)
		end
	end
end

function c10457.mfilter(c,xyzc)
	return c:GetFlagEffect(10457)~=0 and (c:IsCanBeXyzMaterial(xyzc) or not c:IsType(TYPE_MONSTER))
end
function c10457.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(c10457.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c10457.mfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil,c)
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and mg:GetCount()>0
end
function c10457.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
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
			mg=og:Filter(c10457.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c10457.mfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil,c)
		end
		local ct=mg:GetCount()
		xyzg:Merge(mg)
	end
	c:SetMaterial(xyzg)
	Duel.Overlay(c,xyzg)
end

function c10457.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or (bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and se:GetHandler():IsCode(10457))
end

function c10457.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then return end
	Duel.SetChainLimitTillChainEnd(c10457.chlimit)
end
function c10457.chlimit(e,rp,tp)
	return e:IsActiveType(TYPE_TRAP) and e:GetHandler():IsType(TYPE_COUNTER)
end
