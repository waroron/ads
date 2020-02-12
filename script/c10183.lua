--セフェルの多元魔導書
function c10183.initial_effect(c)
	--remove and add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	-- e1:SetCountLimit(1,10183+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10183.condition)
	e1:SetCost(c10183.cost)
	e1:SetTarget(c10183.target)
	e1:SetOperation(c10183.operation)
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
	

end

function c10183.xyz_filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end


function c10183.cfilter(c)
	return c:IsSetCard(0x106e) and c:IsCanAddCounter(0x1,1)
end

function c10183.tagen_filter(c)
	return c:IsSetCard(0x106e)
end

function c10183.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10183.tagen_filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
end
function c10183.cffilter(c)
	return c:IsSetCard(0x106e) and not c:IsPublic()
end
function c10183.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10183.tagen_filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.GetMatchingGroup(c10183.tagen_filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.Remove(g, POS_FACEUP, REASON_COST)
	e:SetLabel(g:GetCount())
end

function c10183.filter(c)
	return c:IsSetCard(0x106e) and not c:IsCode(10183) and not c:IsCode(56981417) and c:CheckActivateEffect(true,true,false)~=nil
end
function c10183.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c10183.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10183.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
end

function c10183.rfilter(c)
	return c:IsSetCard(0x106e) and c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c10183.operation(e,tp,eg,ep,ev,re,r,rp)
	local num = e:GetLabel()
	if num > 0 then
		local g = Duel.GetMatchingGroup(c10183.cfilter,tp,LOCATION_ONFIELD,0,nil)
		local card = g:GetFirst()
		Debug.Message(tostring(g:GetCount()))
		while card do
			Debug.Message(card)
			card:AddCounter(0x1, 2*num)
			card = g:GetNext()
		end
	end
end
