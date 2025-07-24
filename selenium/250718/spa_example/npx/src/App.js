import React, { useState } from "react";
import Viewer from "./Viewer";
import Controller from "./Controller";
import "./App.css";

const App = () => {
  const [count, setCount] = useState(0);
  const handlesetCount = (value) => {
    setCount(count + value);
  };
  return (
    <div className="App">
      <h1>Simple Counter</h1>
      <section>
        <Viewer count={count} />
      </section>
      <section>
        <Controller handlesetCount={handlesetCount} />
      </section>
    </div>
  );
};

export default App;
