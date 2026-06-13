package com.haisensei;

import com.haisensei.dao.TranslationDAO;
import com.haisensei.dto.TranslationDTO;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
class HaisenseiApplicationTests {

    @Autowired
    private TranslationDAO translationDAO;

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
        // verb 3 (飲[の]む) is Group 1. Rules for form 2 (masen) and ending む is み + ません -> 飲みません
        TranslationDTO result = translationDAO.buildSentence(1L, 1L, 3L, 3L, 2L);
        assertNotNull(result);
        assertEquals("私[わたし]は水[みず]を飲[の]みません", result.getJapaneseResult());
        assertEquals("watashi wa mizu o nomimasen", result.getRomajiResult());
    }
}
