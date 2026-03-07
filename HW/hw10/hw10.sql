CREATE TABLE parents AS
  SELECT "ace" AS parent, "bella" AS child UNION
  SELECT "ace"          , "charlie"        UNION
  SELECT "daisy"        , "hank"           UNION
  SELECT "finn"         , "ace"            UNION
  SELECT "finn"         , "daisy"          UNION
  SELECT "finn"         , "ginger"         UNION
  SELECT "ellie"        , "finn";

CREATE TABLE dogs AS
  SELECT "ace" AS name, "long" AS fur, 26 AS height UNION
  SELECT "bella"      , "short"      , 52           UNION
  SELECT "charlie"    , "long"       , 47           UNION
  SELECT "daisy"      , "long"       , 46           UNION
  SELECT "ellie"      , "short"      , 35           UNION
  SELECT "finn"       , "curly"      , 32           UNION
  SELECT "ginger"     , "short"      , 28           UNION
  SELECT "hank"       , "curly"      , 31;

CREATE TABLE sizes AS
  SELECT "toy" AS size, 24 AS min, 28 AS max UNION
  SELECT "mini"       , 28       , 35        UNION
  SELECT "medium"     , 35       , 45        UNION
  SELECT "standard"   , 45       , 60;


-- All dogs with parents ordered by decreasing height of their parent
CREATE TABLE by_parent_height AS
  SELECT  P.child
  FROM dogs as D,parents as P
  WHERE D.name = P.parent
  ORDER BY D.height DESC 
  ;


-- The size of each dog
CREATE TABLE size_of_dogs AS
-- 注意 这里要用逗号
  SELECT D.name,S.size 
  FROM dogs as D, sizes as S
  WHERE D.height > S.min and D.height <= S.max;


-- [Optional] Filling out this helper table is recommended
-- 创建所有的兄弟对（按照字典序） 但是没有保证二者都是同体型的
CREATE TABLE siblings AS
  SELECT P1.child as FR,P2.child  as SE
  FROM parents as P1, parents as P2
  WHERE P1.parent = P2.parent and P1.child < P2.child
  ;

-- Sentences about siblings that are the same size
CREATE TABLE sentences AS
  SELECT "The two siblings, " || S.FR || " and " || S.SE || ", have the same size: " || SD.size
  FROM siblings as S, size_of_dogs as SD,size_of_dogs as SD1
  WHERE S.FR = SD.name 
  and S.SE = SD1.name 
  and SD.size = SD1.size
  ;


-- Height range for each fur type where all of the heights differ by no more than 30% from the average height
-- HAVING 可以用聚合函数，where不可以
CREATE TABLE low_variance AS
  SELECT fur, 1 AS height_range 
  FROM dogs 
  GROUP BY fur 
  HAVING MIN(height) >= AVG(height) * 0.7 
     AND MAX(height) <= AVG(height) * 1.3;

