--ユベル－Das Erbärmlich Vorhandensein
function c10827.initial_effect(c)
	c:SetUniqueOnField(1,1,10827)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP_ATTACK,1)
	e1:SetCondition(c10827.sprcon)
	e1:SetOperation(c10827.sprop)
	c:RegisterEffect(e1)
	--cannot release
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3)
	--cannot summon material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e7)
	--atklimit
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e8)
	--cannot be target
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e9:SetTarget(c10827.target)
	e9:SetValue(1)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	--special summon
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(10827,0))
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e11:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1)
	e11:SetTarget(c10827.sptg)
	e11:SetOperation(c10827.spop)
	c:RegisterEffect(e11)
	--cannot select battle target
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetRange(LOCATION_MZONE)
	e12:SetTargetRange(LOCATION_MZONE,0)
	e12:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e12:SetCondition(c10827.atkcon)
	e12:SetValue(c10827.atlimit)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e13)
	--switch control
	local e14=Effect.CreateEffect(c)
	e14:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e14:SetCode(EVENT_PHASE_START+PHASE_BATTLE_START)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCountLimit(1)
	e14:SetOperation(c10827.maop)
	c:RegisterEffect(e14)
end

--special summon rule
function c10827.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10827.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.IsPlayerCanSpecialSummonCount(tp,2)
end
function c10827.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10827.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP_ATTACK)
	end
end

function c10827.target(e,c)
	return c:IsCode(4779091,31764700,78371393,10827)
end

function c10827.cfilter(c)
	return c:IsFaceup() and c:IsCode(4779091,31764700,78371393,10827)
end
function c10827.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10827.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c10827.atlimit(e,c)
	return not (c:IsFaceup() and c:IsCode(4779091,31764700,78371393,10827))
end

function c10827.spfilter(c,e,tp)
	return c:IsCode(4779091,31764700,78371393,10827) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c10827.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10827.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c10827.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10827.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP_ATTACK)
	end
end

function c10827.ccfilter(c)
	return c:IsAbleToChangeControler() and c:GetSequence()<5
end
function c10827.gfilter(c)
	return c:GetFlagEffect(10827)==0 and c:GetSequence()<5
end
function c10827.cxfilter(c)
	return not c:IsAbleToChangeControler()
end
function c10827.maop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsDefensePos,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_ATTACK)
	local g1=Duel.GetMatchingGroup(c10827.ccfilter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c10827.ccfilter,tp,0,LOCATION_MZONE,nil)
	local og1=g1:GetCount()
	local og2=g2:GetCount()
	if (og1==0 or og2==0) then return end
	if not (g1:FilterCount(c10827.cxfilter,nil)==0 or g2:FilterCount(c10827.cxfilter,nil)==0) then return end
	if og1>og2 then
		local tc1=g1:GetFirst()
		for i=1,og1-og2 do
			Duel.GetControl(tc1,1-tp,PHASE_BATTLE,1)
			tc1:RegisterFlagEffect(10827,RESET_EVENT+0x1fe0000,0,1)
			tc1=g1:GetNext()
		end
	elseif og1<og2 then
		local tc2=g2:GetFirst()
		for i=1,og2-og1 do
			Duel.GetControl(tc2,tp,PHASE_BATTLE,1)
			tc2:RegisterFlagEffect(10827,RESET_EVENT+0x1fe0000,0,1)
			tc2=g2:GetNext()
		end
	end
	local cg1=Duel.GetMatchingGroup(c10827.gfilter,tp,LOCATION_MZONE,0,nil)
	local cg2=Duel.GetMatchingGroup(c10827.gfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SwapControl(cg1,cg2,PHASE_BATTLE,1)
	--reflect damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REFLECT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(c10827.refcon)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--cannot direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end

function c10827.refcon(e,re,val,r,rp,rc)
	return bit.band(r,REASON_EFFECT)~=0
end
