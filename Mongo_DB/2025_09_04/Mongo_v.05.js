use DB_20250903

db.createCollection("reviews02")
db.reviews02.insertMany(
    [
        {Customer_name: "박서연", product: "린넨 셔츠",   rating: 4, comment: "통풍이 잘 돼서 한여름에도 시원해요.",            date: ISODate("2024-06-15")},
        {Customer_name: "이현우", product: "여름 샌들",   rating: 5, comment: "가볍고 쿠션감이 좋아 오래 걸어도 편해요.",     date: ISODate("2024-07-02")},
        {Customer_name: "최지우", product: "반팔 티셔츠", rating: 3, comment: "원단은 부드럽지만 사이즈가 조금 크게 나왔네요.", date: ISODate("2024-08-10")},
        {Customer_name: "정하준", product: "데님 스커트", rating: 4, comment: "핏이 예쁘고 코디하기 쉬워요.",                 date: ISODate("2024-06-28")},
        {Customer_name: "김민지", product: "라탄 백",     rating: 5, comment: "수납공간이 넉넉해서 데일리로 좋아요.",         date: ISODate("2024-07-19")},
        {Customer_name: "유나",   product: "캡 모자",     rating: 5, comment: "차양이 넓어 햇빛 가리기에 딱이에요.",         date: ISODate("2024-08-05")},
        {Customer_name: "김도윤", product: "슬리브리스",  rating: 3, comment: "시원하지만 어깨 끈이 조금 얇아요.",            date: ISODate("2024-09-01")},
        {Customer_name: "장예린", product: "경량 자켓",   rating: 4, comment: "저녁에 걸치기 좋아서 활용도가 높아요.",        date: ISODate("2024-07-30")},
        {Customer_name: "오민호", product: "와이드 팬츠", rating: 5, comment: "원단이 시원하고 구김이 잘 안 가요.",           date: ISODate("2024-08-22")},
        {Customer_name: "한수아", product: "플리츠 원피스",rating: 4, comment: "라인이 예쁘고 움직임이 편안합니다.",          date: ISODate("2024-06-03")}
    ]
)

db.reviews02.deleteMany
(
    {Customer_name: "김민지"}
)



db.reviews02.updateOne(
    {customer_name:"박서연"},
    {$set: {comment: "배송이 빨라서 만족"}}
)

db.reviews.deletMany(
    {date: {$lt:ISODate("2023-09-01")}}
)


db.reviews02.updateMany(
    {product:"여름 샌들"},
    {$inc : {rating: 1}}
)

db.reviews02.find()



