import React from "react";

const Controller = ({ handlesetCount }) => {
  return (
    <div>
      <button onClick={() => handlesetCount(-1)}>-1</button>
      <button onClick={() => handlesetCount(-10)}>-10</button>
      <button onClick={() => handlesetCount(-100)}>-100</button>
      <button onClick={() => handlesetCount(+100)}> +100</button>
      <button onClick={() => handlesetCount(+10)}>+10</button>
      <button onClick={() => handlesetCount(+1)}>+1</button>
    </div>
  );
};

export default Controller;
