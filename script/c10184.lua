--ネクロの多元魔導書
function c10184.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	-- e1:SetCountLimit(1,10184+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10184.target)
	e1:SetOperation(c10184.operation)
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
	over_e:SetTarget(c10184.ov_target)
	over_e:SetOperation(c10184.ov_activate)
	c:RegisterEffect(over_e)
end

function c10184.xyz_filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end

function c10184.ov_target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10184.filter(chkc) end
	if chk==0 then
		-- if e:GetLabel()==0 then return false end
		-- e:SetLabel(0)
		return Duel.IsExistingTarget(c10184.xyz_filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			and e:GetHandler():IsCanOverlay()
	end
	-- e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10184.xyz_filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end

function c10184.ov_activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) then
		-- c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
	end
end

function c10184.cfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:GetLevel()>0 and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingTarget(c10184.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c10184.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10184.cffilter(c)
	return c:IsSetCard(0x106e) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end

function c10184.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:GetLevel()>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10184.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c83764718.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10184.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10184.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10184.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c10184.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
