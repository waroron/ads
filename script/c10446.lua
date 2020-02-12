--混沌の禁断魔導陣
function c10446.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c10446.activate)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c10446.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--copy spell/trap
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10446,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,10446)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c10446.stcon)
	e3:SetTarget(c10446.sttg)
	e3:SetOperation(c10446.stop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10446,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,10446)
	e4:SetCondition(c10446.stcon)
	e4:SetTarget(c10446.sttg2)
	e4:SetOperation(c10446.stop)
	c:RegisterEffect(e4)
end
c10446.card_code_list={46986414}
function c10446.filter(c)
	return aux.IsCodeListed(c,46986414) and c:IsSSetable() and not c:IsCode(10446)
end
function c10446.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local ac=Duel.GetMatchingGroupCount(c10446.filter,tp,LOCATION_DECK,0,nil)
	local sc=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local hc=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if not (sc<=0 or hc~=0 or ac<=0) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(10446,2)) then return end
	local mc=0
	local g=Duel.GetMatchingGroup(c10446.filter,tp,LOCATION_DECK,0,nil)
	local gt=g:GetClassCount(Card.GetCode)
	if gt>=sc then mc=sc else mc=gt end
	local ct=Duel.DiscardHand(tp,aux.TRUE,1,mc,REASON_DISCARD+REASON_EFFECT)
	local tg=Group.CreateGroup()
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10446,0))
		local sg=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
		tg:Merge(sg)
	end
	local tc=tg:GetFirst()
	while tc do
		Duel.SSet(tp,tc)
		tc:SetStatus(STATUS_SET_TURN,false) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(10446,RESET_EVENT+0x1fe0000,0,1)
		tc=tg:GetNext()
	end
	Duel.ConfirmCards(1-tp,tg)
end

function c10446.indtg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and e:GetHandler()~=c
end

function c10446.cfilter(c)
	return c:IsFaceup() and c:IsCode(46986414)
end
function c10446.stcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10446.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end

--[[
function c10446.stfilter(c,tp,eg,ep,ev,re,r,rp)
	local te=c:GetActivateEffect()
	if not te then return false end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	local op=te:GetOperation()
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(10446)
		and (not condition or condition(te,tp,eg,ep,ev,re,r,rp)) and (not cost or cost(te,tp,eg,ep,ev,re,r,rp,0))
		and (not target or target(te,tp,eg,ep,ev,re,r,rp,0)) and op and c:IsAbleToGraveAsCost()
end
]]

function c10446.sefilter(c,tp)
	local te=c:GetActivateEffect()
	if not te then return false end
	local op=te:GetOperation()
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(10446) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(false,false,false)~=nil and op and c:GetActivateEffect():IsActivatable(tp)
end
function c10446.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10446.sefilter,tp,LOCATION_DECK,0,1,nil,tp)
		and not Duel.CheckEvent(EVENT_CHAINING) end
	local g=Duel.SelectMatchingCard(tp,c10446.sefilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,false,false)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local fcos=te:GetCost()
	local tg=te:GetTarget()
	if fcos then fcos(e,tp,eg,ep,ev,re,r,rp,chk) end
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function c10446.stop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

function c10446.sefilter2(c,e,tp,eg,ep,ev,re,r,rp)
	if c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(10446) and c:IsAbleToGraveAsCost() and c:GetActivateEffect():IsActivatable(tp) then
		if c:CheckActivateEffect(false,false,false)~=nil then return true end
		local te=c:GetActivateEffect()
		local op=te:GetOperation()
		if not op then return false end
		if te:GetCode()~=EVENT_CHAINING then return false end
		local con=te:GetCondition()
		if con and not con(e,tp,eg,ep,ev,re,r,rp) then return false end
		local cost=te:GetCost()
		if cost and not cost(te,tp,eg,ep,ev,re,r,rp,0) then return false end
		local tg=te:GetTarget()
		if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
		return true
	else return false end
end
function c10446.sttg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10446.sefilter2,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10446.sefilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	local tc=g:GetFirst()
	local te,ceg,cep,cev,cre,cr,crp
	local fchain=c10446.sefilter(tc)
	if fchain then
		te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,false,false)
	else
		te=tc:GetActivateEffect()
	end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	local fcos=te:GetCost()
	if fcos then fcos(e,tp,eg,ep,ev,re,r,rp,chk) end
	if tg then
		if fchain then
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		else
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
