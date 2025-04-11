select * 
from yelp_BUS
limit 100;


create or replace table yelp_review_tb as
select 
        review_text: business_id:: string as business_id, 
        review_text: user_id:: string as user_id,
        review_text: date:: date as review_date,
        review_text: stars:: number as stars,
        review_text: text:: string as review_text
from yelp_reviews;

create or replace table yelp_busi_tb as
select 
        BUSINESS_TEXT: business_id:: string as business_id, 
        BUSINESS_TEXT: name:: string as business_name, 
        BUSINESS_TEXT: city:: string as city,
        BUSINESS_TEXT: state:: string as state,
        BUSINESS_TEXT: review_count:: int as review_count,
        BUSINESS_TEXT: stars:: int as stars,
        BUSINESS_TEXT: categories:: string as categories
from yelp_bus;



select count(*)
from yelp_review_tb;


select count(1) as cnt
from yelp_busi_tb;
