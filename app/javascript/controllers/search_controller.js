import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["source", "results"]

  showResults(event) {
    let query = this.sourceTarget.value
    if (query === '') {
      this.hideResults()
    } else {
      let url = '/search_preview'
      $.ajax({
        url: url,
        data: { query: query },
        success: (data, textStatus, jqXHR) => {
          this.resultsTarget.innerHTML = data
          this.resultsTarget.classList.remove('hidden')
        }
      })
    }
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      this.hideResults()
    }
  }

  reset(event) {
    this.hideResults()
    this.sourceTarget.value = ""
  }

  hideResults() {
    this.resultsTarget.classList.add("hidden")
  }
}
