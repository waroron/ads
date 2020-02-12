--希望決壊
function c10948.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10948,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10948.cost)
	e1:SetTarget(c10948.target)
	e1:SetOperation(c10948.operation)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10948,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c10948.setcon)
	e2:SetTarget(c10948.settg)
	e2:SetOperation(c10948.setop)
	c:RegisterEffect(e2)
end

function c10948.filter(c,e,tp)
	return c:IsSetCard(0x7f) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c10948.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10948.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10948.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetAttack())
end
function c10948.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c10948.operation(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetLabel(atk)
	e1:SetValue(c10948.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10948.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetTextAttack()<=e:GetLabel() and not re:GetHandler():IsImmuneToEffect(e)
end

function c10948.cfilter(c,tp)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsSetCard(0x7f) and c:IsType(TYPE_MONSTER) 
		and c:IsType(TYPE_XYZ) and c:IsFaceup() and c:IsDestructable()
end
function c10948.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10948.cfilter,1,nil,tp)
end
function c10948.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c10948.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c10948.cfilter,nil,tp)
	if c:IsRelateToEffect(e) and c:IsSSetable() and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
	end
end
