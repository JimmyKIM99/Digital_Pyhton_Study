// MongoDB > NoSQL, Aggregation => 집합 | 집계
// Aggregation => 프레임워크
// $push <-> 배열이 아닌 요소들을 하나의 배열의 자료구조 형태로 만들어주는 기능
// 프레임워크 | 라이브러리
// 기존에 학습했던  find()의 상위호환 버전이라고 생각해도 무방
// Linux 운영체제 => pipeLine 개념을 밴치마킹 => 함수의 기능이 구현 => 기능
// shard : 샤드 => A (*1번 샤드) -> B (*2번 샤드)

use sample_mflix

db.movies.find()
db.comments.find()

db.movies.aggregate(
    [
        {$match: {year: 1995}}
    ]
)

db.comments.aggregate([
    {
        $group :{
            _id: "$movie_id",
            commentCount:{$sum:1}
        }
    }
])

db.comments.aggregate([
    {
        $project :{
            year: "$_id",
            commentCount: 1,
            _id: 0
        }
    }
])

db.movies.aggregate([
  {
    $group: {
      _id: "$year",
      openCount: {$sum: 1}
    }
  }
])

db.movies.aggregate([
  {
    $group: {
      _id: "$year",
      runtime: {$avg: "$runtime"}
    }
  }
])

db.movies.find().limit(2)

db.movies.aggregate([
  {
    $group:{
      _id: "$year",
      averageRating: {$avg: "$imdb.rating"}
    }
  }
])

db.movies.aggregate([
  {
    $group:{
      _id: "$year",
      minRating: {$min: "$imdb.rating"}, // "5.2" => string
      maxRating: {$max: "$imdb.rating"} // 4.8 + "5.2"(자동 형 변환) => 
    }
  }
])

db.movies.aggregate([
  {
    $group:{
      _id: "$year",
      titles: {$push:"$title"}
    }
  }
])

db.movies.find(
  {"imdb.rating": ""}
).limit(5)



db.movies.aggregate([
  {
    $addFields:{
      ratingNum: {
        $convert : {
          input : "$imdb.rating", //
          to : "double", // 실수자료형으로 자료의 값을 변경
          onError : null,
          onNull: null
        }
      }
    }
},
  {
    $match:{ratingNum: {$ne: null}}
  },
  {
    $group:{
      _id:"$year",
      minRating: {$min: "$ratingNum"},
      maxRating: {$max: "$ratingNum"}
    }
  }
])

//addToSet : 동일한 중복값을 제거하고 배열로 가져옴
//동일한 감독의 값을 가지고 있었을 경우, 1번만 출력!!
db.movies.aggregate([
  {
    $group:{
      _id: "$year",
      directors : {$addToSet:"$directors"}
    } //기존 데이터가 배열, 배열형태
  }
])

db.movies.aggregate([
  {
    $group: {
      _id : "$year",
      genres: {$addToSet: "$genres"}
      // => 객체지향언어 => set 함수 : 중복되는 값을 제거하고, 1번만 값을 가져옴
    }
  }
])


db.movies.find()


db.movies.aggregate([
  {
    $sort: {"year": 1}
  }
])





