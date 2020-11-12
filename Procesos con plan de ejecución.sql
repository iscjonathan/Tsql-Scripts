--Author: Jonathan Gabriel Nava
--Correo: iscjonathan@hotmail.com para cualquier duda o comentario

--Descripción: Revisar los procesos que se están ejecutando en nuestra base de datos, además de mostrar el plan de ejecución de cada consulta, 
--para poder ver temas de rendimiento de las consultas

SELECT 
    r.session_id, 
    r.status, 
    c.client_net_address, 
    s.name, 
    [host_name], 
    r.command, 
    t.text,
    DB_NAME(r.database_id) AS DatabaseName, 
    se.cpu_time, 
    se.total_elapsed_time, 
    se.login_time, 
    se.lock_timeout,
    qp.query_plan
FROM 
    sys.sysusers s
    JOIN sys.dm_exec_requests r ON s.uid = r.user_id
    CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
    JOIN sys.dm_exec_connections c ON c.session_id = r.session_id
    JOIN sys.dm_exec_sessions se ON se.session_id = r.session_id
    CROSS APPLY sys.dm_exec_query_plan(plan_handle) as qp
WHERE 
    se.is_user_process = 1
    AND r.session_id <> @@SPID
