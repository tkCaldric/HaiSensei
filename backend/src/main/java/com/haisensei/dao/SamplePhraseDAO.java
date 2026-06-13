package com.haisensei.dao;

import com.haisensei.dto.SearchResultDTO;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class SamplePhraseDAO {

    private final JdbcTemplate jdbcTemplate;

    public SamplePhraseDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<SearchResultDTO> rowMapper = (rs, rowNum) -> {
        SearchResultDTO dto = new SearchResultDTO();
        dto.setSamplePhraseId(rs.getLong("id"));
        dto.setInputPattern(rs.getString("input_pattern"));
        dto.setTemplateId(rs.getLong("template_id"));
        dto.setSubjectNounId(rs.getLong("subject_noun_id"));
        dto.setObjectNounId(rs.getLong("object_noun_id"));
        dto.setVerbId(rs.getLong("verb_id"));
        dto.setGrammaticalFormId(rs.getLong("grammatical_form_id"));
        return dto;
    };

    public List<SearchResultDTO> search(String query) {
        String sql = "SELECT * FROM sample_phrases WHERE LOWER(input_pattern) LIKE ? ORDER BY input_pattern ASC";
        String wildQuery = "%" + query.toLowerCase() + "%";
        return jdbcTemplate.query(sql, rowMapper, wildQuery);
    }
}
