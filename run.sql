-- function call:
select get_players_goals_for_season(8476906);

-- procedure call:
call get_mvps_info();
select * from games_mvps;

-- update initiation to invoke the trigger
update player_info set lastName = 'Verner' where player_id=8466148;
update player_info set lastName = 'Fossel' where player_id=8470607;
select * from players_audits;