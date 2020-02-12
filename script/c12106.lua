--星霊獣輝 チュプカムイ
function c12106.initial_effect(c)
	c:SetUniqueOnField(1,1,12106)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--activate from deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12106,0))
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_DECK)
	e2:SetCondition(c12106.actcon)
	e2:SetTarget(c12106.acttg)
	e2:SetOperation(c12106.actop)
	c:RegisterEffect(e2)
	--summon from deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12106,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,12106)
	e3:SetCost(c12106.sumcost)
	e3:SetTarget(c12106.sumtg)
	e3:SetOperation(c12106.sumop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetOperation(c12106.costop)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c12106.reptg)
	e5:SetValue(c12106.repval)
	c:RegisterEffect(e5)
end
--activate from deck
function c12106.actffilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xb5) and c:IsControler(tp) and c:GetPreviousControler()==tp
end
function c12106.actcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12106.actffilter,1,nil,tp)
end
function c12106.cffilter(c)
	return c:IsFaceup() and c:IsCode(12106)
end
function c12106.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>-1
		and not Duel.IsExistingMatchingCard(c12106.cfilter,tp,LOCATION_SZONE,0,1,nil) end
end
function c12106.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if Duel.IsExistingMatchingCard(c12106.cfilter,tp,LOCATION_SZONE,0,1,nil) then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end

--summon from deck
function c12106.remffilter(c)
	return c:IsSetCard(0xb5) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c12106.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12106.remfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c12106.remfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c12106.sumfilter(c)
	return c:IsSetCard(0xb5) and c:IsSummonable(true,nil)
end
function c12106.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12106.sumfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c12106.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c12106.sumfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end

--spsummon
function c12106.matfilter1(c,e,tp)
	return c:IsSetCard(0xb5) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c12106.matfilter2,tp,LOCATION_MZONE,0,1,c,e,tp,c)
end
function c12106.matfilter2(c,e,tp,tc)
	return c:IsSetCard(0xb5) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c12106.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
--		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,tc))>0
end
function c12106.spffilter(c,e,tp)
	return c:IsSetCard(0xb5) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c12106.costop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c12106.matfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) 
		and Duel.SelectYesNo(tp,aux.Stringid(12106,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,c12106.matfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg2=Duel.SelectMatchingCard(tp,c12106.matfilter2,tp,LOCATION_MZONE,0,1,1,rg:GetFirst(),e,tp,rg:GetFirst())
		rg:Merge(rg2)
		if Duel.Remove(rg,POS_FACEUP,REASON_COST)==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c12106.spfilter,tp,LOCATION_EXTRA,0,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end

--destroy replace
function c12106.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xb5)
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
end
function c12106.tdfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xb5) and c:IsAbleToDeck()
end
function c12106.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local count = 1
	local ct=eg:FilterCount(c12106.repfilter,nil,tp)
	local dg=Duel.GetMatchingGroup(c12106.tdfilter,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return ct>0 and dg:GetCount()>0 end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local g=eg:Filter(c12106.repfilter,nil,tp)
		if g:GetCount()==1 then
			g:GetFirst():RegisterFlagEffect(12106,RESET_EVENT+RESET_CHAIN,0,1)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,dg:GetCount(),nil)
			count = cg:GetCount()
			local tc=cg:GetFirst()
			for i=1,count do
				tc:RegisterFlagEffect(12106,RESET_EVENT+RESET_CHAIN,0,1)
				tc=cg:GetNext()
			end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=dg:Select(tp,count,count,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c12106.rfilter(c,tp)
	return c:GetFlagEffect(12106)>0
end
function c12106.repval(e,c)
	return c12106.rfilter(c,e:GetHandlerPlayer())
end
