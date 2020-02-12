--トリックスター・コリアリス(調整版)
function c10858.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10858,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c10858.sumtg)
	e1:SetOperation(c10858.sumop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10858,1))
	e2:SetCategory(CATEGORY_SPSUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10858)
	e2:SetTarget(c10858.sptg)
	e2:SetOperation(c10858.spop)
	c:RegisterEffect(e2)
	--skip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10858,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c10858.skipcon)
	e3:SetCost(c10858.skipcost)
	e3:SetTarget(c10858.skiptg)
	e3:SetOperation(c10858.skipop)
	c:RegisterEffect(e3)
	--damege
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(aux.chainreg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c10858.acop)
	c:RegisterEffect(e5)
	--synchro limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_TUNER_MATERIAL_LIMIT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetTarget(c10858.synlimit)
	c:RegisterEffect(e6)
	--fusion limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_TUNE_MAGICIAN_F)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e7)
	--xyz limit
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_TUNE_MAGICIAN_X)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetValue(c10858.xyzlimit)
	c:RegisterEffect(e8)
	--link limit
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_TUNE_MAGICIAN_L)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(c10858.linklimit)
	c:RegisterEffect(e9)
end
function c10858.sumfilter(c)
	return c:IsSetCard(0xfb) and c:GetCode()~=10858 and c:IsSummonable(true,nil)
end
function c10858.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10858.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c10858.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c10858.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end

function c10858.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xfb)
end
function c10858.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if chkc then return chkc:IsOnField() and c10858.filter(chkc) end
		if chk==0 then return Duel.IsExistingTarget(c10858.filter,tp,LOCATION_ONFIELD,0,1,nil) 
		 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectTarget(tp,c10858.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	else
		if chkc then return chkc:IsOnField() and c10858.filter(chkc) end
		if chk==0 then return Duel.IsExistingTarget(c10858.filter,tp,LOCATION_MZONE,0,1,nil) 
		 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectTarget(tp,c10858.filter,tp,LOCATION_MZONE,0,1,1,nil)
	end	
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10858.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c10858.skipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_ONFIELD,0)==0
end
function c10858.skipfilter(c)
	return c:IsSetCard(0xfb) and c:IsDiscardable() and not c:IsPublic()
end
function c10858.skipcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and not e:GetHandler():IsPublic() 
		and Duel.GetFlagEffect(tp,10858)==0 
		and Duel.IsExistingMatchingCard(c10858.skipfilter,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_PUBLIC)
	local g=Duel.SelectMatchingCard(tp,c10858.skipfilter,tp,LOCATION_HAND,0,2,2,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=g:Select(tp,2,2,nil)
	Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
	Duel.RegisterFlagEffect(tp,10858,0,0,0)
end
function c10858.skiptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN) end
end
function c10858.skipop(e,tp,eg,ep,ev,re,r,rp)
	--enemy
	Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--controler
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SKIP_BP)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	Duel.RegisterEffect(e2,tp)
end

function c10858.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0xfb) and e:GetHandler():GetFlagEffect(1)>0 and not re:GetHandler():IsType(TYPE_LINK) then
		Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
		Duel.Damage(1-tp,200,REASON_EFFECT)
	end
end

function c10858.synlimit(e,c)
	return c:IsSetCard(0xfb)
end
function c10858.fuslimit(c)
	return not c:IsSetCard(0xfb)
end
function c10858.xyzlimit(e,c)
	return not c:IsSetCard(0xfb)
end
function c10858.linklimit(e,c)
	return not c:IsSetCard(0xfb)
end
