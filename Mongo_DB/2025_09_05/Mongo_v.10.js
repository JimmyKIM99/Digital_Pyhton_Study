db.comments.aggregate([
  {
    $lookup:
      {
        from: "movies",
        localField: "movie_id",
        foreignField:"_id",
        as: "movie"
      }
  }
])

db.users.find().limit(1)

db.users.aggregate([{
  $lookup:{
    from:"comments",
    localField: "email",
    foreignField: "email",
    as: "user_comments"
  }
}])

// lookup : 서로 다른 컬렉션 연결한다는 장점
// 프로그램 실행되는 측면에서 보면 환영 X
// 컬렉션 + 컬렉션 => 새로운 필도 가져와
// 로컬 컴퓨터 안좋음 or 클라우드 컴퓨팅 서버 용량 불충분 -> 무한 로드


db.movies.aggregate([
  {$match: {runtime: {$gte:100}}},
  {$sort: {year: -1}},
  {$skip : 5}
])



db.movies.aggregate([{
  $facet:{
    movieCountByYear: [
      {$group:{_id: "$year", count: {$sum: 1}}}
    ],
    maxRatingByYear :[
      {$group: {_id:"$year", maxRating : {$max: "$imdb.rating"}}}
    ]
  }
}])

db.movies.aggregate([
  {
    $redact: {
      $cond : {
        if: {$gte: ["$imdb.rating", 7]},
        then: "$$KEEP", // 사용자 정의 변수를 활용하고자 할 때 
        else: "$$PRUNE"
      }
    }
  }
])

db.movies.aggregate([
  {
    $match: {year: {}}
  }
])


