-- the procedure creates a table consisting of information about the most valuable players of each match and MVP statistics
drop procedure if exists get_mvps_info;
create or replace procedure get_mvps_info()
language plpgsql
as $$
declare 
	rec RECORD;
	max_goals game_skater_stats.goals%TYPE;
	max_goals_player_id game_skater_stats.player_id%TYPE;
	current_game_id game_skater_stats.game_id%TYPE;
	player varchar(50);
begin
	drop table if exists games_mvps;
	create table games_mvps(
		game_id int,
		player_id int,
		team_id int,
		timeOnice int,
		assists int,
		goals int,
		shots int,
		hits int,
		takeaways int,
		giveaws int
		);

	for current_game_id in (select distinct(game_id) from game_skater_stats) loop
		select into max_goals 0;

		for rec in (select * from game_skater_stats where game_skater_stats.game_id=current_game_id) loop
			if max_goals < rec.goals then
				select into max_goals rec.goals;
				select into max_goals_player_id rec.player_id;
			end if;
		end loop;
		select into player (select firstName || ' ' || lastName from player_info where player_id=max_goals_player_id);
		insert into games_mvps select * from game_skater_stats where game_skater_stats.game_id=current_game_id and game_skater_stats.player_id=max_goals_player_id;
		raise info 'MVP of % game is % who has scored % goals', current_game_id, player, max_goals;

	end loop;
end;
$$;

-- call get_mvps_info();
-- select * from games_mvps;