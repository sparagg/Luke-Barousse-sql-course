-- case expressions problems

--problem 1

SELECT  
    job_id,
    job_title,
    salary_year_avg,
    CASE
        WHEN salary_year_avg > 100000 THEN 'high salary' 
        when salary_year_avg BETWEEN 60000 and 99999 THEN 'standard salary' -- dont need the parenthesis for numbers
        WHEN salary_year_avg < 60000 then 'low salary' 
        --ELSE 'low salary' -- wrong , should end it above when statement
    END as salary_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst' and salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC ;-- forgot desc

-- problem 2

SELECT
    *
FROM job_postings_fact
limit 200;

SELECT
    COUNT (DISTINCT company_id),
    CASE
        WHEN job_work_from_home = 'true' then 'work_from_home'
        ELSE 'on site'
    END as WFH_policy
FROM job_postings_fact
GROUP BY job_work_from_home  --- incorrect should be separating wfh and nonwfh columns but at least you got the same results see below


/*SELECT 
    COUNT(DISTINCT CASE WHEN job_work_from_home = TRUE THEN company_id END) AS wfh_companies,
    COUNT(DISTINCT CASE WHEN job_work_from_home = FALSE THEN company_id END) AS non_wfh_companies
FROM job_postings_fact;*/



-- problem 3

SELECT
    job_id,
    salary_year_avg,
    job_title,
    CASE 
        WHEN job_title ILIKE '%senior%' THEN 'SENIOR'
        WHEN job_title ILIKE '%manager%' or job_title ILIKE '%lead%' then 'Lead/Manager' -- forgot to include job_title after OR
        -- WHEN job_title ILIKE '%lead%' then 'Lead/Manager'
        WHEN job_title ILIKE '%junior%' or job_title ILIKE '%entry%'  then 'Junior/Entry'
        --WHEN job_title ILIKE '%entry%' then 'Lead/Manager'
        ELSE 'not specified'
    END as experience_level,
    CASE
        WHEN job_work_from_home = 'TRUE' THEN 'yes'
        ELSE 'no'
    END as remote_job
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY job_id ;
