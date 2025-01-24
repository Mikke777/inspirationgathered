import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["upcoming", "past", "button"]

  filter(event) {
    const filterType = event.target.dataset.filter

    this.upcomingTarget.classList.add("d-none")
    this.pastTarget.classList.add("d-none")

    if (filterType === "upcoming") {
      this.upcomingTarget.classList.remove("d-none")
    } else if (filterType === "past") {
      this.pastTarget.classList.remove("d-none")
    }

    this.buttonTargets.forEach(button => {
      button.classList.remove("active")
    })
    event.target.classList.add("active")
  }
}
