--アークネメシス・プロートス
function c101012008.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101012008.spcon)
	e1:SetOperation(c101012008.spop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101012008,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101012008)
	e3:SetTarget(c101012008.destg)
	e3:SetOperation(c101012008.desop)
	c:RegisterEffect(e3)
end
function c101012008.lcheck(g)
	return g:GetClassCount(Card.GetAttribute)==g:GetCount()
end
function c101012008.spfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:IsOnField()) and c:IsAbleToRemoveAsCost()
end
function c101012008.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c101012008.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetAttribute)>=3
end
function c101012008.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c101012008.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetClassCount(Card.GetAttribute)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:SelectSubGroup(tp,c101012008.lcheck,false,3,3)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
end
function c101012008.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local Attribute=0
	while tc do
		Attribute=bit.bor(Attribute,tc:GetAttribute())
		tc=g:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_Attribute)
	local arc=Duel.AnnounceAttribute(tp,1,Attribute)
	e:SetLabel(arc)
	local dg=g:Filter(Card.IsAttribute,nil,arc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c101012008.filter2(c,rc)
	return c:IsFaceup() and c:IsAttribute(rc)
end
function c101012008.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local arc=e:GetLabel()
	local g=Duel.GetMatchingGroup(c101012008.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,arc)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012008,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c101012008.sumlimit(arc))
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c101012008.sumlimit(arc)
	return  function(e,c,sump,sumtype,sumpos,targetp)
				return c:IsAttribute(arc)
			end
end