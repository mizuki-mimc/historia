import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  goBack() {
    history.back()
  }
}
