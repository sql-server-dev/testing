if object_id('usp_search_sale','p')is not null
drop procedure usp_search_sale
go

create procedure usp_search_sale
@xml    xml

as

declare 
@handle int,
@table  sysname = 'Salesman',   -- future parameter
@column sysname,
@cllist varchar(max),
@sql    nvarchar(max)

set nocount on

exec sp_xml_preparedocument @handle output, @xml

select  col 
into    #temp
from    openxml (@handle, '/table/columns/column',2)
        with (col varchar(20) '.')

exec sp_xml_removedocument @handle

set @cllist =''

declare cr cursor
for
select  col 
from    #temp

open cr
fetch cr into @column
while @@fetch_status = 0
begin
    
    set @cllist += @column + ','

    fetch cr into @column
end
close cr
deallocate cr

set @cllist = left(@cllist, len(@cllist)-1)
set @sql = 'select ' + @cllist + ' from ' + @table

--print @sql 
set nocount off

begin try
    exec sp_executesql @sql
end try
begin catch
    declare
    @error_number   int,
    @error_message  varchar(max),
    @error_line     int,
    @msg            varchar(max),
    @error_proc     varchar(256)

    select  @error_number = error_number(),
            @error_message= error_message(),
            @error_line   = error_line(),
            @error_proc   = error_procedure()
    set @msg = 'An error number ' + cast(@error_number as varchar(6)) + ': ' + @error_message + ' occured on line ' + cast(@error_line as varchar(6)) + ' in ' + isnull(@error_proc,'') + ' procedure. '
    raiserror (@msg, 16,1)               
    return
end catch

go

execute usp_search_sale
@xml =
'
<table>
    <columns>
	    <column>name</column>
	    <column>city</column>
    </columns>
</table>
'
