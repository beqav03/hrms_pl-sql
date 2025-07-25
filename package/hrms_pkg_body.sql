create or replace package body hrms_pkg as
    procedure add_employee(
        p_first_name in varchar2,
        p_last_name in varchar2,
        p_email in varchar2,
        p_hire_date in date,
        p_department_id in number,
        p_job_id in number,
        p_salary in number
    ) is
        v_employee_id number;
    begin
        if p_first_name is null or p_last_name is null then
            raise_application_error(-20001, 'first name and last name are required');
        end if;
        
        if p_email is null then
            raise_application_error(-20002, 'email is required');
        end if;
        
        if p_hire_date is null then
            raise_application_error(-20003, 'hire date is required');
        end if;
        
        if p_salary < 0 then
            raise_application_error(-20004, 'salary cannot be negative');
        end if;
        
        select employee_seq.nextval into v_employee_id from dual;
        
        insert into employees (
            employee_id,
            first_name,
            last_name,
            email,
            hire_date,
            department_id,
            job_id,
            salary
        ) values (
            v_employee_id,
            p_first_name,
            p_last_name,
            p_email,
            p_hire_date,
            p_department_id,
            p_job_id,
            p_salary
        );
        
        commit;
        
    exception
        when dup_val_on_index then
            raise_application_error(-20005, 'email already exists');
        when others then
            rollback;
            raise_application_error(-20006, 'error adding employee: ' || sqlerrm);
    end add_employee;
    
    procedure update_employee(
        p_employee_id in number,
        p_first_name in varchar2,
        p_last_name in varchar2,
        p_email in varchar2,
        p_department_id in number,
        p_job_id in number,
        p_salary in number
    ) is
        v_count number;
    begin
        select count(*) into v_count
        from employees
        where employee_id = p_employee_id;
        
        if v_count = 0 then
            raise_application_error(-20007, 'employee not found');
        end if;
        
        if p_first_name is null or p_last_name is null then
            raise_application_error(-20001, 'first name and last name are required');
        end if;
        
        if p_email is null then
            raise_application_error(-20002, 'email is required');
        end if;
        
        if p_salary < 0 then
            raise_application_error(-20004, 'salary cannot be negative');
        end if;
        
        update employees
        set first_name = p_first_name,
            last_name = p_last_name,
            email = p_email,
            department_id = p_department_id,
            job_id = p_job_id,
            salary = p_salary
        where employee_id = p_employee_id;
        
        commit;
        
    exception
        when dup_val_on_index then
            raise_application_error(-20005, 'email already exists');
        when others then
            rollback;
            raise_application_error(-20008, 'error updating employee: ' || sqlerrm);
    end update_employee;
    
    procedure delete_employee(
        p_employee_id in number
    ) is
        v_count number;
    begin
        select count(*) into v_count
        from employees
        where employee_id = p_employee_id;
        
        if v_count = 0 then
            raise_application_error(-20007, 'employee not found');
        end if;
        
        delete from employees
        where employee_id = p_employee_id;
        
        commit;
        
    exception
        when others then
            rollback;
            raise_application_error(-20009, 'error deleting employee: ' || sqlerrm);
    end delete_employee;
    
    function calculate_salary(
        p_employee_id in number,
        p_bonus_percentage in number default 0
    ) return number is
        v_salary number;
        v_min_salary number;
        v_max_salary number;
        v_job_id number;
    begin
        select salary, job_id
        into v_salary, v_job_id
        from employees
        where employee_id = p_employee_id;
        
        select min_salary, max_salary
        into v_min_salary, v_max_salary
        from job_positions
        where job_id = v_job_id;
        
        v_salary := v_salary * (1 + p_bonus_percentage/100);
        
        if v_salary < v_min_salary then
            v_salary := v_min_salary;
        elsif v_salary > v_max_salary then
            v_salary := v_max_salary;
        end if;
        
        return v_salary;
        
    exception
        when no_data_found then
            raise_application_error(-20007, 'employee or job not found');
        when others then
            raise_application_error(-20010, 'error calculating salary: ' || sqlerrm);
    end calculate_salary;
end hrms_pkg;