use practice;

-- LIMIT 함수는 변수 사용을 못하때문에 prepare / execute 문을 이용해서 변수를 활용한다.
set @myvar1 = 3;
prepare myquery  -- 쿼리 준비(아직 실행X)
	from 'select name, height from usertbl order by height limit ?';
execute myquery using @myvar1; -- 준비한 쿼리에 있는 '?'에 변수 입입

-- 데이터 형식 변환 함수 : cast(), convert()
desc buytbl;
select userid, proname, amount from buytbl;
select avg(amount)'평균 구매 개수' from buytbl;
-- use cast / convert (compare upside with downside)
	-- two kinds of cast and convert have similar function, the only difference is the syntax.
    -- the downside the functions of cast/convert make the data type cast to integer.
select cast(avg(amount) as signed integer) '평균 구매 개수' from buytbl;
select convert(avg(amount), signed integer) '평균 구매 개수' from buytbl;

select cast('2000%1%20' as date) as '년도';
select cast('2000%2%20' as date);

use practice;
desc buytbl;


-- 사용자들의 평균 구매 개수 : 개수이므로 정수 변환하기
select avg(amount) as '평균 구매 개수' from buytbl;
	-- 반올림되서 나오네..
select cast(avg(amount) as signed integer) as '편균 구매 개수' from buytbl;
select convert(avg(amount), signed integer) as '평균 구매 개수' from buytbl;

select cast('2020%12%12' as date);

-- 247p 암시적인 형 변환 : transaction to not use the function of cast and convert
select '100' + '200'; -- 문자와 문자를 더함(결과: 정수로 변환됨)
-- 문자와 문자를 연결해주는 concat 함수
select concat ('100', '200'); -- 문자와 문자를 연결(문자로 처리)
select concat (100, '300'); -- 정수와 문자를 연결(문자로 처리)
select 1 > '2mega'; -- 정수인 2로 변환되어서 비교
select 1 > 'mega1'; -- 문자 'mega1'이 0으로 변환됨

-- MySQL 내장함수 --

	-- if(수식, 참, 거짓)
select if (100>200, '거짓(반대)이다', '참(반대)이다');
select ifnull (null, '널이군요'), ifnull('100 : 널이 아니군요', '널이군요');
select nullif (100, 200), nullif (999, 999);
	-- case~when~else~end
select case 10 
			when 1 then '일'
            when 5 then '오'
            when 10 then '십'
		end as 'case연습';  -- 출력될 열의 별칭
        
select case '감자튀김'
			when '라면' then '조리시간 : 10분'
            when '만두' then '조리시간 : 20분'
            when '떡볶이' then '조리시간 : 12분'
            when '감자튀김' then '조리시간 : 8분'
		end as '주문 확인서';

	-- 문자열 함수 : ASCII(아스키 코드), CHAR(숫자)
select ascii('A'), char(65);

	-- BIT_LENGTH(문자열), CHAR_LENGTH(문자열), LENGTH(문자열)
select bit_length('abc'), char_length('abc'), length('abc');
select bit_length('가나다'), char_length('가나다'), length('가나다');
		-- MySQL은 기본으로 UTF-8 코드를 사용해서 영문은 3바이트, 한글은 9바이트를 할당함.
        
	-- concat(문자열1, 문자열2, ...), concat_ws(구분자, 문자열1, 문자열2, ...)
select concat_ws('/', '비트', '교육센터');

select
	elt(3, '하나', '둘', '셋') as ELT,
	field('위범석', '이유진', '위범석', '홍진협') as FIELD,
	find_in_set('둘', '하나, 둘, 셋') as FIND_IN_SET,
    instr('하나둘셋', '둘') as INSTR,
    locate('둘', '하나둘셋') as LOCATE;

	-- FORMAT(숫자, 소수점 자릿수)
select format(123456.123456, 4); -- 소수점 4번째자리까지 반올림해서 표현해준다.
select bin(20), hex(31), oct(20);
	-- insert(기준 문자열, 위치, 길이, 삽입할 문자열) : 기준 문자열의 위치부터 길이만큼을 지우고 삽입할 문자열을 끼워 넣는다.
select insert ('abcde', 3, 2, '삽입된 문자열');
	-- left(문자열, 길이), right(문자열, 길이) : 왼쪽 또는 오른쪽에서 문자열의 길이만큼 반환한다.
select left('동해물과 백두산이 마르고 닳도록', 11);
select right('동해물과 백두산이 마르고 닳도록', 5);

	-- upper(문자열), lower(문자열), = LCASE / RCASE
select upper('abcd'), lower('ABCD');
	-- LPAD(문자열, 길이, 채울 문자열), RPAD(문자열, 길이, 채울 문자열)
    
	-- LTRIM(문자열), RTRIM(문자열) : 공백 제거 
    
    -- TRIM(문자열), TRIM(방향 자를 _문자열 from 문자열) : 공백 제거
    
	-- REPEAT(문자열, 횟수) : 문자열을 횟수만큼 반복.
    
    -- REPLACE(문자열, 원래 문자열, 바꿀 문자열)
    
    -- REVERSE(문자열)
    
    -- SPACE(길이)
    
    -- SUBSTRING(문자열, 시작위치, 길이) 또는 SUBSTRING(문자열 from 시작위치 for 길이) : 시작위치부터 길이만큼 문자를 반환한다.
    
    -- SUBSTRING_INDEX(문자열, 구분자, 횟수) : 문자열에서 구분자가 왼쪽부터 횟수 번째 나오면 그 이후의 오른쪽은 버린다. 횟수가 음수면 오른쪽부터 세고 왼쪽을 버린다.
    
	-- 피벗의 구현
use practice;

create table pivottest
(
	uName char(3),
    season char(2),
    amount int
);

insert into pivotTest values ('김범수', '겨울', 10), ('윤종신', '여름', 15), ('김범수', '가을', 25), ('김범수', '봄', 3), 
('김범수', '봄', 37), ('윤종신', '겨울', 40), ('김범수', '여름', 14), ('김범수', '겨울', 22), ('윤종신', '여름', 64);

select * from pivotTest;

	-- sum(), if() 함수와 group by 의 활용하여 피벗테이블로 변환
		-- if(조건식, '참', '거짓')
select uname, 
sum(if(season = '봄', amount, 0)) as '봄',
sum(if(season = '여름', amount, 0)) as '여름',
sum(if(season = '가을', amount, 0)) as '가을',
sum(if(season = '겨울', amount, 0)) as '겨울',
sum(amount) as '합계' from pivotTest group by uname;


	-- 270p 예제
select season,
sum(if(uname = '김범수', amount, 0)) as '김범수',
sum(if(uname = '윤종신', amount, 0)) as '윤종신'
from pivottest group by season;


-- JSON 데이터 (Java Script Object Notation) / JSON_OBJECT, JSON_ARRAY
select * from usertbl;
select json_object('name', name, 'height', height) as 'JSON 값'
	from usertbl
    where height >= 180;

	-- 1970년생 이후인 사람 조회하기
select json_object('이름', name, '태어난 연도', birthyear) as '1970년생 이후인 사람'
	from usertbl
    where birthyear > 1970;

	-- JSON 관련 함수의 사용법

		-- @json 변수에 json 데이터를 우선 대입하면서 테이블의 이름은 usertbl로 지정.
set @json = '{ "usertbl" :
[
	{"name" : "임재범", "height" : 182},
    {"name" : "이승기", "height" : 182},
    {"name" : "성시경", "height" : 186}
]
}';

select * from usertbl;

select json_valid(@json) as json_valid;  -- 문자열이 json 형식을 만족하면 1을 그렇지 않으면 0을 반환한다.
select json_search(@json, 'one', '성시경') as json_search;  -- 세번째 파라미터에 주어진 문자열의 위치를 반환한다. 두번째 파라미터는 'one'과 'all' (272쪽)
select json_extract(@json, '$.usertbl[2].name') as json_extract;  -- 반대로 지정된 위치의 값을 추출한다.
select json_insert(@json, '$.usertbl[0].mDate', '2009-09-09') as JSON_INSERT;  -- usertbl의 첫번째(0)에 mdate를 추가한다.
select json_replace(@json, '$.usertbl[0].name', '홍길동') as json_replace;  -- usertbl의 첫번째(0)의 name부분을 '홍길동'으로 변경한다.
select json_remove(@json, '$.usertbl[0]') as JSON_REMOVE;  -- usertbl의 첫번째(0)의 항목을 통째로 삭제한다.

	-- 273p : 구매 테이블(buytbl)의 구조를 활용해 보자.
    
    

-----------------------
/*
조인 : 2개 이상의 테이블이 서로 관계되어 있는 상태를 고려하여 하나의 결과 집합으로 만들어 내는 것을 말한다.
	1대다 관계의 중요성 : 273쪽
inner join(내부 조인)

select <열 목록>
from <첫 번째 테이블>
	inner join<두 번째 테이블>
    on <조인될 조건>
[where 검색조건]
*/
-- 구매 테이블 중에서 JYP라는 아이디를 가진 사람이 구매한 물건을 발송하기 위해서 이름/주소/연락처 등을 조인해서 검색하려면 다음과 같이 작성하면 된다.
select *
	from buytbl  -- buytbl에서 모든 열의 정보를 가져오는데...
	inner join usertbl  -- 내부 조인을 통해 
		-- 조건을 충죽하는 값을 출력해라.
		on buytbl.userid = usertbl.userid  -- on 구문과 where 구문에는 '테이블이름.열 이름'의 형식으로 되어있다. 중복된 열 이름의 충돌을 막기위해서.
	where buytbl.userid = 'JYP';  -- 조건
    
select *  -- where를 생략한다면 모든행에 대해서 위와 동일한 방식으로 반복하게 된다.
	from buytbl  
	inner join usertbl    
		on buytbl.userid = usertbl.userid;

	-- 아이디/이름/구매물품/주소/연락처만 추출하자.
		-- 코드를 명확히 하기 위해서 select 다음의 컬럼 이름(열 이름)에도 모두 '테이블이름.열 이름'식으로 붙여주자.
select b.userid, u.name, b.proname, u.addr, concat(mobile1, mobile2) as '연락처'  -- userid 컬럼이름의 중복으로 userid의 경로를 나타내줘야 한다.
	from buytbl B
		inner join usertbl U  -- 별칭을 붙여줘서 코드를 더 간결하게 만든다.
			on b.userid = u.userid  -- 조인될 조건
		order by b.num;

select u.userid, u.name, b.proname, u.addr, (mobile1 + mobile2) as '연락처'
	from usertbl u
		inner join buytbl b
			on u.userid = b.userid
		order by u.userid;
		-- 이번에는 전체 회원들이 구매한 목록을 모두 출력해보자.
		-- where B.userid = 'JYP';
	

	-- 한번이라도 구매한 내역이 있는 회원들의 아이디, 이름, 주소 조회하기
select distinct u.userid, u.name, u.addr  -- distinct는 중복 방지 함수이다.
	from usertbl u
    inner join buytbl b
		on u.userid = b.userid  -- 구매한 내역이 있는 회원만 따로 지정.
	order by u.userid;

	-- 위의 결과를 exists문을 사용.
select u.userid, u.name, u.addr
	from usertbl u
    where exists (
		select
        * from buytbl b
        where u.userid = b.userid);
        

-- OUTER JOIN
-- 실습 문제(282쪽)
use practice;
create table stdtbl
(
	stdName varchar(10) primary key,
    addr char(4) not null
);

create table clubtbl
(
	clubname varchar(10) primary key,
    roomNo char(4) not null
);

create table stdclubtbl
(
	num int auto_increment primary key,
    stdName varchar(10) not null,
    clubName varchar(10) not null,
    foreign key(stdName) references stdtbl(stdName),
    foreign key(clubName) references clubtbl(clubName)
);

insert into stdtbl values ('김범수','경남'), ('성시경','서울'), ('조용필','경기'), ('은지원','경북'), ('바비킴', '서울');
insert into clubtbl values ('수영','101호'), ('바둑', '102호'), ('축구', '103호'), ('봉사','104호');
insert into stdclubtbl values (null, '김범수','바둑'), (null, '김범수', '축구'), (null, '조용필', '축구'), (null, '은지원', '축구'), (null, '은지원', '봉사'), (null, '바비킴', '봉사');


-- 282쪽
	-- 학생 테이블, 동아리 테이블, 학생동아리 테이블을 이용해서 학생을 기준으로 학생 이름/지역/가입한 동아리/동아리방을 출력하자. (일대다 관계 : inner join)
select s.stdName, s.Addr, c.clubName, c.roomNo  -- 학생 이름/지역/가입한 동아리/동아리밤
	from stdtbl s
		inner join stdclubtbl sc  -- 학생동아리 테이블과 학생 테이블의 일대다 관계를 inner join함.
			on s.stdname = SC.stdName  -- 조인될 조건(동아리 테이블에 학생 이름이 있어야 가입을 한 것이기때문에...)
		inner join clubtbl c  -- 동아리 테이블과 학생 테이블의 일대다 관계를 inner join함.    + 조인의 묶음 참고자료 (283쪽 그림 7-36)
			on sc.clubName = c.clubname
		order by s.stdName;
									-- 위 예제 코드 작성 과정 : stdTBL '학생 테이블'과 stdclubTBL '학생 동아리 테이블'이 조인되고, 그 조인 결과와 clubTBL이 조인되는 형식의 쿼리문이다.

-- 이번에는 동아리를 기준으로 가입한 학생의 목록을 출력하자.
select c.clubname, c.roomNo, s.stdName, s.addr
	from stdtbl s
		inner join stdclubtbl sc
			on sc.stdName = s.stdName
		inner join clubtbl c
			on sc.clubName = c.clubName
		order by c.clubName;

-------------------------- 283쪽






