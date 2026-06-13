package com.haisensei.dto;

public class TranslationRequest {
    private Long templateId;
    private Long subjectNounId;
    private Long objectNounId;
    private Long verbId;
    private Long grammaticalFormId;

    // Getters and Setters
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
