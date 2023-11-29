/*2.We want to reward the user who has been around the longest, Find the 5 oldest users.*/ 

SELECT  id, username, MIN(created_at) as oldest_users FROM users 
GROUP BY id,username 
ORDER BY MIN(created_at) ASC LIMIT 5; 


/*3.To target inactive users in an email ad campaign, find the users who have never posted a photo.*/ 

SELECT users.id, users.username as inactive_users FROM users 
LEFT JOIN photos ON users.id = photos.user_id 
WHERE photos.id IS NULL; 


/*4.Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?*/ 

SELECT users.id, users.username, images.photos_id, images.total_likes FROM users 
INNER JOIN photos ON photos.user_id=users.id 
INNER JOIN  
(SELECT photos.id as photos_id ,COUNT(*) AS Total_Likes FROM likes 
JOIN photos ON photos.id = likes.photo_id GROUP BY photos.id ) 
images ON photos.id=images.photos_id 
ORDER BY total_likes DESC LIMIT 1; 


/*5.The investors want to know how many times does the average user post.*/ 

SELECT COUNT(*) FROM photos; SELECT COUNT(*) FROM users; 
SELECT (SELECT COUNT(*) FROM photos)/(SELECT COUNT(*) FROM users)  AS avg_user_posts; 


/*6.A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.*/

WITH top_tags AS
(
SELECT tag_id,count(photo_id) AS total_photos
FROM photo_tags
GROUP BY tag_id
ORDER BY COUNT(photo_id) DESC
LIMIT 5
),
top_tags_names AS
(
SELECT tag_id,tag_name,total_photos
FROM top_tags
INNER JOIN tags on top_tags.tag_id=tags.id
)
SELECT tag_id,tag_name,total_photos FROM top_tags_names;


/*7.To find out if there are bots, find users who have liked every single photo on the site.*/

SELECT username,bots.user_id,bots.total_likes FROM users
INNER JOIN
(SELECT user_id,COUNT(*) AS total_likes FROM likes
GROUP BY user_id
HAVING total_likes = (SELECT COUNT(*) FROM photos)) AS bots
ON users.id=bots.user_id ;


/*8.Find the users who have created instagramid in may and select top 5 newest joinees from it?*/

WITH cte1 AS
(
SELECT id, username, created_at FROM users
WHERE MONTH(created_at)=05
),
cte2 AS
(
SELECT id, username, MAX(created_at) AS created_date
FROM cte1
GROUP BY id, username
ORDER BY created_date DESC
LIMIT 5
)
SELECT id, username AS newest_joinees, created_date FROM cte2;


/*9.Can you help me find the users whose name starts with c and ends with any number and have posted the photos as well as liked the photos?*/

WITH cte1 AS
(
SELECT id,username FROM users
WHERE username REGEXP '^c' AND username REGEXP '[0123456789]$'
),
cte2 AS
(
SELECT cte1.id,cte1.username FROM cte1
INNER JOIN photos ON cte1.id=photos.user_id
INNER JOIN likes ON photos.user_id=likes.user_id
GROUP BY cte1.id,cte1.username
)
SELECT cte2.id,cte2.username FROM cte2;


/*10.Demonstrate the top 30 usernames to the company who have posted photos in the range of 3 to 5.*/

SELECT users1.user_id,users.username,users1.total_posts FROM users
INNER JOIN
(SELECT user_id, count(*) AS total_posts FROM photos
GROUP BY user_id
)AS users1
ON users.id=users1.user_id
WHERE total_posts BETWEEN 3 AND 5
LIMIT 30;