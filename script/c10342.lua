--影依の廻転
function c10342.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10342+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10342.target)
	e1:SetOperation(c10342.operation)
	c:RegisterEffect(e1)
	--plus effect
	if not c10342.global_check then
		c10342.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c10342.sdop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c10342.filter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(10342)
end
function c10342.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10342.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c10342.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,10342,RESET_PHASE+PHASE_END,0,1)	
	if Duel.IsExistingMatchingCard(c10342.filter,tp,LOCATION_DECK,0,2,nil) then
		local sg=Duel.GetMatchingGroup(c10342.filter,tp,LOCATION_DECK,0,nil)
		Duel.ConfirmCards(tp,sg)
	end
		--public
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TO_GRAVE)
		e1:SetCondition(c10342.con)
		e1:SetOperation(c10342.op)
		e1:SetLabelObject(e6)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EVENT_TO_HAND)
		Duel.RegisterEffect(e3,tp)
		local e4=e1:Clone()
		e4:SetCode(EVENT_TO_DECK)
		Duel.RegisterEffect(e4,tp)
		local e5=e1:Clone()
		e5:SetCode(EVENT_REMOVE)
		Duel.RegisterEffect(e5,tp)
		--
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_CHAIN_SOLVED)
		e6:SetOperation(c10342.disop)
		e6:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e6,tp)
		local e7=e6:Clone()
		e7:SetCode(EVENT_CHAINING)
		Duel.RegisterEffect(e7,tp)
end

function c10342.cfilter(c,tp)
	return c:GetPreviousControler()==tp
		and (c:IsPreviousLocation(LOCATION_DECK) or c:GetSummonLocation()==LOCATION_DECK
			or (c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK))
			or c:IsLocation(LOCATION_DECK)) and not c:IsReason(REASON_DRAW)
end
function c10342.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10342.cfilter,1,nil,tp)
end
function c10342.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()<=1 then return end
	c:RegisterFlagEffect(10342,RESET_PHASE+PHASE_END,0,1)
end

function c10342.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()<=1 then return end
	if c:GetFlagEffect(10342)~=0 and Duel.IsExistingMatchingCard(c10342.filter,tp,LOCATION_DECK,0,2,nil) then
		local sg=Duel.GetMatchingGroup(c10342.filter,tp,LOCATION_DECK,0,nil)
		Duel.ConfirmCards(tp,sg)
		c:ResetFlagEffect(10342)
	end
end

function c10342.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetOwner()
	local g=Duel.GetMatchingGroup(c10342.filter,c,LOCATION_DECK,LOCATION_DECK,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(10342)==0 then
			local code=tc:GetOriginalCode()
			local ae=tc:GetActivateEffect()
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_ACTIVATE)
			e1:SetCode(ae:GetCode())
			e1:SetCategory(ae:GetCategory())
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+ae:GetProperty())
			e1:SetRange(LOCATION_DECK)
			e1:SetCountLimit(1,code+EFFECT_COUNT_CODE_OATH)
			e1:SetCondition(c10342.sfcon)
			e1:SetTarget(c10342.sftg)
			e1:SetOperation(c10342.sfop)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			--activate cost
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_ACTIVATE_COST)
			e2:SetRange(LOCATION_DECK)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE)
			e2:SetTargetRange(LOCATION_DECK,0)
			e2:SetCost(c10342.costchk)
			e2:SetTarget(c10342.costtg)
			e2:SetOperation(c10342.costop)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(10342,RESET_EVENT+0x1fe0000,0,1)
		end	
		tc=g:GetNext()
	end
end

--deck activate
function c10342.sfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,10342)>0 and Duel.GetFlagEffect(tp,e:GetHandler():GetOriginalCode())==0
end
function c10342.sftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ae=e:GetHandler():GetActivateEffect()
	local fcon=ae:GetCondition()
	local fcos=ae:GetCost()
	local ftg=ae:GetTarget()
	if chk==0 then
		return (not fcon or fcon(e,tp,eg,ep,ev,re,r,rp))
			and (not fcos or fcos(e,tp,eg,ep,ev,re,r,rp,0))
			and (not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,0))
			and e:GetHandler():IsSetCard(0x9d) and e:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP)
	end
	if fcos then 
		fcos(e,tp,eg,ep,ev,re,r,rp,1)
	end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetOriginalCode(),RESET_PHASE+PHASE_END,0,1)
end
function c10342.sfop(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetHandler():GetActivateEffect()
	local fop=ae:GetOperation()
	if fop then
		fop(e,tp,eg,ep,ev,re,r,rp)
	end
end

--activate field
function c10342.costfilter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c10342.costchk(e,te_or_c,tp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10342.costfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c10342.costtg(e,te,tp)
	return te:GetHandler():IsLocation(LOCATION_DECK) and te:GetHandler()==e:GetHandler()
end
function c10342.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c10342.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
