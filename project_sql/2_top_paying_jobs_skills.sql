/*
question: what skills are required for the top paying data analyst jobs?
-use the top 10 highest paying Analyst jobs from first query
-add the specific skills required for these roles
-Why? It provides a detailed look at which high-paying jobs demand certain skills,helping job seekers
understand which skills to develop that align with top salaries
*/

WITH top_paying_jobs as(
    SELECT
        job_id,
        company_dim.name as Company_name,
        job_title,
        salary_year_avg,
        job_location
    FROM
        job_postings_fact
    LEFT JOIN company_dim on job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location LIKE '%IL%' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    skills_dim.skills,
    top_paying_jobs.*
FROM top_paying_jobs
INNER JOIN skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC

/*
Most Frequently Mentioned Skills:

SQL appears most frequently, listed in 5 roles, with an average salary of $165,000.
Tableau follows with 4 roles, averaging $172,500.
High-Demand and High-Value Skills:

AWS and Python are tied in demand (3 jobs each) with average salaries of $175,000 and $150,000, respectively.
Oracle is listed twice but commands a higher average salary of $187,500.
Exceptional High-Paying Skills:

Alteryx, Azure, and DB2 are the highest-paying skills, each offering an average salary of $225,000, though they appear in only one job.
*/