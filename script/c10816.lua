--真竜魔王アモルファージV
function c10816.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2,c10816.ovfilter,aux.Stringid(10816,0),5,c10816.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c10816.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c10816.defval)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10816,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c10816.thcost)
	e3:SetTarget(c10816.thtg)
	e3:SetOperation(c10816.thop)
	c:RegisterEffect(e3)
	--pendulum set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10816,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,10816)
	e4:SetRange(LOCATION_MZONE+LOCATION_EXTRA)
	e4:SetTarget(c10816.settg)
	e4:SetOperation(c10816.setop)
	c:RegisterEffect(e4)
	--xyz material
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10816,6))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,10817)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTarget(c10816.mttg)
	e5:SetOperation(c10816.mtop)
	c:RegisterEffect(e5)
	--destroy & set
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10816,5))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1,10818)
	e6:SetTarget(c10816.destg)
	e6:SetOperation(c10816.desop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e7:SetCondition(c10816.descon)
	c:RegisterEffect(e7)
	--extra summon
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_ADJUST)
	e8:SetRange(LOCATION_PZONE)
	e8:SetOperation(c10816.sumop)
	c:RegisterEffect(e8)
	--
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(10816)
	e9:SetRange(LOCATION_PZONE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetTargetRange(1,0)
	c:RegisterEffect(e9)
	--shuffle
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetRange(LOCATION_PZONE)
	e10:SetCode(EVENT_SPSUMMON)
	e10:SetOperation(c10816.shop)
	c:RegisterEffect(e10)
end

--xyz summon
function c10816.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0)
end
function c10816.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10816)==0 end
	Duel.RegisterFlagEffect(tp,10816,RESET_PHASE+PHASE_END,0,1)
end

--atk & def
function c10816.atkfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:GetAttack()>=0
end
function c10816.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c10816.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c10816.deffilter(c)
	return c:IsType(TYPE_PENDULUM) and c:GetDefense()>=0
end
function c10816.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c10816.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end

--search
function c10816.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10816.thfilter(c)
	return c:IsSetCard(0xe0) and c:IsAbleToHand()
end
function c10816.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10816.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10816.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10816.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--move pzone
function c10816.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not (e:GetHandler():IsLocation(LOCATION_EXTRA) and not e:GetHandler():IsPublic())
		and	(Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10816.setop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e)
		and (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

--xyz material
function c10816.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c10816.mtfilter(c)
	return ((c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)) or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_PENDULUM)
end
function c10816.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10816.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c10816.mtfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10816,3))
	Duel.SelectTarget(tp,c10816.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10816.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10816,4))
		local g=Duel.SelectMatchingCard(tp,c10816.mtfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
		Duel.SetTargetCard(g)
		Duel.Overlay(tc,g)
	end
end

--destroy & set
function c10816.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() 
end
function c10816.desfilter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsDestructable()
end
function c10816.sefilter(c)
	return ((c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)) or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_PENDULUM)
end
function c10816.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10816.desfilter,tp,LOCATION_SZONE,0,1,nil)
	 and Duel.IsExistingMatchingCard(c10816.sefilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetMatchingGroup(c10816.desfilter,tp,LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10816.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local dg=Duel.GetMatchingGroup(c10816.desfilter,tp,LOCATION_SZONE,0,nil)
	if Duel.Destroy(dg,REASON_EFFECT)~=0 then
		local b1=Duel.CheckLocation(tp,LOCATION_SZONE,6) 
		local b2=Duel.CheckLocation(tp,LOCATION_SZONE,7)
		if b1 and b2 then
			op=2
		elseif b1 or b2 then
			op=1
		else return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c10816.sefilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,op,nil)
		local tc=g:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			tc=g:GetNext()
		end
	end
end

--pendulum summon
function c10816.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,10817)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c10816.regop)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,10817,RESET_PHASE+PHASE_END,0,1)
end
function c10816.regop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	if tc and tc:GetFlagEffect(10818)==0 then
		Duel.Hint(HINT_CARD,0,10816)
		tc:RegisterFlagEffect(10818,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(10816,7))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC_G)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetRange(LOCATION_PZONE)
		e1:SetCountLimit(1,10000000)
		e1:SetLabelObject(e)
		e1:SetCondition(c10816.pencon)
		e1:SetOperation(c10816.penop)
		e1:SetValue(SUMMON_TYPE_PENDULUM)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
	end
end
function c10816.penfilter(c,e,tp,lscale,rscale)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return ((c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_DECK)) 
		or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
		and not c:IsForbidden()
end
function c10816.cfilter(c)
	return c:IsSetCard(0xe0)
end
function c10816.pencon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	if not (g:GetCount()>0 and g:FilterCount(c10816.cfilter,nil)==g:GetCount()) then return false end
	if not Duel.IsPlayerAffectedByEffect(tp,10816) then return false end
	if c:GetSequence()~=6 then return false end
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if rpz==nil then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if og then
		return og:IsExists(c10816.penfilter,1,nil,e,tp,lscale,rscale)
	else
		return Duel.IsExistingMatchingCard(c10816.penfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lscale,rscale)
	end
end
function c10816.penop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	local ckg=Duel.GetMatchingGroup(c10816.penfilter,tp,LOCATION_DECK,0,nil,e,tp,lscale,rscale)
	local exg=Duel.GetMatchingGroup(c10816.penfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp,lscale,rscale)
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local tg=nil
	if og then
		tg=og:Filter(tp,c10816.penfilter,nil,e,tp,lscale,rscale)
	else
		tg=Duel.GetMatchingGroup(c10816.penfilter,tp,LOCATION_DECK,0,nil,e,tp,lscale,rscale)
	end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and (ect<=0 or ect>ft) then ect=nil end
	if ect==nil or tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=ect then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local pg=ckg:Select(tp,1,1,nil)
		sg:Merge(pg)
		if ft>1 and exg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10816,8)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=exg:Select(tp,1,ft-1,nil)
			sg:Merge(g)
		end
	else
		repeat
			local ct=math.min(ft,ect)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=tg:Select(tp,1,ct,nil)
			tg:Sub(g)
			sg:Merge(g)
			ft=ft-g:GetCount()
			ect=ect-g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
		until ft==0 or ect==0 or not Duel.SelectYesNo(tp,210)
		local hg=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
		if ft>0 and ect==0 and hg:GetCount()>0 and Duel.SelectYesNo(tp,210) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local pg=ckg:Select(tp,1,1,nil)
			sg:Merge(pg)
			if ft>1 and exg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10816,8)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=exg:Select(tp,1,ft-1,nil)
				sg:Merge(g)
			end
		end
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
	local se=e:GetLabelObject()
	se:Reset()
	e:Reset()
	Duel.RegisterFlagEffect(tp,10818,RESET_PHASE+PHASE_END,0,1)
end
function c10816.shop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,10818)~=0 then
		Duel.ShuffleDeck(tp)
		Duel.ResetFlagEffect(tp,10818)
	end
end
