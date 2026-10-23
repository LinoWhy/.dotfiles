(async () => {
  "use strict";
  mermaid.initialize({
    startOnLoad: false,
    securityLevel: "strict",
    theme: "base",
    look: "classic",
    themeVariables: {
      fontFamily: "system-ui, sans-serif",
      fontSize: "18px",
      primaryColor: "#edf5f2",
      primaryBorderColor: "#528d80",
      primaryTextColor: "#25323b",
      lineColor: "#657d89"
    },
    flowchart: { htmlLabels: false, curve: "linear", useMaxWidth: true }
  });
  await document.fonts.ready;
  const sources = [...document.querySelectorAll("pre.mermaid")];
  for (const [index, source] of sources.entries()) {
    try {
      const result = await mermaid.render("mermaid-diagram-" + index, source.textContent);
      const container = document.createElement("div");
      container.className = "diagram";
      container.innerHTML = result.svg;
      const svg = container.querySelector("svg");
      svg.style.width = svg.viewBox.baseVal.width + "px";
      svg.style.maxWidth = "100%";
      source.replaceWith(container);
    } catch {
      const message = document.createElement("p");
      message.textContent = "图示未能渲染，请检查下面的 Mermaid 源码。";
      source.before(message);
    }
  }
  window.dispatchEvent(new Event("scroll"));
  window.dispatchEvent(new Event("diagrams-rendered"));
})();
