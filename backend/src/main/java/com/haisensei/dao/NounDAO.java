package com.haisensei.dao;

import com.haisensei.model.Noun;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class NounDAO {

    private final JdbcTemplate jdbcTemplate;

    public NounDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Noun> rowMapper = (rs, rowNum) -> {
        Noun noun = new Noun();
        noun.setId(rs.getLong("id"));
        noun.setEnglish(rs.getString("english"));
        noun.setJapaneseForm(rs.getString("japanese_form"));
        noun.setRomajiForm(rs.getString("romaji_form"));
        return noun;
    };

    public List<Noun> findAll() {
        String sql = "SELECT * FROM nouns ORDER BY english ASC";
        return jdbcTemplate.query(sql, rowMapper);
    }

    public Noun findById(Long id) {
        String sql = "SELECT * FROM nouns WHERE id = ?";
        return jdbcTemplate.queryForObject(sql, rowMapper, id);
    }
}
