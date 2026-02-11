													# Data Cleaning
-- 1. Remove duplicate.(If there is any)
-- 2. Standardized The data (Finding issues like spillings or spaces in my data and fixing it).
-- 3. Null values or blank Values.
-- 4. Remove any Columns or Rows.

select * from layoffs;

create table layoffs_staging
like layoffs;

select * from layoffs_staging;

insert into layoffs_staging
select * from layoffs;

								-- 1. Remove duplicate.(If there is any)

select * , row_number () 
over (partition by company,location,industry,total_laid_off,percentage_laid_off,
`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging
order by row_num desc;

with duplicate_cte as
(
select * , row_number () 
over (partition by company,location,industry,total_laid_off,percentage_laid_off,
`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging
)
select * from duplicate_cte where row_num >1;

select * from layoffs_staging			
where company = 'Casper';				

select * from layoffs_staging
where company = 'Yahoo';

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs_staging2;

insert into layoffs_staging2
 select * , row_number () 
over (partition by company,location,industry,total_laid_off,percentage_laid_off,
`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging;

select * from layoffs_staging2
where row_num > 1;

delete from layoffs_staging2
where row_num > 1;

											-- 2. Standardized The data 
select * from layoffs_staging2;

select distinct company 
from layoffs_staging2
order by 1;

update layoffs_staging2
set company = 'Ali Express Russia' where company = 'AliExpress Russia' ;

select company ,trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select * from layoffs_staging2;

select distinct location from layoffs_staging2
order by 1;

select distinct location , trim(trailing '.' from location)
from layoffs_staging2
order by 1;

update layoffs_staging2
set location = trim(trailing '.' from location)
where location like 'Washington D.C%';

select distinct industry from layoffs_staging2;

select * 
from layoffs_staging2
where industry like 'crypto%';

update layoffs_staging2
set industry = 'crypto' where industry like 'crypto%';

select distinct country from layoffs_staging2
order by 1; 

select distinct country 
from layoffs_staging2  
where  country like 'united state%';   

select distinct country , trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing'.' from country)
where country like 'united state%';

select distinct stage from layoffs_staging2;

---- Fixing `Date`

select `date` from layoffs_staging2;

select `date` ,str_to_date(date , '%m/%d/%Y') 
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(date , '%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date;


										-- 3. Null values or blank Values


select *
from layoffs_staging2
where stage is null ;

update layoffs_staging2
set stage = 'Unknown' where stage is null;

select distinct stage from layoffs_staging2;

select distinct industry from layoffs_staging2;

select *
from layoffs_staging2
where industry is null 
or industry = '';

select *
from layoffs_staging2
where company = 'airbnb';

update layoffs_staging2
set industry = null
where industry = '';

select * from layoffs_staging2
where industry is null or industry = '';

select *
from layoffs_staging2
where company like 'bally%';

select * 
from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
	and t1.location = t2.location
where t1.industry is null  
and t2.industry is not null;

select t1.industry, t2.industry 
from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
	and t1.location = t2.location
where t1.industry is null
and t2.industry is not null;

update layoffs_staging2 t1
	join layoffs_staging2 t2
	on t1.company = t2.company
	and t1.location = t2.location
set t1.industry = t2.industry
	where t1.industry is null
	and t2.industry is not null;

										-- 4. Remove any Columns or Rows

select * 
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete 
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

alter table layoffs_staging2
drop column row_num;

select * from layoffs_staging2;
 



------------------------------------------------------------------------------------------------------------------


