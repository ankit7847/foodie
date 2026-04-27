// Get the toggle button for the left navigation panel
var toggleBtn = document.getElementById("toggleBtn");

// Toggle visibility of the left navigation panel when the toggle button is clicked
toggleBtn.addEventListener("click", function() {
    var sidebar = document.querySelector(".sidebar");
    //sidebar.classList.toggle("active");
    
    // Get all elements with the class "nav-text"
    var navTextElements = sidebar.querySelectorAll(".nav-text");
    
    var sectionMain = document.querySelector(".section-main");

    // Iterate over each "nav-text" element
    navTextElements.forEach(function(element) {
        // Toggle the "active" class
        element.classList.toggle("active");
    });
    
    sectionMain.classList.toggle("active");
    
    
});



// Get all links in the sidebar
var sidebarLinks = document.querySelectorAll(".nav-links a");


// Get all dashboard sections
var sections = document.querySelectorAll(".dashboard-section");


// Add click event listeners to sidebar links to show corresponding sections
sidebarLinks.forEach(function(link) {
    link.addEventListener("click", function(event) {
        event.preventDefault();
        var targetSectionId = this.dataset.section;
        var targetSection = document.getElementById(targetSectionId);

        // Toggle visibility of target section
        targetSection.classList.add("active");

        // Hide other sections
        sections.forEach(function(section) {
            if (section.id !== targetSectionId) {
                section.classList.remove("active");
            }
        });

        // Add "active" class to the clicked link and remove from others
        sidebarLinks.forEach(function(link) {
            if (link.dataset.section === targetSectionId) {
                link.classList.add("active");
            } else {
                link.classList.remove("active");
            }
        });
    });
});
