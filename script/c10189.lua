--多元魔導書廊エトワール
function c10189.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--duel start
	--~ local start_e=Effect.CreateEffect(c)
	--~ start_e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	--~ start_e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--~ start_e:SetCode(EVENT_TO_HAND)
	--~ start_e:SetRange(LOCATION_DECK+LOCATION_HAND)
	--~ start_e:SetCondition(c10189.chcon)
	--~ start_e:SetOperation(c10189.chop)
	--~ c:RegisterEffect(start_e)
	
	
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(c10189.efilter)
	c:RegisterEffect(e1)
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c10189.ctcon)
	e3:SetOperation(c10189.ctop)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsPosition,POS_FACEUP))
	e4:SetValue(c10189.atkval)
	c:RegisterEffect(e4)
	-- defup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsPosition,POS_FACEUP))
	e4:SetValue(c10189.atkval)
	c:RegisterEffect(e4)
	--除外 --> 墓地
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10189,1))
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e5:SetRange(LOCATION_SZONE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCondition(c10189.thcon)
	e5:SetTarget(c10189.thtg)
	e5:SetOperation(c10189.thop)
	c:RegisterEffect(e5)
	
	-- モンスター選択
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(10189,2))
	e9:SetCategory(CATEGORY_RECOVER)
	e9:SetRange(LOCATION_SZONE)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetCondition(c10189.recov_mons_con)
	e9:SetTarget(c10189.recov_mons_tg)
	e9:SetOperation(c10189.recov_mons_op)
	c:RegisterEffect(e9)	
	
	--act in hand
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e6)
	--cannot set
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e7)
	--remove type
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_REMOVE_TYPE)
	e8:SetValue(TYPE_QUICKPLAY)
	c:RegisterEffect(e8)
end

function c10189.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function c10189.ctcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local c=re:GetHandler()
	return c:IsSetCard(0x106e) and e:GetHandler():GetFlagEffect(1)>0
	and re:IsHasType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_IGNITION)
end
function c10189.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1,1)
end
function c10189.atkval(e,c)
	return e:GetHandler():GetCounter(0x1)*100
	-- return e:GetHandler():GetCounter(0x1)*300
end

function c10189.chcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==0
end

function c10189.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetOwner()
	if not c:IsLocation(LOCATION_DECK+LOCATION_HAND) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	if g:GetCount()>0 then Duel.SendtoDeck(g,nil,2,REASON_RULE) end
	if c:GetActivateEffect():IsActivatable(tp) and Duel.SelectYesNo(tp,aux.Stringid(10189,0)) then  
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		--cannot set/activate
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SSET)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_SZONE)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c10189.setlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetRange(LOCATION_SZONE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetValue(c10189.actlimit)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetRange(LOCATION_SZONE)
		e3:SetTargetRange(1,1)
		e3:SetValue(c10189.nofilter)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
		--indes
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_SZONE)
		e4:SetCode(EFFECT_INDESTRUCTABLE)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_CANNOT_REMOVE)
		c:RegisterEffect(e5)
		local e6=e4:Clone()
		e6:SetCode(EFFECT_CANNOT_TO_DECK)
		c:RegisterEffect(e6)
		local e7=e4:Clone()
		e7:SetCode(EFFECT_CANNOT_TO_HAND)
		c:RegisterEffect(e7)
		local e8=e4:Clone()
		e8:SetCode(EFFECT_UNRELEASABLE_SUM)
		c:RegisterEffect(e8)
		local e9=e4:Clone()
		e9:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		c:RegisterEffect(e9)
		local e10=e4:Clone()
		e10:SetCode(EFFECT_CANNOT_TO_GRAVE)
		c:RegisterEffect(e10)

		Duel.RegisterFlagEffect(tp,10189,0,0,0)
		Duel.RegisterFlagEffect(1-tp,10489,0,0,0)
	else
		Duel.Destroy(c,REASON_RULE)
	end
	
	if not Duel.IsExistingMatchingCard(c10189.chaosfilter,tp,LOCATION_DECK,LOCATION_DECK,1,nil) then
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.Draw(Duel.GetTurnPlayer(),5,REASON_RULE)
	end

end

function c10189.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function c10189.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c10189.nofilter(e,re,tp)
	return re:GetHandler():IsCode(73468603)
end

function c10189.chaosfilter(c)
	local code1,code2=c:GetOriginalCodeRule()
	return (code1==10189 or code2==10189) or (code1==10189 or code2==10189) or (code1==10189 or code2==10189)
end

function c10189.tagen_filter(c)
	return c:IsSetCard(0x106e)
end

function c10189.monster_filter(c)
	return c:IsType(TYPE_MONSTER)
end

function c10189.pop_filter(c)
	return c:IsPosition(POS_FACEUP)
end

function c10189.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10189.tagen_filter,tp,LOCATION_REMOVED,0,1,nil)
end

function c10189.filter(c,lv)
	return c:IsLevelBelow(lv) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c10189.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10189.tagen_filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function c10189.thop(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(c10189.tagen_filter, tp, LOCATION_REMOVED, 0, nil)
	local n = g:GetCount()
	if n>0 then
		Duel.SendtoGrave(g,nil,REASON_EFFECT)
		e:GetHandler():AddCounter(0x1,n)
		Duel.Recover(tp, n*500, REASON_EFFECT)
	end
end

function c10189.recov_mons_con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x1)
	return ct>0
end

function c10189.recov_mons_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10189.pop_filter,tp,LOCATION_MZONE, LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,1,tp,LOCATION_MZONE)
end

function c10189.recov_mons_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g = Duel.SelectMatchingCard(tp,c10189.monster_filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Recover(tp, g:GetFirst():GetAttack() + g:GetFirst():GetDefense(), REASON_EFFECT)
		Duel.RemoveCounter(tp,1,0,0x1,1,REASON_EFFECT)
end
