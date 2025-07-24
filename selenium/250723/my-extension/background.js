chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.type === "getData") {
    async function handleMessage() {
      await new Promise(resolve => setTimeout(resolve, 1000));
      sendResponse({ data: "Hello from background!" });
    }
    handleMessage();
    return true;
  }
});