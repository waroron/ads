--トーラの多元魔導書
function c10182.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10182.target)
	e1:SetOperation(c10182.activate)
	c:RegisterEffect(e1)
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
	
	--オーバーレイユニット
	local over_e=Effect.CreateEffect(c)
	over_e:SetRange(LOCATION_GRAVE)
	over_e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	over_e:SetType(EFFECT_TYPE_QUICK_O)
	over_e:SetCode(EVENT_FREE_CHAIN)
	over_e:SetTarget(c10182.ov_target)
	over_e:SetOperation(c10182.ov_activate)
	c:RegisterEffect(over_e)
end

function c10182.xyz_filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end

function c10182.ov_target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10182.filter(chkc) end
	if chk==0 then
		-- if e:GetLabel()==0 then return false end
		-- e:SetLabel(0)
		return Duel.IsExistingTarget(c10182.xyz_filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			and e:GetHandler():IsCanOverlay()
	end
	-- e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10182.xyz_filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end

function c10182.ov_activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) then
		-- c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
	end
end

function c10182.filter2(c)
	return c:IsFaceup()
end
function c10182.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10182.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10182.filter2,tp,LOCATION_MZONE,0,1,nil) end
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	--Duel.SelectTarget(tp,c10182.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	-- local opt=Duel.SelectOption(tp,aux.Stringid(10182,0),aux.Stringid(10182,1))
	-- e:SetLabel(opt)
	
end

function c10182.activate(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	--local tc=Duel.GetFirstTarget()
	local tc = Duel.GetMatchingGroup(c10182.filter2, tp, LOCATION_MZONE, 0, nil)
	local card = tc:GetFirst()
	while card do
		Debug.Message(card)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		
		local e3 = e2:Clone()
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(c10182.efilter)  
		card:RegisterEffect(e3)
		
		local e4 = e2:Clone()
		e3:SetCode(EFFECT_UNRELEASABLE_EFFECT)  
		card:RegisterEffect(e3)
		card = tc:GetNext()
	end

end
function c10182.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
