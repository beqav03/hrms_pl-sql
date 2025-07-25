-- creating tables
create table departments (
    department_id number primary key,
    department_name varchar2(50) not null,
    location varchar2(100)
);

create table job_positions (
    job_id number primary key,
    job_title varchar2(50) not null,
    min_salary number(10,2),
    max_salary number(10,2)
);

create table employees (
    employee_id number primary key,
    first_name varchar2(50) not null,
    last_name varchar2(50) not null,
    email varchar2(100) unique,
    hire_date date not null,
    department_id number,
    job_id number,
    salary number(10,2),
    constraint fk_department foreign key (department_id) references departments(department_id),
    constraint fk_job foreign key (job_id) references job_positions(job_id)
);

create table audit_log (
    log_id number primary key,
    table_name varchar2(30),
    operation varchar2(10),
    record_id number,
    change_date timestamp default current_timestamp,
    changed_by varchar2(30)
);