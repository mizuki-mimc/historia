import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "select", "textarea" ]
  static values = { templates: Array }

  insert() {
    const selectedId = this.selectTarget.value;
    if (!selectedId) {
      return;
    }

    const template = this.templatesValue.find(t => t.id == selectedId);
    if (!template) {
      return;
    }

    const currentText = this.textareaTarget.value;
    const templateBody = template.body;

    if (currentText.length > 0 && !currentText.endsWith('\n\n')) {
      if (currentText.endsWith('\n')) {
        this.textareaTarget.value = `${currentText}\n${templateBody}\n`;
      } else {
        this.textareaTarget.value = `${currentText}\n\n${templateBody}\n`;
      }
    } else {
      this.textareaTarget.value = `${currentText}${templateBody}\n`;
    }

    this.textareaTarget.focus();
    this.selectTarget.selectedIndex = 0;
  }
}
