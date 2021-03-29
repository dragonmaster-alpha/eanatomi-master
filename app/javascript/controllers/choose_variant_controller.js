import { Controller } from "stimulus"


export default class extends Controller {
  static targets = ['input', 'variant']

  change () {
    this.variantTargets.forEach((el) => {
      if (el.dataset.id === this.variantID) {
        el.classList.remove('hidden')
      }
      else {
        el.classList.add('hidden')
      }
    })
  }

  get variantID () {
    return this.inputTargets.find((el) => {
      return el.checked
    }).value
  }

}
