-- Tasks #79


alter table object_states add column event_code integer default 500 not null;
comment on column object_states.event_code is 'код события для записи в лог';

update object_states set event_code = 505 where code = 1;
update object_states set event_code = 506 where code = 2;
update object_states set event_code = 507 where code = 3;
update object_states set event_code = 508 where code = 4;