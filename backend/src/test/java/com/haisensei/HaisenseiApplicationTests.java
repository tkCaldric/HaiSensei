package com.haisensei;

import com.haisensei.dao.TranslationDAO;
import com.haisensei.dto.SearchResultDTO;
import com.haisensei.dto.TranslationDTO;
import com.haisensei.service.EnglishParser;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
class HaisenseiApplicationTests {

    @Autowired
    private TranslationDAO translationDAO;

    @Autowired
    private EnglishParser englishParser;

    @Test
    void testBuildSentencePolitePresentPositive() {
        // templateId 1, subject 1 (watashi), object 2 (Food), verb 1 (taberu), form 1 (masu)
        TranslationDTO result = translationDAO.buildSentence(1L, 1L, 2L, 1L, 1L);
        assertNotNull(result);
        assertEquals("私[わたし]は食[た]べ物[もの]を食[た]べます", result.getJapaneseResult());
        assertEquals("watashi wa tabemono o tabemasu", result.getRomajiResult());
    }

    @Test
    void testBuildSentencePolitePresentNegative() {
        // templateId 1, subject 1 (watashi), object 3 (Drink), verb 3 (nomu), form 2 (masen)
        TranslationDTO result = translationDAO.buildSentence(1L, 1L, 3L, 3L, 2L);
        assertNotNull(result);
        assertEquals("私[わたし]は飲[の]み物[もの]を飲[の]みません", result.getJapaneseResult());
        assertEquals("watashi wa nomimono o nomimasen", result.getRomajiResult());
    }

    @Test
    void testBuildTeFormRequest() {
        // templateId 4 (Polite Request), object 2 (Food), verb 1 (eat), form 6 (kudasai)
        TranslationDTO result = translationDAO.buildSentence(4L, 1L, 2L, 1L, 6L);
        assertNotNull(result);
        assertEquals("食[た]べ物[もの]を食[た]べてください", result.getJapaneseResult());
        assertEquals("tabemono o tabete kudasai", result.getRomajiResult());
    }

    @Test
    void testBuildDesireForm() {
        // templateId 6 (Desire), subject 1 (I), object 4 (Reading), verb 5 (read), form 8 (tai desu)
        TranslationDTO result = translationDAO.buildSentence(6L, 1L, 4L, 5L, 8L);
        assertNotNull(result);
        assertEquals("私[わたし]は読[よ]み物[もの]を読[よ]みたいです", result.getJapaneseResult());
        assertEquals("watashi wa yomimono o yomitai desu", result.getRomajiResult());
    }

    @Test
    void testEnglishParserRequest() {
        SearchResultDTO result = englishParser.parse("please write a letter");
        assertNotNull(result);
        assertEquals(4L, result.getTemplateId()); // Request template
        assertEquals(5L, result.getObjectNounId()); // [Writing / Letter] category
        assertEquals(4L, result.getVerbId()); // write
        assertEquals(6L, result.getGrammaticalFormId()); // Request form (-te kudasai)
    }

    @Test
    void testEnglishParserDesire() {
        SearchResultDTO result = englishParser.parse("I want to drink water");
        assertNotNull(result);
        assertEquals(6L, result.getTemplateId()); // Desire template
        assertEquals(3L, result.getObjectNounId()); // [Drink] category
        assertEquals(3L, result.getVerbId()); // drink
        assertEquals(8L, result.getGrammaticalFormId()); // Desire form (-tai desu)
    }

    @Test
    void testEnglishParserHeuristicPizza() {
        // Test parsing an arbitrary unknown word "pizza" -> maps to Food slot (ID 2) because of the verb "eat"
        SearchResultDTO result = englishParser.parse("I want to eat pizza");
        assertNotNull(result);
        assertEquals(6L, result.getTemplateId()); // Desire template
        assertEquals(2L, result.getObjectNounId()); // mapped to [Food]
        assertEquals(1L, result.getVerbId()); // eat
        assertEquals(8L, result.getGrammaticalFormId()); // Desire form (-tai desu)
    }
}
