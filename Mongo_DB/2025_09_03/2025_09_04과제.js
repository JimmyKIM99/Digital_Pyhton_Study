/*

6.  사용자별 댓글 활동 분석
        comments에서 *사용자(email 기준)*별 총 댓글 수, 댓글 평균 길이를 집계하고, 총 댓글 수 내림차순 → 평균 길이 내림차순으로 정렬하여 상위 5명을 출력하세요.
*/
use sample_mflix

db.movies.aggregate([
  {$project: {title:1, year:1, genres:1}},
  {$match:{year:{$gte:2010},genres:"Action"}}
])


//새로운 고객 "홍길동"을 users 컬렉션에 추가하세요. 이메일은 "hong@test.com", 관심 장르는 ["Action", "Comedy"]입니다.
db.users.insertOne({
  name: "홍길동",
  email: "hong@test.com",
  관심장르: ["Action", "Comedy"]
})
db.users.find({email: "hong@test.com"})

//댓글 등록 및 수정
//comments 컬렉션에 "홍길동"이 "Action 영화 최고!"라는 댓글을 삽입하세요.
db.comments.insertOne({name:"홍길동", text:"Action 영화 최고!"})
db.comments.find({text:"Action 영화 최고!"})

//이후 "홍길동"의 댓글 내용을 "Action 영화 진짜 재밌다!"로 수정하세요.
db.comments.updateOne({name:"홍길동"}, {$set:{text:"Action 영화 진짜 재밌다!"}})
db.comments.find({name:"홍길동"})

//장르별 인기 분석
//movies 컬렉션에서 장르별 영화 수를 집계하고, 가장 많은 3개 장르를 출력하세요.
db.movies.find()
db.movies.aggregate([
{$unwind: "$genres"},
{
  $group:{
    _id :"$genres",
    count_movies:{$sum:1}
  }
},
{$sort:{count_movies: -1}},
{$limit:3}])

//평점 기준 상위 영화
//movies 컬렉션에서 평점이 8.5 이상인 영화의 title, imdb.rating, year를 출력하고, 최신 영화 순으로 정렬하세요.

db.movies.find(
  {"imdb.rating": {$gte: 8.5}},
  {title:1,"imdb.rating" : 1, year: 1 },
  {sort:{year: -1}}
)


