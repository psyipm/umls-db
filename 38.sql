create or replace function create_agent()
	returns trigger
	as
	$body$
	declare
		v_name varchar[];
	begin

	v_name = regexp_split_to_array(NEW.name, E'\\s+');

	insert into agents(name_f, name_n, name_o, user_id)
	values(v_name[1], v_name[2], v_name[3], NEW.id);

	return NEW;
	end;
	$body$
	LANGUAGE plpgsql;


create trigger tr_create_agent
	after insert on users
	for each row
	execute procedure create_agent();