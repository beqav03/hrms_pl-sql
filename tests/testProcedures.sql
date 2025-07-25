-- test cases for hrms_pl-sql procedures

declare
    -- variables for employee data
    v_employee_id number;
    v_first_name varchar2(50) := 'john';
    v_last_name varchar2(50) := 'doe';
    v_email varchar2(100) := 'john.doe@example.com';
    v_phone_number varchar2(20) := '123-456-7890';
    v_job_id number := 1; -- assuming job_id 1 exists
    v_salary number := 50000;
    v_department_id number := 10; -- assuming department_id 10 exists

    -- variables for updated salary
    v_new_salary number := 55000;

begin
    -- test add_employee procedure
    begin
        add_employee(v_first_name, v_last_name, v_email, v_phone_number, v_job_id, v_salary, v_department_id);
        dbms_output.put_line('add_employee executed successfully');
    exception
        when others then
            dbms_output.put_line('add_employee failed: ' || sqlerrm);
    end;

    -- test update_employee_salary procedure
    begin
        -- assuming employee_id is known after insertion
        v_employee_id := 1001; -- replace with actual employee_id
        update_employee_salary(v_employee_id, v_new_salary);
        dbms_output.put_line('update_employee_salary executed successfully');
    exception
        when others then
            dbms_output.put_line('update_employee_salary failed: ' || sqlerrm);
    end;

    -- test delete_employee procedure
    begin
        -- assuming employee_id is known
        delete_employee(v_employee_id);
        dbms_output.put_line('delete_employee executed successfully');
    exception
        when others then
            dbms_output.put_line('delete_employee failed: ' || sqlerrm);
    end;

    -- test trg_employee_changes trigger
    begin
        -- insert a new employee to test trigger
        insert into employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, department_id)
        values (employees_seq.nextval, 'jane', 'smith', 'jane.smith@example.com', '987-654-3210', sysdate, v_job_id, v_salary, v_department_id);
        commit;
        dbms_output.put_line('insert operation executed to test trg_employee_changes trigger');
    exception
        when others then
            dbms_output.put_line('insert operation failed: ' || sqlerrm);
    end;

    -- test utility procedures
    begin
        -- assuming utility procedures like log_error exist
        log_error('test error message');
        dbms_output.put_line('log_error executed successfully');
    exception
        when others then
            dbms_output.put_line('log_error failed: ' || sqlerrm);
    end;

    -- test email alert procedure
    begin
        -- assuming email_alert procedure exists
        email_alert('recipient@example.com', 'Test Subject', 'Test Body');
        dbms_output.put_line('email_alert executed successfully');
    exception
        when others then
            dbms_output.put_line('email_alert failed: ' || sqlerrm);
    end;

    -- test scheduled job procedure
    begin
        -- assuming create_scheduled_job procedure exists
        create_scheduled_job('test_job', 'begin null; end;', sysdate, sysdate + 1);
        dbms_output.put_line('create_scheduled_job executed successfully');
    exception
        when others then
            dbms_output.put_line('create_scheduled_job failed: ' || sqlerrm);
    end;

    -- test bulk insert procedure
    begin
        -- assuming bulk_insert_employees procedure exists
        bulk_insert_employees;
        dbms_output.put_line('bulk_insert_employees executed successfully');
    exception
        when others then
            dbms_output.put_line('bulk_insert_employees failed: ' || sqlerrm);
    end;

end;