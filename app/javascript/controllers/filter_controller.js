import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["upcoming", "past", "booked", "questions", "button"]

  filter(event) {
    const filterType = event.target.dataset.filter

    this.hideAllTargets()

    if (filterType === "upcoming" && this.hasUpcomingTarget) {
      this.upcomingTarget.classList.remove("d-none")
    } else if (filterType === "past" && this.hasPastTarget) {
      this.pastTarget.classList.remove("d-none")
    } else if (filterType === "booked" && this.hasBookedTarget) {
      this.bookedTarget.classList.remove("d-none")
    } else if (filterType === "questions" && this.hasQuestionsTarget) {
      this.questionsTarget.classList.remove("d-none")
    }

    this.buttonTargets.forEach(button => {
      button.classList.remove("active")
    })
    event.target.classList.add("active")
  }

  hideAllTargets() {
    if (this.hasUpcomingTarget) this.upcomingTarget.classList.add("d-none")
    if (this.hasPastTarget) this.pastTarget.classList.add("d-none")
    if (this.hasBookedTarget) this.bookedTarget.classList.add("d-none")
    if (this.hasQuestionsTarget) this.questionsTarget.classList.add("d-none")
  }
}
