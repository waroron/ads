---奇跡の創造者
function c200201401.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(200201401,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c200201401.target)
	e1:SetOperation(c200201401.operation)
	c:RegisterEffect(e1)
	if not c200201401.global_check then
		c200201401.global_check=true
		c200201401[0]=0
		c200201401[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c200201401.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c200201401.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(200201401) then
		c200201401[rp]=bit.bor(c200201401[rp],1)
	end
	if re:GetHandler():IsCode(200201303) then
		c200201401[rp]=bit.bor(c200201401[rp],2)
	end
end
function c200201401.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x7f) and c:IsSetCard(0x1048) and not c:IsHasEffect(EFFECT_DIRECT_ATTACK)
end
function c200201401.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c200201401.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c200201401.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_CODE,tp,200201402)
	Duel.SelectTarget(tp,c200201401.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c200201401.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		--
		if c200201401[tp]==3 then
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(200201401,1))
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_BATTLE_DAMAGE)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e2:SetCondition(c200201401.wincon)
			e2:SetOperation(c200201401.winop)
			tc:RegisterEffect(e2)
		end
	end
end
function c200201401.wincon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c200201401.winop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(tp,0x0)
end
