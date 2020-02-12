--サイクリボー
function c11040.initial_effect(c)
	--change control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11040,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE)
	e1:SetCondition(c11040.adcon)
	e1:SetCost(c11040.cost)
	e1:SetTarget(c11040.adtg)
	e1:SetOperation(c11040.adop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c11040.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(11040)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	--deck activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c11040.operation)
	c:RegisterEffect(e4)
	--replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_DECK+LOCATION_HAND)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetTarget(c11040.reptg)
	e5:SetOperation(c11040.repop)
	e5:SetValue(c11040.repval)
	c:RegisterEffect(e5)
	--plus effect
	if not c11040.global_check then
		c11040.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c11040.sdop)
		Duel.RegisterEffect(ge1,0)
	end
end

function c11040.adcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) 
		and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c11040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(11040)==0 end
	e:GetHandler():RegisterFlagEffect(11040,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c11040.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and bc:IsOnField() and c:IsAbleToChangeControler() and bc:IsAbleToChangeControler() end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11040,0))
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,2,0,0)
end
function c11040.adop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if not (a:IsRelateToEffect(e) or at:IsRelateToEffect(e)) then return end
	if Duel.SwapControl(a,at,RESET_PHASE+PHASE_BATTLE,1) then
			Duel.CalculateDamage(a,at)
	end
end

function c11040.eftg(e,c)
	return c:IsSetCard(0xa4) and c:IsType(TYPE_MONSTER)
end

function c11040.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if Duel.GetFlagEffect(tp,11040)>0 then return end
	Duel.RegisterFlagEffect(tp,11040,RESET_PHASE+PHASE_END,0,1)
	if c:GetPreviousLocation()==LOCATION_DECK then Duel.ShuffleDeck(tp) end
	if Duel.IsExistingMatchingCard(c11040.kufilter,tp,LOCATION_DECK,0,2,nil) then
		local sg=Duel.GetMatchingGroup(c11040.kufilter,tp,LOCATION_DECK,0,nil)
		Duel.ConfirmCards(tp,sg)
	end
	--public
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c11040.con)
	e1:SetOperation(c11040.op)
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
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetOperation(c11040.pubop)
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)
end

--public
function c11040.cfilter(c,tp)
	return c:GetPreviousControler()==tp
		and (c:IsPreviousLocation(LOCATION_DECK) or c:GetSummonLocation()==LOCATION_DECK
			or (c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK))
			or c:IsLocation(LOCATION_DECK)) and not c:IsReason(REASON_DRAW)
end
function c11040.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11040.cfilter,1,nil,tp)
end
function c11040.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()<=1 then return end
	c:RegisterFlagEffect(11040,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1) 
end
function c11040.pubop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()<=1 then return end
	if c:GetFlagEffect(11040)~=0 and Duel.IsExistingMatchingCard(c11040.kufilter,tp,LOCATION_DECK,0,2,nil) then
		local sg=Duel.GetMatchingGroup(c11040.kufilter,tp,LOCATION_DECK,0,nil)
		Duel.ConfirmCards(tp,sg)
		c:ResetFlagEffect(11040)
	end
end

function c11040.prfilter(c)
	return c:IsCode(11040) and c:IsAbleToGrave()
end
function c11040.repfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa4) and not c:IsCode(11040)
		and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup())) and c:GetDestination()==LOCATION_GRAVE
end
function c11040.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c11040.repfilter,1,nil,tp) end
	if not Duel.IsExistingMatchingCard(c11040.prfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) then return end
	if Duel.GetFlagEffect(tp,11041)>0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(11040,2)) then
		local g=eg:Filter(c11040.repfilter2,nil,tp)
		if g:GetCount()>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleHand(tp)
		end
		return true
	else return false end
end
function c11040.repfilter2(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa4)
		and c:IsLocation(LOCATION_HAND) and c:GetDestination()==LOCATION_GRAVE
end
function c11040.repop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	Duel.RegisterFlagEffect(tp,11041,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c11040.prfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if tg:GetCount()>0 then
		Duel.SendtoGrave(tg,REASON_EFFECT+REASON_REPLACE)
	end
end
function c11040.repval(e,c)
	return c11040.repfilter(c,e:GetHandlerPlayer())
end

function c11040.kufilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsCode(80831721,15471265,20065322,25573054,40703222,89086566) or c:IsSetCard(0xa4))
end
function c11040.kmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa4)
end
function c11040.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetOwner()
	local g=Duel.GetMatchingGroup(c11040.kufilter,c,LOCATION_DECK,LOCATION_DECK,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(11040)==0 then
			local code=tc:GetOriginalCode()
			local ae=tc:GetActivateEffect()
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_ACTIVATE)
			e1:SetCode(ae:GetCode())
			e1:SetCategory(ae:GetCategory())
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+ae:GetProperty())
			e1:SetRange(LOCATION_DECK)
			e1:SetCountLimit(1,code)
			e1:SetCondition(c11040.sfcon)
			e1:SetTarget(c11040.sftg)
			e1:SetOperation(c11040.sfop)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			--activate cost
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_ACTIVATE_COST)
			e2:SetRange(LOCATION_DECK)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE)
			e2:SetTargetRange(LOCATION_DECK,0)
			e2:SetCost(c11040.costchk)
			e2:SetTarget(c11040.costtg)
			e2:SetOperation(c11040.costop)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(11040,RESET_EVENT+0x1fe0000,0,1)
		end	
		tc=g:GetNext()
	end
	local kg=Duel.GetMatchingGroup(c11040.kmfilter,c,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_HAND,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_HAND,nil)
	local tck=kg:GetFirst()
	while tck do
		if tck:GetFlagEffect(11041)==0 then
			--spsummon
			local e1=Effect.CreateEffect(tck)
			e1:SetDescription(aux.Stringid(11040,1))
			e1:SetCategory(CATEGORY_SPSUMMON)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
			e1:SetCode(EVENT_TO_GRAVE)
			e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
			e1:SetCondition(c11040.spcon)
			e1:SetCost(c11040.cost)
			e1:SetTarget(c11040.sptg)
			e1:SetOperation(c11040.spop)
			tck:RegisterEffect(e1)
			tck:RegisterFlagEffect(11041,0,0,1)
		end
		tck=kg:GetNext()
	end
end

--deck activate
function c11040.sfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,11040)>0
end
function c11040.sftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ae=e:GetHandler():GetActivateEffect()
	local fcon=ae:GetCondition()
	local fcos=ae:GetCost()
	local ftg=ae:GetTarget()
	if chk==0 then
		return (not fcon or fcon(e,tp,eg,ep,ev,re,r,rp))
			and (not fcos or fcos(e,tp,eg,ep,ev,re,r,rp,0))
			and (not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,0))
	end
	if fcos then 
		fcos(e,tp,eg,ep,ev,re,r,rp,1)
	end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function c11040.sfop(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetHandler():GetActivateEffect()
	local fop=ae:GetOperation()
	if fop then
		fop(e,tp,eg,ep,ev,re,r,rp)
	end
end

--activate field
function c11040.costchk(e,te_or_c,tp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c11040.costtg(e,te,tp)
	return te:GetHandler():IsLocation(LOCATION_DECK) and te:GetHandler()==e:GetHandler()
end
function c11040.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end

function c11040.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsReason(REASON_LINK) and (c:IsPreviousLocation(LOCATION_HAND) or c:IsPreviousLocation(LOCATION_ONFIELD))
end
function c11040.spfilter(c,e,tp,code)
	return c:IsSetCard(0xa4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code)
end
function c11040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local code=c:GetOriginalCode()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11040.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,code)
		and Duel.IsPlayerAffectedByEffect(tp,11040) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11040,1))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c11040.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=c:GetOriginalCode()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11040.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c11040.sumlimit)
		e1:SetLabel(g:GetFirst():GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c11040.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
