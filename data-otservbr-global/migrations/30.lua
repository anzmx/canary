function onUpdateDatabase()
	Spdlog.info("Updating database to version 31 (wheel of destiny)")
	db.query([[
	CREATE TABLE IF NOT EXISTS `player_wheeldata` (
		`player_id` int(11) NOT NULL,
		`slot` blob NOT NULL,
		INDEX `player_id` (`player_id`),
		CONSTRAINT `player_wheeldata_players_fk`
			FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
			ON DELETE CASCADE
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])
	Spdlog.info("Updating database to version 31 (create vip system columns)")
	db.query(
		[[
			ALTER TABLE `accounts`
				ADD COLUMN `vipdays` int(11) NOT NULL DEFAULT 0 AFTER `lastday`,
				ADD COLUMN `viplastday` int(10) NOT NULL DEFAULT 0 AFTER `vipdays`;
		]]
	)
	return true
end
