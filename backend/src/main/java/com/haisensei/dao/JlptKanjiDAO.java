package com.haisensei.dao;

import com.haisensei.model.JlptKanji;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class JlptKanjiDAO {

    private final JdbcTemplate jdbcTemplate;

    public JlptKanjiDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<JlptKanji> rowMapper = (rs, rowNum) -> {
        JlptKanji kanji = new JlptKanji();
        kanji.setId(rs.getLong("id"));
        kanji.setKanji(rs.getString("kanji"));
        kanji.setJlptLevel(rs.getString("jlpt_level"));
        return kanji;
    };

    public List<JlptKanji> search(String query, String level) {
        String levelFilter = (level != null && !level.trim().isEmpty()) ? level : "%";
        String wildQuery = "%" + (query != null ? query.toLowerCase() : "") + "%";
        
        String sql = "SELECT * FROM jlpt_kanji WHERE " +
                "LOWER(kanji) LIKE ? " +
                "AND jlpt_level LIKE ? " +
                "ORDER BY jlpt_level ASC, kanji ASC LIMIT 100";
                
        return jdbcTemplate.query(sql, rowMapper, wildQuery, levelFilter);
    }

    public long count() {
        return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM jlpt_kanji", Long.class);
    }
}
