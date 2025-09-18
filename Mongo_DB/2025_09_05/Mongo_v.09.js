db.movies.find()

use sample_mflix


db.movies.find(
  {year:{$gte: 2010}, genres: "Action"},
  {_id:0, title:1, year:1, genres:1}
)

db.movies.aggregate(
  {$match: {year: {$gte:2010}, genres: "Action"}},
  {$project: {_id:0, title:1, year:1, genres:1}}
)

db.users.inserOne({
  name:"홍길동",
  email:"hong@test.com",
  password:"test123",
  preference:["Action","Comedy"],
  createdAt: new Date()
})


db.users.aggregate([{
  $documents: {

  }
  
}])

db.comments.find().limit(5)


db.comments.insertOne({
    name : "홍길동",
    email: "hong@test.com",
    movie_id : "test123",
    text : "Action 영화 최고",
    createAt: new Date()
})

db.comments.find({name:"홍길동"})

// Javascripte = > 변수 선언, const, let, var
// const = > 재선언, 재할당 불가 // 엄격한 변수
// let => 재선언 불가, 재할당 가능


const m = db.movies.findOne(
  {year: {$gte: 2010}, genres: "Action"},
  {_id :1, title:1}
)


db.comments.updateOne({
  email: "hong@test.com"
},
{
  $set: {text: "Action 영화 진짜 재밌다!", editedAt: new Date()}
})

db.comments.updateOne(
  {email: "hong@test.com", movie_id}
)


db.movies.aggregate([
{}
,{
  $group: {_id: "$genres", count: {$sum:1}}
}])

db.movies.aggregate([
  {$match:{"imdb.rating": {$gte: 8.5}}},
  {$project: {_id:0, title:1, year:1, "imdb.rating":1}},
  {$sort: {year:-1}}
])

db.comments.aggregate([{
  $addFields: {
    textStr: {
      $convert: {
        input: "$text",
        to: "string",
        onError: "",
        onNull: ""
      }
    }
  }
},
{
  $addFields: {
    textSafe: {},
    textLen: {$strLenCP: "$textStr"}
  }
},
{
  $group: {
    _id: "$email",
    totalComments: {$sum:1},
    avgTextLength :{$avg: "$textLen"}
  }
},
{
  $sort: {totalComments: -1, avgTextLength: -1}
},
{
  $limit:5
}])







