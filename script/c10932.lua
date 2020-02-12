--未来儀式-フューチャー・リチューアル
function c10932.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10932.target)
	e1:SetOperation(c10932.activate)
	c:RegisterEffect(e1)
end

function c10932.filter(c,e,tp)
	local mg=Duel.GetMatchingGroup(c10932.matfilter,tp,LOCATION_DECK,0,c,e)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsAbleToRemove() then return false end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c10932.matfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c10932.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10932.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,nil,tp,LOCATION_DECK)
end
function c10932.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOREMOVE)
	local tg=Duel.SelectMatchingCard(tp,c10932.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=tg:GetFirst()
	local mg=Duel.GetMatchingGroup(c10932.matfilter,tp,LOCATION_DECK,0,tc,e)
	if tc then
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		mat:KeepAlive()
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL+REASON_RELEASE)
		if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
		e1:SetCondition(c10932.thcon)
		e1:SetOperation(c10932.thop)
		e1:SetLabelObject(mat)
		tc:RegisterEffect(e1)
	end
end
function c10932.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c10932.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then
		Duel.Hint(HINT_CARD,0,10932)
		c:SetMaterial(e:GetLabelObject())
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		c:CompleteProcedure()
	else
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
