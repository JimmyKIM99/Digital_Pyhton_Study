db.getCollection("test").find({})

// 특정 DB > 컬렉션 삭제
db.test.drop();

// 컬랙션 생선 -> CLI 방식 VS GUI 방식
db.createCollection("test");

//
use Funcoding;

// 컬랙션을 생성하는 2가지 방식
// 특정 옵션 없이 단순 컬렉션 생선 방식
// 2진수 데이터 처리 방식 => 최소 단위 bit / 
//1kb = 2^10 -> 1024 bytes
//1mb = 2^10*2*10 bytes

/*
1) 특정 옵션 없이 단순 컬렉션 생성 방식
2) 별도의 옵션을 설정하여 컬렉션 생성 방식
- capped : true => 고정된 크기의 컬렉션을 갖도록 하겠다는 의미
- size : byte의 단위로 입력하게끔 되어 있음
- max : 해당 켈렉션 안에 저장할 수 있는 데이터 (*=문서), 몇 개의 문서를 허용할 것인가
- autoIndexId : true => 모든 문서를 생성할 때마다 _id 필드에 대한 값을 처음으로 설정할 것인가
*/

db.createCollection("log",{
    capped:true, 
    size:5242800,
    max: 5000
})

show collections

db.log.isCapped()

// 이미 생성된 컬렉션 이름을 수정하고자 할 때
db.log.renameCollection("test01")

db.collectionname.insertOne(
    {
        name: "Jimmy",
        age: 20,
        status: "pendig"
    }
)
db.collectionname.insertMany(
    {subject: "math", "science"},
    {score: "a","b"}
)

db.createCollection("user");
db.user.insertOne(
    {subject:"coding", author:"funcoding"}
);
// 해당 컬렉션 내부에 있는 값을 확인하고자 할 떄
db.user.find()

db.user.insertMany(
    [
        {subject: "coffee", authore : "Fiz", views:50},
        {subject: "cake", authore : "Fio", views:50},
        {subject: "bake", authore : "jim", views:50},
        {subject: "status", authore : "cc", views:50}
    ]
)

// No-SQL 구문/문법은 SQL 대비 상대적으로 유연한 문법 체계를 가지고 있음
// {subject: "coffee02", author: 123, views: "avd"}

// SQL 내 Schema를 정의했던 것처럼 NO-SQL에서도 사전에 Schema Validation 유효성 기능설정

db.createCollection("users02", {
    validator: {
        $jsonSchema: {
            bsonType:"object",
            required: ['subject', 'author','views'],
            properties : {
                subject :{
                    bsonType :'string',
                    description : "Must be a string and is required"
                },
                author:{
                     bsonType :'string',
                     description : "Must be a string and is required"
                },
                view:{
                     bsonType :'int',
                     description : "Must be a string and is required"
                }
            }
        }
    },
    validationAction:"error"
})

db.user.drop()

// users 컬렉션 생성
// 다음과 같은 데이터를 삽입
/*
name, age, hobby, address 키 삽입
David, 45, "서울"
Dave, 25, "경기도"
Andy, 50, "골프", "경기도"
Kate, 35, "수원시"
Brown,8
*/

db.createCollection("users",{
    capped: true,
    size: 100000,
    max: 5000
})

db.users.insertMany([
        {name: "David", age:"45",address:"서울"},
        {name: "Dave", age:"25",address:"경기도"},
        {name: "Andy", age:"50",hobby:"골프",address:"경기도"},
        {name: "Kate", age:"35",address:"수원시"},
        {name: "Brown", age:"8"}
    ]
)
db.users.find()
// find() : 해당 컬렉션 안에 있는 모든 데이터를 읽기 위한 함수
/*
만약, 특정 조건에 해당되는 값을 찾아보고 싶다면?
SELECT * FROM users;
db.users.find()

SELECT _id, name, address FROM users
db.users.find({}, {name:1, address: 1})
> truthy, falsy : python => 0 / 1
> {} : 직접 입력 및 삽입한 값 뿐만 아니라 자동적으로 내장되어있는 값까지 모두 찾아온다는 의미 = all
> {특정 값을 입력} : 조건

SELECT name, address FROM users
db.users.find({}, {name:1, address:1, _id:0})


SELECT name, address FROM users WHERE address = "서울";
db.users.find({address: "서울"})

*/

// findOne() : 매칭되는 한개의 document 문서를 검색해서 찾아온다
// 어떤 쿼리의 조건을 의미하는 명칭 : query criteria
/*

db.users.find(
    {age: {$gt: 18}}, -> query criteria
    {name: 1, address: 1, _id; 0} -> projection
).limit(5) -> cursor modifier

*/


db.users.find(
    {name: "Dave"},
    {name:1, adress:1, age:1, _id:0}
);

//비교연산자
/*

$eq : = 
$gt : >
$gte : >=
$lt : <
$lte : <=
$nin // $in

SELECT * FROM users WHERE age > 25 AND age <= 50;
db.user.find({age: {$lte: 50, $gt: 25}})
*/

db.users.find(
    {age: {$gt: 20}}
)


db.users.find(
    {age: {$lt: 20}}
)

db.users.find(
    {age: {$in:[45, 50]}}
)

db.users.find(
    {age: {$nin:[45, 50]}}
)

db.users.find(
    {age:{$gt :20}},
    {name : 1}
)

db.users.find(
    {age:{$eq: 50}, address: {$eq:"경기도"}},
    {name:1}
)

db.users.find(
    {age:{$lt: 30}},
    {name: 1, age: 1, _id:0}
)

// 논리연산 문법
/*

SELECT * FROM users

db.users.find(
    {$and: [{address: "서울"}, {age: "45"}}]}

)
db.users.find({age: {$not{$eq:45}}})

db.users.find(
    {name: {$regex: /^Da/ }}
)

db.user.find(
    {address: "경기도"}
).sort()

*/

db.users.find(
    {$and:[{address: "서울"}, {age: 45}]}
)
// name이 brown이거나, age가 23인 모든 값 출력

db.users.find(
    {$or:[{age:23}, {address:"서울"}]}
)

db.users.find(
    {name:{$regex:/Da/}}
)

db.user.find(
 {adress:"경기도"}
).sort({age:-0})


// 현재 컬랙션 내 문서의 개수 확인하고자 할 때 => count()
db.users.find().count()
db.users.count()

// 현재 컬렉션 내 필드 존재 여부로 문서 개수 확인하고자 할 때 : $exists => 속성


// $가 붙어있다는 것은 NoSQL 문법에서 예약어로 사용되고 있다
// $가 붙어있는 예약어 중에서 연산자, 속성

db.users.count(
    {address:{$exists:true}}
)


db.users.find({address:{$exists:true}}).count()

db.users.count(
    {address:{$exists:false}}
)

// 중복제거 distinct
/*

SELECT DISTINCT(address) FROM users
결과값이 같은 비슷한 구문

*/

db.users.distinct("address")
db.users.find().limit(1)

// 데이터 수정
db.users.insertMany(
    [
    {name:"유진", age: 25, hobbies: ["독서","영화","요리"]},
    {name:"동현", age: 38, hobbies: ["축구","수영","러닝"]},
    {name:"해", age: 27, hobbies: ["여행","독서","요리"]}
    ]
)

db.users.find(
    {hobbies: {$all: ["축구", "수영"]}}
)

// $all : 배열 자료구조를 갖고 있는 필드에서 조건이 충족되는 모든 값을 포함하는 문서를 찾아올 때

// Document 수정
/*

1) updateOne(*정석) // update
- 매칭되는 1개 문서 업데이트
2) updateMany
-매칭되는 모든 문서를 업데이트 할 때 사용

db.users.updateOne(
    {age:{$gt:25}}
)
*/

db.users.updateOne(
 {age:{$gt:40}},
 {address:"수원시"}
)


db.users.updateMany(
    {age:{$gt:40}},
    {$set: {address: "수원시"}}
)

db.users.updateOne(
    {name: "유진"},
    {set: {age: 20}}
)

// 특정 조건에 부합하는 경우, 통으로 문서를 대체(*replace)하는 구문


