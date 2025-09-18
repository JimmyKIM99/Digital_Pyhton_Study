db.movies.aggregate([
  {
    $group:{
      _id: "$year",
      firstMovie: {$first: "$title"},
      lastMovie: {$last: "$title"}
    }
  }
])

db.movies.aggregate([
  {
    $group:{
      _id: "$year",
      avgTitlelength: {$avg: {$strLenCP: {$toString:"$title"}}}
    }
  }
])

db.movies.aggregate([
  {
    $match:{year: {$gte: 2000}},
  },
  {
    $count: "movies_since_2000"
  }
])

db.movies.find()

db.movies.aggregate([
  {$sort: {"year": 1, "title": 1}},
  {$limit: 5}
])

db.movies.aggregate([
  {$unwind: "$genres"},
  {$limit: 5}
])

db.movies.aggregate([
  {$sort: {"imdb.rating": 1}}
])

// 1. 2000년 이후로 출시된 영화의 수는 몇개인가요?

db.movies.aggregate([
  {
    $match: {year: {$gte: 2000}}
  },
    {$count: "after_2000"}
])

// 2. 각 연도별로 출시된 영화의 개수는?
db.movie.aggregate([
  {$group: 
  {_id : "$year",
  per_year:{$count:$title}}}
])

db.movies.aggregate([
  {
    $group:
    {_id: "$year", count: {$sum:1}}
  }
])

// 3. 가장 많은 영화가 출시된 연도는 언제일까

db.movies.aggregate([{
  $group: {
    _id: "$year",
    count: {$sum:1}
  }},
  {$sort:{count: -1}},
  {$limit: 1}
])

db.movies.find()
// 4. 각 연도별 평균 영화 러닝타임
db.movies.aggregate([{
  $group : {
    _id : "$year",
    avgValue: {$avg: "$runtime"}
  }
},
{$sort: {avgValue:-1}}
])

// 5. 러닝타임이 가장 긴 영화는 어떤 영화인가요?

db.movies.aggregate([{
  $group : {
    _id : "plot",
    title : "title"
  }
}, {$sort: {runtime:-1}},
{$limit: 1}
]
)

db.movies.aggregate([
{$unwind:"$genres"},{
  $group:{
    _id : "$genres",
    G_avg : {$avg: "$imdb.rating"}
  }
},
{$sort: {G_avg:-1}}])

// 7. 각 연도별 영화 제목의 평균 길이를 구해주세요!
db.movies.aggregate([{
  $group:{
    _id : "$year",
    avg_leng : {$avg: {$strLenCP:{$toString:"$title"}}}
  }
},{
  $sort: {avg_leng: 1}
}])

// 8. 각 연도별 가장 먼저 출시된(*year) 영화의 제목은 무엇인가요?
db.movies.aggregate([
{$sort: {"year": 1, "released": 1}},
{$group:{_id : "$year"}}
, {sort: {_id:1}}])


// 9. 각 연도별 개봉된 영화의 장르들을 출력해 주세요. (단, 장르는 1번씩만 출력되어야 합니다)

db.movies.aggregate([
  {$unwind:"$genres"},{
  $group:{
    _id : "$year",
    y_genre : {$addToSet: "$genres"}
  }
}])

db.movies.find()






