--混沌
function c10468.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10468.actcost)
	e1:SetTarget(c10468.target)
	c:RegisterEffect(e1)
	--duel start
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_DECK+LOCATION_HAND)
	e2:SetCondition(c10468.chcon)
	e2:SetOperation(c10468.chop)
	c:RegisterEffect(e2)
end

function c10468.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10468)==0 end
	Duel.RegisterFlagEffect(tp,10468,0,0,0)
end
function c10468.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetLabel(0)
	e1:SetCountLimit(1)
	e1:SetCondition(c10468.tgcon)
	e1:SetOperation(c10468.tgop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	e:GetHandler():RegisterEffect(e1)
end
function c10468.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c10468.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	ct=ct+1
	e:SetLabel(ct)
	if ct<=3 then e:GetHandler():SetTurnCounter(ct) end
	if ct==3 then
		--search & destroy
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(10468,1))
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_FZONE)
		e1:SetCountLimit(1)
		e1:SetTarget(c10468.destg)
		e1:SetOperation(c10468.desop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

function c10468.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c10468.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.SetLP(tp,4000)
	local dc=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if Duel.GetLP(tp)<Duel.GetLP(1-tp) and dc>1 and Duel.SelectYesNo(tp,aux.Stringid(10468,2)) then
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)
			Duel.ConfirmDecktop(tp,1)
		end
	end
end


function c10468.chcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==0
end
function c10468.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetOwner()
	if not c:IsLocation(LOCATION_DECK+LOCATION_HAND) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	if g:GetCount()>0 then Duel.SendtoDeck(g,nil,2,REASON_RULE) end
	if not Duel.IsExistingMatchingCard(c10468.chaosfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and c:GetActivateEffect():IsActivatable(tp) and Duel.SelectYesNo(tp,aux.Stringid(10468,0)) then  
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		c:RegisterFlagEffect(10468,RESET_EVENT+0x1fe0000,0,1)
		--cannot activate
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetRange(LOCATION_FZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(1,0)
		e1:SetCondition(c10468.negcon)
		e1:SetValue(c10468.actlimit)
		Duel.RegisterEffect(e1,tp)
		--cannot set
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SSET)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetRange(LOCATION_SZONE)
		e2:SetTargetRange(1,0)
		e2:SetCondition(c10468.negcon)
		e2:SetTarget(c10468.setlimit)
		e2:SetValue(c10468.actlimit)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetRange(LOCATION_SZONE)
		e3:SetTargetRange(1,1)
		e3:SetCondition(c10468.negcon)
		e3:SetValue(c10468.nofilter)
		Duel.RegisterEffect(e3,tp)
		--indes
		local e4=Effect.CreateEffect(c)
		e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetTargetRange(LOCATION_SZONE,0)
		e4:SetTarget(c10468.indtg)
		e4:SetCondition(c10468.negcon)
		e4:SetCode(EFFECT_INDESTRUCTABLE)
		e4:SetValue(1)
		Duel.RegisterEffect(e4,tp)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_CANNOT_REMOVE)
		Duel.RegisterEffect(e5,tp)
		local e6=e4:Clone()
		e6:SetCode(EFFECT_CANNOT_TO_DECK)
		Duel.RegisterEffect(e6,tp)
		local e7=e4:Clone()
		e7:SetCode(EFFECT_CANNOT_TO_HAND)
		Duel.RegisterEffect(e7,tp)
		local e8=e4:Clone()
		e8:SetCode(EFFECT_UNRELEASABLE_SUM)
		Duel.RegisterEffect(e8,tp)
		local e9=e4:Clone()
		e9:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		Duel.RegisterEffect(e9,tp)
		local e10=e4:Clone()
		e10:SetCode(EFFECT_CANNOT_TO_GRAVE)
		Duel.RegisterEffect(e10,tp)
		--chage name
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetRange(LOCATION_FZONE)
		e1:SetTargetRange(0xff,0xff)
		e1:SetValue(10468)
		c:RegisterEffect(e1)
		Duel.RegisterFlagEffect(tp,10469,0,0,0)
		Duel.RegisterFlagEffect(1-tp,10469,0,0,0)
	else
		Duel.Destroy(c,REASON_RULE)
	end
	if not Duel.IsExistingMatchingCard(c10468.chaosfilter,tp,LOCATION_DECK,LOCATION_DECK,1,nil) then
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.Draw(Duel.GetTurnPlayer(),5,REASON_RULE)
	end
end
function c10468.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown()
end
function c10468.indtg(e,c)
	return c:IsCode(10468) and c:IsFacedown() and c:IsType(TYPE_FIELD) and c:GetFlagEffect(10468)~=0
end
function c10468.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and not re:GetHandler():IsCode(10468)
end
function c10468.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function c10468.nofilter(e,re,tp)
	return re:GetHandler():IsCode(73468603)
end
function c10468.chaosfilter(c)
	local code1,code2=c:GetOriginalCodeRule()
	return (code1==10468 or code2==10468) or (code1==10470 or code2==10470) or (code1==10868 or code2==10868)
end
