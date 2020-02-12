--Ａｉ－コンタクト
function c101012056.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101012056)--+EFFECT_COUNT_CODE_OATH
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101012056.condition)
	e1:SetCost(c101012056.cost)
	e1:SetTarget(c101012056.target)
	e1:SetOperation(c101012056.activate)
	c:RegisterEffect(e1)
end
function c101012056.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(59054773)
end
function c101012056.costfilter(c)
	return c:IsCode(59054773) and c:IsAbleToDeckAsCost() and not c:IsPublic()
end
function c101012056.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101012056.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c101012056.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c101012056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c101012056.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
