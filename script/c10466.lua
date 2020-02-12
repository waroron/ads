--真竜剣の解放
function c10466.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10466.target)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c10466.chainop)
	c:RegisterEffect(e2)
	--tribute summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10466,0))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,10466)
	e3:SetCondition(c10466.sumcon)
	e3:SetTarget(c10466.sumtg)
	e3:SetOperation(c10466.sumop)
	c:RegisterEffect(e3)
	--search & destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10466,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,10467)
	e4:SetCondition(c10466.thcon)
	e4:SetTarget(c10466.thtg)
	e4:SetOperation(c10466.thop)
	c:RegisterEffect(e4)
	--act in hand
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e5:SetCondition(c10466.handcon)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_REMOVE_TYPE)
	e6:SetValue(TYPE_QUICKPLAY)
	c:RegisterEffect(e6)
	if c10466.counter==nil then
		c10466.counter=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c10466.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c10466.clearop)
		Duel.RegisterEffect(ge2,0)
	end
end

--activate
function c10466.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ph=Duel.GetCurrentPhase()
	if chk==0 then return true end
	if (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.IsExistingMatchingCard(c10466.sumfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.GetFlagEffect(tp,10466)==0 and Duel.SelectYesNo(tp,aux.Stringid(10466,4)) then
		e:SetCategory(CATEGORY_SUMMON)
		e:SetOperation(c10466.sumop)
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
		Duel.RegisterFlagEffect(tp,10466,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(10466,0))
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end 
end

--act limit
function c10466.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsSetCard(0xf9) then
		Duel.SetChainLimit(c10466.chainlm)
	end
end
function c10466.chainlm(e,rp,tp)
	return tp==rp
end

--tribute summon
function c10466.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c10466.sumfilter(c)
	return c:IsSetCard(0xf9) and c:IsSummonable(true,nil,1)
end
function c10466.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10466.sumfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.GetFlagEffect(tp,10466)==0 end
	Duel.RegisterFlagEffect(tp,10466,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c10466.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c10466.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,1)
	end
end

--search & destroy
function c10466.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function c10466.thfilter(c,tp)
	return c:IsSetCard(0xf9) and (c:GetType()==0x20004 or c:GetType()==0x20002) and not c:IsCode(10466)
		and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function c10466.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10466.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10466.mpfilter(c)
	return c:IsFaceup() and c:IsCode(21377582)
end
function c10466.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10466.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:GetActivateEffect():IsActivatable(tp) or Duel.SelectYesNo(tp,aux.Stringid(10466,2))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,tc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
		end
		--destroy
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		if Duel.IsExistingMatchingCard(c10466.mpfilter,tp,LOCATION_MZONE,0,1,nil) and sg:GetCount()>0
			and Duel.SelectYesNo(tp,aux.Stringid(10466,3)) then
			Duel.BreakEffect()
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end

--act in hand
function c10466.handcon(e)
	local ph=Duel.GetCurrentPhase()
	local tp=e:GetHandler():GetControler()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()==0
end


--change script
local st=Effect.SetTarget
Effect.SetTarget=function(e,tg)
	if e:GetDescription()==aux.Stringid(58984738,1) or e:GetDescription()==aux.Stringid(22499034,1) then
		return st(e,c10466.tg)
	else
		return st(e,tg)
	end
end
local so=Effect.SetOperation
Effect.SetOperation=function(e,op)
	if e:GetDescription()==aux.Stringid(58984738,1) or e:GetDescription()==aux.Stringid(22499034,1) then
		return so(e,c10466.op)
	else
		return so(e,op)
	end
end

function c10466.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if c:GetOriginalCode()==58984738 then
		if chk==0 then return Duel.IsExistingMatchingCard(c10466.filter1,tp,LOCATION_DECK,0,1,nil,tp) end
	else
		if chk==0 then return Duel.IsExistingMatchingCard(c10466.filter2,tp,LOCATION_DECK,0,1,nil,tp) end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10466.filter1(c,tp)
	return c:IsSetCard(0xf9) and (c:GetType()==0x20004 or c:IsCode(10466))
		and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function c10466.filter2(c,tp)
	return c:IsSetCard(0xf9) and (c:GetType()==0x20002 or c:IsCode(10466))
		and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function c10466.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(58984738,3))
	if c:GetOriginalCode()==58984738 then
		g=Duel.SelectMatchingCard(tp,c10466.filter1,tp,LOCATION_DECK,0,1,1,nil,tp)
	else
		g=Duel.SelectMatchingCard(tp,c10466.filter2,tp,LOCATION_DECK,0,1,1,nil,tp)
	end
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:GetActivateEffect():IsActivatable(tp)
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(58984738,2))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
end

function c10466.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousLocation(LOCATION_ONFIELD) and tc:IsSetCard(0xf9) then
			local typ=bit.band(tc:GetOriginalType(),0x7)
			if tc:GetOriginalCode()==10466 and Duel.GetFlagEffect(0,49430783)==0 then
				c49430782.counter=c49430782.counter+1
				Duel.RegisterFlagEffect(0,49430783,RESET_PHASE+PHASE_END,0,1)
			end
			if tc:GetOriginalCode()==10466 and Duel.GetFlagEffect(0,49430784)==0 then
				c49430782.counter=c49430782.counter+1
				Duel.RegisterFlagEffect(0,49430784,RESET_PHASE+PHASE_END,0,1)
			end
				if (typ==TYPE_MONSTER and Duel.GetFlagEffect(0,49430782)==0)
					or (typ==TYPE_SPELL and Duel.GetFlagEffect(0,49430783)==0)
					or (typ==TYPE_TRAP and Duel.GetFlagEffect(0,49430784)==0) then
				c49430782.counter=c49430782.counter+1
				if typ==TYPE_MONSTER then
					Duel.RegisterFlagEffect(0,49430782,RESET_PHASE+PHASE_END,0,1)
				elseif typ==TYPE_SPELL then
					Duel.RegisterFlagEffect(0,49430783,RESET_PHASE+PHASE_END,0,1)
				else
					Duel.RegisterFlagEffect(0,49430784,RESET_PHASE+PHASE_END,0,1)
				end
			end
		end
		tc=eg:GetNext()
	end
end

--[[
local ist=Card.IsSetCard
Card.IsSetCard=function(card,category)
	return true
end
local co=Effect.SetCountLimit
Effect.SetCountLimit=function(effect,count,code)
	return co(effect,99999,code)
end

local sv=Effect.SetValue
Effect.SetValue=function(effect,value)
	return sv(effect,0)
end
]]

