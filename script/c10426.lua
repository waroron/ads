--進化の到達点
function c10426.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c10426.ctop2)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10426,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c10426.drcon)
	e2:SetOperation(c10426.drop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10426,2))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(aux.chainreg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10426,2))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c10426.ctcon)
	e4:SetOperation(c10426.ctop)
	c:RegisterEffect(e4)
	--leave
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetOperation(c10426.checkop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetLabelObject(e5)
	e6:SetOperation(c10426.leave)
	c:RegisterEffect(e6)
end

function c10426.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c10426.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and c:GetFlagEffect(10425)<=1
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10426,3)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(10426,2))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c10426.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		c:RegisterFlagEffect(10425,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end

function c10426.cfilter(c,tp)
	return c:IsSetCard(0x504e) and c:GetPreviousControler()==tp and c:GetSummonType()==SUMMON_TYPE_XYZ
end
function c10426.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10426.cfilter,1,nil,tp)
end
function c10426.thfilter(c)
	return (c:IsCode(10426) or c:IsCode(5338223) or c:IsCode(22431243) or c:IsCode(84808313) or c:IsCode(88760522)
		or c:IsCode(25573054) or c:IsCode(34026662) or c:IsCode(8632967) or c:IsCode(14154221)
		 or c:IsCode(62991886) or c:IsCode(24362891) or c:IsCode(74100225) or c:IsCode(64815084)
		  or c:IsCode(93504463)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c10426.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c10426.thfilter,tp,LOCATION_DECK,0,1,nil) and c:GetFlagEffect(10426)<=1
	and Duel.SelectYesNo(tp,aux.Stringid(10426,1)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(10426,0))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c10426.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		c:RegisterFlagEffect(10426,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end

function c10426.spfilter(c,e,tp)
	return (c:IsSetCard(0x304e) or c:IsSetCard(0x504e) or c:IsSetCard(0x604e)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10426.ctcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local c=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
	and (c:IsCode(10426) or c:IsCode(5338223) or c:IsCode(22431243) or c:IsCode(84808313) or c:IsCode(88760522)
		or c:IsCode(25573054) or c:IsCode(34026662) or c:IsCode(8632967) or c:IsCode(14154221)
		 or c:IsCode(62991886) or c:IsCode(24362891) or c:IsCode(74100225) or c:IsCode(64815084)
		  or c:IsCode(93504463))
end
function c10426.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c10426.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and c:GetFlagEffect(10425)<=1
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10426,3)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(10426,2))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c10426.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		c:RegisterFlagEffect(10425,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end

function c10426.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c10426.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c10426.leave(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabelObject():GetLabel()==0 and c:GetPreviousControler()==tp and c:IsStatus(STATUS_ACTIVATED) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(10426,4))
		local g=Duel.GetMatchingGroup(c10426.rfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
