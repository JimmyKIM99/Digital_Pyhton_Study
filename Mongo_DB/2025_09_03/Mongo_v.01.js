db.getCollection("users").find({})
db.users.find()
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