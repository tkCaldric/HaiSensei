package com.haisensei.service;

import com.haisensei.dto.SearchResultDTO;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class EnglishParser {

    // Maps inflections to Verb IDs
    private static final Map<String, Long> VERB_MAP = new HashMap<>();
    // Maps keywords to Noun IDs
    private static final Map<String, Long> NOUN_MAP = new HashMap<>();

    static {
        // Verb mappings
        putVerb(1L, "eat", "eats", "eating", "ate", "eaten");
        putVerb(2L, "see", "sees", "seeing", "saw", "seen", "watch", "watches", "watching", "watched");
        putVerb(3L, "drink", "drinks", "drinking", "drank", "drunk");
        putVerb(4L, "write", "writes", "writing", "wrote", "written");
        putVerb(5L, "read", "reads", "reading");
        putVerb(6L, "buy", "buys", "buying", "bought");
        putVerb(7L, "do", "does", "doing", "did", "done");
        putVerb(8L, "come", "comes", "coming", "came");
        putVerb(9L, "speak", "speaks", "speaking", "spoke", "spoken", "talk", "talks", "talking", "talked");
        putVerb(10L, "listen", "listens", "listening", "listened", "ask", "asks", "asking", "asked");
        putVerb(11L, "meet", "meets", "meeting", "met");
        putVerb(12L, "wait", "waits", "waiting", "waited");
        putVerb(13L, "return", "returns", "returning", "returned", "go back", "goes back");

        // Noun mappings
        putNoun(1L, "i", "me", "myself");
        putNoun(2L, "apple", "apples");
        putNoun(3L, "water");
        putNoun(4L, "book", "books");
        putNoun(5L, "letter", "letters");
        putNoun(6L, "tea");
        putNoun(7L, "sushi");
        putNoun(8L, "movie", "movies");
        putNoun(9L, "japanese", "nihongo");
        putNoun(10L, "friend", "friends");
        putNoun(11L, "teacher", "teachers", "sensei");
        putNoun(12L, "student", "students");
        putNoun(13L, "fish");
        putNoun(14L, "meat", "beef", "pork", "chicken");
    }

    private static void putVerb(Long id, String... inflections) {
        for (String inf : inflections) {
            VERB_MAP.put(inf.toLowerCase(), id);
        }
    }

    private static void putNoun(Long id, String... synonyms) {
        for (String syn : synonyms) {
            NOUN_MAP.put(syn.toLowerCase(), id);
        }
    }

    public SearchResultDTO parse(String query) {
        if (query == null || query.trim().isEmpty()) {
            return null;
        }

        String cleaned = query.toLowerCase()
                .replaceAll("[.,!?/\\-]", " ")
                .replaceAll("'", " ");
        String[] tokens = cleaned.split("\\s+");

        boolean isNegative = false;
        boolean isPast = false;
        boolean isContinuous = false;
        boolean isRequest = false;
        boolean isDesire = false;

        // 1. Pre-detect Grammatical intent flags
        // Check negative keywords
        for (String token : tokens) {
            if (token.equals("not") || token.equals("n") || token.equals("t") || token.equals("don") || token.equals("doesn") || token.equals("didn") || token.equals("never") || token.equals("won") || token.equals("cant")) {
                isNegative = true;
            }
        }

        // Check request keywords
        if (cleaned.contains("please") || cleaned.contains("request") || cleaned.contains("ask")) {
            isRequest = true;
        }

        // Check desire keywords
        if (cleaned.contains("want") || cleaned.contains("wants") || cleaned.contains("desire") || cleaned.contains("like to")) {
            isDesire = true;
        }

        // Check continuous indicators
        if (cleaned.contains(" am ") || cleaned.contains(" is ") || cleaned.contains(" are ") || cleaned.contains(" was ") || cleaned.contains(" were ")) {
            for (String token : tokens) {
                if (token.endsWith("ing")) {
                    isContinuous = true;
                    break;
                }
            }
        }

        // Check past indicators
        if (cleaned.contains("yesterday") || cleaned.contains("past") || cleaned.contains("did ") || cleaned.contains("was") || cleaned.contains("were")) {
            isPast = true;
        } else {
            // Check past verb inflections
            for (String token : tokens) {
                if (token.equals("ate") || token.equals("saw") || token.equals("drank") || token.equals("wrote") || token.equals("read") || token.equals("bought") || token.equals("did") || token.equals("came") || token.equals("spoke") || token.equals("talked") || token.equals("listened") || token.equals("met") || token.equals("waited") || token.equals("returned") || token.equals("went")) {
                    isPast = true;
                    break;
                }
            }
        }

        Long subjectId = null;
        Long objectId = null;
        Long verbId = null;

        // 2. Identify Nouns based on context
        List<Long> foundNouns = new ArrayList<>();
        boolean hasI = false;
        
        for (String token : tokens) {
            if (token.equals("i")) {
                hasI = true;
            }
            if (NOUN_MAP.containsKey(token)) {
                foundNouns.add(NOUN_MAP.get(token));
            }
        }

        if (hasI) {
            subjectId = 1L; // 'I'
            // Object is the first non-I noun found
            for (Long nounId : foundNouns) {
                if (!nounId.equals(1L)) {
                    objectId = nounId;
                    break;
                }
            }
        } else {
            // If it is a Request/Command structure, first found noun is the Object!
            if (isRequest || tokens[0].equals("please") || VERB_MAP.containsKey(tokens[0])) {
                if (!foundNouns.isEmpty()) {
                    objectId = foundNouns.get(0);
                }
                subjectId = 1L; // Default Subject
            } else {
                if (foundNouns.size() >= 1) {
                    subjectId = foundNouns.get(0);
                }
                if (foundNouns.size() >= 2) {
                    objectId = foundNouns.get(1);
                }
            }
        }

        // 3. Identify Verb
        for (String token : tokens) {
            if (VERB_MAP.containsKey(token)) {
                verbId = VERB_MAP.get(token);
                break;
            }
        }

        // Special check: handle multi-word phrase "go back"
        if (cleaned.contains("go back") || cleaned.contains("goes back") || cleaned.contains("went back")) {
            verbId = 13L; // return home
        }

        // Fallbacks if not fully detected
        if (subjectId == null) {
            subjectId = 1L; // Default to 'I'
        }
        if (objectId == null) {
            objectId = 2L; // Default to 'apple'
        }
        if (verbId == null) {
            verbId = 1L; // Default to 'eat'
        }

        // 4. Identify Grammatical Form & Template
        long formId = 1L; // Polite Present Positive
        long templateId = 1L; // Subject-Object-Verb (Standard Action)

        if (isRequest) {
            formId = 6L; // Polite Request (-te kudasai)
            templateId = 4L; // Polite Request template (Object + Verb)
        } else if (isContinuous) {
            formId = 7L; // Present Continuous (-te imasu)
            templateId = 5L; // Continuous template
        } else if (isDesire) {
            formId = 8L; // Desire Form (-tai desu)
            templateId = 6L; // Desire template
        } else if (isPast) {
            if (isNegative) {
                formId = 4L; // Polite Past Negative
            } else {
                formId = 3L; // Polite Past Positive
            }
            templateId = 1L;
        } else {
            if (isNegative) {
                formId = 2L; // Polite Present Negative
            } else {
                formId = 1L; // Polite Present Positive
            }
            templateId = 1L;
        }

        SearchResultDTO dto = new SearchResultDTO();
        dto.setSamplePhraseId(0L); // 0 indicates synthetic parsed result
        dto.setInputPattern("Translate: \"" + query + "\"");
        dto.setTemplateId(templateId);
        dto.setSubjectNounId(subjectId);
        dto.setObjectNounId(objectId);
        dto.setVerbId(verbId);
        dto.setGrammaticalFormId(formId);

        return dto;
    }
}
