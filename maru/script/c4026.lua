--ＣＮｏ１　ゲート・オブ・カオス・ヌメロン―シニューニャ
function c4026.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,4,c4026.ovfilter,aux.Stringid(4026,1))
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4026,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c4026.rcon)
	e1:SetTarget(c4026.rtg)
	e1:SetOperation(c4026.rop)
	c:RegisterEffect(e1)
	--No
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c4026.indval)
	c:RegisterEffect(e2)
	--selfdes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c4026.descon)
	c:RegisterEffect(e3)
end
function c4026.filter(c,e,tp)
	local code=c:GetCode()
	return ((code==4022) or (code==4023) or (code==4024) or (code==4025) or (code==4026))
end
function c4026.indval(e,c)
	return not c:IsSetCard(0x48)
end
function c4026.rcon(e)
	return Duel.IsEnvironment(4010) and e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c4026.ovfilter(c)
	return c:IsFaceup() and c:IsCode(4022)
end
function c4026.descon(e)
	return not Duel.IsEnvironment(4010)
end
function c4026.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c4026.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 and c:IsRelateToEffect(e) and c:IsControler(tp) then
		local tc=g:GetFirst()
		local atk=0
			while tc do
				local tatk=tc:GetAttack()
				if tc==c then
					if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then atk=atk+tatk end
				else if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then atk=atk+tatk end
				end
				tc=g:GetNext()
			end
		--return
		local e1=Effect.CreateEffect(c)
		e1:SetLabel(atk)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabelObject(c)
		e1:SetCondition(c4026.retcon)
		e1:SetOperation(c4026.retop)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		Duel.RegisterEffect(e1,tp)
	end
end
function c4026.retcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c4026.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsForbidden() then Duel.SendtoGrave(tc,REASON_RULE)
		else if Duel.ReturnToField(tc) then
			if Duel.IsEnvironment(4010) then
				Duel.Damage(1-tp,e:GetLabel(),REASON_EFFECT)
			end
		end
	end
end
