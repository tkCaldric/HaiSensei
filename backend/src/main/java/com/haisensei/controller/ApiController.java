package com.haisensei.controller;

import com.haisensei.dao.*;
import com.haisensei.dto.*;
import com.haisensei.model.*;
import com.haisensei.service.EnglishParser;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*") // Allow requests from Angular frontend
public class ApiController {

    private final SamplePhraseDAO samplePhraseDAO;
    private final TranslationDAO translationDAO;
    private final VerbDAO verbDAO;
    private final NounDAO nounDAO;
    private final GrammaticalFormDAO grammaticalFormDAO;
    private final SentenceTemplateDAO sentenceTemplateDAO;
    private final EnglishParser englishParser;
    private final JlptVocabDAO jlptVocabDAO;

    public ApiController(SamplePhraseDAO samplePhraseDAO, TranslationDAO translationDAO,
                         VerbDAO verbDAO, NounDAO nounDAO, GrammaticalFormDAO grammaticalFormDAO,
                         SentenceTemplateDAO sentenceTemplateDAO, EnglishParser englishParser,
                         JlptVocabDAO jlptVocabDAO) {
        this.samplePhraseDAO = samplePhraseDAO;
        this.translationDAO = translationDAO;
        this.verbDAO = verbDAO;
        this.nounDAO = nounDAO;
        this.grammaticalFormDAO = grammaticalFormDAO;
        this.sentenceTemplateDAO = sentenceTemplateDAO;
        this.englishParser = englishParser;
        this.jlptVocabDAO = jlptVocabDAO;
    }

    // 1. Fuzzy search sample phrases & Dynamic English Parsing
    @GetMapping("/search")
    public ResponseEntity<List<SearchResultDTO>> search(@RequestParam(value = "query", defaultValue = "") String query) {
        List<SearchResultDTO> results = new ArrayList<>();
        
        // If query is provided, check for synthetic parsed result first
        if (query != null && !query.trim().isEmpty()) {
            SearchResultDTO parsedResult = englishParser.parse(query);
            if (parsedResult != null) {
                results.add(parsedResult);
            }
        }

        // Fetch fuzzy matches from database
        List<SearchResultDTO> dbResults = samplePhraseDAO.search(query);
        results.addAll(dbResults);

        return ResponseEntity.ok(results);
    }

    // 2. Build translation from slots
    @PostMapping("/translate/build")
    public ResponseEntity<TranslationDTO> buildTranslation(@RequestBody TranslationRequest request) {
        TranslationDTO result = translationDAO.buildSentence(
                request.getTemplateId(),
                request.getSubjectNounId(),
                request.getObjectNounId(),
                request.getVerbId(),
                request.getGrammaticalFormId()
        );
        return ResponseEntity.ok(result);
    }

    // 3. Find alternatives for sentence template
    @GetMapping("/templates/alternatives/{id}")
    public ResponseEntity<List<SentenceTemplate>> findAlternatives(@PathVariable("id") Long id) {
        List<SentenceTemplate> alternatives = translationDAO.findAlternatives(id);
        return ResponseEntity.ok(alternatives);
    }

    // 4. Dictionary Lookup: JLPT Vocab Search
    @GetMapping("/jlpt/vocab")
    public ResponseEntity<List<JlptVocab>> searchJlptVocab(
            @RequestParam(value = "query", defaultValue = "") String query,
            @RequestParam(value = "level", defaultValue = "") String level) {
        return ResponseEntity.ok(jlptVocabDAO.search(query, level));
    }



    // Dropdown helpers to feed SentenceBuilder slots dynamically
    @GetMapping("/verbs")
    public ResponseEntity<List<Verb>> getVerbs() {
        return ResponseEntity.ok(verbDAO.findAll());
    }

    @GetMapping("/nouns")
    public ResponseEntity<List<Noun>> getNouns() {
        return ResponseEntity.ok(nounDAO.findAll());
    }

    @GetMapping("/grammatical-forms")
    public ResponseEntity<List<GrammaticalForm>> getGrammaticalForms() {
        return ResponseEntity.ok(grammaticalFormDAO.findAll());
    }

    @GetMapping("/templates")
    public ResponseEntity<List<SentenceTemplate>> getTemplates() {
        return ResponseEntity.ok(sentenceTemplateDAO.findAll());
    }
}
