package com.haisensei.dto;

public class TranslationDTO {
    private String japaneseResult;
    private String romajiResult;
    private String englishStructure;
    private Long templateId;
    private Long subjectNounId;
    private Long objectNounId;
    private Long verbId;
    private Long grammaticalFormId;

    // Getters and Setters
    public String getJapaneseResult() { return japaneseResult; }
    public void setJapaneseResult(String japaneseResult) { this.japaneseResult = japaneseResult; }

    public String getRomajiResult() { return romajiResult; }
    public void setRomajiResult(String romajiResult) { this.romajiResult = romajiResult; }

    public String getEnglishStructure() { return englishStructure; }
    public void setEnglishStructure(String englishStructure) { this.englishStructure = englishStructure; }

    public Long getTemplateId() { return templateId; }
    public void setTemplateId(Long templateId) { this.templateId = templateId; }

    public Long getSubjectNounId() { return subjectNounId; }
    public void setSubjectNounId(Long subjectNounId) { this.subjectNounId = subjectNounId; }

    public Long getObjectNounId() { return objectNounId; }
    public void setObjectNounId(Long objectNounId) { this.objectNounId = objectNounId; }

    public Long getVerbId() { return verbId; }
    public void setVerbId(Long verbId) { this.verbId = verbId; }

    public Long getGrammaticalFormId() { return grammaticalFormId; }
    public void setGrammaticalFormId(Long grammaticalFormId) { this.grammaticalFormId = grammaticalFormId; }
}
