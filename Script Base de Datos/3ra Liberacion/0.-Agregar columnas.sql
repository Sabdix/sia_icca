 use IICA_1
 go
 IF not EXISTS (SELECT column_name 
                 FROM information_schema.columns 
                 WHERE
                   table_name='DT_TBL_PERMISO' 
                   and column_name='path_formato_autorizacion') 
    alter table DT_TBL_PERMISO add path_formato_autorizacion varchar(200)



 IF not EXISTS (SELECT column_name 
                 FROM information_schema.columns 
                 WHERE
                   table_name='DT_TBL_VACACIONES' 
                   and column_name='path_formato_autorizacion') 
    alter table DT_TBL_VACACIONES add path_formato_autorizacion varchar(200)