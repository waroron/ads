--Sakyo, Swordmaster of the Far East
function c200201520.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(200201520,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c200201520.skcos)
	e2:SetTarget(c200201520.sktg)
	e2:SetOperation(c200201520.skop)
	c:RegisterEffect(e2)
end
function c200201520.skcfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost()
end
function c200201520.skfilter1(c,e,tp)
	return c200201520.skcfilter(c)
		and Duel.IsExistingMatchingCard(c200201520.skfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp,c)
end
function c200201520.skfilter2(c,e,tp,tc1)
	return c200201520.skcfilter(c) and c~=tc1
		and Duel.IsExistingMatchingCard(c200201520.skfilter3,tp,LOCATION_MZONE,0,1,nil,e,tp,tc1,c)
end
function c200201520.skfilter3(c,e,tp,tc1,tc2)
	return c200201520.skcfilter(c) and c~=tc1 and c~=tc2
		and Duel.IsExistingTarget(c200201520.skfilter4,tp,LOCATION_MZONE,0,1,nil,tc1,tc2,c)
end
function c200201520.skfilter4(c,tc1,tc2,tc3)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c~=tc1 and c~=tc2 and c~=tc3
end
function c200201520.skfilter5(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c200201520.skcos(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c200201520.skfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g1=Duel.SelectMatchingCard(tp,c200201520.skfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc1=g1:GetFirst()
	local g2=Duel.SelectMatchingCard(tp,c200201520.skfilter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp,tc1)
	local tc2=g2:GetFirst()
	local g3=Duel.SelectMatchingCard(tp,c200201520.skfilter3,tp,LOCATION_MZONE,0,1,1,nil,e,tp,tc1,tc2)
	local tc3=g3:GetFirst()
	Duel.Remove(Group.FromCards(tc1,tc2,tc3),POS_FACEUP,REASON_COST)
end
function c200201520.sktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c200201520.skfilter5(chkc) end
	if chk==0 then return true end
	Duel.SelectTarget(tp,c200201520.skfilter5,tp,LOCATION_MZONE,0,1,1,nil)
end
function c200201520.skop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		--
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MATCH_KILL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
