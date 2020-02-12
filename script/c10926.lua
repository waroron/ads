--音響戦士アーティストス
function c10926.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--monste effect
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAINING)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c10926.chcon)
	e0:SetOperation(c10926.chop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c10926.syncon)
	e1:SetOperation(c10926.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10926,1))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c10926.cost)
	e2:SetTarget(c10926.eqtg)
	e2:SetOperation(c10926.eqop)
	c:RegisterEffect(e2)
	--special summon equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10926,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c10926.cost)
	e3:SetTarget(c10926.sptg)
	e3:SetOperation(c10926.spop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c10926.desop)
	c:RegisterEffect(e4)
	--pendulum set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10926,3))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c10926.pencon)
	e5:SetTarget(c10926.pentg)
	e5:SetOperation(c10926.penop)
	c:RegisterEffect(e5)
	--control
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10926,4))
	e6:SetCategory(CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c10926.cost)
	e6:SetTarget(c10926.rltg)
	e6:SetOperation(c10926.rlop)
	c:RegisterEffect(e6)
	--spsummon condition
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_SPSUMMON_CONDITION)
	e7:SetValue(c10926.splimit)
	c:RegisterEffect(e7)
	--pendulum effect
	--pendulum set
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(10926,7))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_PZONE)
	e8:SetCountLimit(1)
	e8:SetCost(c10926.cost)
	e8:SetTarget(c10926.pctg)
	e8:SetOperation(c10926.pcop)
	c:RegisterEffect(e8)
	--spsummon from deck
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(10926,8))
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_PZONE)
	e9:SetCountLimit(1)
	e9:SetCost(c10926.cost)
	e9:SetTarget(c10926.decktg)
	e9:SetOperation(c10926.deckop)
	c:RegisterEffect(e9)
	--act limit
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_SPSUMMON)
	e10:SetOperation(c10926.limop)
	c:RegisterEffect(e10)
end

function c10926.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or (bit.band(st,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO and se:GetHandler():IsCode(10926))
end

function c10926.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end

function c10926.mfilter(c,sync)
	return c:GetFlagEffect(10926)~=0 and c:IsCanBeSynchroMaterial(sync)
end
function c10926.opfilter(c)
	return c:IsFaceup() and c:IsCode(91279700) and not c:IsDisabled()
end
function c10926.syncon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c10926.mfilter,tp,LOCATION_MZONE,0,nil,c)
	local lv=mg:GetSum(Card.GetLevel)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and mg:GetCount()>0
		and (lv<=4 or not Duel.IsExistingMatchingCard(c10926.opfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil))
end
function c10926.synop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c10926.mfilter,tp,LOCATION_MZONE,0,nil,c)
	c:SetMaterial(mg)
	Duel.Destroy(mg,REASON_COST+REASON_MATERIAL+REASON_SYNCHRO)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(mg:GetSum(Card.GetLevel))
	e1:SetReset(RESET_EVENT+0xfe0000)
	c:RegisterEffect(e1)
end

function c10926.cfilter(c,e,tp,sync)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_TUNER) 
		and c:IsDestructable() and c:IsFaceup() and c:IsCanBeSynchroMaterial(sync)
end
function c10926.tnfilter(c,e,tp,sync)
	return not c:IsType(TYPE_TUNER) and c:IsSetCard(0x1066) and c:IsType(TYPE_MONSTER) and c:IsDestructable()
		and c:IsCanBeSynchroMaterial(sync) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10926.atfilter(c)
	return c:IsFaceup() and c:IsCode(10926)
end
function c10926.chcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c10926.cfilter,1,nil,e,tp,c)
		and re:GetHandler():IsSetCard(0x1066) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c10926.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local b1=Duel.IsPlayerCanSpecialSummonCount(tp,2)
	local b2=Duel.IsExistingMatchingCard(c10926.tnfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
	local b3=Duel.IsExistingMatchingCard(c10926.atfilter,tp,LOCATION_ONFIELD,0,1,nil)
	local b4=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if not (b1 or b2 or not b3 or b4) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(c10926.cfilter,nil,e,tp,c)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10926,0)) then
		Duel.ConfirmCards(1-tp,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c10926.tnfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,c):GetFirst()
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		tc:RegisterFlagEffect(10926,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		sg:RegisterFlagEffect(10926,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		Duel.SynchroSummon(tp,c,nil)
		Duel.BreakEffect()
		local tf=re:GetTarget()
		local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
		if tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c) then
			local g=Group.CreateGroup()
			g:AddCard(c)
			Duel.ChangeTargetCard(ev,g)
		end
	end
end

function c10926.eqfilter(c)
	return c:IsSetCard(0x1066) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c10926.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10926.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c10926.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c10926.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c10926.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		if c:IsFaceup() and c:IsRelateToEffect(e) then c:SetCardTarget(tc) end
		local atk=tc:GetTextAttack()
		tc:RegisterFlagEffect(10926,RESET_EVENT+0x1fe0000,0,0)
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c10926.eqlimit)
		tc:RegisterEffect(e1)
		if atk>0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(atk)
			tc:RegisterEffect(e2)
		end
	end
end
function c10926.eqlimit(e,c)
	return e:GetOwner()==c
end

function c10926.desfilter(c,rc)
	return rc:GetCardTarget():IsContains(c)
end
function c10926.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCardTargetCount()>0 then
		local dg=Duel.GetMatchingGroup(c10926.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end

function c10926.spfilter(c,e,tp,ec)
	return c:GetFlagEffect(10926)~=0 and c:GetEquipTarget()==ec and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10926.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c10926.spfilter(chkc,e,tp,e:GetHandler()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10926.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10926.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10926.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c10926.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c10926.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c10926.penop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function c10926.rlfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1066)
		and Duel.IsExistingMatchingCard(c10926.confilter,tp,0,LOCATION_MZONE,1,nil,e,tp,c)
end
function c10926.confilter(c,e,tp,tc)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsCanBeEffectTarget(e)
		and (c:GetLevel()==tc:GetLevel() or c:GetRank()==tc:GetLevel()) and c:IsRace(tc:GetRace()) and c:IsAttribute(tc:GetAttribute())
		and ((c:IsAbleToHand() or c:IsAbleToExtra()) or c:IsControlerCanBeChanged())
end
function c10926.rltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.CheckReleaseGroup(tp,c10926.rlfilter,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	local sg=Duel.SelectReleaseGroup(tp,c10926.rlfilter,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c10926.confilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp,sg:GetFirst())
	Duel.Release(sg,REASON_COST)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10926.rlop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local b1=tc:IsControlerCanBeChanged() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=tc:IsAbleToHand() or tc:IsAbleToExtra()
	if not tc:IsRelateToEffect(e) then return end
	local op=2
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(10926,5),aux.Stringid(10926,6))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(10926,5))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(10926,6))+1
	else
		return
	end
	if op==0 then
		Duel.GetControl(tc,tp)
	else
		if tc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) then
			Duel.SendtoDeck(tc,tp,1,REASON_EFFECT)
		else
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end

function c10926.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x1066) and c:IsFaceup() and not c:IsForbidden()
end
function c10926.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
		and Duel.IsExistingMatchingCard(c10926.pcfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c10926.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c10926.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function c10926.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c10926.deckfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c10926.deckfilter(c,e,tp,tc)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:GetLevel()==tc:GetLevel()+1 and c:IsRace(tc:GetRace()) and c:IsAttribute(tc:GetAttribute())
end
function c10926.decktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10926.tgfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10926,9))
	local g=Duel.SelectMatchingCard(tp,c10926.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.SendtoGrave(g,REASON_COST+REASON_RETURN)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10926.deckop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10926.deckfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabelObject())
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		tc:RegisterFlagEffect(10927,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		Duel.SpecialSummonComplete()
		g:KeepAlive()
		local de=Effect.CreateEffect(c)
		de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		de:SetCode(EVENT_PHASE+PHASE_END)
		de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		de:SetCountLimit(1)
		de:SetReset(RESET_PHASE+PHASE_END)
		de:SetLabel(fid)
		de:SetLabelObject(g)
		de:SetCondition(c10926.mncon)
		de:SetOperation(c10926.mnop)
		Duel.RegisterEffect(de,tp)
	end
end
function c10926.mnfilter(c,fid)
	return c:GetFlagEffectLabel(10927)==fid
end
function c10926.mncon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c10926.mnfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c10926.mnop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local dg=g:Filter(c10926.mnfilter,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.Destroy(dg,REASON_EFFECT)
end

function c10926.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then return end
	Duel.SetChainLimitTillChainEnd(c10926.chlimit)
end
function c10926.chlimit(e,rp,tp)
	return e:IsActiveType(TYPE_TRAP) and e:GetHandler():IsType(TYPE_COUNTER)
end
