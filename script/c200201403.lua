--遺言の札
function c200201403.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCondition(c200201403.condition)
	e1:SetTarget(c200201403.target)
	e1:SetOperation(c200201403.operation)
	c:RegisterEffect(e1)
	if not c200201403.global_check then
		c200201403.global_check=true
		--
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c200201403.check1)
		Duel.RegisterEffect(ge1,tp)
	end
end
function c200201403.check1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local atk=sc:GetAttack()
			if sc:GetFlagEffectLabel(200201403)==nil then
				sc:RegisterFlagEffect(200201403,RESET_EVENT+0x1fe0000,0,1,atk)
				sc:RegisterFlagEffect(200201403+100000000,RESET_EVENT+0x1fe0000,0,1,0)
			else
				local flb1=sc:GetFlagEffectLabel(200201403)
				local flb2=sc:GetFlagEffectLabel(200201403+100000000)
				if flb1~=atk then
					sc:SetFlagEffectLabel(200201403,atk)
					if flb2==0 and atk==0 then
						sc:SetFlagEffectLabel(200201403+100000000,1)
					end
				end
			end
			--
			sc=g:GetNext()
		end
	end
end
function c200201403.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local sc=g:GetFirst()
	while sc do
		local flb2=sc:GetFlagEffectLabel(200201403+100000000)
		if flb2>0 then ct=ct+1 end
		sc:SetFlagEffectLabel(200201403+100000000,0)
		--
		sc=g:GetNext()
	end
	return ct>0
end
function c200201403.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=5-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c200201403.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ct<5 then
		Duel.Draw(tp,5-ct,REASON_EFFECT)
	end
end
