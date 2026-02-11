-- Exploratory data analysis

select * from layoffs_staging2;

select max(total_laid_off),max(total_laid_off),count(total_laid_off),avg(total_laid_off)
from layoffs_staging2;

select max(percentage_laid_off),max(percentage_laid_off),count(percentage_laid_off),avg(percentage_laid_off)
from layoffs_staging2;

select max(total_laid_off),max(percentage_laid_off) 
from layoffs_staging2;

select * from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

select * from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

select * from layoffs_staging2
where percentage_laid_off = 1 and country = 'united states';

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select max(`date`),min(`date`)
from layoffs_staging2;

select `date`, sum(total_laid_off)
from layoffs_staging2
group by `date`
order by 1 desc;

select month(`date`), sum(total_laid_off)
from layoffs_staging2
where month(`date`) is not null
group by month(`date`)
order by 1;

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

# Rollint sum of laid off based of the months

select substring(`date`,1,7) as `Month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date` , 1,7) is not null
group by `Month`
order by 1;

with rolling_off as
(select substring(`date`,1,7) as `Month`, sum(total_laid_off) as total_laid_sum
from layoffs_staging2
where substring(`date` , 1,7) is not null
group by `Month`
order by 1)
select `month`,
total_laid_sum,sum(total_laid_sum) over(order by `month`) as rolling_total
from rolling_off;

# We want to rank top 5 companies laid off the most every year.

select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;

with Company_year (company,years,total_laid_off) as
(select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
)
select *, 
dense_rank () over (partition by years order by total_laid_off desc) as Ranking
from Company_year
where years is not null
order by Ranking;

with Company_year (company,years,total_laid_off) as
(select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), company_year_rank as
(select *,
dense_rank () over (partition by years order by total_laid_off desc) as Ranking
from Company_year
where years is not null)
select * 
from company_year_rank where Ranking <=5;
---------------------------------------------------------------------------------------------------------------

