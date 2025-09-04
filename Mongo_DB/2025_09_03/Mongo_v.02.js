use DB_20250903
db.users.updateOne(
    { name: "동현" },
    { $set: { name: "동현2세", age: 31, hobbies: ["축구", "음악", "영화"] } }
)

db.users.find(
    { name: "동현2세" }
)

// 특정 조건에 따라서 필도를 제거하는 문법/구문
db.users.updateOne(
    { name: "유진" },
    { $unset: { age: 1 } }
)



db.users.updateOne(
    { name: "동현" },
    { $set: { name: "민준", age: 22, hobbies: ["음악", "여행"] } },
    { upsert: true }
)

db.users.updateOne(
    { name: "유진" },
    { $set: { hobbies: "운동" } }
)

db.users.updateOne(
    { name: "유진" },
    { $push: { hobbies: "영화" } }
)

db.users.updateOne(
    { name: "유진" },
    { $pull: { hobbies: "운동" } }

)

/*

특정 컬렉션 안에 값을 추가할 때에도 단일값 & 다중값 적용
값을 수정할 때에도 단일값 & 다중값 적용
값을 삭제할 때에도 단일값 & 다중값 적용

*/

// deleteone, deleteMany

/* DELET FROM users WHERE address = '서울'
db.users.deleteMany(
    {address:"서울"}
)
*/


db.users.deleteMany(
    { address: "수원시" }
)


db.users.insertMany([
    { name: "Davide", age: 43, address: "서울" },
    { name: "DaveLee", age: 25, hobbies: "골프", address: "경기도" },
    { name: "Andy", age: 50, address: "경기도" },
    { name: "Kate", age: 35, address: "수원시" }]
)

db.users.deleteMany(
    { age: { $lt: 30 } }
)

db.users.insertMany(
    [
        { name: "A", age: 20, address: "경기도", date: ISODate("2024-08-15")},
        { name: "A", age: 30, address: "서울", date: ISODate("2025-06-12")}
    ]
)

db.users.updateMany(
    {address: "경기도"},
    {$inc: {age: 1}}
)

db.users.find()





