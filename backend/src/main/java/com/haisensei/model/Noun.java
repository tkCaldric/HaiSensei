package com.haisensei.model;

public class Noun {
    private Long id;
    private String english;
    private String japaneseForm;
    private String romajiForm;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getEnglish() { return english; }
    public void setEnglish(String english) { this.english = english; }

    public String getJapaneseForm() { return japaneseForm; }
    public void setJapaneseForm(String japaneseForm) { this.japaneseForm = japaneseForm; }

    public String getRomajiForm() { return romajiForm; }
    public void setRomajiForm(String romajiForm) { this.romajiForm = romajiForm; }
}
