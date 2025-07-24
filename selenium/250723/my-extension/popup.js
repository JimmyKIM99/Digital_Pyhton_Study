document.getElementById("btn").addEventListener("click", () => {
  chrome.runtime.sendMessage({ type: "getData" }, (response) => {
    if (chrome.runtime.lastError) {
      document.getElementById("result").textContent = "Error: " + chrome.runtime.lastError.message;
      return;
    }
    document.getElementById("result").textContent = response.data;
  });
});