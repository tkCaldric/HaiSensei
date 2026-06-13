package com.haisensei.dao;

import com.haisensei.model.JlptVocab;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class JlptVocabDAO {

    private final JdbcTemplate jdbcTemplate;

    public JlptVocabDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<JlptVocab> rowMapper = (rs, rowNum) -> {
        JlptVocab vocab = new JlptVocab();
        vocab.setId(rs.getLong("id"));
        vocab.setKanji(rs.getString("kanji"));
        vocab.setReading(rs.getString("reading"));
        vocab.setJlptLevel(rs.getString("jlpt_level"));
        return vocab;
    };

    public List<JlptVocab> search(String query, String level) {
        String levelFilter = (level != null && !level.trim().isEmpty()) ? level : "%";
        String wildQuery = "%" + (query != null ? query.toLowerCase() : "") + "%";
        
        String sql = "SELECT * FROM jlpt_vocab WHERE " +
                "(LOWER(kanji) LIKE ? OR LOWER(reading) LIKE ?) " +
                "AND jlpt_level LIKE ? " +
                "ORDER BY jlpt_level ASC, kanji ASC LIMIT 100";
                
        return jdbcTemplate.query(sql, rowMapper, wildQuery, wildQuery, levelFilter);
    }

    public long count() {
        return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM jlpt_vocab", Long.class);
    }
}
