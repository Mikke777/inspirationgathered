import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["title", "story", "workshops", "storyLink", "workshopsLink"];

  changeTitle(event) {
    event.preventDefault();
    const title = event.currentTarget.dataset.title;
    this.titleTarget.innerText = title;

    if (title === "My Story") {
      this.showStory();
    } else if (title === "My Workshops") {
      this.showWorkshops();
    }
  }

  showStory() {
    if (!this.storyTarget.classList.contains("show")) {
      this.storyTarget.classList.add("show");
      this.workshopsTarget.classList.remove("show");
      this.storyLinkTarget.classList.add("active-link");
      this.workshopsLinkTarget.classList.remove("active-link");
    }
  }

  showWorkshops() {
    if (!this.workshopsTarget.classList.contains("show")) {
      this.workshopsTarget.classList.add("show");
      this.storyTarget.classList.remove("show");
      this.workshopsLinkTarget.classList.add("active-link");
      this.storyLinkTarget.classList.remove("active-link");
    }
  }
}
