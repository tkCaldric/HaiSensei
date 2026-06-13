package com.haisensei.model;

public class JlptVocab {
    private Long id;
    private String kanji;
    private String reading;
    private String jlptLevel;
    private String meaning;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getKanji() { return kanji; }
    public void setKanji(String kanji) { this.kanji = kanji; }

    public String getReading() { return reading; }
    public void setReading(String reading) { this.reading = reading; }

    public String getJlptLevel() { return jlptLevel; }
    public void setJlptLevel(String jlptLevel) { this.jlptLevel = jlptLevel; }

    public String getMeaning() { return meaning; }
    public void setMeaning(String meaning) { this.meaning = meaning; }
}
