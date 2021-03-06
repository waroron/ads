--闇道化師と化したマサヒロ
function c200200110.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(200200110,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetTarget(c200200110.target)
	e1:SetOperation(c200200110.operation)
	c:RegisterEffect(e1)
end
c200200110.illegal=true
function c200200110.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsType(TYPE_FLIP) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_GRAVE,0,1,1,nil,TYPE_FLIP)
end
function c200200110.cfilter(c)
	return c:IsType(TYPE_FLIP) and c:GetOriginalCode()~=200200110
end
function c200200110.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) then
		if tc:GetOriginalCode()~=200200110 then
			c:ReplaceEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000)
		end
		if tc:GetOriginalCode()~=200200110 or Duel.IsExistingTarget(c200200110.cfilter,tp,LOCATION_GRAVE,0,1,nil) then
			Duel.RaiseSingleEvent(c,EVENT_FLIP,e,r,rp,ep,ev)
		end
	end
end
