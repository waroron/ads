--リンクロス
function c101012049.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c101012049.matfilter,1,1)
	--Token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012049,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101012049)
	e1:SetCondition(c101012049.condition)
	e1:SetTarget(c101012049.target)
	e1:SetOperation(c101012049.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c101012049.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c101012049.matfilter(c,lc,sumtype,tp)
	return c:IsLinkAbove(2) and c:IsType(TYPE_LINK,lc,sumtype,tp)
end
function c101012049.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c101012049.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101012149,0,TYPES_TOKEN,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c101012049.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),e:GetLabel())
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,101012149,0,TYPES_TOKEN,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local ct=ft
	if ft>1 then
		local options={}
		for i=1,ft do
			table.insert(options,i)
		end
		ct=Duel.AnnounceNumber(tp,table.unpack(options))
	end
	local c=e:GetHandler()
	for i=1,ct do
		local token=Duel.CreateToken(tp,101012149)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(101012049,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		token:RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete()
end
function c101012049.valcheck(e,c)
	e:GetLabelObject():SetLabel(c:GetMaterial():GetFirst():GetLink())
end
