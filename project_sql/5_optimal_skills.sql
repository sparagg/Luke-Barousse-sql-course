/*
Answer: what are the most optimal skills to learn (aka it's in high demand and high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
-concentrate on remote positions with specified salaries
-Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
offering strategic insights for career development in data analysis
*/


WITH skills_demand as (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        count(skills_job_dim.job_id) as demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' 
        AND job_postings_fact.salary_year_avg is not null
        AND job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
), average_salary as  (
    SELECT
        skills_dim.skill_id,
        ROUND (AVG(salary_year_avg), 0) as average_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' 
        AND job_postings_fact.salary_year_avg is not null
        AND job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    average_salary
FROM
    skills_demand
INNER JOIN average_salary on skills_demand.skill_id = average_salary.skill_id
WHERE demand_count > 10
ORDER BY 
    demand_count DESC,
    average_salary DESC
        
limit 25


-- same query rewritten in a more simplified  concise manner and focusing on salary

 SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        count(skills_job_dim.job_id) as demand_count,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) as average_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' 
        AND job_postings_fact.salary_year_avg is not null
        AND job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
    Having
        COUNT(skills_job_dim.job_id) > 10
    ORDER BY
        average_salary DESC,
        demand_count DESC
        
    LIMIT 25