--十二除獣ドランシア
function c10916.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,5,c10916.ovfilter,aux.Stringid(10916,0),5,c10916.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c10916.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c10916.defval)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10916,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetCost(c10916.spcost)
	e3:SetTarget(c10916.sptg)
	e3:SetOperation(c10916.spop)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e3)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10916,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c10916.mttg)
	e4:SetOperation(c10916.mtop)
	c:RegisterEffect(e4)
end

function c10916.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf1) and not c:IsCode(10916)
end
function c10916.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10916)==0 end
	Duel.RegisterFlagEffect(tp,10916,RESET_PHASE+PHASE_END,0,1)
end
function c10916.atkfilter(c)
	return c:IsSetCard(0xf1) and c:GetAttack()>=0
end
function c10916.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c10916.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c10916.deffilter(c)
	return c:IsSetCard(0xf1) and c:GetDefense()>=0
end
function c10916.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c10916.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end

function c10916.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10916.filter(c,e,tp,code)
	return c:GetRank()==4 and e:GetHandler():IsCanBeXyzMaterial(c) and c:GetCode()~=code
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c10916.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10916.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler():GetCode())
--		and aux.MustMaterialCheck(e:GetHandler(),tp,EFFECT_MUST_BE_XMATERIAL)
--		and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10916.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
--	if Duel.GetLocationCountFromEx(tp,tp,c)<=0 then return end
--	if not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10916.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c:GetCode())
	local sc=g:GetFirst()
	if sc then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end

function c10916.mtfilter(c)
	return c:IsSetCard(0xf1)
end
function c10916.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c10916.mtfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10916.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c10916.mtfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
