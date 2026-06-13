package com.haisensei.dao;

import com.haisensei.model.Verb;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class VerbDAO {

    private final JdbcTemplate jdbcTemplate;

    public VerbDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Verb> rowMapper = (rs, rowNum) -> {
        Verb verb = new Verb();
        verb.setId(rs.getLong("id"));
        verb.setGroupId(rs.getLong("group_id"));
        verb.setEnglish(rs.getString("english"));
        verb.setDictionaryForm(rs.getString("dictionary_form"));
        verb.setKanjiRoot(rs.getString("kanji_root"));
        verb.setRomajiRoot(rs.getString("romaji_root"));
        verb.setBaseStem(rs.getString("base_stem"));
        verb.setRomajiBaseStem(rs.getString("romaji_base_stem"));
        verb.setLastKanaChar(rs.getString("last_kana_char"));
        verb.setJlptLevel(rs.getString("jlpt_level"));
        return verb;
    };

    public List<Verb> findAll() {
        String sql = "SELECT * FROM verbs ORDER BY english ASC";
        return jdbcTemplate.query(sql, rowMapper);
    }

    public Verb findById(Long id) {
        String sql = "SELECT * FROM verbs WHERE id = ?";
        return jdbcTemplate.queryForObject(sql, rowMapper, id);
    }
}
