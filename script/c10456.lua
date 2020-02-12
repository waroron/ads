--多元魔導書の円環
function c10456.initial_effect(c)
	c:EnableCounterPermit(0x1)
	c:SetUniqueOnField(1,0,10456)
	
	
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(c10456.efilter)
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
	e3:SetCondition(c10456.ctcon)
	e3:SetOperation(c10456.ctop)
	c:RegisterEffect(e3)		

	-- 手札 --> デッキ
	local eenh_=Effect.CreateEffect(c)
	eenh_:SetDescription(aux.Stringid(10456,5))
	eenh_:SetCategory(CATEGORY_REMOVE)
	eenh_:SetType(EFFECT_TYPE_QUICK_O)
	eenh_:SetRange(LOCATION_SZONE)
	eenh_:SetCode(EVENT_FREE_CHAIN)
	eenh_:SetCondition(c10456.enh_con)
	eenh_:SetTarget(c10456.enh_tg)
	eenh_:SetOperation(c10456.enh_op)
	c:RegisterEffect(eenh_)		
	
	
	-- 月の書
	local etuki=Effect.CreateEffect(c)
	etuki:SetDescription(aux.Stringid(10456,0))
	etuki:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	etuki:SetType(EFFECT_TYPE_QUICK_O)
	etuki:SetRange(LOCATION_SZONE)
	etuki:SetCode(EVENT_FREE_CHAIN)
	etuki:SetCondition(c10456.tukicon)
	etuki:SetTarget(c10456.tukitg)
	etuki:SetOperation(c10456.tukiop)
	c:RegisterEffect(etuki)
	
	-- ハンデス
	local ehandeath=Effect.CreateEffect(c)
	ehandeath:SetDescription(aux.Stringid(10456,1))
	ehandeath:SetCategory(CATEGORY_REMOVE)
	ehandeath:SetType(EFFECT_TYPE_QUICK_O)
	ehandeath:SetRange(LOCATION_SZONE)
	ehandeath:SetCode(EVENT_FREE_CHAIN)
	ehandeath:SetCondition(c10456.handeathcon)
	ehandeath:SetTarget(c10456.handeathtg)
	ehandeath:SetOperation(c10456.handeathop)
	c:RegisterEffect(ehandeath)	
	
	-- デッキ除外
	local eremoval_=Effect.CreateEffect(c)
	eremoval_:SetDescription(aux.Stringid(10456,2))
	eremoval_:SetCategory(CATEGORY_REMOVE)
	eremoval_:SetType(EFFECT_TYPE_QUICK_O)
	eremoval_:SetRange(LOCATION_SZONE)
	eremoval_:SetCode(EVENT_FREE_CHAIN)
	eremoval_:SetCondition(c10456.removal_con)
	eremoval_:SetTarget(c10456.removal_tg)
	eremoval_:SetOperation(c10456.removal_op)
	c:RegisterEffect(eremoval_)	
	
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e2)
	--cannot set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e3)
	--remove type
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_REMOVE_TYPE)
	e4:SetValue(TYPE_QUICKPLAY)
	c:RegisterEffect(e4)

end

function c10456.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function c10456.ctcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local c=re:GetHandler()
	return c:IsSetCard(0x106e) and e:GetHandler():GetFlagEffect(1)>0 
	and re:IsHasType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_IGNITION)
end

function c10456.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1,1)
end
	
function c10456.tukicon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x1)
	return ct>0
end

function c10456.pop_filter(c)
	return c:IsPosition(POS_FACEUP)
end

function c10456.tukitg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=Duel.IsExistingMatchingCard(c10456.pop_filter,tp,0,LOCATION_MZONE,1,nil)

	e:SetCategory(0)
	if chk==0 then return b end

	local g=Duel.GetMatchingGroup(c10456.pop_filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function c10456.tukiop(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(c10456.pop_filter, tp, 0, LOCATION_MZONE, nil)
	local n = g:GetCount()
	if n>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end

function c10456.handeathcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCounter(tp, 1, 0, 0x1) > 1
end

function c10456.handeathtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
	e:SetCategory(0)
	if chk==0 then return b end

	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	-- Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,LOCATION_HAND)
	-- Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end

function c10456.handeathop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)

	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,1,1,nil)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		Duel.ShuffleHand(1-p)
	end
end

function c10456.removal_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsCanRemoveCounter(tp,1,0,0x1,3,REASON_EFFECT)
end

function c10456.removal_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1 = Duel.GetFieldGroupCount(tp,0,LOCATION_DECK) 
	local b2 = Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)
	e:SetCategory(0)
	if chk==0 then return (b1 > 0 or b2 > 0) end
	
	local c=e:GetHandler()
	-- local n_max=c:GetCounter(0x1)
	local n_max = Duel.GetCounter(tp, 1, 0, 0x1)
	
	local lvt={}
	if b1 < b2 then b1 = b2 end
	if n_max > b1 then n_max = b1 end
	for i=3,n_max do
		-- lvt[i] = i
		table.insert(lvt, i)
		Debug.Message(tostring(i))
	end
	Debug.Message(tostring(sum_c))
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10456,3))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.RemoveCounter(tp,1,0,0x1,lv,REASON_EFFECT)
	e:SetLabel(lv)	

	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK+LOCATION_EXTRA,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end

function c10456.removal_op(e,tp,eg,ep,ev,re,r,rp)
	local lv = e:GetLabel()
	local n_extra = Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)
	Debug.Message(tostring(n_extra))
	Debug.Message(tostring(lv))
	local n_deck = Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	
	if lv > n_extra then
		local cards = Duel.GetDecktopGroup(1-tp, lv)
		Duel.Remove(cards, POS_FACEDOWN, REASON_EFFECT)
	else
		if  Duel.SelectYesNo(tp,aux.Stringid(10456,4)) then
			-- deck
			local cards = Duel.GetDecktopGroup(1-tp, lv)
			Duel.Remove(cards, POS_FACEDOWN, REASON_EFFECT)
		else
			-- extra
			local cards = Duel.GetFieldGroup(tp, 0, LOCATION_EXTRA, nil)
			local tc=cards:GetFirst()
			for i=1,lv do
				Duel.Remove(tc, POS_FACEDOWN, REASON_EFFECT)
				tc = cards:GetNext()
			end
			
		end
	end
end


function c10456.enh_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0) > 0
end

function c10456.enh_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0) > 0
	e:SetCategory(0)
	if chk==0 then return b end

	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

function c10456.enh_op(e,tp,eg,ep,ev,re,r,rp)
	local n_max = Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,n_max,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2, REASON_EFFECT)
		e:GetHandler():AddCounter(0x1,2*g:GetCount())
	end
end

