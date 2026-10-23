(() => {
  "use strict";

  const navigation = document.querySelector(".page-toc");
  const layout = document.querySelector(".page-layout");
  const main = document.querySelector("#main-content");
  const rail = document.querySelector(".toc-rail");
  const toggle = document.querySelector(".toc-toggle");
  const backdrop = document.querySelector(".toc-backdrop");
  const skipLink = document.querySelector(".skip-link");
  const links = [...navigation.querySelectorAll('a[href^="#"]')];
  const smallScreen = window.matchMedia("(max-width: 900px)");
  let isOpen = false;
  const setOpen = (open, moveFocus = false) => {
    const focusWasInside = navigation.contains(document.activeElement);
    isOpen = open && links.length > 0;
    const modal = isOpen && smallScreen.matches;
    navigation.hidden = !isOpen;
    layout.classList.toggle("toc-collapsed", !isOpen);
    document.documentElement.classList.toggle("toc-open", isOpen);
    toggle.setAttribute("aria-expanded", String(isOpen));
    toggle.setAttribute("aria-label", isOpen ? "收起目录" : "打开目录");
    toggle.title = isOpen ? "收起目录" : "打开目录";
    backdrop.hidden = !modal;
    document.body.classList.toggle("toc-modal-open", modal);
    main.inert = modal;
    skipLink.inert = modal;
    if (isOpen && moveFocus) links[0].focus();
    else if (!isOpen && (moveFocus || focusWasInside)) toggle.focus();
  };
  if (links.length) {
    document.documentElement.classList.add("toc-enhanced");
    rail.hidden = false;
  }
  const adaptNavigation = () => setOpen(!smallScreen.matches);
  adaptNavigation();
  if (smallScreen.addEventListener) smallScreen.addEventListener("change", adaptNavigation);
  else if (smallScreen.addListener) smallScreen.addListener(adaptNavigation);
  toggle.addEventListener("click", () => setOpen(!isOpen, true));
  backdrop.addEventListener("click", () => setOpen(false, true));
  document.addEventListener("keydown", event => {
    if (!isOpen || !smallScreen.matches) return;
    if (event.key === "Escape") {
      event.preventDefault();
      setOpen(false, true);
    } else if (event.key === "Tab") {
      const first = toggle;
      const last = links[links.length - 1];
      if (event.shiftKey && document.activeElement === first) {
        event.preventDefault();
        last.focus();
      } else if (!event.shiftKey && document.activeElement === last) {
        event.preventDefault();
        first.focus();
      }
    }
  });

  const sections = links.map(link => {
    let id;
    try { id = decodeURIComponent(link.hash.slice(1)); }
    catch { return null; }
    const heading = document.getElementById(id);
    return heading ? { link, heading } : null;
  }).filter(Boolean);

  for (const { link, heading } of sections) {
    link.addEventListener("click", () => {
      if (!smallScreen.matches) return;
      setOpen(false);
      heading.setAttribute("tabindex", "-1");
      heading.focus({ preventScroll: true });
    });
  }

  let pending = false;
  const markCurrentSection = () => {
    let current = sections[0];
    for (const section of sections) {
      if (section.heading.getBoundingClientRect().top <= 120) current = section;
      else break;
    }
    for (const section of sections) {
      if (section === current) section.link.setAttribute("aria-current", "location");
      else section.link.removeAttribute("aria-current");
    }
    pending = false;
  };
  window.addEventListener("scroll", () => {
    if (!pending) {
      pending = true;
      window.requestAnimationFrame(markCurrentSection);
    }
  }, { passive: true });
  window.addEventListener("resize", markCurrentSection);
  window.addEventListener("load", markCurrentSection);
  markCurrentSection();

  const copyFallback = text => {
    const textarea = document.createElement("textarea");
    textarea.value = text;
    textarea.setAttribute("readonly", "");
    textarea.style.cssText = "position:fixed;top:0;left:-9999px;";
    const previousFocus = document.activeElement;
    document.body.append(textarea);
    textarea.select();
    try {
      if (!document.execCommand("copy")) throw new Error("Copy failed");
    } finally {
      textarea.remove();
      if (previousFocus) previousFocus.focus({ preventScroll: true });
    }
  };

  for (const code of document.querySelectorAll(".prose pre > code")) {
    const pre = code.parentElement;
    const wrapper = document.createElement("div");
    wrapper.className = "code-block";
    pre.before(wrapper);
    wrapper.append(pre);
    pre.tabIndex = 0;
    const button = document.createElement("button");
    button.type = "button";
    button.className = "copy-button";
    button.textContent = "复制代码";
    button.setAttribute("aria-live", "polite");
    wrapper.append(button);
    button.addEventListener("click", async () => {
      try {
        if (navigator.clipboard && window.isSecureContext) {
          try { await navigator.clipboard.writeText(code.textContent); }
          catch { copyFallback(code.textContent); }
        } else copyFallback(code.textContent);
        button.textContent = "已复制";
      } catch {
        button.textContent = "请手动选择并复制";
      }
      window.setTimeout(() => { button.textContent = "复制代码"; }, 2000);
    });
  }
  const viewer = document.querySelector(".image-viewer");
  const viewerContent = viewer.querySelector(".image-viewer-content");
  let imageTrigger = null;
  const prepareImages = () => {
    for (const image of main.querySelectorAll("img, svg")) {
      if (image.closest("a") || image.parentElement.closest("svg")) continue;
      image.classList.add("zoomable");
      image.tabIndex = 0;
      image.setAttribute("role", "button");
      const description = image.getAttribute("alt") || image.querySelector("title")?.textContent || "图示";
      image.setAttribute("aria-label", "放大：" + description);
      image.setAttribute("aria-haspopup", "dialog");
      image.setAttribute("title", "点击放大");
    }
  };
  const showImage = source => {
    const enlarged = document.createElement("img");
    let naturalWidth = source.naturalWidth || 0;
    if (source.tagName.toLowerCase() === "svg") {
      const copy = source.cloneNode(true);
      const box = source.viewBox.baseVal;
      if (box.width && box.height) {
        naturalWidth = box.width;
        copy.setAttribute("width", box.width);
        copy.setAttribute("height", box.height);
      }
      copy.style.removeProperty("width");
      copy.style.removeProperty("max-width");
      enlarged.src = "data:image/svg+xml;charset=utf-8," + encodeURIComponent(new XMLSerializer().serializeToString(copy));
    } else enlarged.src = source.currentSrc || source.src;
    enlarged.alt = source.getAttribute("alt") || source.querySelector("title")?.textContent || "放大图示";
    enlarged.style.width = Math.ceil(Math.max(naturalWidth, source.getBoundingClientRect().width * 2)) + "px";
    viewerContent.replaceChildren(enlarged);
    imageTrigger = source;
    viewer.showModal();
    viewerContent.scrollTo(0, 0);
    document.body.classList.add("image-modal-open");
  };
  main.addEventListener("click", event => {
    const source = event.target.closest(".zoomable");
    if (source) showImage(source);
  });
  main.addEventListener("keydown", event => {
    if ((event.key === "Enter" || event.key === " ") && event.target.matches(".zoomable")) {
      event.preventDefault();
      showImage(event.target);
    }
  });
  viewer.addEventListener("click", () => viewer.close());
  viewer.addEventListener("keydown", event => {
    if (event.key === "Enter" || event.key === " ") {
      event.preventDefault();
      viewer.close();
    }
  });
  viewer.addEventListener("close", () => {
    document.body.classList.remove("image-modal-open");
    viewerContent.replaceChildren();
    if (imageTrigger?.isConnected) imageTrigger.focus({ preventScroll: true });
  });
  prepareImages();
  window.addEventListener("diagrams-rendered", prepareImages);
})();
