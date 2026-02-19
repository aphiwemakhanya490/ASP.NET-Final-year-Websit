const currentPage = window.location.pathname.split("/").pop();

// Get all links
document.querySelectorAll("nav a").forEach(link => {
    if (link.getAttribute("href") === currentPage) {
        link.classList.add("active");
    }
});