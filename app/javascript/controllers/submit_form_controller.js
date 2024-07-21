import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "search"];

  connect() {
    this.formTarget.focus();
    this.searchTarget.focus();
    var length = this.searchTarget.value.length;
    this.searchTarget.setSelectionRange(length, length);
  }

  submit() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this._submit();
    }, 300);
  }

  _submit() {
    this.formTarget.requestSubmit();
  }
}
