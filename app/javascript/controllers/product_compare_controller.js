import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["selector", "page"]

  connect() {
    this.selectorTargets[0].click()
  }

  choose(e) {
    e.preventDefault()
    let pageIndex = this.selectorTargets.indexOf(e.target)

    this.selectorTargets.forEach( (selector) => {
      selector.classList.remove("border-black")
    })
    e.target.classList.add("border-black")

    this.pageTargets.forEach( (page) => {
      page.classList.add("hidden")
    })
    this.pageTargets[pageIndex].classList.remove("hidden")
  }
}
