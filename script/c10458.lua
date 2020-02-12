--極光の宣告者
function c10458.initial_effect(c)
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_DECK)	
	e1:SetOperation(c10458.op)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10458,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c10458.thtg)
	e2:SetOperation(c10458.tgop)
	c:RegisterEffect(e2)
	--revive 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10458,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,10460)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c10458.spcost)
	e3:SetTarget(c10458.sptg)
	e3:SetOperation(c10458.spop)
	c:RegisterEffect(e3)
end

function c10458.filterx(c)
	return c:IsCode(17266660) or c:IsCode(21074344) or c:IsCode(94689635) or c:IsCode(44665365) or c:IsCode(48546368)
	--     monster                 magic                trap                RITUAL
end
function c10458.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10458.filterx,c:GetControler(),LOCATION_HAND+LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(10458)==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(10458,0))
			e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetCode(EVENT_CHAINING)
			e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
			if not tc:IsType(TYPE_RITUAL) then
				e1:SetRange(LOCATION_HAND)
				e1:SetCost(c10458.discost)
			else
				e1:SetRange(LOCATION_MZONE)
				e1:SetCost(c10458.discost2)
			end
			e1:SetCondition(c10458.discon)
			e1:SetTarget(c10458.distg)
			e1:SetOperation(c10458.disop)
			e1:SetReset(RESET_EVENT+0x1fe0000,1)
			tc:RegisterEffect(e1)
			--disable spsummon
			if tc:IsCode(48546368) then
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(aux.Stringid(10458,0))
				e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
				e2:SetType(EFFECT_TYPE_QUICK_O)
				e2:SetRange(LOCATION_MZONE)
				e2:SetCode(EVENT_SPSUMMON)
				e2:SetCondition(c10458.discon2)
				e2:SetCost(c10458.discost2)
				e2:SetTarget(c10458.distg2)
				e2:SetOperation(c10458.disop2)
				tc:RegisterEffect(e2)
			end
			tc:RegisterFlagEffect(10458,RESET_EVENT+0x1fe0000,0,1)
		end
		tc=g:GetNext()
	end
end

function c10458.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsCode(17266660) then
		return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
	elseif c:IsCode(21074344) then
		return ep~=tp and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
	elseif c:IsCode(94689635) then
		return ep~=tp and re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
	elseif c:IsType(TYPE_RITUAL) then
		if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
		return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
	else
		return false
	end
end
function c10458.costfilter(c)
	return c:IsCode(10458) and c:IsAbleToGraveAsCost()
end
function c10458.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sg=Group.CreateGroup()
	if chk==0 then return c:IsAbleToGraveAsCost() 
		and Duel.IsExistingMatchingCard(c10458.costfilter,tp,LOCATION_DECK,0,1,nil) end
	local tc=Duel.GetFirstMatchingCard(c10458.costfilter,tp,LOCATION_DECK,0,nil)
	sg:AddCard(tc)
	sg:AddCard(c)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c10458.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10458)==0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.RegisterFlagEffect(tp,10458,RESET_PHASE+PHASE_END,0,1)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c10458.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

function c10458.filter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c10458.discon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(c10458.filter,1,nil,1-tp)
end
function c10458.discost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10458.costfilter,tp,LOCATION_DECK,0,1,nil) end
	local tc=Duel.GetFirstMatchingCard(c10458.costfilter,tp,LOCATION_DECK,0,nil)
	Duel.SendtoGrave(tc,REASON_COST)
end
function c10458.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c10458.filter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10458.disop2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c10458.filter,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end


function c10458.thfilter(c)
	return (c:IsCode(17266660) or c:IsCode(21074344) or c:IsCode(94689635) or c:IsCode(44665365)
		or c:IsCode(48546368) or c:IsCode(79606837) or c:IsCode(1249315) or c:IsCode(27383110)
		or c:IsCode(79306385) or c:IsCode(10458) or c:IsCode(10469))
		and c:IsAbleToHand()
end
function c10458.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10458.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10458.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10458.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c10458.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c10458.spfilter(c,e,tp)
	return (c:IsCode(17266660) or c:IsCode(21074344) or c:IsCode(94689635) or c:IsCode(44665365)
		or c:IsCode(48546368) or c:IsCode(79606837) or c:IsCode(1249315) or c:IsCode(27383110)
		or c:IsCode(79306385) or c:IsCode(10469)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10458.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10458.spfilter(chkc,e,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c10458.spfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10458.spfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c10458.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local tc=g:GetFirst()
	while tc do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
		end
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	local sg=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,g)
	local xyzg=Duel.GetMatchingGroup(c10458.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if (sg:GetCount()>0 or xyzg:GetCount()>0) and not Duel.SelectYesNo(tp,aux.Stringid(10458,3)) then return end
	if sg:GetCount()>0 and xyzg:GetCount()>0 then
		op=Duel.SelectOption(tp,aux.Stringid(10458,4),aux.Stringid(10458,5))
	elseif sg:GetCount()>0 then
		op=Duel.SelectOption(tp,aux.Stringid(10458,4))
	elseif xyzg:GetCount()>0 then
		op=Duel.SelectOption(tp,aux.Stringid(10458,5))+1
	else
		return
	end
	Duel.BreakEffect()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local syg=sg:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,syg:GetFirst(),nil,g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
function c10458.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg,2,2)
end
