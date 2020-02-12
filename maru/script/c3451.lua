--地縛囚人ストーン・スィーパー
function c3451.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c3451.spcon)
	c:RegisterEffect(e1)
end
function c3451.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.GetFieldCard(tp,LOCATION_SZONE,5) or Duel.GetFieldCard(1-tp,LOCATION_SZONE,5))
end
