--多元魔導書庫クレッセン
function c10190.initial_effect(c)
	--Activate(effect)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_DECK+LOCATION_HAND)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetCondition(c10190.condition2)
	-- e4:SetTarget(c10190.target)
	e4:SetOperation(c10190.activate2)
	c:RegisterEffect(e4)
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
	--Duel.AddCustomActivityCounter(10190,ACTIVITY_CHAIN,c10190.chainfilter)
end

function c10190.chainfilter(re,tp,cid)
	return not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and not re:GetHandler():IsSetCard(0x106e))
end

function c10190.tagen_filter(c)
	return c:IsSetCard(0x106e)
end

function c10190.condition2(e,tp,eg,ep,ev,re,r,rp)
	local flag = re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
	if flag == true then Debug.Message("ok")
	else Debug.Message("no") end
	--Debug.Message("no") 
	return flag
end

function c10190.target(e,tp,eg,ep,ev,re,r,rp,chk, chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

function c10190.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if Duel.NegateActivation(ev) then
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.SendtoGrave(c, REASON_EFFECT)
	end
end
