--強欲な瓶
function c4392.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_DECK)
	--e1:SetCondition(c4392.con)
	e1:SetTarget(c4392.target)
	e1:SetOperation(c4392.activate)
	c:RegisterEffect(e1)
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_DECK)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
--	e2:SetTarget(c4392.actarget)
	e2:SetCost(c4392.costchk)
	e2:SetOperation(c4392.costop)
	c:RegisterEffect(e2)
end
function c4392.con(e,c,tp)
	return Duel.CheckReleaseGroup(tp,Card.IsRace,1,nil,RACE_DRAGON)
end
function c4392.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c4392.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function c4392.actarget(e,te,tp)
	return te:GetHandler():IsLocation(LOCATION_DECK)
end
function c4392.costchk(e,te_or_c,tp)
	return Duel.CheckLPCost(tp,500)
end
function c4392.costop(e,te,tp)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
