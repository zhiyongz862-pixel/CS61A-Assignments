CREATE TABLE finals AS
  SELECT "RSF" AS hall, "61A" as course UNION
  SELECT "Wheeler"    , "61A"           UNION
  SELECT "Pimentel"   , "61A"           UNION
  SELECT "Li Ka Shing", "61A"           UNION
  SELECT "Stanley"    , "61A"           UNION
  SELECT "RSF"        , "61B"           UNION
  SELECT "Wheeler"    , "61B"           UNION
  SELECT "Morgan"     , "61B"           UNION
  SELECT "Wheeler"    , "61C"           UNION
  SELECT "Pimentel"   , "61C"           UNION
  SELECT "Soda 310"   , "61C"           UNION
  SELECT "Soda 306"   , "10"            UNION
  SELECT "RSF"        , "70";

CREATE TABLE sizes AS
  SELECT "RSF" AS room, 900 as seats    UNION
  SELECT "Wheeler"    , 700             UNION
  SELECT "Pimentel"   , 500             UNION
  SELECT "Li Ka Shing", 300             UNION
  SELECT "Stanley"    , 300             UNION
  SELECT "Morgan"     , 100             UNION
  SELECT "Soda 306"   , 80              UNION
  SELECT "Soda 310"   , 40              UNION
  SELECT "Soda 320"   , 30;

CREATE TABLE sharing AS
  SELECT F.course as course, COUNT(DISTINCT F.hall) as shared
  FROM finals as F,finals as F1
  WHERE F.hall = F1.hall and F.course != F1.course 
  GROUP BY F.course 
  ;


-- 聪明的做法是！=改成小于 一个去重的trick
-- 还有就是要注意+法要加上括号
CREATE TABLE pairs AS
  SELECT S.room || ' and ' || S1.room || ' together have ' || (S.seats + S1.seats) || ' seats' AS rooms
  FROM sizes as S,  sizes as S1
  WHERE S.room < S1.room and S.seats + S1.seats >= 1000
  ORDER BY S.seats + S1.seats DESC
  ;

CREATE TABLE big AS
  SELECT F.course as course 
  FROM finals as F, sizes as S 
  WHERE F.hall = S.room 
  GROUP BY F.course 
  HAVING SUM(seats) >= 1000
  
  ;

CREATE TABLE remaining AS
  SELECT F.course as course, SUM(S.seats) - MAX(S.seats) as remaining
  FROM finals as F, sizes as S 
  WHERE F.hall = S.room 
  GROUP BY F.course   
  ;

