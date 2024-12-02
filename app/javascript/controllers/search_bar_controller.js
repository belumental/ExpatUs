import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search-bar"
export default class extends Controller {
  static targets = ["icon", "container", "input"]; // Define targets

  connect() {
    // Toggle active state when clicking the search icon
    this.iconTarget.addEventListener("click", () => {
      this.containerTarget.classList.toggle("active");
      if (this.containerTarget.classList.contains("active")) {
        this.inputTarget.focus(); // Automatically focus on the input when it expands
      }
    });

    // Close the search bar when clicking outside of it
    document.addEventListener("click", (event) => {
      if (
        !this.containerTarget.contains(event.target) &&
        !this.iconTarget.contains(event.target)
      ) {
        this.containerTarget.classList.remove("active");
      }
    });
  }
}
