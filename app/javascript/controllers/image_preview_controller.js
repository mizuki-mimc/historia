import { Controller } from "@hotwired/stimulus"

// This controller handles live previewing of a selected image file
// and manages the removal of an existing or newly previewed image.
export default class extends Controller {
  static targets = [ "input", "previewContainer", "existingImageWrapper", "removeInput" ]

  connect() {
    // Bind the removeImage function to the controller instance
    // and listen for a custom event dispatched from a modal.
    this.boundRemoveImage = this.removeImage.bind(this)
    window.addEventListener("remove-image", this.boundRemoveImage)
  }

  disconnect() {
    // Clean up the event listener when the controller is disconnected.
    window.removeEventListener("remove-image", this.boundRemoveImage)
  }

  // Previews the selected image file.
  preview() {
    const file = this.inputTarget.files[0]
    if (!file) return;

    // When a new image is selected, hide the existing one and reset the remove flag.
    if (this.hasExistingImageWrapperTarget) {
      this.existingImageWrapperTarget.classList.add('hidden')
    }
    if (this.hasRemoveInputTarget) {
      this.removeInputTarget.value = '0'
    }

    const reader = new FileReader()
    reader.onload = (e) => {
      // Create and display the preview image with a remove button.
      this.previewContainerTarget.innerHTML = `
        <div class="relative w-32 h-32">
          <img src="${e.target.result}" class="w-32 h-32 object-cover rounded-lg">
          <button type="button"
                  class="absolute -top-2 -right-2 bg-gray-700 text-white rounded-full h-6 w-6 flex items-center justify-center text-xs font-bold hover:bg-red-600 transition-colors"
                  data-action="click->modal#open"
                  data-modal-title="イメージ画像の削除"
                  data-modal-body="選択した画像をキャンセルします。よろしいですか？"
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