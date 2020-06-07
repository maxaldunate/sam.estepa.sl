import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators, AbstractControl, ValidatorFn } from '@angular/forms';
import { NgbActiveModal, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { MythicalMysfitProfileService } from '../services/mythical-mysfit-profile.service';

@Component({
  selector: 'mm-contact',
  templateUrl: './contact.component.html',
  styleUrls: ['./contact.component.css']
})
export class ContactComponent implements OnInit {
  contactForm: FormGroup;
  errorMessage: string;
  showError = false;
  showSuccess = false;

  get email() { return this.contactForm.get('email'); }
  get question() { return this.contactForm.get('question'); }

  constructor(
    public activeModal: NgbActiveModal,
    private formBuilder: FormBuilder,
    private mysfitsService: MythicalMysfitProfileService,
    ) { }

  ngOnInit() {
      this._createQuestionForm();
  }

  _createQuestionForm() {
      this.contactForm = this.formBuilder.group(
      {
        email: ['', [Validators.required, Validators.email]],
        question: ['', [Validators.required]],
      },
    );
  }

  async submitContactForm() {
    try {
      let res = this.mysfitsService.registerQuestion({ email: this.email.value, question: this.question.value } );
      console.log(res);
      this.activeModal.close('submitted');
      this.showSuccess = true;
    } catch (e) {
      console.log(e);
      this.errorMessage = this._processAuthError(e);
      this.showError = true;
    }
  }

  _processAuthError(e) {
    let message = "An error occurred...";
    if (e && e.code) {
      switch (e.code) {
        case "UserNotFoundException":
          message = `${e.message} Try registering first.`;
          break;
        case "UsernameExistsException":
          message = `${e.message}. Try logging in.`;
          break;
        case "UserNotConfirmedException":
          message = `${e.message} Try resending the confirmation code.`;
          break;
        case "CodeMismatchException":
          message = `${e.message}`;
          break;
        case "NotAuthorizedException":
          message = `${e.message}`;
          break;
        default:
          message = `Something went wrong when trying to log in.`;
          break;
      }
    }
    return message;
  }

}
