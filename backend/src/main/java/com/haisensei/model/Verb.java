package com.haisensei.model;

public class Verb {
    private Long id;
    private Long groupId;
    private String english;
    private String dictionaryForm;
    private String kanjiRoot;
    private String romajiRoot;
    private String baseStem;
    private String romajiBaseStem;
    private String lastKanaChar;
    private String jlptLevel;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getGroupId() { return groupId; }
    public void setGroupId(Long groupId) { this.groupId = groupId; }

    public String getEnglish() { return english; }
    public void setEnglish(String english) { this.english = english; }

    public String getDictionaryForm() { return dictionaryForm; }
    public void setDictionaryForm(String dictionaryForm) { this.dictionaryForm = dictionaryForm; }

    public String getKanjiRoot() { return kanjiRoot; }
    public void setKanjiRoot(String kanjiRoot) { this.kanjiRoot = kanjiRoot; }

    public String getRomajiRoot() { return romajiRoot; }
    public void setRomajiRoot(String romajiRoot) { this.romajiRoot = romajiRoot; }

    public String getBaseStem() { return baseStem; }
    public void setBaseStem(String baseStem) { this.baseStem = baseStem; }

    public String getRomajiBaseStem() { return romajiBaseStem; }
    public void setRomajiBaseStem(String romajiBaseStem) { this.romajiBaseStem = romajiBaseStem; }

    public String getLastKanaChar() { return lastKanaChar; }
    public void setLastKanaChar(String lastKanaChar) { this.lastKanaChar = lastKanaChar; }

    public String getJlptLevel() { return jlptLevel; }
    public void setJlptLevel(String jlptLevel) { this.jlptLevel = jlptLevel; }
}
