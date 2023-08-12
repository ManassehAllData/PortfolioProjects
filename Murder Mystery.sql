SELECT date, type, description, city  

from crime_scene_report 

WHERE date = "20180115" AND city = "SQL City" AND type ="murder"; 

SELECT * from person 

WHERE address_street_name =f "Franklin Ave" or address_street_name = "Northwestern Dr" 

ORDER BY address_number ASC; 


SELECT * FROM interview 

where person_id = "14887" OR person_id = "16371" 


SELECT * from get_fit_now_check_in 

WHERE check_in_date = "20180109" and membership_id like "48Z%"  


SELECT * FROM person 

INNER join get_fit_now_member  

ON get_fit_now_member.person_id = person.id 

where get_fit_now_member.id = "48Z55" OR get_fit_now_member.id = "48Z7A" 


SELECT * FROM drivers_license 

WHERE plate_number like "%H42W%" 


SELECT * from person 

JOIN drivers_license 

ON person.license_id = drivers_license.id 

where person.license_id = "423327" or person.license_id = "664760" 


SELECT * FROM get_fit_now_member 

WHERE name = “Tushar Chandra” 


INSERT INTO solution (user, value) 

VALUES ("1", "Jeremy Bowers") 

SELECT * FROM solution
