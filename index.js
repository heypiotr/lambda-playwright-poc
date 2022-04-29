const { webkit } = require("playwright");

let browserPromise = webkit.launch();
async function getBrowser() {
  if (!browserPromise) {
    browserPromise = webkit.launch();
  }
  return browserPromise;
}

async function run(label, fn) {
  try {
    console.time(label);
    return await fn();
  } finally {
    console.timeEnd(label);
  }
}

module.exports.handler = async function handler() {
  try {
    const browser = await run("getBrowser", () => getBrowser());

    const page = await run("browser.newPage", () => browser.newPage());
    console.log("browser contexts", browser.contexts().length);

    const base64 = Buffer.from(Date.now().toString()).toString("base64");
    await run("page.goto", () =>
      page.goto(`https://httpbin.org/base64/${base64}`)
    );

    const content = await run("page.content", () => page.content());
    console.log(content);

    await run("page.close", () => page.close());
    console.log("browser contexts", browser.contexts().length);

    return content;
  } catch (error) {
    // Assume browser crashed
    try {
      // Try to clean it up; it's fine if this fails
      const browser = await browserPromise;
      await browser.close();
    } catch {}
    // Let's re-create the browser during the next event
    browserPromise = null;

    throw error;
  }
};
