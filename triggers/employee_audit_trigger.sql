create or replace trigger employee_audit_trigger
after insert or update or delete on employees
for each row
declare
    v_operation varchar2(10);
    v_log_id number;
    v_record_id number;
begin
    if inserting then
        v_operation := 'insert';
        v_record_id := :new.employee_id;
    elsif updating then
        v_operation := 'update';
        v_record_id := :new.employee_id;
    elsif deleting then
        v_operation := 'delete';
        v_record_id := :old.employee_id;
    end if;
    
    select audit_log_seq.nextval into v_log_id from dual;
    
    insert into audit_log (
        log_id,
        table_name,
        operation,
        record_id,
        changed_by
    ) values (
        v_log_id,
        'employees',
        v_operation,
        v_record_id,
        user
    );
    
exception
    when others then
        raise_application_error(-20011, 'error in audit trigger: ' || sqlerrm);
end;