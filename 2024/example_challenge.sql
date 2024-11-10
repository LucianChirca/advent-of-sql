with childrenThatReceivedGift as (
select
	c.*
from
	children c
join christmaslist cl on
	c.child_id = cl.child_id
	and cl.was_delivered = true
),
childrenWithGiftFromCitiesWithSufficientChildren as (
select
	*
from
	childrenThatReceivedGift c
where (select count(*) from childrenThatReceivedGift c_inner where c_inner.city = c.city) >= 5),
citiesWithAverageScore as (
select
	city,
	country,
	avg(naughty_nice_score) as score
from
	childrenWithGiftFromCitiesWithSufficientChildren
group by
	country,
	city
),
rankedCities as (
select
	city,
	country,
	score,
	row_number() over (partition by country order by score desc) as rank
from
	citiesWithAverageScore
)
select
	city,
	country,
	score
from
	rankedCities
where
	rank <= 3
order by
	score desc;
