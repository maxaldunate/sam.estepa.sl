import { Observable } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MythicalMysfitResponse } from '../models/mythical-mysfit-response';
import { environment } from '../../environments/environment';
import { AmplifyService } from 'aws-amplify-angular';
import { MythicalMysfitProfile } from '../models/mythical-mysfit-profile';
import { MythicalMysfitClickEvent } from '../models/mythical-mysfit-click-event';
import { MythicalMysfitContactEvent } from '../models/mythical-mysfit-contact-event';

@Injectable()
export class MythicalMysfitProfileService {
  mysfitsApi: string;
  mysfitsStreamingServiceUrl: string;
  mysfitsQuestionServiceUrl: string;

  constructor(
    private http: HttpClient,
    private amplify: AmplifyService
  ) {
    this.mysfitsApi = environment.mysfitsApiUrl;
    this.mysfitsStreamingServiceUrl = environment.mysfitsStreamingServiceUrl;
    this.mysfitsQuestionServiceUrl = environment.mysfitsQuestionServiceUrl;
  }

  retriveMysfitProfiles(): Observable<MythicalMysfitResponse> {
    return this.http.get<MythicalMysfitResponse>(`${this.mysfitsApi}/mysfits`);
  }

  retriveMysfitProfileById(mysfitId: string): Observable<MythicalMysfitProfile> {
    return this.http.get<MythicalMysfitProfile>(`${this.mysfitsApi}/mysfits/${mysfitId}`);
  }

  filterMysfitProfiles(filter: string, value: string): Observable<MythicalMysfitResponse> {
    const qs = {
      filter,
      value
    }
    return this.http.get<MythicalMysfitResponse>(`${this.mysfitsApi}/mysfits`, {
      params: qs
    });
  }

  async like(mysfitId: string) {
    const path = `/mysfits/${mysfitId}/like`;
    await this.amplify.api().post('mm-api', path, { body: {} })
  }

  async adopt(mysfitId: string) {
    const path = `/mysfits/${mysfitId}/adopt`;
    await this.amplify.api().post('mm-api', path, { body: {} })
  }

  registerClick(click: MythicalMysfitClickEvent) {
    console.log()
    const path = '/clicks'
    return this.http.put(`${this.mysfitsStreamingServiceUrl}${path}`, click);
  }

  registerQuestion(question: MythicalMysfitContactEvent) {
    console.log("ContactComponent submitContactForm");
    console.log(question);
    const path = '/questions'
    console.log(`${this.mysfitsQuestionServiceUrl}${path}`)
    return this.http.post(`${this.mysfitsQuestionServiceUrl}${path}`, JSON.stringify(question));
  }


  // $.ajax({
  //   url : questionsApi,
  //   type : 'POST',
  //   headers : {'Content-Type': 'application/json'},
  //   dataType: 'json',
  //   data : JSON.stringify(question),
  //   success : function(response) {
  //     console.log("question submitted!")
  //   },
  //   error : function(response) {
  //     console.log("could not submit question");
  //     console.log(response);
  //   }
  // });
}
