package com.haisensei.dao;

import com.haisensei.dto.TranslationDTO;
import com.haisensei.model.*;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class TranslationDAO {

    private final JdbcTemplate jdbcTemplate;
    private final VerbDAO verbDAO;
    private final NounDAO nounDAO;
    private final GrammaticalFormDAO grammaticalFormDAO;
    private final SentenceTemplateDAO sentenceTemplateDAO;

    public TranslationDAO(JdbcTemplate jdbcTemplate, VerbDAO verbDAO, NounDAO nounDAO,
                          GrammaticalFormDAO grammaticalFormDAO, SentenceTemplateDAO sentenceTemplateDAO) {
        this.jdbcTemplate = jdbcTemplate;
        this.verbDAO = verbDAO;
        this.nounDAO = nounDAO;
        this.grammaticalFormDAO = grammaticalFormDAO;
        this.sentenceTemplateDAO = sentenceTemplateDAO;
    }

    private final RowMapper<ConjugationRule> ruleRowMapper = (rs, rowNum) -> {
        ConjugationRule rule = new ConjugationRule();
        rule.setId(rs.getLong("id"));
        rule.setFormId(rs.getLong("form_id"));
        rule.setGroupId(rs.getLong("group_id"));
        rule.setAppliesToEnding(rs.getString("applies_to_ending"));
        rule.setStemMutation(rs.getString("stem_mutation"));
        rule.setRomajiStemMutation(rs.getString("romaji_stem_mutation"));
        rule.setSuffix(rs.getString("suffix"));
        rule.setRomajiSuffix(rs.getString("romaji_suffix"));
        return rule;
    };

    public TranslationDTO buildSentence(Long templateId, Long subjectNounId, Long objectNounId, Long verbId, Long grammaticalFormId) {
        SentenceTemplate template = sentenceTemplateDAO.findById(templateId);
        Noun subject = nounDAO.findById(subjectNounId);
        Noun object = nounDAO.findById(objectNounId);
        Verb verb = verbDAO.findById(verbId);
        GrammaticalForm form = grammaticalFormDAO.findById(grammaticalFormId);

        // 1. Perform rule-based conjugation
        String conjugatedVerbJapanese = "";
        String conjugatedVerbRomaji = "";

        // Look for matching rule based on form_id, group_id, and last_kana_char
        String sqlRule = "SELECT * FROM conjugation_rules WHERE form_id = ? AND group_id = ? AND applies_to_ending = ?";
        List<ConjugationRule> rules = jdbcTemplate.query(sqlRule, ruleRowMapper, form.getId(), verb.getGroupId(), verb.getLastKanaChar());

        if (!rules.isEmpty()) {
            ConjugationRule rule = rules.get(0);
            
            // For verbs like 'suru' and 'kuru', base_stem is empty, so root/mutation is applied
            String baseStem = verb.getBaseStem() != null ? verb.getBaseStem() : "";
            String romajiBaseStem = verb.getRomajiBaseStem() != null ? verb.getRomajiBaseStem() : "";

            String stemMutation = rule.getStemMutation() != null ? rule.getStemMutation() : "";
            String romajiStemMutation = rule.getRomajiStemMutation() != null ? rule.getRomajiStemMutation() : "";
            String suffix = rule.getSuffix() != null ? rule.getSuffix() : "";
            String romajiSuffix = rule.getRomajiSuffix() != null ? rule.getRomajiSuffix() : "";

            conjugatedVerbJapanese = baseStem + stemMutation + suffix;
            
            // To ensure smooth romaji pronunciation, we handle potential empty spacings
            conjugatedVerbRomaji = (romajiBaseStem + romajiStemMutation + romajiSuffix).trim();
        } else {
            // Fallback to dictionary form
            conjugatedVerbJapanese = verb.getDictionaryForm();
            conjugatedVerbRomaji = verb.getRomajiRoot() + verb.getLastKanaChar(); // generic fallback
        }

        // 2. Perform template string replacement
        String finalJapanese = template.getJapaneseStructure()
                .replace("{subject}", subject.getJapaneseForm())
                .replace("{object}", object.getJapaneseForm())
                .replace("{verb}", conjugatedVerbJapanese);

        String finalRomaji = template.getRomajiStructure()
                .replace("{subject}", subject.getRomajiForm())
                .replace("{object}", object.getRomajiForm())
                .replace("{verb}", conjugatedVerbRomaji);

        String finalEnglish = template.getEnglishStructure()
                .replace("{subject}", subject.getEnglish())
                .replace("{object}", object.getEnglish())
                .replace("{verb}", verb.getEnglish() + " (" + form.getFormName() + ")");

        // 3. Assemble and return the DTO
        TranslationDTO dto = new TranslationDTO();
        dto.setJapaneseResult(finalJapanese);
        dto.setRomajiResult(finalRomaji);
        dto.setEnglishStructure(finalEnglish);
        dto.setTemplateId(templateId);
        dto.setSubjectNounId(subjectNounId);
        dto.setObjectNounId(objectNounId);
        dto.setVerbId(verbId);
        dto.setGrammaticalFormId(grammaticalFormId);

        return dto;
    }

    public List<SentenceTemplate> findAlternatives(Long templateId) {
        SentenceTemplate template = sentenceTemplateDAO.findById(templateId);
        return sentenceTemplateDAO.findByIntentCategory(template.getIntentCategory());
    }
}
