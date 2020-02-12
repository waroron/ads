--パラレルエクシード
function c101012001.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101012001)
	e1:SetCondition(c101012001.condition)
	e1:SetTarget(c101012001.target)
	e1:SetOperation(c101012001.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101012001,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,101012001+100)
	e2:SetTarget(c101012001.sptg)
	e2:SetOperation(c101012001.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--change level
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_COST)
	e4:SetOperation(c101012001.lvop)
	c:RegisterEffect(e4)
end
function c101012001.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetSummonPlayer()==tp and eg:GetFirst():IsSummonType(SUMMON_TYPE_LINK)
end
function c101012001.getLinkedZones(g,p)
	local zones=0
	for c in aux.Next(g) do
		zones=zones|(c:GetLinkedZone(p)&0x1f)
	end
	return zones
end
function c101012001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local zones=c101012001.getLinkedZones(eg,tp)
	if chk==0 then return zones~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zones) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c101012001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zones=c101012001.getLinkedZones(eg,tp)
	if c:IsRelateToEffect(e) and zones~=0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zones)
	end
end
function c101012001.spfilter(c,e,tp)
	return c:IsCode(101012001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101012001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101012001.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101012001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101012001.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101012001.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local reff=c:GetReasonEffect()
	if reff and reff:GetHandler():IsCode(101012001) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(4)
		e1:SetReset(RESET_EVENT+0x7f0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_ATTACK)
		e2:SetValue(c:GetBaseAttack()/2)
		c:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_SET_BASE_DEFENSE)
		e3:SetValue(c:GetBaseDefense()/2)
		c:RegisterEffect(e3)
	end
end

