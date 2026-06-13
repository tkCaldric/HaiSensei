package com.haisensei.model;

public class SamplePhrase {
    private Long id;
    private String inputPattern;
    private Long templateId;
    private Long subjectNounId;
    private Long objectNounId;
    private Long verbId;
    private Long grammaticalFormId;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getInputPattern() { return inputPattern; }
    public void setInputPattern(String inputPattern) { this.inputPattern = inputPattern; }

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
