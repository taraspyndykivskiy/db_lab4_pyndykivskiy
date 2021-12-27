--trigger invokes automatically when a 'lastName' in 'player_info' table is updated 
--and logs changes and time they were made into another table

drop function if exists log_name_changes cascade;

drop table if exists players_audits;
create table players_audits(
	change_id serial,
	plr_id int not null,
	prev_lastName varchar(20) not null,
	cur_lastName varchar(20) not null,
	changed timestamp(6) not null
);

drop function if exists log_last_name_changes cascade;
create or replace function log_last_name_changes()
	returns trigger
	language plpgsql
as
$$
begin

	RAISE NOTICE 'Called % % on %',	TG_WHEN, TG_OP, TG_TABLE_NAME;
	raise info 'old last name : %', old.lastName;	
	raise info 'new last name : %', new.lastName;	

	if (new.lastName <> old.lastName) then
		
		insert into players_audits(plr_id, prev_lastName, cur_lastName, changed)
		values (old.player_id, old.lastName, new.lastName, now());

	end if;
	return new;
end;
$$;

drop trigger if exists last_name_changes on player_info;
create trigger last_name_changes
	before update
	on player_info
	for each row 
	execute procedure log_last_name_changes();


-- update player_info	set lastName = 'Verner' where player_id=8466148;
-- update player_info set lastName = 'Fossel' where player_id=8470607;

-- select * from players_audits;