import { Pipe, PipeTransform } from '@angular/core';
import { DomSanitizer, SafeHtml } from '@angular/platform-browser';

@Pipe({
  name: 'furigana',
  standalone: true
})
export class FuriganaPipe implements PipeTransform {
  constructor(private sanitizer: DomSanitizer) {}

  transform(value: string | null | undefined): SafeHtml {
    if (!value) return '';
    // Regex matches Kanji[Furigana] and replaces it with HTML5 <ruby> tags
    const parsed = value.replace(/([^\s[\]]+)\[([^[\]]+)\]/g, '<ruby>$1<rt>$2</rt></ruby>');
    return this.sanitizer.bypassSecurityTrustHtml(parsed);
  }
}
