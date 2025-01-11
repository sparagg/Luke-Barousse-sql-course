# Introduction

Dive into the data job market. focusing on data analyst roles, salary range, in-demand skills,  and where high demand meets high salary in data analytics.

SQL Query Details:
[project_sql folder](/project_sql/)

# Background
This project was the beginning of my path in changing my careers. It was also a way to further my understanding of sql. 
Additionally, this was to help navigate the data analyst job market more effectively. I wanted to understand what the most in-demand skills were needed, the salary range and showing the opprotunities present for different job locations.
Data Provided from [sql course](https://www.lukebarousse.com/sql). 

## The questions i wanted to answer through sql queries were:

1. What are the top paying jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I used

- **SQL:** main vehicle for querying the databases and bringing critical insights to light.
- **PostresSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** Tool for executing sql queries.
- **Git & GitHub:** version control systems for sharing SQL scripts and analysis, ensuring collaboration and tracking.

# The Analysis
Each query for this project is aimed at investigating specific aspects of the data analyst job market.
Here's how i approached each question:

### 1. Top Paying Analyst Jobs in Illinois
To identify the highest-paying roles, by filtering Analyst positions by average yearly salary and location. This query highlights the different high paying analyst positions within Illinois.
```sql
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
```

### 2. Top Paying Job skills
To understand what skills are required for the top-paying jobs in Illinois, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles. 
```sql
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
```
### 3. In-Demand Skills for Data Analysts
This query helped identify the skills most frequently requested in job posings, directing focus to areas with high demand.
```sql
SELECT
    skills,
    count(skills_job_dim.job_id) as demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
Limit 5
```
### 4. Top Paying Skills
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
SELECT
    skills,
    ROUND (AVG(salary_year_avg), 0) as average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_postings_fact.salary_year_avg is not null
    AND job_work_from_home = TRUE
GROUP BY
    skills_dim.skills
ORDER BY
    average_salary DESC
Limit 25
```
### 5. Optimal Skills
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and are relatively high-paying, offering a strategic focus for skill development.
```sql
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
ORDER BY average_salary DESC,
        demand_count DESC
limit 25
```

# What I Learned
# Conclusion