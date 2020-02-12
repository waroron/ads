--古代の機械双頭猟犬
function c3073.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,3072,2,false,true)
	c3073.material_count=2
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetOperation(c3073.atkop)
	c:RegisterEffect(e1)
	--gearacid
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3073,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c3073.acidcon)
	e2:SetOperation(c3073.acidop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(3073,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c3073.destg)
	e4:SetOperation(c3073.desop)
	e4:SetCondition(c3073.descon)
	c:RegisterEffect(e4)
end
function c3073.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c3073.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c3073.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c3073.acidfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:GetCounter(0x1343)==0
end
function c3073.acidcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c3073.acidfilter,1,nil,1-tp)
end
function c3073.acidop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c3073.acidfilter,nil,1-tp)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1343,1)
		tc=g:GetNext()
	end
end
function c3073.desfilter(c)
	return c:GetCounter(0x1343)~=0 and c:IsDestructable()
end
function c3073.descon(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	local g=Group.CreateGroup()
	if tc:GetCounter(0x1343)>0 then
		g:AddCard(tc)
	end
	if bc then
		if bc:GetCounter(0x1343)>0 then
			g:AddCard(bc)
		end
	end
	g:KeepAlive()
	e:SetLabelObject(g)
	return g:GetCount()>0
end
function c3073.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	if chk==0 then return g and g:IsExists(Card.IsDestructable,1,nil) end
	g:KeepAlive()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c3073.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(c3073.desfilter,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
