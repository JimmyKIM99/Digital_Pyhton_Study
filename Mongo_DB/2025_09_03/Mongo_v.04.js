/*
1) 시나리오
 당신은 온라인 쇼핑몰 마케팅 담당자입니다. 고객 리뷰 데이터를 MongoDB에 저장하고, 이를 바탕으로 마케팅 전략을 기획해야 합니다.
2) 과제 단계
데이터 삽입 (Insert)
고객 리뷰 10개를 reviews 컬렉션에 저장하세요.
각 리뷰 문서는 customer_name, product, rating, comment, date 필드를 포함해야 합니다.
데이터 조회 (Find)
별점(rating)이 4점 이상인 리뷰만 조회하세요.
특정 제품(product)의 리뷰만 필터링하세요.
데이터 수정 (Update)
한 고객의 리뷰 코멘트를 "배송이 빨라서 만족합니다"로 수정하세요.
특정 제품의 리뷰 별점을 일괄적으로 +1 해보세요.
데이터 삭제 (Delete)
오래된 리뷰(date 기준 1년 이상 지난 것)를 삭제하세요.
3) 10개의 raw data는 임의로 생성하시되, 위 문제를 해결할 수 있도록 생성해주세요!!
*/

db.createCollection("reviews")
db.reviews.insertMany([
  {customer_name:"민준", product:"shoes",     rating:4.5, comment:"가볍고 편해요",     date: ISODate("2025-01-12")},
  {customer_name:"서연", product:"bag",       rating:3.5, comment:"디자인은 좋아요",   date: ISODate("2025-02-03")},
  {customer_name:"지우", product:"t-shirt",   rating:4.0, comment:"원단이 부드러움",   date: ISODate("2025-03-21")},
  {customer_name:"현우", product:"watch",     rating:2.5, comment:"생각보다 무거움",   date: ISODate("2025-04-10")},
  {customer_name:"수아", product:"hat",       rating:5.0, comment:"강추합니다",       date: ISODate("2025-05-18")},
  {customer_name:"도윤", product:"shoes",     rating:3.0, comment:"사이즈가 조금 큼",  date: ISODate("2025-06-07")},
  {customer_name:"유진", product:"hoodie",    rating:4.5, comment:"색감이 예뻐요",     date: ISODate("2025-07-26")},
  {customer_name:"지민", product:"jeans",     rating:4.0, comment:"핏이 좋아요",       date: ISODate("2025-08-15")},
  {customer_name:"하준", product:"socks",     rating:3.5, comment:"가격 대비 만족",   date: ISODate("2025-09-05")},
  {customer_name:"서준", product:"backpack",  rating:4.0, comment:"수납공간 넉넉",     date: ISODate("2025-10-29")}
])

db.reviews.find()

db.reviews.find(
    {rating:{$gt:4}},
    {}
)

db.reviews.find(
    {$or:[{product:"shoes"}, {product:"bag"}]}
)

db.reviews.updateOne(
    {customer_name:"민준"},
    {$set:{comment:"배송이 빨라서 만족해요"}}
)

db.reviews.updateMany(
    {product:"shoes"},
    {$inc:{rating: 1}}
)

db.reviews.deleteOne(
    {product:"shoes"}
)

db.reviews.deleteMany(
    {date:{$gt: ISODate("2025-06-01")}}
)
