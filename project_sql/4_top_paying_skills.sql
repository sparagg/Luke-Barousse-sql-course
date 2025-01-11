/*
question: what are the top paying skills based on salary?
- look at the average salary associated with each skill for data analyst positions
-focuses on roles with specified salaries, in Illinois
-WHy? it reveals ho different skills impact salary levels for data analysts and helps identify
    the most financially rewarding skills to acquire or improve
*/


SELECT
    skills,
    ROUND (AVG(salary_year_avg), 0) as average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND job_postings_fact.salary_year_avg is not null
    AND job_location LIKE '%IL%'
GROUP BY
    skills_dim.skills
ORDER BY
    average_salary DESC
Limit 25