document.addEventListener('DOMContentLoaded', function () {
  const searchIcon = document.querySelector('.search-icon');
  const inputContainer = document.querySelector('.input-container');
  const searchInput = document.querySelector('.search-input');

  // Toggle active state when clicking the search icon
  searchIcon.addEventListener('click', () => {
    inputContainer.classList.toggle('active');
    if (inputContainer.classList.contains('active')) {
      searchInput.focus(); // Automatically focus on the input when it expands
    }
  });

  // Close the search bar when clicking outside of it
  document.addEventListener('click', (e) => {
    if (!inputContainer.contains(e.target) && !searchIcon.contains(e.target)) {
      inputContainer.classList.remove('active');
    }
  });
});
