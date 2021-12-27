-- the function returns number of goals scored by a player during the whole season
drop function if exists get_players_goals_for_season;
create or replace function get_players_goals_for_season(plr_id int)
	returns int
	language plpgsql
as
$$
declare
	goals_stats game_skater_stats.goals%TYPE;
begin
select sum(goals) into goals_stats from game_skater_stats where game_skater_stats.player_id=plr_id;
return goals_stats;
end;
$$;

-- select get_players_goals_for_season(8476906);