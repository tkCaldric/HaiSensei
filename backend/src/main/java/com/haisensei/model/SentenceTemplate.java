package com.haisensei.model;

public class SentenceTemplate {
    private Long id;
    private String templateName;
    private String intentCategory;
    private String englishStructure;
    private String japaneseStructure;
    private String romajiStructure;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTemplateName() { return templateName; }
    public void setTemplateName(String templateName) { this.templateName = templateName; }

    public String getIntentCategory() { return intentCategory; }
    public void setIntentCategory(String intentCategory) { this.intentCategory = intentCategory; }

    public String getEnglishStructure() { return englishStructure; }
    public void setEnglishStructure(String englishStructure) { this.englishStructure = englishStructure; }

    public String getJapaneseStructure() { return japaneseStructure; }
    public void setJapaneseStructure(String japaneseStructure) { this.japaneseStructure = japaneseStructure; }

    public String getRomajiStructure() { return romajiStructure; }
    public void setRomajiStructure(String romajiStructure) { this.romajiStructure = romajiStructure; }
}
