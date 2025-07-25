create or replace package hrms_pkg as
    procedure add_employee(
        p_first_name in varchar2,
        p_last_name in varchar2,
        p_email in varchar2,
        p_hire_date in date,
        p_department_id in number,
        p_job_id in number,
        p_salary in number
    );
    
    procedure update_employee(
        p_employee_id in number,
        p_first_name in varchar2,
        p_last_name in varchar2,
        p_email in varchar2,
        p_department_id in number,
        p_job_id in number,
        p_salary in number
    );
    
    procedure delete_employee(
        p_employee_id in number
    );
    
    function calculate_salary(
        p_employee_id in number,
        p_bonus_percentage in number default 0
    ) return number;
end hrms_pkg;