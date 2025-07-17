import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "previewContainer", "existingImageWrapper", "removeInput" ]

  connect() {
    this.boundRemoveImage = this.removeImage.bind(this)
    window.addEventListener("remove-image", this.boundRemoveImage)
  }

  disconnect() {
    window.removeEventListener("remove-image", this.boundRemoveImage)
  }

  preview() {
    const file = this.inputTarget.files[0]
    if (!file) return;

    if (this.hasExistingImageWrapperTarget) {
      this.existingImageWrapperTarget.classList.add('hidden')
    }
    if (this.hasRemoveInputTarget) {
      this.removeInputTarget.value = '0'
    }

    const reader = new FileReader()
    reader.onload = (e) => {
      this.previewContainerTarget.innerHTML = `
        <div class="relative w-32 h-32">
          <img src="${e.target.result}" class="w-32 h-32 object-cover rounded-lg">
          <button type="button"
                  class="absolute -top-2 -right-2 bg-gray-700 text-white rounded-full h-6 w-6 flex items-center justify-center text-xs font-bold hover:bg-red-600 transition-colors"
                  data-action="click->modal#open"
                  data-modal-title="イメージ画像の削除"
                  data-modal-body="イメージ画像を削除します。本当によろしいですか？"
                  data-modal-button-text="削除する"
                  data-modal-confirm-event-name-param="remove-image">
            ×
          </button>
        </div>
      `
    }
    reader.readAsDataURL(file)
  }

  removeImage() {
    this.inputTarget.value = ""
    this.previewContainerTarget.innerHTML = ""

    if (this.hasExistingImageWrapperTarget) {
      this.existingImageWrapperTarget.classList.add('hidden')
    }

    if (this.hasRemoveInputTarget) {
      this.removeInputTarget.value = '1'
    }
  }
}
