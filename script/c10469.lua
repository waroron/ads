--閃光の宣告者
function c10469.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10469,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10469.discon)
	e1:SetCost(c10469.discost)
	e1:SetTarget(c10469.distg)
	e1:SetOperation(c10469.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
end
function c10469.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetCurrentChain()==0
end
function c10469.costfilter(c,tp)
	return (c:IsRace(RACE_FAIRY) and c:IsLocation(LOCATION_HAND) or (c:IsCode(10458) and Duel.GetFlagEffect(tp,10458)==0)) 
		and c:IsAbleToGraveAsCost()
end
function c10469.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() 
		and Duel.IsExistingMatchingCard(c10469.costfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10469.costfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,c,tp)
	local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		Duel.RegisterFlagEffect(tp,10458,RESET_PHASE+PHASE_END,0,1)
	end 
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c10469.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
end
function c10469.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg:GetFirst())
	Duel.SendtoHand(eg,nil,REASON_EFFECT)
end
