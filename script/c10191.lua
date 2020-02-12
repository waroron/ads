--多元魔導書士 バテル
function c10191.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10191,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c10191.shtg)
	e1:SetOperation(c10191.shop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10192,0))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c10191.spcon)
	e3:SetTarget(c10191.sptg)
	e3:SetOperation(c10191.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c10191.spcon2)
	c:RegisterEffect(e4)
	--cannot mset
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e5)
	--summon limit
	--local e6=Effect.CreateEffect(c)
	--e6:SetType(EFFECT_TYPE_SINGLE)
	--e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e6:SetCode(EFFECT_CANNOT_SUMMON)
	--e6:SetCondition(c10191.sumcon)
	--c:RegisterEffect(e6)
	--if not c10191.global_flag then
		--c10191.global_flag=true
		--local ge1=Effect.CreateEffect(c)
		--ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		--ge1:SetCode(EVENT_SUMMON)
		--ge1:SetOperation(c10191.regop)
		--Duel.RegisterEffect(ge1,0)
	--end
end

function c10191.filter(c)
	return c:IsSetCard(0x106e) and c:IsAbleToHand()
end
function c10191.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10191.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10191.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c10191.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.CheckEvent(EVENT_CHAINING)
end
function c10191.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.CheckEvent(EVENT_CHAINING) and re:GetHandler()~=e:GetHandler()
end
function c10191.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsSummonable(true,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end
function c10191.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.Summon(tp,c,true,nil)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end

function c10191.sumcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),10191)>0
end
function c10191.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		local code1,code2=tc:GetOriginalCodeRule()
		if code1==10191 or code2==10191 then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),10191,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
