import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['btn', 'content']

  navigate (e) {
    this.tabId = e.currentTarget.dataset.tabId

    this.btnTargets.forEach((el) => {
      if (el.dataset.tabId === this.tabId) {
        el.classList.add('font-bold')
      }
      else {
        el.classList.remove('font-bold')
      }
    })

    this.contentTargets.forEach((el) => {
      if (el.dataset.tabId === this.tabId) {
        el.classList.remove('hidden')
      }
      else {
        el.classList.add('hidden')
      }
    })
  }

}
