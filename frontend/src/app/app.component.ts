import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Subject } from 'rxjs';
import { debounceTime, distinctUntilChanged, switchMap } from 'rxjs/operators';
import { ApiService, Verb, Noun, GrammaticalForm, SentenceTemplate, SearchResultDTO, TranslationDTO, JlptVocab } from './api.service';
import { FuriganaPipe } from './furigana.pipe';

const KANA_MAP: { [key: string]: string } = {
  'あ': 'a', 'い': 'i', 'う': 'u', 'え': 'e', 'お': 'o',
  'か': 'ka', 'き': 'ki', 'く': 'ku', 'け': 'ke', 'こ': 'ko',
  'さ': 'sa', 'し': 'shi', 'す': 'su', 'せ': 'se', 'そ': 'so',
  'た': 'ta', 'ち': 'chi', 'つ': 'tsu', 'て': 'te', 'と': 'to',
  'な': 'na', 'に': 'ni', 'ぬ': 'nu', 'ね': 'ne', 'の': 'no',
  'は': 'ha', 'ひ': 'hi', 'ふ': 'fu', 'へ': 'he', 'ほ': 'ho',
  'ま': 'ma', 'み': 'mi', 'む': 'mu', 'め': 'me', 'も': 'mo',
  'や': 'ya', 'ゆ': 'yu', 'よ': 'yo',
  'ら': 'ra', 'り': 'ri', 'る': 'ru', 'れ': 're', 'ろ': 'ro',
  'わ': 'wa', 'を': 'o', 'ん': 'n',
  'が': 'ga', 'ぎ': 'gi', 'ぐ': 'gu', 'げ': 'ge', 'ご': 'go',
  'ざ': 'za', 'じ': 'ji', 'ず': 'zu', 'ぜ': 'ze', 'ぞ': 'zo',
  'だ': 'da', 'ぢ': 'ji', 'づ': 'zu', 'で': 'de', 'ど': 'do',
  'ば': 'ba', 'び': 'bi', 'ぶ': 'bu', 'べ': 'be', 'ぼ': 'bo',
  'ぱ': 'pa', 'ぴ': 'pi', 'ぷ': 'pu', 'ぺ': 'pe', 'ぽ': 'po',
  'ア': 'a', 'イ': 'i', 'ウ': 'u', 'エ': 'e', 'オ': 'o',
  'カ': 'ka', 'キ': 'ki', 'ク': 'ku', 'ケ': 'ke', 'コ': 'ko',
  'サ': 'sa', 'シ': 'shi', 'ス': 'su', 'セ': 'se', 'ソ': 'so',
  'タ': 'ta', 'チ': 'chi', 'ツ': 'tsu', 'テ': 'te', 'ト': 'to',
  'ナ': 'na', 'ニ': 'ni', 'ヌ': 'nu', 'ネ': 'ne', 'ノ': 'no',
  'ハ': 'ha', 'ヒ': 'hi', 'フ': 'fu', 'ヘ': 'he', 'ホ': 'ho',
  'マ': 'ma', 'ミ': 'mi', 'ム': 'mu', 'メ': 'me', 'モ': 'mo',
  'ヤ': 'ya', 'ユ': 'yu', 'ヨ': 'yo',
  'ラ': 'ra', 'リ': 'ri', 'ル': 'ru', 'レ': 're', 'ロ': 'ro',
  'ワ': 'wa', 'ヲ': 'o', 'ン': 'n',
  'ガ': 'ga', 'ギ': 'gi', 'グ': 'gu', 'ゲ': 'ge', 'ゴ': 'go',
  'ザ': 'za', 'ジ': 'ji', 'ズ': 'zu', 'ゼ': 'ze', 'ゾ': 'zo',
  'ダ': 'da', 'ヂ': 'ji', 'ヅ': 'zu', 'デ': 'de', 'ド': 'do',
  'バ': 'ba', 'ビ': 'bi', 'ブ': 'bu', 'ベ': 'be', 'ボ': 'bo',
  'パ': 'pa', 'ピ': 'pi', 'プ': 'pu', 'ペ': 'pe', 'ポ': 'po'
};

const YOON_MAP: { [key: string]: string } = {
  'きゃ': 'kya', 'きゅ': 'kyu', 'きょ': 'kyo',
  'しゃ': 'sha', 'しゅ': 'shu', 'しょ': 'sho',
  'ちゃ': 'cha', 'ちゅ': 'chu', 'ちょ': 'cho',
  'にゃ': 'nya', 'にゅ': 'nyu', 'にょ': 'nyo',
  'ひゃ': 'hya', 'ひゅ': 'hyu', 'ひょ': 'hyo',
  'みゃ': 'mya', 'みゅ': 'myu', 'みょ': 'myo',
  'りゃ': 'rya', 'りゅ': 'ryu', 'りょ': 'ryo',
  'ぎゃ': 'gya', 'ぎゅ': 'gyu', 'ぎょ': 'gyo',
  'じゃ': 'ja', 'じゅ': 'ju', 'じょ': 'jo',
  'びゃ': 'bya', 'びゅ': 'byu', 'びょ': 'byo',
  'ぴゃ': 'pya', 'ぴゅ': 'pyu', 'ぴょ': 'pyo',
  'キャ': 'kya', 'キュ': 'kyu', 'キョ': 'kyo',
  'シャ': 'sha', 'シュ': 'shu', 'ショ': 'sho',
  'チャ': 'cha', 'チュ': 'chu', 'チョ': 'cho',
  'ニャ': 'nya', 'ニュ': 'nyu', 'ニョ': 'nyo',
  'ヒャ': 'hya', 'ヒュ': 'hyu', 'ヒョ': 'hyo',
  'ミャ': 'mya', 'ミュ': 'myu', 'ミョ': 'myo',
  'リャ': 'rya', 'リュ': 'ryu', 'リョ': 'ryo',
  'ギャ': 'gya', 'ギュ': 'gyu', 'ギョ': 'gyo',
  'ジャ': 'ja', 'ジュ': 'ju', 'ジョ': 'jo',
  'ビャ': 'bya', 'ビュ': 'byu', 'ビョ': 'byo',
  'ピャ': 'pya', 'ピュ': 'pyu', 'ピョ': 'pyo'
};

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, FormsModule, FuriganaPipe],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  // Option lists for dropdown slots
  verbs: Verb[] = [];
  nouns: Noun[] = [];
  grammaticalForms: GrammaticalForm[] = [];
  templates: SentenceTemplate[] = [];

  // Selected values for the mechanical Slot-Builder form
  selectedTemplateId: number = 1;
  selectedSubjectId: number = 1;
  selectedObjectId: number = 2;
  selectedVerbId: number = 1;
  selectedGrammaticalFormId: number = 1;

  // Search variables
  searchQuery: string = '';
  searchResults: SearchResultDTO[] = [];
  private searchSubject = new Subject<string>();

  // JLPT reference search variables
  jlptSearchQuery: string = '';
  jlptSelectedLevel: string = ''; // '' for All, 'N5', 'N4'
  jlptVocabResults: JlptVocab[] = [];
  isJlptLoading: boolean = false;
  private jlptSearchSubject = new Subject<{query: string, level: string}>();

  // Searchable select dropdown state variables
  isTemplateDropdownOpen = false;
  isSubjectDropdownOpen = false;
  isObjectDropdownOpen = false;
  isVerbDropdownOpen = false;
  isGrammaticalFormDropdownOpen = false;

  templateSearchQuery = '';
  subjectSearchQuery = '';
  objectSearchQuery = '';
  verbSearchQuery = '';
  grammaticalFormSearchQuery = '';

  // Compiled result
  translationResult: TranslationDTO | null = null;
  isLoading: boolean = false;
  errorMessage: string = '';

  constructor(private apiService: ApiService) {}

  ngOnInit(): void {
    // 1. Fetch dropdown options
    this.loadDropdownData();

    // 2. Set up RxJS debouncing logic for the search box
    this.searchSubject.pipe(
      debounceTime(300),
      distinctUntilChanged(),
      switchMap(query => {
        if (!query.trim()) {
          return Promise.resolve([]);
        }
        return this.apiService.search(query);
      })
    ).subscribe({
      next: (results) => {
        this.searchResults = results;
      },
      error: (err) => {
        console.error('Search error:', err);
      }
    });

    // 3. Set up RxJS debouncing for JLPT Reference Search
    this.jlptSearchSubject.pipe(
      debounceTime(300),
      switchMap(params => {
        this.isJlptLoading = true;
        return this.apiService.searchJlptVocab(params.query, params.level);
      })
    ).subscribe({
      next: (results) => {
        this.jlptVocabResults = results;
        this.isJlptLoading = false;
      },
      error: (err) => {
        console.error('JLPT reference search error:', err);
        this.isJlptLoading = false;
      }
    });

    // 4. Perform initial translation build
    this.buildTranslation();

    // 5. Trigger initial JLPT search to populate on start
    this.triggerJlptSearch();
  }

  loadDropdownData(): void {
    this.apiService.getVerbs().subscribe(data => this.verbs = data);
    this.apiService.getNouns().subscribe(data => this.nouns = data);
    this.apiService.getGrammaticalForms().subscribe(data => this.grammaticalForms = data);
    this.apiService.getTemplates().subscribe(data => this.templates = data);
  }

  // Triggered when any dropdown form control changes value
  onControlChange(): void {
    this.buildTranslation();
  }

  // Triggers RxJS search input sequence
  onSearchInput(value: string): void {
    this.searchSubject.next(value);
  }

  // Set Slot IDs based on the search result click
  selectSearchResult(result: SearchResultDTO): void {
    this.selectedTemplateId = result.templateId;
    this.selectedSubjectId = result.subjectNounId;
    this.selectedObjectId = result.objectNounId;
    this.selectedVerbId = result.verbId;
    this.selectedGrammaticalFormId = result.grammaticalFormId;
    
    // Clear search box and results overlay
    this.searchQuery = '';
    this.searchResults = [];
    
    this.buildTranslation();
  }

  // Mechanical Slot POST request
  buildTranslation(): void {
    this.isLoading = true;
    this.errorMessage = '';
    const payload = {
      templateId: Number(this.selectedTemplateId),
      subjectNounId: Number(this.selectedSubjectId),
      objectNounId: Number(this.selectedObjectId),
      verbId: Number(this.selectedVerbId),
      grammaticalFormId: Number(this.selectedGrammaticalFormId)
    };

    this.apiService.buildTranslation(payload).subscribe({
      next: (res) => {
        this.translationResult = res;
        this.isLoading = false;
      },
      error: (err) => {
        console.error('Translation error:', err);
        this.errorMessage = 'Failed to compile rule-based translation.';
        this.isLoading = false;
      }
    });
  }

  // Alternates template structural layout in the identical category
  cycleAlternatives(): void {
    if (!this.translationResult) return;
    
    this.apiService.getAlternatives(this.selectedTemplateId).subscribe({
      next: (alternatives) => {
        if (alternatives.length <= 1) return;

        // Find the index of the currently active template
        const currentIndex = alternatives.findIndex(t => t.id === Number(this.selectedTemplateId));
        // Get the next index (looping to 0 if at the end)
        const nextIndex = (currentIndex + 1) % alternatives.length;
        
        // Update selection and trigger build
        this.selectedTemplateId = alternatives[nextIndex].id;
        this.buildTranslation();
      },
      error: (err) => {
        console.error('Alternatives error:', err);
      }
    });
  }

  // Trigger the debounced JLPT reference search
  triggerJlptSearch(): void {
    this.jlptSearchSubject.next({
      query: this.jlptSearchQuery,
      level: this.jlptSelectedLevel
    });
  }

  // Handle keyboard/input changes on JLPT Search
  onJlptSearchInput(value: string): void {
    this.jlptSearchQuery = value;
    this.triggerJlptSearch();
  }

  // Handle level filter tab changes
  onJlptLevelChange(level: string): void {
    this.jlptSelectedLevel = level;
    this.triggerJlptSearch();
  }



  // Display Name Helpers for selected items
  getSelectedTemplateName(): string {
    const t = this.templates.find(x => x.id === Number(this.selectedTemplateId));
    return t ? t.templateName.split('(')[0] : 'Select Structure';
  }

  getSelectedSubjectName(): string {
    const n = this.nouns.find(x => x.id === Number(this.selectedSubjectId));
    return n ? n.english : 'Select Subject';
  }

  getSelectedObjectName(): string {
    const n = this.nouns.find(x => x.id === Number(this.selectedObjectId));
    return n ? n.english : 'Select Object';
  }

  getSelectedVerbName(): string {
    const v = this.verbs.find(x => x.id === Number(this.selectedVerbId));
    return v ? v.english : 'Select Action';
  }

  getSelectedGrammaticalFormName(): string {
    const g = this.grammaticalForms.find(x => x.id === Number(this.selectedGrammaticalFormId));
    return g ? g.formName.split('(')[0] : 'Select Tense';
  }

  // Filtered List Helpers
  getFilteredTemplates(): SentenceTemplate[] {
    const q = this.templateSearchQuery.toLowerCase().trim();
    if (!q) return this.templates;
    return this.templates.filter(x => x.templateName.toLowerCase().includes(q));
  }

  getFilteredSubjects(): Noun[] {
    const q = this.subjectSearchQuery.toLowerCase().trim();
    if (!q) return this.nouns;
    return this.nouns.filter(x => x.english.toLowerCase().includes(q));
  }

  getFilteredObjects(): Noun[] {
    const q = this.objectSearchQuery.toLowerCase().trim();
    if (!q) return this.nouns;
    return this.nouns.filter(x => x.english.toLowerCase().includes(q));
  }

  getFilteredVerbs(): Verb[] {
    const q = this.verbSearchQuery.toLowerCase().trim();
    if (!q) return this.verbs;
    return this.verbs.filter(x => x.english.toLowerCase().includes(q));
  }

  getFilteredGrammaticalForms(): GrammaticalForm[] {
    const q = this.grammaticalFormSearchQuery.toLowerCase().trim();
    if (!q) return this.grammaticalForms;
    return this.grammaticalForms.filter(x => x.formName.toLowerCase().includes(q));
  }

  // Toggle & Control Handlers
  toggleDropdown(type: 'template' | 'subject' | 'object' | 'verb' | 'grammaticalForm', event?: Event): void {
    if (event) {
      event.stopPropagation();
    }
    const targetState = !this.getDropdownState(type);
    this.closeAllDropdowns();
    this.setDropdownState(type, targetState);
  }

  private getDropdownState(type: string): boolean {
    if (type === 'template') return this.isTemplateDropdownOpen;
    if (type === 'subject') return this.isSubjectDropdownOpen;
    if (type === 'object') return this.isObjectDropdownOpen;
    if (type === 'verb') return this.isVerbDropdownOpen;
    if (type === 'grammaticalForm') return this.isGrammaticalFormDropdownOpen;
    return false;
  }

  private setDropdownState(type: string, value: boolean): void {
    if (type === 'template') {
      this.isTemplateDropdownOpen = value;
      if (value) this.templateSearchQuery = '';
    }
    if (type === 'subject') {
      this.isSubjectDropdownOpen = value;
      if (value) this.subjectSearchQuery = '';
    }
    if (type === 'object') {
      this.isObjectDropdownOpen = value;
      if (value) this.objectSearchQuery = '';
    }
    if (type === 'verb') {
      this.isVerbDropdownOpen = value;
      if (value) this.verbSearchQuery = '';
    }
    if (type === 'grammaticalForm') {
      this.isGrammaticalFormDropdownOpen = value;
      if (value) this.grammaticalFormSearchQuery = '';
    }
  }

  closeAllDropdowns(): void {
    this.isTemplateDropdownOpen = false;
    this.isSubjectDropdownOpen = false;
    this.isObjectDropdownOpen = false;
    this.isVerbDropdownOpen = false;
    this.isGrammaticalFormDropdownOpen = false;
  }

  // Selection Handlers
  selectTemplate(id: number): void {
    this.selectedTemplateId = id;
    this.closeAllDropdowns();
    this.buildTranslation();
  }

  selectSubject(id: number): void {
    this.selectedSubjectId = id;
    this.closeAllDropdowns();
    this.buildTranslation();
  }

  selectObject(id: number): void {
    this.selectedObjectId = id;
    this.closeAllDropdowns();
    this.buildTranslation();
  }

  selectVerb(id: number): void {
    this.selectedVerbId = id;
    this.closeAllDropdowns();
    this.buildTranslation();
  }

  selectGrammaticalForm(id: number): void {
    this.selectedGrammaticalFormId = id;
    this.closeAllDropdowns();
    this.buildTranslation();
  }

  // Helper to convert Japanese kana-only readings into Romaji
  toRomaji(kana: string): string {
    if (!kana) return '';
    let result = '';
    let i = 0;
    while (i < kana.length) {
      // Check 2-character combination (Yoon)
      if (i + 1 < kana.length) {
        const doubleChar = kana.substring(i, i + 2);
        if (YOON_MAP[doubleChar]) {
          result += YOON_MAP[doubleChar];
          i += 2;
          continue;
        }
      }

      const char = kana.charAt(i);

      // Check small っ/ッ (Sokuon)
      if (char === 'っ' || char === 'ッ') {
        if (i + 1 < kana.length) {
          let nextChar = kana.charAt(i + 1);
          if (i + 2 < kana.length) {
            const peekDouble = kana.substring(i + 1, i + 3);
            if (YOON_MAP[peekDouble]) {
              const romajiNext = YOON_MAP[peekDouble];
              result += romajiNext.charAt(0);
              i += 1;
              continue;
            }
          }
          if (KANA_MAP[nextChar]) {
            const romajiNext = KANA_MAP[nextChar];
            result += romajiNext.charAt(0);
          }
        }
        i += 1;
        continue;
      }

      // Check Katakana long vowel mark
      if (char === 'ー') {
        if (result.length > 0) {
          const lastChar = result.charAt(result.length - 1);
          if (['a', 'i', 'u', 'e', 'o'].includes(lastChar)) {
            result += lastChar;
          }
        }
        i += 1;
        continue;
      }

      // Single character mapping
      if (KANA_MAP[char]) {
        result += KANA_MAP[char];
      } else {
        result += char; // Fallback
      }
      i += 1;
    }
    return result;
  }
}
