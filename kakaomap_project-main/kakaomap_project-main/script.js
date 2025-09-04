const url =
  "https://api.odcloud.kr/api/15004303/v1/uddi:398988c5-5a01-4445-b093-cbe6578456b8?page=1&perPage=4000&serviceKey=oMLY3SekqYi6Z3IHiIY01u%2F5BYoy8D0%2Foxwm0wq%2BUI8u3qqZwutT5AuBlmd3bTIjc22dXkLGnEAjYKI2y2hRaQ%3D%3D&_returnType=JSON";

fetch(url)
  .then((response) => response.json())
  .then((result) => {
    const data = result.response.body.items.item;
    console.log(data);
    const showPosition = (position) => {
      const { latitude, longitude } = position.coords;
      console.log(latitude, longitude);
      const container = document.getElementById("map");

      var options = {
        center: new kakao.maps.LatLng(latitude, longitude),
        level: 3,
      };

      var map = new kakao.maps.Map(container, options);
    };

    const erroPosition = (error) => {
      alert(error.message);
    };

    window.navigator.geolocation.getCurrentPosition(showPosition, erroPosition);
  });
