// 각 영화의 제목과 해당 영화에 달린 댓글을 출력

db.movies.aggregate([{
  $lookup : {
    from: "comments",
        localField: "_id",
        foreignField:"movie_id",  
        as: "movie1"
  }
},{
  $project: {
    title: 1,
    movie1: {
      $map:{
        input: "$movie1",
        as : "comment",
        in: "$$comment.text"
      }
    },
    _id: 0 
  }
}])
db.comments.find(
)

// 평점이 가장 높은 영화의 제목과 평점을 출력

db.movies.find()

db.movies.find(
  {title: 1, "imdb.rating": 1},
  {$sort: {"imdb.rating": 1}}
)

db.movies.aggregate([{
  $sort: {"imdb.rating": -1}
},{
  $limit: 1
},
{
  $project: {_id:0, title:1, "imdb.rating": 1}
}])

// 각 장르별로 평균 평점이 가장 높은 장르와 평균 평점을 출력해주세요.

db.movies.aggregate([
{$unwind: "$genres"},
{
  $group:{
    _id : "$genres",
    avg_rating :{$avg:"$imdb.rating"}
  }
},
{$sort : {avg_rating : -1}}
,{$limit: 1}])


// 개봉 연도별 평균 러닝타임이 가장 짧은 영화의 개봉년도와 평균 러닝타임을 출력해주세요
db.movies.aggregate([
{$unwind:"$year"},
{
  $group : {
    _id: "$year",
    avg_run : {$avg: "$runtime"}
  }
},
{
  $sort: {avg_run : 1}
//},
//{
//  $limit : 1
//}
}])

// 국가별로 가장 많은 영화를 제작함 감독과 그 감독의 영화 수 출력
db.movies.find()

db.movies.aggregate([
{$unwind: "$countries"}, {$unwind:"$directors"},
{
  $group: {
    _id: "$directors",
    sum_movie : {$sum: 1}
  }
}])

db.movies.aggregate([
{$unwind: "$countries"},
{$unwind: "$directors"}
,
{
  $group: {_id : {country : "$countries", director : "$directors"},count: {$sum: 1}}
},
{$sort: {count: -1}},
{$group: {_id : "$_id.country",
topDirector:{$first: "$_id.director"},
movieCount: {$first:"$count"}}}])






