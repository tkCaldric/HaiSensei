package com.haisensei.model;

public class ConjugationRule {
    private Long id;
    private Long formId;
    private Long groupId;
    private String appliesToEnding;
    private String stemMutation;
    private String romajiStemMutation;
    private String suffix;
    private String romajiSuffix;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getFormId() { return formId; }
    public void setFormId(Long formId) { this.formId = formId; }

    public Long getGroupId() { return groupId; }
    public void setGroupId(Long groupId) { this.groupId = groupId; }

    public String getAppliesToEnding() { return appliesToEnding; }
    public void setAppliesToEnding(String appliesToEnding) { this.appliesToEnding = appliesToEnding; }

    public String getStemMutation() { return stemMutation; }
    public void setStemMutation(String stemMutation) { this.stemMutation = stemMutation; }

    public String getRomajiStemMutation() { return romajiStemMutation; }
    public void setRomajiStemMutation(String romajiStemMutation) { this.romajiStemMutation = romajiStemMutation; }

    public String getSuffix() { return suffix; }
    public void setSuffix(String suffix) { this.suffix = suffix; }

    public String getRomajiSuffix() { return romajiSuffix; }
    public void setRomajiSuffix(String romajiSuffix) { this.romajiSuffix = romajiSuffix; }
}
