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
        // templateId 1, subject 1 (watashi), object 2 (ringo), verb 1 (taberu), form 1 (masu)
        TranslationDTO result = translationDAO.buildSentence(1L, 1L, 2L, 1L, 1L);
        assertNotNull(result);
        assertEquals("私[わたし]は林檎[りんご]を食[た]べます", result.getJapaneseResult());
        assertEquals("watashi wa ringo o tabemasu", result.getRomajiResult());
    }

    @Test
    void testBuildSentencePolitePresentNegative() {
        // templateId 1, subject 1 (watashi), object 3 (mizu), verb 3 (nomu), form 2 (masen)
        TranslationDTO result = translationDAO.buildSentence(1L, 1L, 3L, 3L, 2L);
        assertNotNull(result);
        assertEquals("私[わたし]は水[みず]を飲[の]みません", result.getJapaneseResult());
        assertEquals("watashi wa mizu o nomimasen", result.getRomajiResult());
    }

    @Test
    void testBuildTeFormRequest() {
        // templateId 4 (Polite Request), object 7 (sushi), verb 1 (eat), form 6 (kudasai)
        TranslationDTO result = translationDAO.buildSentence(4L, 1L, 7L, 1L, 6L);
        assertNotNull(result);
        assertEquals("寿司[すし]を食[た]べてください", result.getJapaneseResult());
        assertEquals("sushi o tabete kudasai", result.getRomajiResult());
    }

    @Test
    void testBuildDesireForm() {
        // templateId 6 (Desire), subject 1 (I), object 4 (book), verb 5 (read), form 8 (tai desu)
        TranslationDTO result = translationDAO.buildSentence(6L, 1L, 4L, 5L, 8L);
        assertNotNull(result);
        assertEquals("私[わたし]は本[ほん]を読[よ]みたいです", result.getJapaneseResult());
        assertEquals("watashi wa hon o yomitai desu", result.getRomajiResult());
    }

    @Test
    void testEnglishParserRequest() {
        SearchResultDTO result = englishParser.parse("please write a letter");
        assertNotNull(result);
        assertEquals(4L, result.getTemplateId()); // Request template
        assertEquals(5L, result.getObjectNounId()); // letter
        assertEquals(4L, result.getVerbId()); // write
        assertEquals(6L, result.getGrammaticalFormId()); // Request form (-te kudasai)
    }

    @Test
    void testEnglishParserDesire() {
        SearchResultDTO result = englishParser.parse("I want to drink water");
        assertNotNull(result);
        assertEquals(6L, result.getTemplateId()); // Desire template
        assertEquals(3L, result.getObjectNounId()); // water
        assertEquals(3L, result.getVerbId()); // drink
        assertEquals(8L, result.getGrammaticalFormId()); // Desire form (-tai desu)
    }
}
