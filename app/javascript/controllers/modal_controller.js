import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "container", "form", "modalTitle", "body", "submitButton" ]
  static values = { confirmEventName: String }

  open(event) {
    event.preventDefault()
    this.containerTarget.classList.remove("hidden")
    this.submitButtonTarget.classList.remove("hidden")

    const dataset = event.currentTarget.dataset
    const title = dataset.modalTitle || "確認"
    const body = dataset.modalBody || "この操作を続けてもよろしいですか？"
    const buttonText = dataset.modalButtonText || "実行する"
    const url = dataset.modalUrl

    this.confirmEventNameValue = dataset.modalConfirmEventNameParam || ""

    this.modalTitleTarget.textContent = title
    this.bodyTarget.innerHTML = body
    this.submitButtonTarget.value = buttonText

    this.submitButtonTarget.dataset.action = "click->modal#confirm"

    if (this.confirmEventNameValue) {
      this.submitButtonTarget.type = "button"
      this.formTarget.action = ""
    } else {
      this.submitButtonTarget.type = "submit"
      this.formTarget.action = url
    }
  }

  confirm(event) {
    event.preventDefault()
    if (this.confirmEventNameValue) {
      const customEvent = new CustomEvent(this.confirmEventNameValue, { bubbles: true })
      window.dispatchEvent(customEvent)
    } else {
      this.formTarget.requestSubmit()
    }
    this.close()
  }

  close() {
    this.containerTarget.classList.add("hidden")
  }

  showWarning(event) {
    const { title, body } = event.detail
    this.modalTitleTarget.textContent = title
    this.bodyTarget.innerHTML = `<p>${body}</p>`
    this.submitButtonTarget.classList.add("hidden")
    this.containerTarget.classList.remove("hidden")
  }
}
