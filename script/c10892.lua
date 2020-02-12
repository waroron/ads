--トポロジック・ガンブラー・ドラゴン
function c10892.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--spsummon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10892,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c10892.descon)
	e1:SetTarget(c10892.destg)
	e1:SetOperation(c10892.desop)
	c:RegisterEffect(e1)
	--handes only 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10096,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c10892.hancon)
	e2:SetTarget(c10892.hantg)
	e2:SetOperation(c10892.hanop)
	c:RegisterEffect(e2)
	--cannot effect destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c10892.hancon)
	e3:SetTarget(c10892.target)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c10892.cfilter(c,zone)
	local seq=c:GetSequence()
	if c:IsControler(1) then seq=seq+16 end
	return bit.extract(zone,seq)~=0
end
function c10892.descon(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(0)+Duel.GetLinkedZone(1)*0x10000
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c10892.cfilter,1,nil,zone)
end
function c10892.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10892.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	Duel.Destroy(g,REASON_EFFECT)
end

function c10892.hancon(e)
	return e:GetHandler():IsExtraLinked()
end
function c10892.hantg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	local g=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10892.hanop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	Duel.Destroy(g,REASON_EFFECT)
end

function c10892.target(e,c)
	return c:IsType(TYPE_LINK)
end
