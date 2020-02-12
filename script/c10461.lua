--ナーガの存在
function c10461.initial_effect(c)
	c:SetUniqueOnField(1,0,10461)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c10461.sprcon)
	e1:SetOperation(c10461.sprop)
	c:RegisterEffect(e1)
	--to s/t zone
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c10461.sdcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c10461.desreptg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--to monster zone
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c10461.sdcon2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetTarget(c10461.desreptg2)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--immune
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_IMMUNE_EFFECT)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_ONFIELD)
	e10:SetValue(c10461.efilter)
	c:RegisterEffect(e10)
	--battle target
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetValue(aux.imval1)
	c:RegisterEffect(e11)
	--triple summon
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetRange(LOCATION_ONFIELD)
	e12:SetTargetRange(1,0)
	e12:SetCondition(c10461.sumcon)
	e12:SetValue(3)
	e12:SetTarget(aux.TargetBoolFunction(Card.IsRace,0x8000))
	c:RegisterEffect(e12)
	--oath effects
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetRange(LOCATION_ONFIELD)
	e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e13:SetCode(EFFECT_CANNOT_SUMMON)
	e13:SetTarget(c10461.splimit)
	e13:SetTargetRange(1,0)
	c:RegisterEffect(e13)
	local e14=e13:Clone()
	e14:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e14)
	--replace
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e15:SetCode(EFFECT_SEND_REPLACE)
	e15:SetRange(LOCATION_ONFIELD)
	e15:SetTarget(c10461.destg)
	e15:SetValue(c10461.repval)
	c:RegisterEffect(e15)
	--
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_FIELD)
	e17:SetCode(10461)
	e17:SetRange(LOCATION_ONFIELD)
	e17:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e17:SetTargetRange(1,0)
	c:RegisterEffect(e17)
	--extra summon
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e18:SetCode(EVENT_SUMMON_SUCCESS)
	e18:SetRange(LOCATION_MZONE)
	e18:SetOperation(c10461.drop)
	c:RegisterEffect(e18)
	--counter
	local e19=Effect.CreateEffect(c)
	e19:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e19:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e19:SetRange(LOCATION_MZONE)
	e19:SetCode(EVENT_PHASE+PHASE_END)
	e19:SetCountLimit(1)
	e19:SetOperation(c10461.counter)
	c:RegisterEffect(e19)
	--advance summon
	local e20=Effect.CreateEffect(c)
	e20:SetDescription(aux.Stringid(10461,1))
	e20:SetType(EFFECT_TYPE_FIELD)
	e20:SetCode(EFFECT_SUMMON_PROC)
	e20:SetRange(LOCATION_MZONE)
	e20:SetTargetRange(LOCATION_HAND,0)
	e20:SetCondition(c10461.otcon)
	e20:SetTarget(c10461.ottg)
	e20:SetOperation(c10461.otop)
	e20:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e20)
	local e21=e20:Clone()
	e21:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e21)
	--act qp/trap in hand
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_FIELD)
	e22:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e22:SetRange(LOCATION_ONFIELD)
	e22:SetTargetRange(LOCATION_HAND,0)
	e22:SetTarget(aux.TargetBoolFunction(c10461.dafilter))
	c:RegisterEffect(e22)
	local e23=e22:Clone()
	e23:SetCode(10461)
	c:RegisterEffect(e23)
	--
	local e25=Effect.CreateEffect(c)
	e25:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e25:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e25:SetCode(EVENT_CHAINING)
	e25:SetRange(LOCATION_ONFIELD)
	e25:SetOperation(c10461.actop)
	c:RegisterEffect(e25)
	--public
	local e26=Effect.CreateEffect(c)
	e26:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e26:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e26:SetCode(EVENT_TO_GRAVE)
	e26:SetRange(LOCATION_ONFIELD)
	e26:SetCondition(c10461.con)
	e26:SetOperation(c10461.op)
	c:RegisterEffect(e26)
	local e27=e26:Clone()
	e27:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e27)
	local e28=e26:Clone()
	e28:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e28)
	local e29=e26:Clone()
	e29:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e29)
	local e30=e26:Clone()
	e30:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e30)
	local e31=Effect.CreateEffect(c)
	e31:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e31:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e31:SetCode(EVENT_CHAIN_SOLVED)
	e31:SetRange(LOCATION_ONFIELD)
	e31:SetOperation(c10461.pubop)
	c:RegisterEffect(e31)
	local e32=e31:Clone()
	e32:SetCode(EVENT_SUMMON)
	c:RegisterEffect(e32)
	local e33=Effect.CreateEffect(c)
	e33:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e33:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e33:SetCode(EVENT_SPSUMMON_SUCCESS)
	e33:SetOperation(c10461.sumsuc)
	c:RegisterEffect(e33)
	--plus effect
	if not c10461.global_check then
		c10461.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c10461.adop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SUMMON)
		ge2:SetOperation(c10461.regop)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		ge3:SetCode(EVENT_MSET)
		Duel.RegisterEffect(ge3,0)
	end
end

--special summon rule
function c10461.sprfilter(c)
	return c:IsSetCard(0x50) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c10461.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c10461.sprfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	return ft>0 and g:GetClassCount(Card.GetCode)>3
end
function c10461.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10461.sprfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>3 end
	local tg=Group.CreateGroup()
	for i=1,4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
		tg:Merge(sg)
	end
	Duel.SendtoGrave(tg,REASON_COST)
end

--to s/t zone
function c10461.venomfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x50)
end
function c10461.sdcon(e)
	return not Duel.IsExistingMatchingCard(c10461.venomfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c10461.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and not (not re or re:GetOwner()~=c) end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
		return true
	else
		Duel.SendtoGrave(c,REASON_RULE)
		return true
	end
end

--to monster zone
function c10461.sdcon2(e)
	return Duel.IsExistingMatchingCard(c10461.venomfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c10461.desreptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and not (not re or re:GetOwner()~=c) end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.MoveToField(c,tp,tp,c:GetPreviousLocation(),c:GetPreviousPosition(),true)
		return true
	else
		Duel.SendtoGrave(c,REASON_RULE)
		return true
	end
end

--immune
function c10461.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

--summon limit
function c10461.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_REPTILE)
end

--send leplace
function c10461.vmfilter(c)
	return c:IsFaceup() and c:IsCode(8062132)
end
function c10461.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c10461.vmfilter,1,e:GetHandler()) 
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	if Duel.SelectYesNo(tp,aux.Stringid(10461,3)) then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c10461.repval(e,c)
	return c:IsFaceup() and c:IsCode(8062132) and c~=e:GetHandler()
end

--extra summon
function c10461.sufilter(c,e,tp)
	return c:IsControler(tp) and c:IsRace(RACE_REPTILE) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c10461.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel())
end
function c10461.exfilter(c,e,tp,lv)
	return (c:GetRank()==lv or c:GetLevel()==lv) and c:IsRace(RACE_REPTILE)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10461.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if eg:IsExists(c10461.sufilter,1,nil,e,tp) then
		local g=eg:Filter(c10461.sufilter,nil,e,tp)
		local tc=g:GetFirst()
		local lv=tc:GetLevel()
		if Duel.IsExistingMatchingCard(c10461.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv)
			and Duel.SelectYesNo(tp,aux.Stringid(10461,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c10461.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

--counter
function c10461.counter(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10461.vmfilter,tp,LOCATION_MZONE,0,c)
	local sg=Group.CreateGroup()
	if g:GetCount()==0 then return end
	if g:GetCount()==1 then
		sg:AddCard(g:GetFirst())
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10461,4))
		sg:AddCard(g:Select(tp,1,1,nil):GetFirst())
	end
	local tc=sg:GetFirst()
	Duel.HintSelection(Group.FromCards(tc))
	tc:AddCounter(0x11,1)
	local WIN_REASON_VENNOMINAGA = 0x12
	if tc:GetCounter(0x11)==3 then
		Duel.Win(tp,WIN_REASON_VENNOMINAGA)
	end
end

--advance
function c10461.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c10461.ottg(e,c)
	local mi,ma=c:GetTributeRequirement()
	return ((mi<=2 and ma>=2 and Duel.IsExistingMatchingCard(c10461.sprfilter,e:GetHandlerPlayer(),LOCATION_DECK,0,2,nil)) 
		or (mi<=1 and ma>=1) and Duel.IsExistingMatchingCard(c10461.sprfilter,e:GetHandlerPlayer(),LOCATION_DECK,0,1,nil)) 
		and c:IsRace(RACE_REPTILE)
end
function c10461.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mi,ma=c:GetTributeRequirement()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10461.sprfilter,tp,LOCATION_DECK,0,mi,ma,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

--act in hand
function c10461.acttg(e,te,tp)
	local tc=te:GetHandler()
	return tc:IsLocation(LOCATION_HAND) and tc:GetEffectCount(10461)>0
		and tc:GetEffectCount(EFFECT_TRAP_ACT_IN_HAND)<=tc:GetEffectCount(10461) and tc:IsType(TYPE_TRAP)
		and tc:IsCode(16067089,93217231,80678380) and Duel.GetFlagEffect(tp,tc:GetOriginalCode())==0
end
function c10461.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if re:GetActivateLocation()~=LOCATION_HAND then return end
	if not rc:IsCode(16067089,93217231,80678380) then return end
	Duel.RegisterFlagEffect(rc:GetControler(),rc:GetOriginalCode(),RESET_PHASE+PHASE_END,0,1)
end

--public
function c10461.cfilter(c,tp)
	return c:GetPreviousControler()==tp
		and (c:IsPreviousLocation(LOCATION_DECK) or c:GetSummonLocation()==LOCATION_DECK
			or (c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK))
			or c:IsLocation(LOCATION_DECK)) and not c:IsReason(REASON_DRAW)
end
function c10461.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10461.cfilter,1,nil,tp)
end
function c10461.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()<=1 then return end
	c:RegisterFlagEffect(10461,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1) 
end
function c10461.pubop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(10461)~=0 and Duel.IsExistingMatchingCard(c10461.dafilter,tp,LOCATION_DECK,0,2,nil) then
		local sg=Duel.GetMatchingGroup(c10461.dafilter,tp,LOCATION_DECK,0,nil)
		Duel.ConfirmCards(tp,sg)
	end
end
function c10461.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c10461.dafilter,tp,LOCATION_DECK,0,2,nil) then
		local sg=Duel.GetMatchingGroup(c10461.dafilter,tp,LOCATION_DECK,0,nil)
		Duel.ConfirmCards(tp,sg)
	end
end

--plus effect
function c10461.dafilter(c)
	return c:IsType(TYPE_TRAP) and c:IsCode(16067089,93217231,80678380) 
end
function c10461.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10461.dafilter,c:GetControler(),LOCATION_DECK,LOCATION_DECK,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(10461)==0 then
			local code=tc:GetOriginalCode()
			local ae=tc:GetActivateEffect()
			--deck activate
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_ACTIVATE)
			e1:SetCode(ae:GetCode())
			e1:SetCategory(ae:GetCategory())
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+ae:GetProperty())
			e1:SetRange(LOCATION_DECK)
			e1:SetCountLimit(1,code)
			e1:SetCondition(c10461.sfcon)
			e1:SetTarget(c10461.sftg)
			e1:SetOperation(c10461.sfop)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			--activate cost
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_ACTIVATE_COST)
			e2:SetRange(LOCATION_DECK)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTargetRange(LOCATION_DECK,0)
			e2:SetCost(c10461.costchk)
			e2:SetTarget(c10461.actarget)
			e2:SetOperation(c10461.costop)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(10461,RESET_EVENT+0x1fe0000,0,1) 
		end
		tc=g:GetNext()
	end
end

--deck activate 
function c10461.sfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,10461) and Duel.GetFlagEffect(tp,e:GetHandler():GetOriginalCode())==0
end
function c10461.sftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ae=e:GetHandler():GetActivateEffect()
	local fcon=ae:GetCondition()
	local fcos=ae:GetCost()
	local ftg=ae:GetTarget()
	if chk==0 then
		return (not fcon or fcon(e,tp,eg,ep,ev,re,r,rp))
			and (not fcos or fcos(e,tp,eg,ep,ev,re,r,rp,0))
			and (not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,0))
			and e:GetHandler():IsCode(16067089,93217231,80678380) 
	end
	if fcos then fcos(e,tp,eg,ep,ev,re,r,rp,1) end
	if ftg then ftg(e,tp,eg,ep,ev,re,r,rp,1) end
	if Duel.IsExistingMatchingCard(c10461.dafilter,tp,LOCATION_DECK,0,2,nil) then
		local sg=Duel.GetMatchingGroup(c10461.dafilter,tp,LOCATION_DECK,0,nil)
		Duel.ConfirmCards(tp,sg)
	end
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetOriginalCode(),RESET_PHASE+PHASE_END,0,1)
end
function c10461.sfop(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetHandler():GetActivateEffect()
	local fop=ae:GetOperation()
	if fop then	fop(e,tp,eg,ep,ev,re,r,rp) end
end

--activate field
function c10461.actarget(e,te,tp)
	return te:GetHandler():IsLocation(LOCATION_DECK) and te:GetHandler()==e:GetHandler()
end
function c10461.costchk(e,te_or_c,tp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c10461.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end

--summon check
function c10461.sumcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),10461)==0
end
function c10461.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if not tc:IsRace(RACE_REPTILE) or (tc:IsFacedown() and not Duel.IsPlayerAffectedByEffect(tc:GetSummonPlayer(),10461)) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),10461,RESET_PHASE+PHASE_END,0,1)
		end
	end
end

