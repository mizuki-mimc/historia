import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "container", "image", "card", "handle" ]

  connect() {
    this.drag = this.drag.bind(this)
    this.endDrag = this.endDrag.bind(this)
  }

  open(event) {
    event.preventDefault()
    const imageUrl = event.params.src
    this.imageTarget.src = imageUrl
    this.containerTarget.classList.remove("hidden")
  }

  close() {
    this.containerTarget.classList.add("hidden")
    this.imageTarget.src = ""
    this.cardTarget.style.transform = ''
  }

  preventClose(event) {
    event.stopPropagation()
  }

  startDrag(event) {
    if (event.button !== 0) return
    
    event.stopPropagation()
    event.preventDefault()
    
    this.handleTarget.style.cursor = 'grabbing'
    
    this.startX = event.clientX
    this.startY = event.clientY
    const style = window.getComputedStyle(this.cardTarget)
    const matrix = new DOMMatrixReadOnly(style.transform)
    this.initialTranslateX = matrix.m41
    this.initialTranslateY = matrix.m42

    window.addEventListener('mousemove', this.drag)
    window.addEventListener('mouseup', this.endDrag, { once: true })
  }

  drag(event) {
    event.preventDefault()
    const dx = event.clientX - this.startX
    const dy = event.clientY - this.startY
    this.cardTarget.style.transform = `translate(${this.initialTranslateX + dx}px, ${this.initialTranslateY + dy}px)`
  }

  endDrag() {
    this.handleTarget.style.cursor = 'grab'
    window.removeEventListener('mousemove', this.drag)
  }
}
