CREATE TABLE appleStore_description_combined AS

SELECT * from appleStore_description1

UNION ALL

SELECT * from appleStore_description2

UNION ALL

SELECT * from appleStore_description3

UNION ALL

SELECT * from appleStore_description4

 ** EXPLORATORY DATA ANALYSIS**
 -- Check the number af unique apps in both tables
 
 SELECT COUNT (DISTINCT id) as UniqueAppIDs
 from AppleStore
 
 SELECT COUNT (DISTINCT id) as UniqueAppIDs
 from appleStore_description_combined
 
# quindi non ci sono valori mancanti perche in tutte e due sono risultati 7197 il numero dei id##

-- check for any missing values in key fields--

SELECT COUNT(*) as MissingValues
from AppleStore
where track_name is  NULL or user_rating is null or prime_genre is NULL

SELECT COUNT(*) as MissingValues
from appleStore_description_combined
where app_desc is NULL

## anche qui risulta 0 valori ##


---- finde out the number of apps per genre---

SELECT prime_genre, COUNT(*) as NumApps
FROM AppleStore
GROUP by prime_genre
ORDER by NumApps DESC
  
  __ get the overvew of the apps rating---
  SELECT min( user_rating) as  minrating, max( user_rating) as MaxRating, avg( user_rating) as averreting
  from AppleStore
  
  
  
  ----get the distribuition of app prices----- 
  
  SELECT track_name,
  (price /2) * 2 as PriceBinStart,
  ((price/2)*2) +2 as PriceBinEnd,
  COUNT(*) as NumApp
  from AppleStore
  GROUP by PriceBinStart, PriceBinStart
  
  
  ### finde the isights##
  -- detterminate whether paid apps have higher rating than free apps----- 
  
  SELECT CASE
            when price > 0 then ' Paid'
            ELSE 'Free'
            end as App_Type, avg(user_rating) as Avg_Rating
            
 from AppleStore
 group by App_Type
 
 --- check if app than have more language have highter rating--- 
 
 SELECT CASE
             when lang_num< 3 then '<3 languages'
             when lang_num BETWEEN 3 AND 5 then '3 to 5 languages'
             ELSE'>5 languages'
             
        end as language_bucket, avg(user_rating) as Avg_rating     
  FROM AppleStore
  GROUP by language_bucket
  ORDER by  Avg_rating DESC
  
  
  --- check genres with low ratings---
  
  SELECT prime_genre,
         avg(user_rating) as Avg_rating 
         from AppleStore
         GROUP by prime_genre
         ORDER by Avg_rating asc
   
  ----- check if there is correlation between the lenght of the app description and the user rating--- 4
  
  SELECT CASE
  when length(b.app_desc)< 500 then 'short'
  when length(b. app_desc) BETWEEN 500 and 1000 then 'medium'
  else 'long'
  end as description_lenght_bucket,
  avg(a.user_rating) as aver_rating
  FROM
       AppleStore as A 
  join 
      appleStore_description_combined as B
      
    ----- check the top rated apps for each genre----
    
 select prime_genre, track_name, user_rating
  from  (select  prime_genre, track_name, user_rating,    rank() over(partition by prime_genre ORDER by user_rating DESC, rating_count_tot DESC) as rank 
         FROM AppleStore) as A
         
         where a.rank = 1 
                  
