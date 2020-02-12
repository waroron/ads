--RR-レトロフィット・レイニアス
function c4009.initial_effect(c)
	--copy name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c4009.sptg)
	e1:SetOperation(c4009.spop)
	c:RegisterEffect(e1)
	--xyz summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)	
	e2:SetOperation(c4009.op)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(4009)
	c:RegisterEffect(e3)
end
function c4009.spfil(c)
	return c:IsFaceup() and c:IsSetCard(0xba) and not c:IsType(TYPE_XYZ)
end
function c4009.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c4009.spfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c4009.spfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c4009.spfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c4009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) then
		local code=tc:GetOriginalCode()
		local lv=tc:GetLevel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(lv)
		c:RegisterEffect(e2)
	end
end
function c4009.filterx(c)
	return c:IsSetCard(0xba) and c:IsType(TYPE_XYZ) and c.xyz_count and c.xyz_count>0
end
function c4009.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c4009.filterx,c:GetControler(),LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local tc=g:GetFirst()
	while tc do
		local tck=Duel.CreateToken(tp,4009)
		if tc:GetFlagEffect(4009)==0 then
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetDescription(aux.Stringid(4009,0))
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e1:SetRange(LOCATION_EXTRA)
			e1:SetValue(SUMMON_TYPE_XYZ)
			e1:SetCondition(c4009.xyzcon)
			e1:SetOperation(c4009.xyzop)
			e1:SetLabelObject(tck)
			e1:SetReset(RESET_EVENT+EVENT_ADJUST)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(4009,RESET_EVENT+EVENT_ADJUST,0,1) 	
		end
		tc=g:GetNext()
	end
end
function c4009.doublefilter(c,rk,xyz)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyz) and c:IsXyzLevel(xyz,rk) and c:IsType(TYPE_MONSTER)
	and c:IsHasEffect(4009) and not c:IsType(TYPE_XYZ)
end
function c4009.notgafilter(c,rk,xyz)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyz) and c:IsXyzLevel(xyz,rk) and c:IsType(TYPE_MONSTER)
	and not c:IsHasEffect(4009) and not c:IsType(TYPE_XYZ)
end
function c4009.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local rk=c:GetRank()
	local ct=c.xyz_count
	local mg=Duel.GetMatchingGroup(c4009.doublefilter,tp,LOCATION_ONFIELD,0,nil,rk,c)
	local mg2=Duel.GetMatchingGroup(c4009.notgafilter,tp,LOCATION_ONFIELD,0,nil,rk,c)
	return mg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and mg:GetCount()*2+mg2:GetCount()>=ct
end
function c4009.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local c=e:GetHandler()
	local rk=c:GetRank()
	local ct=c.xyz_count
	local mg=Duel.GetMatchingGroup(c4009.doublefilter,tp,LOCATION_ONFIELD,0,nil,rk,c)
	local mg2=Duel.GetMatchingGroup(c4009.notgafilter,tp,LOCATION_ONFIELD,0,nil,rk,c)
	mg:Merge(mg2)
	local g1=Group.CreateGroup()
	g1:KeepAlive()
	while ct>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local gc=mg:Select(tp,1,1,nil):GetFirst()
		g1:AddCard(gc)
		mg:RemoveCard(gc)
		if gc:IsHasEffect(4009) then
			if gc:IsHasEffect(4009) and (mg:GetCount()<=1 or Duel.SelectYesNo(tp,aux.Stringid(4009,1)))  then
				ct=ct-1
			end
		end
		ct=ct-1
	end
	local sg=Group.CreateGroup()
	local tc=g1:GetFirst()
	while tc do
		local sg1=tc:GetOverlayGroup()
		sg:Merge(sg1)
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g1)
	Duel.Overlay(c,g1)
end
function c4009.effectcon(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(4009)==0 or c:IsHasEffect(EFFECT_CANNOT_DISABLE)
end