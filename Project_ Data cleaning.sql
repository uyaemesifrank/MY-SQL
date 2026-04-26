-- Data Cleaning

select *
from layoffs;

-- 1. Remove duplicates
-- 2. Standardize the data
-- 3. Null values or blank Values
-- 4. Remove any columnst or row

Create Table layoffs_staging
like layoffs;

select *
from layoffs_staging;

SELECT *, COUNT(*)
FROM layoffs_staging2
GROUP BY company, country, location, industry, percentage_laid_off,total_laid_off, date, stage, funds_raised_millions, row_num
HAVING COUNT(*) > 1;


insert layoffs_staging
select *
from layoffs;

select *,
row_number() over (
partition by company, industry, total_laid_off, percentage_laid_off, `date` ) as row_num
from layoffs_staging;

with duplicate_cte as
(
select *,
row_number() over (
partition by company, industry, location, total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions ) as row_num
from layoffs_staging
)
delete
 from duplicate_cte
 where row_num > 1;
 
 
 select *
 from layoffs_staging
 where company = 'Casper';



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

Select * 
from layoffs_staging2;

insert into layoffs_staging2
select *,
row_number() over (
partition by company, industry, location, total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions ) as row_num
from layoffs_staging;

Delete 
from layoffs_staging2
where row_num > 1;

select count(*)
from layoffs_staging2;

select *
from layoffs_staging2
where row_num > 1;


-- Standardizing Data

select company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company)
order by 1;

select distinct industry
from layoffs_staging2
order by 1

;

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%' ;

select *
from layoffs_staging2
where industry like 'Crypto%' ;

Select distinct country, trim( trailing '.' from country)
from layoffs_staging2 
order by 1 desc 

;
update layoffs_staging2
set country = trim( trailing '.' from country)

;

select `date`,
str_to_date(`date` , '%m/%d/%Y')

from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date` , '%m/%d/%Y')
;
select `date`
from layoffs_staging2;


Alter table layoffs_staging2
modify column `date` date;

DELETE FROM layoffs_staging2
WHERE row_num > 1;

select *
from layoffs_staging2
where total_laid_off is null 
and percentage_laid_off is NULL ;

DELETE 
from layoffs_staging2
where total_laid_off is null 
and percentage_laid_off is NULL ;

update layoffs_staging2
SET industry = NULL
where industry = '';

select *
from layoffs_staging2
where industry is null
or  industry = '';

select *
from layoffs_staging2
where company = 'Bally%';

select t1.industry, t2.industry
from layoffs_staging2 t1
join	layoffs_staging2 t2
	 on t1.company = t2.company
     and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2 t1
join	layoffs_staging2 t2
	 on t1.company = t2.company
SET t1.industry = t2.industry
where ( t1.industry is null )
and t2.industry is not null;

select *
from layoffs_staging2;

alter table layoffs_staging2
drop column row_num;


