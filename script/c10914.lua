--アーティファクト・ケリュケイオン
function c10914.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
--	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_FAIRY),2,2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10914,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,10914)
	e1:SetCondition(c10914.spcon)
	e1:SetCost(c10914.spcost)
	e1:SetTarget(c10914.sptg)
	e1:SetOperation(c10914.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e2:SetCondition(c10914.poscon)
	c:RegisterEffect(e2)
	--cannot set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_MSET)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetRange(0xff)
	e3:SetTarget(c10914.limit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetTarget(c10914.sumlimit)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SET_BASE_DEFENSE)
	e6:SetValue(0)
	c:RegisterEffect(e6)
	--activate from hand
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x97))
	e7:SetTargetRange(LOCATION_HAND,0)
	e7:SetCondition(c10914.actcon)
	e7:SetLabel(2)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e8)
	--search
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(10914,1))
	e9:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetCountLimit(1)
	e9:SetCondition(c10914.actcon)
	e9:SetCost(c10914.actcost)
	e9:SetTarget(c10914.shtg)
	e9:SetOperation(c10914.shop)
	e9:SetLabel(5)
	c:RegisterEffect(e9)
	--release
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(10914,2))
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetCondition(c10914.actcon)
	e10:SetCost(c10914.actcost)
	e10:SetTarget(c10914.canttg)
	e10:SetOperation(c10914.cantop)
	e10:SetLabel(9)
	c:RegisterEffect(e10)
	--ep effects
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(10914,3))
	e11:SetCategory(CATEGORY_DISABLE)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e11:SetCode(EVENT_PHASE+PHASE_END)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1)
	e11:SetCondition(c10914.epcon)
	e11:SetCost(c10914.actcost)
	e11:SetTarget(c10914.eptg)
	e11:SetOperation(c10914.epop)
	c:RegisterEffect(e11)
	--remove type
	local e12=Effect.CreateEffect(c)
	e12:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_REMOVE_TYPE)
	e12:SetValue(TYPE_FUSION)
	c:RegisterEffect(e12)
	--link summon
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetCode(EFFECT_SPSUMMON_PROC)
	e13:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e13:SetRange(LOCATION_EXTRA)
	e13:SetTargetRange(POS_FACEUP_ATTACK,0)
	e13:SetCondition(c10914.linkcon)
	e13:SetOperation(c10914.linkop)
	c:RegisterEffect(e13)
end

function c10914.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return re:GetHandler():IsSetCard(0x97)
end
function c10914.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function c10914.spfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x97) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c10914.mgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c10914.mgfilter(c)
	return c:IsAbleToGrave()
end
function c10914.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false,POS_FACEUP_ATTACK)
		and Duel.IsExistingMatchingCard(c10914.spfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,0)
end
function c10914.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mt=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mg=nil
	local tg=nil
	if not c:IsRelateToEffect(e) then return end
	if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false,POS_FACEUP_ATTACK) then return end
	if not Duel.IsExistingMatchingCard(c10914.spfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10914.spfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	local tc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	if mt>0 or (tc:IsLocation(LOCATION_MZONE) and tc:IsControler(tp)) then
		tg=Duel.SelectMatchingCard(tp,c10914.mgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,tc)
	else
		tg=Duel.SelectMatchingCard(tp,c10914.mgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,tc)
	end
	local mg=Group.FromCards(tg:GetFirst(),tc)
	if Duel.SendtoGrave(mg,REASON_EFFECT)==2 then
		Duel.SpecialSummon(c,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP_ATTACK)
		c:CompleteProcedure()
	end
end

function c10914.poscon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function c10914.limit(e,c)
	return c==e:GetHandler()
end
function c10914.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return (bit.band(sumpos,POS_FACEDOWN)>0 or bit.band(sumpos,POS_FACEUP_DEFENSE)>0) and c==e:GetHandler()
end

function c10914.actfilter(c)
	return c:IsSetCard(0x97) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c10914.actcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c10914.actfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,e:GetLabel(),nil)
end

function c10914.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10914.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10914.shfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10914.shfilter(c)
	return c:IsSetCard(0x97) and c:IsAbleToHand()
end
function c10914.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10914.shfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c10914.canttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10914.cantop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c10914.aclimit)
	if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,3)
	else
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	end
	Duel.RegisterEffect(e1,tp)
end
function c10914.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end

function c10914.epcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c10914.eptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10914.tgfilter(c)
	return c:IsSetCard(0x97) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c10914.epop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10914.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
		Duel.RegisterEffect(e1,tp)
	end
end

function c10914.linkfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToGraveAsCost()
end
function c10914.linkcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c10914.linkfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetCount()>1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
end
function c10914.linkop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10914.linkfilter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
	c:SetMaterial(g)
end
