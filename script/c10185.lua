--多元魔導書院ラメイソン
function c10185.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--duel start
	local start_e=Effect.CreateEffect(c)
	start_e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	start_e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	start_e:SetCode(EVENT_TO_HAND)
	start_e:SetRange(LOCATION_DECK+LOCATION_HAND)
	start_e:SetCondition(c10185.chcon)
	start_e:SetOperation(c10185.chop)
	c:RegisterEffect(start_e)
	
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetValue(c10185.efilter)
	c:RegisterEffect(e1)
	
	--Add counter
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetCode(EVENT_CHAINING)
	e9:SetRange(LOCATION_SZONE)
	e9:SetOperation(aux.chainreg)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e10:SetCode(EVENT_CHAIN_SOLVED)
	e10:SetRange(LOCATION_SZONE)
	e10:SetCondition(c10185.ctcon)
	e10:SetOperation(c10185.ctop)
	c:RegisterEffect(e10)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	-- 墓地 --> デッキ
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10185,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c10185.drcon)
	e3:SetTarget(c10185.drtg)
	e3:SetOperation(c10185.drop)
	c:RegisterEffect(e3)
	
	-- 枚数制限
	--~ local e7=Effect.CreateEffect(c)
	--~ e7:SetType(EFFECT_TYPE_FIELD)
	--~ e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--~ e7:SetCode(EVENT_HAND_LIMIT)
	--~ e7:SetCondition(c10185.handcon)
	--~ e7:SetRange(LOCATION_SZONE)
	--~ e7.SetTargetRange(1,1)
	--~ e7:SetValue(10)
	--~ c:RegisterEffect(e7)
	
	-- カウンター 墓地と手札
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(10185,2))
	e8:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e8:SetRange(LOCATION_SZONE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetCondition(c10185.excon)
	e8:SetTarget(c10185.extg)
	e8:SetOperation(c10185.exop)
	c:RegisterEffect(e8)
	
	-- カウンター サルベージ
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(10185,3))
	e11:SetCategory(CATEGORY_TOHAND)
	e11:SetRange(LOCATION_SZONE)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetCondition(c10185.salcon)
	e11:SetTarget(c10185.saltg)
	e11:SetOperation(c10185.salop)
	c:RegisterEffect(e11)
	
	-- カウンター サーチ
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(10185,4))
	e12:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetCondition(c10185.searchcon)
	e12:SetTarget(c10185.searchtg)
	e12:SetOperation(c10185.searchop)
	c:RegisterEffect(e12)
	
	-- カウンター コントロール
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(10185,5))
	e13:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL)
	e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e13:SetRange(LOCATION_SZONE)
	e13:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e13:SetCode(EVENT_FREE_CHAIN)
	e13:SetCondition(c10185.depcon)
	e13:SetTarget(c10185.deptg)
	e13:SetOperation(c10185.depop)
	c:RegisterEffect(e13)
	
	--act in hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e4)
	--cannot set
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e5)
	--remove type
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_REMOVE_TYPE)
	e6:SetValue(TYPE_QUICKPLAY)
	c:RegisterEffect(e6)
end

function c10185.ctcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local c=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_IGNITION) and c:IsSetCard(0x106e) and e:GetHandler():GetFlagEffect(1)>0
end
function c10185.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1,1)
end

function c10185.cfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c10185.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10185.tagen_filter,tp,LOCATION_GRAVE,0,1,nil)
end
function c10185.filter(c)
	return c:IsSetCard(0x106e) and c:IsAbleToDeck()
end

function c10185.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c10185.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function c10185.drop(e,tp,eg,ep,ev,re,r,rp)
		--local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	--Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	--local g=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,1,63,nil)
	--if g:GetCount()==0 then return end
	--Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	--Duel.ShuffleDeck(p)
	--Duel.BreakEffect()
	--Duel.Draw(p,g:GetCount(),REASON_EFFECT)

	if not e:GetHandler():IsRelateToEffect(e) then return end
	-- Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	-- local g=Duel.SelectMatchingCard(tp,c10185.filter,tp,LOCATION_GRAVE,0,1,63,nil)
	g = Duel.GetMatchingGroup(c10185.tagen_filter, tp, LOCATION_GRAVE, 0, nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(tp)
		Duel.ConfirmCards(1-tp,g)
			e:GetHandler():AddCounter(0x1,g:GetCount())
		Duel.Draw(tp,g:GetCount(),REASON_EFFECT)
	end
end

function c10185.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function c10185.excon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsCanRemoveCounter(tp,1,0,0x1,1,REASON_EFFECT)
end

function c10185.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b= Duel.IsExistingMatchingCard(c10185.tagen_filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c10185.tagen_filter,tp,LOCATION_HAND,0,1,nil)

	e:SetCategory(0)
	if chk==0 then return b end

	local g=Duel.GetMatchingGroup(c10185.tagen_filter,tp,LOCATION_HAND,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	local g=Duel.GetMatchingGroup(c10185.tagen_filter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function c10185.exop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local h=Duel.SelectMatchingCard(tp,c10185.tagen_filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectMatchingCard(tp,c10185.tagen_filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and h:GetCount()>0 then
			Duel.RemoveCounter(tp,1,0,0x1,1,REASON_EFFECT)
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.SendtoGrave(h, nil, REASON_EFFECT)
	end
end
	
function c10185.salcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsCanRemoveCounter(tp,1,0,0x1,2,REASON_EFFECT)
end

function c10185.saltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=Duel.IsExistingMatchingCard(c10185.tagen_filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)

	e:SetCategory(0)
	if chk==0 then return b end

	local g=Duel.GetMatchingGroup(c10185.tagen_filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function c10185.salop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectMatchingCard(tp,c10185.tagen_filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.RemoveCounter(tp,1,0,0x1,2,REASON_EFFECT)
		Duel.SendtoHand(g, nil, REASON_EFFECT)
	end
end
	
function c10185.searchcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsCanRemoveCounter(tp,1,0,0x1,3,REASON_EFFECT)
end

function c10185.searchtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=Duel.IsExistingMatchingCard(c10185.tagen_filter,tp,LOCATION_DECK,0,1,nil)

	e:SetCategory(0)
	if chk==0 then return b end

	local g=Duel.GetMatchingGroup(c10185.tagen_filter,tp,0,LOCATION_DECK,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function c10185.searchop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10185.tagen_filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.RemoveCounter(tp,1,0,0x1,3,REASON_EFFECT)
	end
end

function c10185.depcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsCanRemoveCounter(tp,1,0,0x1,4,REASON_EFFECT)
end

function c10185.deptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=Duel.IsExistingMatchingCard(c10185.monster_filter,tp,0,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA,1,nil)

	e:SetCategory(0)
	if chk==0 then return b end

	-- Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	-- local g = Duel.SelectMatchingCard(tp,c10185.monster_filter,tp,0,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,b,1,0,0)
end

function c10185.depop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	Duel.ConfirmCards(p,g)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp,c10185.monster_filter,tp,0,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA,1,1,nil)
	Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	Duel.RemoveCounter(tp,1,0,0x1,4,REASON_EFFECT)

	--~ local tc=Duel.GetFirstTarget()
	--~ if tc:IsRelateToEffect(e) then
		--~ Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		--~ Duel.RemoveCounter(tp,1,0,0x1,4,REASON_EFFECT)
	--~ end
end

function c10185.handcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x1)>5
end

function c10185.tagen_filter(c)
	return c:IsSetCard(0x106e)
end
function c10185.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10185.monster_filter(c)
	return c:IsType(TYPE_MONSTER)
end

function c10185.ctfilter(c)
	return c:IsSetCard(0x106e) and c:IsType(TYPE_SPELL)
end


function c10185.chcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==0
end

function c10185.isetw(c)
	return c:IsCode(10189)
end

function c10185.iscir(c)
	return c:IsCode(10456)
end

function c10185.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetOwner()
	if not c:IsLocation(LOCATION_DECK+LOCATION_HAND) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	if g:GetCount()>0 then Duel.SendtoDeck(g,nil,2,REASON_RULE) end
	if c:GetActivateEffect():IsActivatable(tp) and Duel.SelectYesNo(tp,aux.Stringid(10185,0)) then  
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		
		etw = Duel.GetFirstMatchingCard(c10185.isetw, tp, LOCATION_DECK, 0 ,nil)
		Duel.MoveToField(etw,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		
		cir = Duel.GetFirstMatchingCard(c10185.iscir, tp, LOCATION_DECK, 0 ,nil)
		Duel.MoveToField(cir,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		
		--cannot set/activate
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SSET)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_FZONE)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c10185.setlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetRange(LOCATION_FZONE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetValue(c10185.actlimit)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetRange(LOCATION_FZONE)
		e3:SetTargetRange(1,1)
		e3:SetValue(c10185.nofilter)
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
		local e11=e4:Clone()
		e11:SetCode(EFFECT_UNRELEASABLE_EFFECT)
		c:RegisterEffect(e11)

		Duel.RegisterFlagEffect(tp,10185,0,0,0)
		Duel.RegisterFlagEffect(1-tp,10185,0,0,0)
	else
		Duel.Destroy(c,REASON_RULE)
	end
	
	if not Duel.IsExistingMatchingCard(c10185.chaosfilter,tp,LOCATION_DECK,LOCATION_DECK,1,nil) then
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.Draw(Duel.GetTurnPlayer(),5,REASON_RULE)
	end

end

function c10185.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function c10185.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c10185.nofilter(e,re,tp)
	return re:GetHandler():IsCode(73468603)
end

function c10185.chaosfilter(c)
	local code1,code2=c:GetOriginalCodeRule()
	return (code1==10185 or code2==10185) or (code1==10185 or code2==10185) or (code1==10185 or code2==10185)
end
