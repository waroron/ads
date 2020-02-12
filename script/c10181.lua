--ゲーテの多元魔導書
function c10181.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	-- e1:SetCountLimit(1,10181+EFFECT_COUNT_CODE_OATH)
	-- 発動条件
	e1:SetCondition(c10181.condition)
	-- 効果の発動できるとき，発動について
	e1:SetTarget(c10181.target_2)
	e1:SetOperation(c10181.operation)
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
	over_e:SetTarget(c10181.ov_target)
	over_e:SetOperation(c10181.ov_activate)
	c:RegisterEffect(over_e)
end

function c10181.xyz_filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end

function c10181.ov_target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10181.filter(chkc) end
	if chk==0 then
		-- if e:GetLabel()==0 then return false end
		-- e:SetLabel(0)
		return Duel.IsExistingTarget(c10181.xyz_filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			and e:GetHandler():IsCanOverlay()
	end
	-- e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10181.xyz_filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end

function c10181.ov_activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) then
		-- c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
	end
end

function c10181.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c10181.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10181.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10181.rfilter(c)
	return true
end
function c10181.filter1(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function c10181.filter2(c)
	return not c:IsPosition(POS_FACEUP_ATTACK) or c:IsCanTurnSet()
end
function c10181.filter3(c)
	return c:IsAbleToRemove()
end

function c10181.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c10181.rfilter,tp,LOCATION_GRAVE,0,1,nil) 
		and Duel.IsExistingMatchingCard(c10181.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler())
	local b2=Duel.IsExistingMatchingCard(c10181.rfilter,tp,LOCATION_GRAVE,0,2,nil)
		and Duel.IsExistingMatchingCard(c10181.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b3=Duel.IsExistingMatchingCard(c10181.rfilter,tp,LOCATION_GRAVE,0,3,nil)
		and Duel.IsExistingMatchingCard(c10181.filter3,tp,0,LOCATION_ONFIELD,1,nil)
	local op=3
	e:SetCategory(0)
	-- chk==0なら対象が存在するか調べるモード
	if chk==0 then return (b1 or b2 or b3) end
	
	-- 実際に対象をとる
	if (b1 or b2 or b3) then
		if b1 and b2 and b3 then
			op=Duel.SelectOption(tp,aux.Stringid(10181,0),aux.Stringid(10181,1),aux.Stringid(10181,2))
		elseif b1 and b2 and not b3 then
			op=Duel.SelectOption(tp,aux.Stringid(10181,0),aux.Stringid(10181,1))
		elseif b1 and not b2 and b3 then
			op=Duel.SelectOption(tp,aux.Stringid(10181,0),aux.Stringid(10181,2))
			if op==1 then op=2 end
		elseif not b1 and b2 and b3 then
			op=Duel.SelectOption(tp,aux.Stringid(10181,1),aux.Stringid(10181,2))+1
		elseif b1 and not (b2 and b3) then
			op=Duel.SelectOption(tp,aux.Stringid(10181,0))
		elseif b2 and not (b1 and b3) then
			op=Duel.SelectOption(tp,aux.Stringid(10181,1))+1
		else
			op=Duel.SelectOption(tp,aux.Stringid(10181,2))+2
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c10181.rfilter,tp,LOCATION_GRAVE,0,op+1,op+1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		if op==0 then
			local g=Duel.GetMatchingGroup(c10181.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,e:GetHandler())
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		elseif op==1 then
			local g=Duel.GetMatchingGroup(c10181.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
			Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
		else
			local g=Duel.GetMatchingGroup(c10181.filter3,tp,0,LOCATION_ONFIELD,nil)
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
		end
	end
	e:SetLabel(op)
end

function c10181.target_2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c10181.rfilter,tp,LOCATION_GRAVE,0,1,nil) 
		and Duel.IsExistingMatchingCard(c10181.filter3,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingMatchingCard(c10181.rfilter,tp,LOCATION_GRAVE,0,2,nil)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
	local b3=Duel.IsExistingMatchingCard(c10181.rfilter,tp,LOCATION_GRAVE,0,3,nil)
		and Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil)
	local op=3
	e:SetCategory(0)
	-- chk==0なら対象が存在するか調べるモード
	if chk==0 then return (b1 or b2 or b3) end
	
	-- 実際に対象をとる
	if (b1 or b2 or b3) then
		if b1 and b2 and b3 then
			op=Duel.SelectOption(tp,aux.Stringid(10181,0),aux.Stringid(10181,1),aux.Stringid(10181,2))
		elseif b1 and b2 and not b3 then
			op=Duel.SelectOption(tp,aux.Stringid(10181,0),aux.Stringid(10181,1))
		elseif b1 and not b2 and b3 then
			op=Duel.SelectOption(tp,aux.Stringid(10181,0),aux.Stringid(10181,2))
			if op==1 then op=2 end
		elseif not b1 and b2 and b3 then
			op=Duel.SelectOption(tp,aux.Stringid(10181,1),aux.Stringid(10181,2))+1
		elseif b1 and not (b2 and b3) then
			op=Duel.SelectOption(tp,aux.Stringid(10181,0))
		elseif b2 and not (b1 and b3) then
			op=Duel.SelectOption(tp,aux.Stringid(10181,1))+1
		else
			op=Duel.SelectOption(tp,aux.Stringid(10181,2))+2
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c10181.rfilter,tp,LOCATION_GRAVE,0,op+1,op+1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		if op==0 then
			local g=Duel.GetMatchingGroup(c10181.filter3,tp,0,LOCATION_ONFIELD,nil)
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
		elseif op==1 then
			Duel.SetTargetPlayer(tp)
			Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,LOCATION_HAND)
		else
			local g=Duel.SelectTarget(tp,c10181.filter5,tp,0,LOCATION_MZONE,1,1,nil)
			Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
		end
	end
	e:SetLabel(op)
end

function c10181.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==3 then return end
	if e:GetLabel()==1 then
		-- ハンデス
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
		if g:GetCount()>0 then
			Duel.ConfirmCards(p,g)
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local sg=g:Select(p,1,1,nil)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			Duel.ShuffleHand(1-p)
		end
	elseif e:GetLabel()==2 then
		-- コントロールダッシュ
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.GetControl(tc,tp)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c10181.filter3,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
