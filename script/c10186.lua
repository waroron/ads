--多元魔導書の神判
function c10186.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	-- e1:SetCountLimit(1,10186+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c10186.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e2)
	--cannot set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e3)
	--remove type
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_REMOVE_TYPE)
	e4:SetValue(TYPE_QUICKPLAY)
	c:RegisterEffect(e4)
end

function c10186.filter(c)
	return c:IsSetCard(0x106e)
end

function c10186.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10186.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end

function c10186.activate(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(c10186.tagen_filter, tp, LOCATION_GRAVE, 0, nil)
	local n = g:GetCount()
	Debug.Message(tostring(n))
	if n > 0 then 
		local g=Duel.SelectMatchingCard(tp,c10186.filter,tp,LOCATION_DECK,0,1,n,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

