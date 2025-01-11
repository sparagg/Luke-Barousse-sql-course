/* Question: What are the top paying data analyst jobs?
- Identify the tip 10 highest-paying  data analyst roles that are available locally.
- focus on job postings with specified salaries (remove nulls).
- Why? Hightlight the top-paying opportunities for Data Analysts, offering insights into emplo
*/


SELECT
    job_id,
    company_dim.name as Company_name,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN company_dim on job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short iLIKE '%analyst%' AND
    job_location LIKE '%IL%' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
