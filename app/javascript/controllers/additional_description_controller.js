import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['container', 'body', 'overlay', 'minimize', 'expand']

  connect () {
    this.setup()
  }

  setup () {
    if (this.contractedHeight > 0 && this.contractedHeight >= this.expandedHeight) {
      this.overlayTarget.remove()
      this.minimizeTarget.remove()
    }
  }

  expand () {
    this.overlayTarget.classList.add('hidden')
    this.containerTarget.style.maxHeight = `${this.expandedHeight + 50}px`
  }

  minimize () {
    this.overlayTarget.classList.remove('hidden')
    this.containerTarget.style.maxHeight = null
  }

  get expandedHeight () {
    return this.bodyTarget.getBoundingClientRect().height
  }

  get contractedHeight () {
    return this.containerTarget.getBoundingClientRect().height
  }

}
