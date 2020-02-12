--単一空間
function c10868.initial_effect(c)
	--duel start
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND)
	e1:SetCondition(c10868.chcon)
	e1:SetOperation(c10868.chop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2)
	--cannnot spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(c10868.sumop)
	c:RegisterEffect(e3)
	--cannot activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(aux.chainreg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_FZONE)
	e5:SetOperation(c10868.actop)
	c:RegisterEffect(e5)
	--negate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EVENT_BATTLE_START)
	e6:SetOperation(c10868.attackop)
	c:RegisterEffect(e6)
end

function c10868.chcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==0
end
function c10868.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetOwner()
	if not c:IsLocation(LOCATION_DECK+LOCATION_HAND) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	if g:GetCount()>0 then Duel.SendtoDeck(g,nil,2,REASON_RULE) end
	if c:GetActivateEffect():IsActivatable(tp) and Duel.SelectYesNo(tp,aux.Stringid(10868,0)) then 
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.ShuffleDeck(tp)
		--unaffectable
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_FZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c10868.efilter)
		c:RegisterEffect(e1)
		--cannot set/activate
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SSET)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetRange(LOCATION_FZONE)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c10868.setlimit)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetRange(LOCATION_FZONE)
		e3:SetTargetRange(1,0)
		e3:SetValue(c10868.actlimit)
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CANNOT_ACTIVATE)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetRange(LOCATION_FZONE)
		e4:SetTargetRange(1,1)
		e4:SetValue(c10868.nofilter)
		c:RegisterEffect(e4)
		--cannot disable
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CANNOT_DISABLE)
		c:RegisterEffect(e5)
	else
		Duel.ConfirmCards(1-tp,c)
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(10868,1))
		Duel.Remove(c,POS_FACEDOWN,REASON_RULE)
	end
	if not Duel.IsExistingMatchingCard(c10868.chaosfilter,tp,LOCATION_DECK,LOCATION_DECK,1,nil) then
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.Draw(Duel.GetTurnPlayer(),5,REASON_RULE)
	end
end
function c10868.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c10868.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function c10868.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c10868.nofilter(e,re,tp)
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return (code1==re:GetHandler():IsCode(73468603) or code2==re:GetHandler():IsCode(73468603))
end
function c10868.chaosfilter(c)
	local code1,code2=c:GetOriginalCodeRule()
	return (code1==10468 or code2==10468) or (code1==10470 or code2==10470) or (code1==10868 or code2==10868)
end

function c10868.sumfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c10868.sumop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c10868.sumfilter,nil)
	local tc=g:GetFirst()
	while tc do
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetLabel(code)
		e1:SetTarget(c10868.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		tc=g:GetNext()
	end
end
function c10868.splimit(e,c)
	return c:IsCode(e:GetLabel())
end

function c10868.actfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c10868.actop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local code=rc:GetOriginalCode()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c10868.aclimit)
	e1:SetLabel(code)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	Duel.RegisterEffect(e2,tp)
end
function c10868.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end

function c10868.attackop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local code=tc:GetOriginalCode()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c10868.atktg)
	e1:SetLabel(code)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10868.atktg(e,c)
	return c:IsCode(e:GetLabel())
end
