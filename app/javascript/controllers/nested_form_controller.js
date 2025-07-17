import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "template", 
    "container", 
    "inputType", 
    "inputExplanation",
    "flashContainer",
    "modalPlaceholder"
  ]

  static values = {
    modalTitle: { type: String, default: "項目の削除" },
    modalMessage: { type: String, default: "この項目を削除しますか？" }
  }

  connect() {
    console.log("✅ nested-form controller connected for:", this.element.dataset.formType);
    this.restoreFieldsOnError();
  }

  restoreFieldsOnError() {
    console.log("🔄 Attempting to restore fields...");
    const errorTrigger = document.getElementById('form-validation-error-trigger');

    if (!errorTrigger) {
      console.log("   -> No error trigger found. Exiting restore.");
      return;
    }

    if (!this.hasContainerTarget) {
      console.error("   -> CRITICAL: container target is missing!");
      return;
    }

    const formType = this.element.dataset.formType;
    console.log(`   -> Error trigger found. This form is for: [${formType}]`);

    const dataKey = formType === 'worldGuideFeatures' ? 'worldGuideFeatures' : formType;
    if (!formType || !errorTrigger.dataset[dataKey]) {
      console.log(`   -> No data to restore for [${formType}].`);
      return;
    }

    const dataToRestore = JSON.parse(errorTrigger.dataset[dataKey]);
    
    if (dataToRestore.length === 0) {
      console.log(`   -> Data for [${formType}] is empty.`);
      return;
    }
    
    console.log(`   -> Received ${dataToRestore.length} items for [${formType}]:`, dataToRestore);

    this.containerTarget.innerHTML = '';

    dataToRestore.forEach(data => {
      if (!data.id) {
        console.log("     -> Restoring unsaved item:", data);

        if (formType === 'features') {
          this.inputTypeTarget.value = data.character_feature_category_id;
          this.inputExplanationTarget.value = data.explanation;
        } else if (formType === 'relationships') {
          this.inputTypeTarget.value = data.related_character_id;
          this.inputExplanationTarget.value = data.relationship_type;
        } else if (formType === 'worldGuideFeatures') {
          this.inputTypeTarget.value = data.world_feature_category_id;
          this.inputExplanationTarget.value = data.explanation;
        }

        this.add(new Event('manual_restore'));
      } else {
        console.log("     -> Skipping saved item (already rendered by Rails):", data);
      }
    });
  }

  add(event) {
    if (event.type !== 'manual_restore') {
      event.preventDefault()
    }

    if (!this.hasInputTypeTarget || !this.hasInputExplanationTarget || !this.hasTemplateTarget || !this.hasContainerTarget) {
      console.error("Cannot add field: one or more targets are missing (inputType, inputExplanation, template, container).");
      return;
    }

    const selectedOption = this.inputTypeTarget.selectedOptions[0];
    const categoryId = selectedOption.value;
    const categoryName = selectedOption.dataset.category; 
    const characterName = selectedOption.dataset.name;
    const explanation = this.inputExplanationTarget.value;

    const formType = this.element.dataset.formType; 
    let newContentHTML;

    if (!categoryId || explanation.trim() === "") {
      if (event.type !== 'manual_restore') {
        if (formType === 'relationships') {
          this.showFlash("キャラクターと関係性の両方を入力してください。");
        } else if (formType === 'features' || formType === 'worldGuideFeatures') {
          this.showFlash("特徴と説明の両方を入力してください。");
        } else {
          this.showFlash("項目を入力してください。");
        }
        return;
      }
    }
 
    if (this.hasFlashContainerTarget) {
      this.flashContainerTarget.innerHTML = ""
    }
 
    const childIndex = new Date().getTime() + Math.floor(Math.random() * 1000);
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, childIndex);
    this.containerTarget.insertAdjacentHTML("beforeend", content)
    const newCapsule = this.containerTarget.lastElementChild;
    const capsuleTextSpan = newCapsule.querySelector("[data-nested-form-target='capsuleText']");

    if (formType === 'features' || formType === 'worldGuideFeatures') {
      const featureCategoryName = selectedOption.dataset.name; 
      newContentHTML = `
        <span class="flex items-center">${featureCategoryName} / ${explanation}</span>
      `;
    } else if (formType === 'relationships') {
      newContentHTML = `
        <span class="flex items-center">${categoryName}</span>
        <span class="border-l border-gray-700"></span>
        <span class="flex items-center">${characterName} / ${explanation}</span>
      `;
    } else {
      const genericCategoryName = selectedOption.dataset.category || selectedOption.dataset.name;
      newContentHTML = `
        <span class="flex items-center">${genericCategoryName} / ${explanation}</span>
      `;
    }

    capsuleTextSpan.innerHTML = newContentHTML;
    capsuleTextSpan.classList.add("flex", "items-stretch", "gap-x-2");

    if (formType === 'features') {
        newCapsule.querySelector("[data-nested-form-target='hiddenCategoryId']").value = categoryId;
        newCapsule.querySelector("[data-nested-form-target='hiddenExplanation']").value = explanation;
    } else if (formType === 'relationships') {

        const hiddenRelatedCharIdInput = newCapsule.querySelector("[data-nested-form-target='hiddenCategoryId']");
        const hiddenRelationshipTypeInput = newCapsule.querySelector("[data-nested-form-target='hiddenExplanation']");
        
        if (hiddenRelatedCharIdInput) {
            hiddenRelatedCharIdInput.value = categoryId;
        } else {
            console.warn("hiddenCategoryId target not found for relationships.");
        }
        
        if (hiddenRelationshipTypeInput) {
            hiddenRelationshipTypeInput.value = explanation;
        } else {
            console.warn("hiddenExplanation target not found for relationships.");
        }
    } else if (formType === 'worldGuideFeatures') {
        newCapsule.querySelector("[data-nested-form-target='hiddenCategoryId']").value = categoryId;
        newCapsule.querySelector("[data-nested-form-target='hiddenExplanation']").value = explanation;
    }

    this.inputExplanationTarget.value = "";
    this.inputTypeTarget.selectedIndex = 0;
  }

  remove(event) {
    event.preventDefault()
    const wrapper = event.target.closest(".nested-fields-wrapper")

    const removalLogic = () => {
      if (wrapper.dataset.newRecord === "true") {
        wrapper.remove()
      } else {
        wrapper.style.display = "none"
        const destroyInput = wrapper.querySelector("input[name*='_destroy']")
        destroyInput.value = "1"
      }
    }
    this.showConfirmationModal(this.modalMessageValue, removalLogic)
  }

  showConfirmationModal(message, callback) {
    if (!this.hasModalPlaceholderTarget) return;
    this.hideConfirmationModal()
    const modalHTML = `
      <div class="fixed inset-0 z-[1050] bg-gray-900 bg-opacity-50 transition-opacity" data-action="click->nested-form#hideConfirmationModal"></div>
      <div class="fixed inset-0  z-[1060] w-screen overflow-y-auto">
        <div class="flex min-h-full items-center justify-center p-4 text-center">
          <div class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
            <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
              <div class="sm:flex sm:items-start">
                <div class="mx-auto flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
                  <svg class="h-6 w-6 text-red-600" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z" /></svg>
                </div>
                <div class="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left">
                  <h3 class="text-base font-semibold leading-6 text-gray-900">${this.modalTitleValue}</h3>
                  <div class="mt-2"><p class="text-sm text-gray-500">${message}</p></div>
                </div>
              </div>
            </div>
            <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6">
              <button type="button" data-action="click->nested-form#confirmAndHide" class="inline-flex w-full justify-center rounded-md bg-red-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-red-500 sm:ml-3 sm:w-auto">削除する</button>
              <button type="button" data-action="click->nested-form#hideConfirmationModal" class="mt-3 inline-flex w-full justify-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 sm:mt-0 sm:w-auto">キャンセル</button>
            </div>
          </div>
        </div>
      </div>
    `
    this.modalPlaceholderTarget.innerHTML = modalHTML
    this.confirmCallback = callback
  }

  hideConfirmationModal() {
    if (this.hasModalPlaceholderTarget) {
      this.modalPlaceholderTarget.innerHTML = ""
    }
    this.confirmCallback = null
  }

  confirmAndHide() {
    if (this.confirmCallback) {
      this.confirmCallback()
    }
    this.hideConfirmationModal()
  }

  showFlash(message) {
    if (!this.hasFlashContainerTarget) return;
    const flashEl = document.createElement("div")
    flashEl.className = "p-3 bg-red-100 border border-red-400 text-red-700 rounded-md text-sm"
    flashEl.textContent = message
    this.flashContainerTarget.innerHTML = ""
    this.flashContainerTarget.appendChild(flashEl)
  }
}
