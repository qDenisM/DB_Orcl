SELECT SUM(VALUE) FROM V$SGA;

SELECT * FROM V$SGA;

SELECT component, granule_size from v$sga_dynamic_components;

SELECT * from v$sga_dynamic_free_memory;

SELECT SUM(MAX_SIZE), SUM(CURRENT_SIZE) FROM v$sga_dynamic_components;

SELECT component, min_size, current_size, max_size FROM v$sga_dynamic_components
WHERE component like '%cache%';

create table xxx(k int) storage(buffer_pool keep) tablespace users;

insert into xxx values(1);
commit;

select segment_name, segment_type, tablespace_name, buffer_pool from user_segments
where segment_name in ('XXX');

create table yyy(k int) tablespace users;

insert into yyy values(1);
commit;

select segment_name, segment_type, tablespace_name, buffer_pool from user_segments
where segment_name in ('YYY');

select name, value from v$sysstat where name like '%redo%retries%';

SELECT pool, name, bytes
FROM v$sgastat 
WHERE pool = 'large pool' AND name = 'free memory';

SELECT username, sid, server 
FROM v$session
WHERE username is not null;

SELECT name, description, paddr
FROM v$bgprocess
WHERE paddr != hextoraw('00');

SELECT sid, process, program 
FROM v$session 
WHERE type = 'USER';

SELECT COUNT(*)
FROM v$bgprocess ы
WHERE name LIKE 'DBW%';

SELECT name, network_name 
FROM v$services;

SELECT name, value 
FROM v$parameter 
WHERE name LIKE '%dispatchers%';