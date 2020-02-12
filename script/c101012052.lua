--コードブレイカー・ウイルスソードマン
function c101012052.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012052,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101012052)
	e1:SetCondition(c101012052.condition)
	e1:SetTarget(c101012052.target)
	e1:SetOperation(c101012052.operation)
	c:RegisterEffect(e1)
	--special summon from grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c101012052.tgop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101012052,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1,101012052+100)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c101012052.spcon)
	e3:SetTarget(c101012052.sptg)
	e3:SetOperation(c101012052.spop)
	c:RegisterEffect(e3)
end
function c101012052.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c101012052.spfilter(c,e,tp,p,zones)
	return c:IsCode(101012002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,p,zones)
end
function c101012052.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101012052.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,tp,Duel.GetLinkedZone(tp)&0x1f)
		or Duel.IsExistingMatchingCard(c101012052.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,1-tp,Duel.GetLinkedZone(1-tp)&0x1f) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c101012052.operation(e,tp,eg,ep,ev,re,r,rp)
	local zones={}
	zones[tp]=Duel.GetLinkedZone(tp)&0x1f
	zones[1-tp]=Duel.GetLinkedZone(1-tp)&0x1f
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=(Duel.GetMatchingGroup(aux.NecroValleyFilter(c101012052.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,tp,zones[tp])+Duel.GetMatchingGroup(aux.NecroValleyFilter(c101012052.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,1-tp,zones[1-tp])):Select(tp,1,1,nil):GetFirst()
	if tc then
		local p
		if c101012052.spfilter(tc,e,tp,tp,zones[tp]) and c101012052.spfilter(tc,e,tp,1-tp,zones[1-tp]) then
			p=Duel.SelectYesNo(tp,aux.Stringid(101012052,2)) and 1-tp or tp
		elseif c101012052.spfilter(tc,e,tp,tp,zones) then
			p=tp
		else
			p=1-tp
		end
		Duel.SpecialSummon(tc,0,tp,p,false,false,POS_FACEUP,zones[p])
	end
end
function c101012052.tgop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsReason(REASON_DESTROY) and rp~=tp then
		e:GetHandler():RegisterFlagEffect(101012052,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c101012052.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(101012052)>0
end
function c101012052.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101012052.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end