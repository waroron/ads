--混沌(エラッタ前)
function c10470.initial_effect(c)
	--duel start
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND)
	e1:SetCondition(c10470.chcon)
	e1:SetOperation(c10470.chop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2)
end

function c10470.chcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==0
end
function c10470.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetOwner()
	if not c:IsLocation(LOCATION_DECK+LOCATION_HAND) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	if g:GetCount()>0 then Duel.SendtoDeck(g,nil,2,REASON_RULE) end
--	Duel.ShuffleDeck(Duel.GetTurnPlayer())
	if c:GetActivateEffect():IsActivatable(tp) and Duel.SelectYesNo(tp,aux.Stringid(10470,0)) then  
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
--		Duel.ShuffleDeck(tp)
		--cannot set/activate
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SSET)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_FZONE)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c10470.setlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetRange(LOCATION_FZONE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetValue(c10470.actlimit)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetRange(LOCATION_FZONE)
		e3:SetTargetRange(1,1)
		e3:SetValue(c10470.nofilter)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
		--indes
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_FZONE)
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
		--chage name
		local e0=Effect.CreateEffect(c)
		e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY+EFFECT_FLAG_SET_AVAILABLE)
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(EFFECT_CHANGE_CODE)
		e0:SetRange(LOCATION_FZONE)
		e0:SetTargetRange(0xff,0xff)
		e0:SetValue(10470)
		c:RegisterEffect(e0)
		Duel.RegisterFlagEffect(tp,10469,0,0,0)
		Duel.RegisterFlagEffect(1-tp,10469,0,0,0)
	else
		Duel.Destroy(c,REASON_RULE)
	end
	if not Duel.IsExistingMatchingCard(c10470.chaosfilter,tp,LOCATION_DECK,LOCATION_DECK,1,nil) then
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.Draw(Duel.GetTurnPlayer(),5,REASON_RULE)
	end
end
function c10470.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c10470.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function c10470.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c10470.nofilter(e,re,tp)
	return re:GetHandler():IsCode(73468603)
end
function c10470.chaosfilter(c)
	local code1,code2=c:GetOriginalCodeRule()
	return (code1==10468 or code2==10468) or (code1==10470 or code2==10470) or (code1==10868 or code2==10868)
end
