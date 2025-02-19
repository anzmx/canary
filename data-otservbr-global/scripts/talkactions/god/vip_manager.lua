local vipGod = TalkAction("/vip")

local config = {
	minDays = 1, -- minimum number of days that can be added
	maxDays = 90 -- maximum days that can be added
}

function vipGod.onSay(player, words, param)
	if not configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) then
		player:sendCancelMessage('Vip System are not enabled!')
		return false
	end

	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	-- create log
	logCommand(player, words, param)

	local params = param:split(',')
	local action = params[1]:trim():lower()
	local targetName = params[2]:trim()
	local target = Player(targetName)

	if not action or not targetName then
		player:sendTextMessage(MESSAGE_INFO_DESCR, 'Command invalid.\nUsage:\n/vip <action>, <name>, [, <value>]\n\nAvailable actions:\ncheck, adddays, addinfinite, removedays, remove')
		return false
	end

	if not target then
		player:sendTextMessage(MESSAGE_INFO_DESCR, string.format('Player "%s" is not online or does not exist!', targetName))
		return false
	end
	local targetVipDays = target:getVipDays()
	targetName = target:getName()

	if action == "check" then
		player:sendTextMessage(MESSAGE_STATUS, string.format('"%s" has %s VIP day(s) left.', targetName, (targetVipDays == 0xFFFF and 'infinite' or targetVipDays)))
	elseif action == "adddays" then
		local amount = tonumber(params[3])
		if not amount or amount <= 0 then
			player:sendCancelMessage('<value> has to be a numeric value.')
			return false
		end

		if amount < config.minDays or amount > config.maxDays then
			player:sendTextMessage(MESSAGE_INFO_DESCR, string.format('You can only add %d to %d VIP days at a time.', config.minDays, config.maxDays))
			target:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
			return false
		end

		target:addVipDays(amount)
		player:sendTextMessage(MESSAGE_STATUS, string.format('"%s" received %d VIP day(s) and now has %d VIP day(s)', targetName, amount, target:getVipDays()))
		target:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	elseif action == 'addinfinite' then
		target:addInfiniteVip()
		player:sendTextMessage(MESSAGE_STATUS, string.format('%s now has infinite vip time.', targetName))
		target:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	elseif action == 'removedays' then
		local amount = tonumber(params[3])
		if not amount then
			player:sendTextMessage(MESSAGE_INFO_DESCR, '<value> has to be a numeric value.')
			return false
		end
		if amount > targetVipDays then
			target:removeVip()
			player:sendTextMessage(MESSAGE_STATUS, string.format('You removed all vip days from %s.', targetName))
			target:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		else
			target:removeVipDays(amount)
			player:sendTextMessage(MESSAGE_STATUS, string.format('%s lost %s vip day(s) and now has %s vip day(s).', targetName, amount, target:getVipDays()))
		end
	elseif action == 'remove' then
		target:removeVip()
		player:sendTextMessage(MESSAGE_STATUS, string.format('You removed all vip days from %s.', targetName))
		target:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	else
		player:sendTextMessage(MESSAGE_INFO_DESCR, 'Action is required.\nUsage:\n/vip <action>, <name>, [, <value>]\n\nAvailable actions:\ncheck, adddays, addinfinite, removedays, remove')
		return false
	end
	return true
end

vipGod:separator(" ")
vipGod:register()
