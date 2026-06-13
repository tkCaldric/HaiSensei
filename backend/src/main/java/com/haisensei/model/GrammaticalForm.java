package com.haisensei.model;

public class GrammaticalForm {
    private Long id;
    private String formName;
    private String jlptLevel;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getFormName() { return formName; }
    public void setFormName(String formName) { this.formName = formName; }

    public String getJlptLevel() { return jlptLevel; }
    public void setJlptLevel(String jlptLevel) { this.jlptLevel = jlptLevel; }
}
