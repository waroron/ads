--金牙の王 ランディア
function c200201110.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,3)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c200201110.splimit)
	c:RegisterEffect(e1)
	--match kill
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_MATCH_KILL)
	e2:SetCondition(c200201110.condition)
	c:RegisterEffect(e2)
end
function c200201110.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c200201110.condition(e)
	local g=e:GetHandler():GetOverlayGroup()
	return g:IsExists(Card.IsRace,1,nil,RACE_BEASTWARRIOR)
end