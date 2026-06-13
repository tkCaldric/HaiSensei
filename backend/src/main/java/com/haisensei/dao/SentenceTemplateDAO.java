package com.haisensei.dao;

import com.haisensei.model.SentenceTemplate;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class SentenceTemplateDAO {

    private final JdbcTemplate jdbcTemplate;

    public SentenceTemplateDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<SentenceTemplate> rowMapper = (rs, rowNum) -> {
        SentenceTemplate template = new SentenceTemplate();
        template.setId(rs.getLong("id"));
        template.setTemplateName(rs.getString("template_name"));
        template.setIntentCategory(rs.getString("intent_category"));
        template.setEnglishStructure(rs.getString("english_structure"));
        template.setJapaneseStructure(rs.getString("japanese_structure"));
        template.setRomajiStructure(rs.getString("romaji_structure"));
        return template;
    };

    public List<SentenceTemplate> findAll() {
        String sql = "SELECT * FROM sentence_templates ORDER BY id ASC";
        return jdbcTemplate.query(sql, rowMapper);
    }

    public SentenceTemplate findById(Long id) {
        String sql = "SELECT * FROM sentence_templates WHERE id = ?";
        return jdbcTemplate.queryForObject(sql, rowMapper, id);
    }

    public List<SentenceTemplate> findByIntentCategory(String intentCategory) {
        String sql = "SELECT * FROM sentence_templates WHERE intent_category = ? ORDER BY id ASC";
        return jdbcTemplate.query(sql, rowMapper, intentCategory);
    }
}
