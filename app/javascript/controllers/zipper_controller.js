import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['zip', 'city']

  initialize () {
    this.countryCode = this.element.dataset.countryCode
  }

  update () {
    this.cleanZip()
    if (this.zipTarget.value.length < 3) {
      this.cityTarget.value = ''
      return false
    }

    fetch(`https://postnr.herokuapp.com/city/${this.countryCode}/${this.zipTarget.value}`)
      .then(response => response.text())
      .then(val => {
        this.cityTarget.value = val
      })
  }

  cleanZip () {
    this.zipTarget.value = this.zipTarget.value.replace(/\D/, '')
  }

}
