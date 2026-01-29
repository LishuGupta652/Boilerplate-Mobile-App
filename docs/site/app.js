const sections = Array.from(document.querySelectorAll("main section"));
const navLinks = Array.from(document.querySelectorAll(".nav-links a"));

const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) return;
      const id = entry.target.getAttribute("id");
      navLinks.forEach((link) => {
        const isActive = link.getAttribute("href") === `#${id}`;
        link.classList.toggle("active", isActive);
      });
    });
  },
  { threshold: 0.4 }
);

sections.forEach((section) => observer.observe(section));
