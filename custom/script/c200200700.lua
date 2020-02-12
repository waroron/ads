--Get Your Game On!
function c200200700.initial_effect(c,e)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c200200700.target)
	c:RegisterEffect(e1)
	--double atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(200200700,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3008))
	e2:SetValue(c200200700.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1f))
	c:RegisterEffect(e3)
end
function c200200700.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CODE,tp,200200701)
end
function c200200700.atkval(e,c)
	return c:GetAttack()*2
end