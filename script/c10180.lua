--グリモの多元魔導書
function c10180.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	-- e1:SetCountLimit(1,10180+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10180.target)
	e1:SetOperation(c10180.activate)
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
	over_e:SetTarget(c10180.ov_target)
	over_e:SetOperation(c10180.ov_activate)
	c:RegisterEffect(over_e)
end

function c10180.xyz_filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end

function c10180.ov_target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10180.filter(chkc) end
	if chk==0 then
		-- if e:GetLabel()==0 then return false end
		-- e:SetLabel(0)
		return Duel.IsExistingTarget(c10180.xyz_filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			and e:GetHandler():IsCanOverlay()
	end
	-- e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10180.xyz_filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end

function c10180.ov_activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) then
		-- c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
	end
end

function c10180.filter(c)
	return c:IsSetCard(0x106e) and c:GetCode()~=10180 and c:IsAbleToHand()
end
function c10180.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10180.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10180.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10180.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
