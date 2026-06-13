package com.haisensei.dao;

import com.haisensei.model.GrammaticalForm;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class GrammaticalFormDAO {

    private final JdbcTemplate jdbcTemplate;

    public GrammaticalFormDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<GrammaticalForm> rowMapper = (rs, rowNum) -> {
        GrammaticalForm form = new GrammaticalForm();
        form.setId(rs.getLong("id"));
        form.setFormName(rs.getString("form_name"));
        form.setJlptLevel(rs.getString("jlpt_level"));
        return form;
    };

    public List<GrammaticalForm> findAll() {
        String sql = "SELECT * FROM grammatical_forms ORDER BY id ASC";
        return jdbcTemplate.query(sql, rowMapper);
    }

    public GrammaticalForm findById(Long id) {
        String sql = "SELECT * FROM grammatical_forms WHERE id = ?";
        return jdbcTemplate.queryForObject(sql, rowMapper, id);
    }
}
