--転生炎獣ゼブロイドＸ
function c101012003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,101012003)
	e1:SetCondition(c101012003.spcon)
	e1:SetTarget(c101012003.sptg)
	e1:SetOperation(c101012003.spop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c101012003.efcon)
	e2:SetOperation(c101012003.efop)
	c:RegisterEffect(e2)
	if not c101012003.global_check then
		c101012003.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(c101012003.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101012003.checkop(e,tp,eg,ep,ev,re,r,rp)
	for ec in aux.Next(eg) do
		if ec:GetPreviousTypeOnField()&TYPE_LINK>0
			and ec:IsPreviousSetCard(0x119) and REASON_EFFECT&ec:GetReason()>0
			and ec:GetPreviousControler()~=ec:GetReasonEffect():GetHandlerPlayer() then
			Duel.RegisterFlagEffect(ec:GetPreviousControler(),id,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c101012003.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetFlagEffect(tp,id)>0 and ph>=PHASE_MAIN1 and ph<=PHASE_MAIN2
end
function c101012003.filter(c,e,tp,tc)
	return c:IsSetCard(0x119) and c:IsLevelBelow(4)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c101012003.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,Group.FromCards(c,tc))
end
function c101012003.xyzfilter(c,mg)
	return c:IsSetCard(0x119) and c:IsType(TYPE_XYZ) and c:IsXyzSummonable(mg,2,2)
end
function c101012003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c101012003.filter,tp,LOCATION_GRAVE,0,1,c,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101012003.spop(e,tp,eg,ep,ev,re,r,rp)
	if chkc then return false end
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101012003.filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,c)+c
	if #g~=2 then return end
	for tc in aux.Next(g) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	local xyzg=Duel.GetMatchingGroup(c101012003.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if #xyzg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
function c101012003.efcon(e,tp,eg,ep,ev,re,r,rp)
	return (r&REASON_XYZ)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c101012003.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012003,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c101012003.atkval)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c101012003.atkval(e,c)
	return c:GetOverlayCount()*300
end