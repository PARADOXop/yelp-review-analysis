
select *
from yelp_review_tb;


select *
from yelp_busi_tb;

-- while working on the project we didn't add business name (business_name) column so when working with business we didn't display name of the business
-- you can do it if you want


--1. find number of business in each category

with cte as (
select business_id, A.value as cat
from yelp_busi_tb,
lateral split_to_table (categories, ', ') A )
select cat, count(1) as business_count
from cte
group by cat
order by business_count desc, CAT;




--2. find the top 1- users who have reviewed the most businesses in the "restaurants' category




select user_id, count(distinct r.business_id) as count_review
from yelp_review_tb R
inner join yelp_busi_tb cte 
on R.business_id = cte.business_id
where user_id is not null and categories like '%Restaurants%'
group by user_id
order by count_review desc
limit 10;





--3. find the most popular category of business based on number of review



with cte as (
select business_id, A.value as cat
from yelp_busi_tb,
lateral split_to_table (categories, ', ') A 
)
select cat, count(1) as count_review
from yelp_review_tb R
inner join cte 
on R.business_id = cte.business_id
where user_id is not null 
group by cat
order by count_review desc
limit 1;




--4. find the top 3 most recent review for each business



with cte as (
select business_id, review_date, row_number() over(partition by business_id order by review_date desc) as rn
from yelp_review_tb
where review_date is not null
)
select business_id, review_date
from cte
where rn <= 3;




--5. find the month with the highest number of reviews



select month(review_date), count(1) as number_of_review
from yelp_review_tb 
group by month(review_date)
order by number_of_review desc
limit 1;



--6. find the percentage of 5-star reviews for each business


with cte as (
select business_id,
        sum(case when stars = 5 then 1 else 0 end) as five,
        count(1) as total_reviews
from yelp_review_tb
where stars is not null
group by business_id
)
select 
  business_id, 
  five * 1.0 / total_reviews * 100.0 as perc_five_stars
from cte
order by business_id, perc_five_stars desc




--7. find the top 5 most reviewed business in each city



with cte as (
select city, r.business_id, count(1) as review_cnt
from yelp_review_tb r
inner join yelp_busi_tb cte
on r.business_id = cte.business_id
group by city, r.business_id
order by 1
),
final_cte as (
select *, row_number() over(partition by city order by review_cnt desc) as rn
from cte
)
select city, business_id, review_cnt
from final_cte
where rn <= 5
order by city;





--8. find the avg rating of businesses that have at least 100 reviews



select r.business_id, avg(b.stars) as avg_rating 
from yelp_review_tb r
inner join yelp_busi_tb b
on r.business_id = b.business_id
where review_text is not null
group by r.business_id
having count(1) >= 100 



--9. list the top 10 users who have written the most reviews, along with the businesses they reviewed




with cte as (
select user_id, count(1) as review_count
from yelp_review_tb 
group by user_id
order by review_count desc
limit 10
)
select user_id, business_id
from yelp_review_tb 
where user_id in (select user_id from cte)
group by 1, 2
order by user_id 


