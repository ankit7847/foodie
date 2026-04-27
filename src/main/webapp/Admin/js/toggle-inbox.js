document.addEventListener("DOMContentLoaded", function() {
  // Get all the cards
  var cards = document.querySelectorAll(".card");

  // Loop through each card
  cards.forEach(function(card) {
    // Add click event listener to each card
    card.addEventListener("click", function() {
      // Toggle the active class on the next sibling (.toggle div) when the card is clicked
      var toggleDiv = this.nextElementSibling; // Get the sibling .toggle div
      toggleDiv.classList.toggle("active");
    });
  });
});
