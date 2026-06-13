import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Verb {
  id: number;
  groupId: number;
  english: string;
  dictionaryForm: string;
  kanjiRoot: string;
  romajiRoot: string;
  baseStem: string;
  romajiBaseStem: string;
  lastKanaChar: string;
  jlptLevel: string;
}

export interface Noun {
  id: number;
  english: string;
  japaneseForm: string;
  romajiForm: string;
}

export interface GrammaticalForm {
  id: number;
  formName: string;
  jlptLevel: string;
}

export interface SentenceTemplate {
  id: number;
  templateName: string;
  intentCategory: string;
  englishStructure: string;
  japaneseStructure: string;
  romajiStructure: string;
}

export interface SearchResultDTO {
  samplePhraseId: number;
  inputPattern: string;
  templateId: number;
  subjectNounId: number;
  objectNounId: number;
  verbId: number;
  grammaticalFormId: number;
}

export interface TranslationDTO {
  japaneseResult: string;
  romajiResult: string;
  englishStructure: string;
  templateId: number;
  subjectNounId: number;
  objectNounId: number;
  verbId: number;
  grammaticalFormId: number;
}

export interface JlptVocab {
  id: number;
  kanji: string;
  reading: string;
  jlptLevel: string;
}

export interface JlptKanji {
  id: number;
  kanji: string;
  jlptLevel: string;
}

export interface TranslationRequest {
  templateId: number;
  subjectNounId: number;
  objectNounId: number;
  verbId: number;
  grammaticalFormId: number;
}

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private baseUrl = 'http://localhost:8080/api';

  constructor(private http: HttpClient) {}

  search(query: string): Observable<SearchResultDTO[]> {
    return this.http.get<SearchResultDTO[]>(`${this.baseUrl}/search?query=${encodeURIComponent(query)}`);
  }

  buildTranslation(request: TranslationRequest): Observable<TranslationDTO> {
    return this.http.post<TranslationDTO>(`${this.baseUrl}/translate/build`, request);
  }

  getAlternatives(templateId: number): Observable<SentenceTemplate[]> {
    return this.http.get<SentenceTemplate[]>(`${this.baseUrl}/templates/alternatives/${templateId}`);
  }

  getVerbs(): Observable<Verb[]> {
    return this.http.get<Verb[]>(`${this.baseUrl}/verbs`);
  }

  getNouns(): Observable<Noun[]> {
    return this.http.get<Noun[]>(`${this.baseUrl}/nouns`);
  }

  getGrammaticalForms(): Observable<GrammaticalForm[]> {
    return this.http.get<GrammaticalForm[]>(`${this.baseUrl}/grammatical-forms`);
  }

  getTemplates(): Observable<SentenceTemplate[]> {
    return this.http.get<SentenceTemplate[]>(`${this.baseUrl}/templates`);
  }

  searchJlptVocab(query: string, level: string): Observable<JlptVocab[]> {
    return this.http.get<JlptVocab[]>(`${this.baseUrl}/jlpt/vocab?query=${encodeURIComponent(query)}&level=${encodeURIComponent(level)}`);
  }

  searchJlptKanji(query: string, level: string): Observable<JlptKanji[]> {
    return this.http.get<JlptKanji[]>(`${this.baseUrl}/jlpt/kanji?query=${encodeURIComponent(query)}&level=${encodeURIComponent(level)}`);
  }
}
