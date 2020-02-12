--Sin オッドアイズ・パラレル・ドラゴン
function c10854.initial_effect(c)
	c:EnableReviveLimit()
	--monster effect
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e1:SetCondition(c10854.spcon)
	e1:SetOperation(c10854.spop)
	c:RegisterEffect(e1)
	--only 1 can exists
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e2:SetCondition(c10854.excon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetTarget(c10854.sumlimit)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e6)
	--selfdes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c10854.descon)
	c:RegisterEffect(e7)
	--no remove overlay
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(10854,0))
	e8:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(c10854.rcon)
	e8:SetOperation(c10854.rcop)
	c:RegisterEffect(e8)
	--spson
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	e9:SetValue(aux.FALSE)
	c:RegisterEffect(e9)
	--tofield
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(10854,1))
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e10:SetCode(EVENT_DESTROYED)
	e10:SetTarget(c10854.rettg)
	e10:SetOperation(c10854.retop)
	c:RegisterEffect(e10)
	--pendulum effect
	--activate
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(1160)
	e11:SetType(EFFECT_TYPE_ACTIVATE)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_HAND)
	c:RegisterEffect(e11)
	--
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(10854)
	e12:SetRange(LOCATION_PZONE)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetTargetRange(1,0)
	c:RegisterEffect(e12)
	--self destroy
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_PZONE)
	e13:SetCode(EFFECT_SELF_DESTROY)
	e13:SetCondition(c10854.sdcon)
	c:RegisterEffect(e13)
	--equip
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(10854,2))
	e14:SetCategory(CATEGORY_EQUIP)
	e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e14:SetRange(LOCATION_PZONE)
	e14:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE+EFFECT_FLAG_CARD_TARGET)
	e14:SetCode(EVENT_REMOVE)
	e14:SetCondition(c10854.eqcon)
	e14:SetTarget(c10854.eqtg)
	e14:SetOperation(c10854.eqop)
	c:RegisterEffect(e14)
	--destroy
	local e15=Effect.CreateEffect(c)
	e15:SetDescription(aux.Stringid(10854,5))
	e15:SetCategory(CATEGORY_DESTROY)
	e15:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e15:SetRange(LOCATION_PZONE)
	e15:SetCountLimit(1)
	e15:SetCode(EVENT_PHASE+PHASE_END)
	e15:SetCondition(c10854.descon2)
	e15:SetTarget(c10854.destg2)
	e15:SetOperation(c10854.desop2)
	c:RegisterEffect(e15)
	--plus effect
	if not c10854.global_check then
		c10854.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c10854.ecop)
		Duel.RegisterEffect(ge1,0)
	end	
end

function c10854.sumlimit(e,c)
	return c:IsSetCard(0x23)
end
function c10854.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x23)
end
function c10854.excon(e)
	return Duel.IsExistingMatchingCard(c10854.exfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c10854.spfilter(c)
	return not c:IsCode(10854) and c:IsSetCard(0x99) and c:IsAbleToRemoveAsCost()
end
function c10854.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10854.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil)
		and not Duel.IsExistingMatchingCard(c10854.exfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
--		and (c:IsLocation(LOCATION_HAND) or Duel.GetLocationCountFromEx(tp)>0)
end
function c10854.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c10854.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil)
	Duel.Remove(tg,POS_FACEUP,REASON_COST)
end

function c10854.descon(e)
	return not Duel.IsEnvironment(27564031)
end

function c10854.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:GetHandler():IsType(TYPE_XYZ) and ep==e:GetOwnerPlayer() and re:GetHandler():GetOverlayCount()>=ev-1
		and re:GetHandler():IsCode(53025096) and Duel.IsExistingMatchingCard(c10854.gfilter,tp,LOCATION_DECK,0,1,nil)
end
function c10854.gfilter(c)
	return c:IsSetCard(0x23) and c:IsAbleToGraveAsCost()
end
function c10854.rcop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10854.gfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end

function c10854.ffilter(c,tp)
	return c:IsCode(27564031) and c:GetActivateEffect():IsActivatable(tp)
end
function c10854.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10854.ffilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c10854.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.GetFirstMatchingCard(c10854.ffilter,tp,LOCATION_DECK,0,nil,tp)
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end

function c10854.sdcon(e)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return ((f1==nil or not f1:IsFaceup()) and (f2==nil or not f2:IsFaceup()))
end

function c10854.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc:IsPreviousLocation(LOCATION_DECK+LOCATION_EXTRA) and tc:IsControler(tp) and tc:IsType(TYPE_MONSTER)
end
function c10854.sinfilter(c)
	return c:IsSetCard(0x23) and c:GetEquipCount()==0
end
function c10854.eqfilter(c,att,rc)
	return c:IsAttribute(att) and c:IsRace(rc) and c:IsType(TYPE_MONSTER) 
		and (c:GetLevel()<9 or c:GetRank()<9) and not c:IsForbidden()
end
function c10854.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c10854.sinfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c10854.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ec=Duel.GetFirstTarget()
	if not ec then return end
	if ec:IsRelateToEffect(e) and ec:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c10854.eqfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,eg:GetFirst():GetAttribute(),eg:GetFirst():GetRace())
		local tc=g:GetFirst()
		if not tc or not Duel.Equip(tp,tc,ec,true) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c10854.eqlimit)
		e1:SetLabelObject(ec)
		tc:RegisterEffect(e1)
		--add oddeyes
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_CHANGE_CODE)
		e2:SetValue(53025096)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		--change pos
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(75987257,3))
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetCategory(CATEGORY_POSITION)
		e3:SetCode(EVENT_FREE_CHAIN)
		e3:SetRange(LOCATION_SZONE)
		e3:SetCondition(c10854.poscon)
		e3:SetOperation(c10854.posop)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		--add xyz type
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_EQUIP)
		e4:SetRange(LOCATION_SZONE)
		e4:SetCode(EFFECT_ADD_TYPE)
		e4:SetValue(TYPE_XYZ)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e4)
		--disable
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetRange(LOCATION_SZONE)
		e5:SetTargetRange(LOCATION_MZONE,0)
		e5:SetTarget(c10854.disable)
		e5:SetCode(EFFECT_DISABLE)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e5)
	end
end
function c10854.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c10854.poscon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_CHAINING) and e:GetHandler():GetEquipTarget()
end
function c10854.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ec=c:GetEquipTarget()
	if ec then
		Duel.ChangePosition(ec,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end
function c10854.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and c:IsDefensePos()
end

function c10854.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c10854.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsLocation(LOCATION_DECK) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c10854.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Destroy(c,REASON_EFFECT)
end



--plus effect
function c10854.ecfilter(c)
	return c:IsFaceup() and (c:IsCode(53025096) or c:IsSetCard(0x23))
end
function c10854.ecop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetOwner()
	local g=Duel.GetMatchingGroup(c10854.ecfilter,c,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(10854)==0 then
			--copy
			local e1=Effect.CreateEffect(tc)
			e1:SetDescription(aux.Stringid(10854,2))
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e1:SetCode(EVENT_EQUIP)
			e1:SetTarget(c10854.copytg)
			e1:SetOperation(c10854.copyop)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(10854,RESET_EVENT+0x1fe0000,0,1)
		end
		tc=g:GetNext()
	end
end

function c10854.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerAffectedByEffect(tp,10854) end
end
function c10854.copyfilter(c,ec)
	return c:GetEquipTarget()==ec
end
function c10854.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=eg:Filter(c10854.copyfilter,nil,e:GetHandler())
	local tc=dg:GetFirst()
	if tc then
		local code=tc:GetOriginalCode()
		if c:IsFaceup() and c:GetFlagEffect(code)==0 then
			c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
			c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000,0,1)
			c:RegisterFlagEffect(0,RESET_EVENT+0x4fc0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10854,4))
		end
	end
end
