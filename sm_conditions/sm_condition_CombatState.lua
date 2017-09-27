-- CombatState check condition
local sm_condition_combatstate = class('CombatState', sm_condition)
sm_condition_combatstate.uid = "CombatState"
sm_condition_combatstate.targets = { [1] = GetString("Player is"), [2] = GetString("Target is"), [3] = GetString("Friend is"),  }
sm_condition_combatstate.operators = { [1] = GetString("In Combat"), [2] = GetString("Not In Combat"),  }
-- Initialize new class, - gets called when :new(..) is called
function sm_condition_combatstate:initialize(data)
	self.target = data.target or 1
	self.operator = data.operator or 1
end
-- Save  the condition data into a table and returns that
function sm_condition_combatstate:Save()
	local data = {}
	data.target = self.target
	data.operator = self.operator
	return data
end
-- Evaluates the condition, returns "true" / "false"
function sm_condition_combatstate:Evaluate(context)
	local state 
	if ( self.target == 1 and context.player ) then
		state = context.player.incombat
	elseif ( self.target == 2 and context.attack_target ) then
		state = context.attack_target.isaggro or context.attack_target.hp.percent < 100 or context.attack_target.incombat
	elseif ( self.target == 3 and context.heal_target ) then
		state = context.heal_target.incombat or context.heal_target.hp.percent < 100
	end
	if (state) then
		if ( self.operator == 1 ) then return state == true
		elseif ( self.operator == 2 ) then return state == false
		end		
	end
	return false
end
-- Renders the condition data into UI, for "presentation" in the SkillManager's Condition Builder. Returns "true" when stuff changed, for saving
function sm_condition_combatstate:Render(id) -- need to pass an index value here, for the unique IDs used by imgui	
	local modified
	local changed
	GUI:PushItemWidth(100)
	self.target, changed = GUI:Combo("##sm_condition_combatstate"..tostring(id),self.target, self.targets)
	if ( changed ) then modified = true end
	GUI:PopItemWidth()	
	
	GUI:PushItemWidth(150)
	GUI:SameLine()
	self.operator, changed = GUI:Combo("##sm_condition_combatstate2"..tostring(id),self.operator, self.operators)
	if ( changed ) then modified = true end
	GUI:PopItemWidth()
	
	return modified
end
SkillManager:AddCondition(sm_condition_combatstate)