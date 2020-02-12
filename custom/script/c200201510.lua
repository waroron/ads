--Kuzunoha, the Onmyojin
function c200201510.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(200201510,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c200201510.skcos)
	e2:SetTarget(c200201510.sktg)
	e2:SetOperation(c200201510.skop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c200201510.splimit)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRIBUTE_LIMIT)
	e4:SetValue(c200201510.tlimit)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(200201510,0))
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e5:SetCondition(c200201510.ttcon)
	e5:SetOperation(c200201510.ttop)
	e5:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e6)
	--
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_MATCH_KILL)
	e7:SetCondition(c200201510.wincon)
	c:RegisterEffect(e7)
end
function c200201510.skcfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost()
end
function c200201510.skfilter1(c,e,tp)
	return c200201510.skcfilter(c)
		and Duel.IsExistingMatchingCard(c200201510.skfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp,c)
end
function c200201510.skfilter2(c,e,tp,tc1)
	return c200201510.skcfilter(c) and c~=tc1
		and Duel.IsExistingMatchingCard(c200201510.skfilter3,tp,LOCATION_MZONE,0,1,nil,e,tp,tc1,c)
end
function c200201510.skfilter3(c,e,tp,tc1,tc2)
	return c200201510.skcfilter(c) and c~=tc1 and c~=tc2
		and Duel.IsExistingTarget(c200201510.skfilter4,tp,LOCATION_MZONE,0,1,nil,tc1,tc2,c)
end
function c200201510.skfilter4(c,tc1,tc2,tc3)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c~=tc1 and c~=tc2 and c~=tc3
end
function c200201510.skfilter5(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c200201510.skcos(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c200201510.skfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g1=Duel.SelectMatchingCard(tp,c200201510.skfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc1=g1:GetFirst()
	local g2=Duel.SelectMatchingCard(tp,c200201510.skfilter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp,tc1)
	local tc2=g2:GetFirst()
	local g3=Duel.SelectMatchingCard(tp,c200201510.skfilter3,tp,LOCATION_MZONE,0,1,1,nil,e,tp,tc1,tc2)
	local tc3=g3:GetFirst()
	Duel.Remove(Group.FromCards(tc1,tc2,tc3),POS_FACEUP,REASON_COST)
end
function c200201510.sktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c200201510.skfilter5(chkc) end
	if chk==0 then return true end
	Duel.SelectTarget(tp,c200201510.skfilter5,tp,LOCATION_MZONE,0,1,1,nil)
end
function c200201510.skop(e,tp,eg,ep,ev,re,r,rp)
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
function c200201510.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c200201510.tlimit(e,c)
	return not c:IsRace(RACE_SPELLCASTER)
end
function c200201510.ttcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3 and Duel.GetTributeCount(c)>=3
end
function c200201510.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c200201510.wincon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==1
end
