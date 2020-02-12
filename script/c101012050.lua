--ジ・アライバル・サイバース＠イグニスター
function c101012050.initial_effect(c)
	c:SetUniqueOnField(1,0,101012050)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,3,6,c101012050.lcheck)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c101012050.atkop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c101012050.efilter)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(32750510,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c101012050.destg)
	e3:SetOperation(c101012050.desop)
	c:RegisterEffect(e3)
end
function c101012050.lcheck(g)
	return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end
function c101012050.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_LINK) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(c:GetMaterialCount()*1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function c101012050.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c101012050.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local zone=bit.band(c:GetLinkedZone(tp),0x1f)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	local lg=c:GetLinkedGroup():Filter(Card.IsControler,nil,tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101012050.cfilter(chkc,g,ct) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c101012050.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,lg,ct)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101012150,0x135,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK,POS_FACEUP,tp,0,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101012050.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c,lg,ct)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c101012050.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if not c:IsRelateToEffect(e) then return end
		local zone=bit.band(c:GetLinkedZone(tp),0x1f)
		if Duel.IsPlayerCanSpecialSummonMonster(tp,101012150,0x135,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK,POS_FACEUP,tp,0,zone) then
			local token=Duel.CreateToken(tp,101012150)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
end