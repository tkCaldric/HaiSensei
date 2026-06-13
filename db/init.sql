-- PostgreSQL Schema and Seed Data Initialization

DROP TABLE IF EXISTS sample_phrases CASCADE;
DROP TABLE IF EXISTS sentence_templates CASCADE;
DROP TABLE IF EXISTS conjugation_rules CASCADE;
DROP TABLE IF EXISTS grammatical_forms CASCADE;
DROP TABLE IF EXISTS nouns CASCADE;
DROP TABLE IF EXISTS verbs CASCADE;
DROP TABLE IF EXISTS verb_groups CASCADE;

-- 1. verb_groups
CREATE TABLE verb_groups (
    id SERIAL PRIMARY KEY,
    group_name VARCHAR(50) NOT NULL UNIQUE
);

-- 2. verbs
CREATE TABLE verbs (
    id SERIAL PRIMARY KEY,
    group_id INTEGER REFERENCES verb_groups(id) ON DELETE CASCADE,
    english VARCHAR(100) NOT NULL,
    dictionary_form VARCHAR(100) NOT NULL,
    kanji_root VARCHAR(100) NOT NULL,
    romaji_root VARCHAR(100) NOT NULL,
    base_stem VARCHAR(100) NOT NULL,
    romaji_base_stem VARCHAR(100) NOT NULL,
    last_kana_char VARCHAR(10) NOT NULL,
    jlpt_level VARCHAR(10) NOT NULL
);

-- 3. nouns
CREATE TABLE nouns (
    id SERIAL PRIMARY KEY,
    english VARCHAR(100) NOT NULL,
    japanese_form VARCHAR(100) NOT NULL,
    romaji_form VARCHAR(100) NOT NULL
);

-- 4. grammatical_forms
CREATE TABLE grammatical_forms (
    id SERIAL PRIMARY KEY,
    form_name VARCHAR(100) NOT NULL UNIQUE,
    jlpt_level VARCHAR(10) NOT NULL
);

-- 5. conjugation_rules
CREATE TABLE conjugation_rules (
    id SERIAL PRIMARY KEY,
    form_id INTEGER REFERENCES grammatical_forms(id) ON DELETE CASCADE,
    group_id INTEGER REFERENCES verb_groups(id) ON DELETE CASCADE,
    applies_to_ending VARCHAR(10) NOT NULL,
    stem_mutation VARCHAR(50) DEFAULT '',
    romaji_stem_mutation VARCHAR(50) DEFAULT '',
    suffix VARCHAR(50) DEFAULT '',
    romaji_suffix VARCHAR(50) DEFAULT ''
);

-- 6. sentence_templates
CREATE TABLE sentence_templates (
    id SERIAL PRIMARY KEY,
    template_name VARCHAR(100) NOT NULL,
    intent_category VARCHAR(100) NOT NULL,
    english_structure VARCHAR(255) NOT NULL,
    japanese_structure VARCHAR(255) NOT NULL,
    romaji_structure VARCHAR(255) NOT NULL
);

-- 7. sample_phrases
CREATE TABLE sample_phrases (
    id SERIAL PRIMARY KEY,
    input_pattern VARCHAR(255) NOT NULL,
    template_id INTEGER REFERENCES sentence_templates(id) ON DELETE CASCADE,
    subject_noun_id INTEGER REFERENCES nouns(id) ON DELETE CASCADE,
    object_noun_id INTEGER REFERENCES nouns(id) ON DELETE CASCADE,
    verb_id INTEGER REFERENCES verbs(id) ON DELETE CASCADE,
    grammatical_form_id INTEGER REFERENCES grammatical_forms(id) ON DELETE CASCADE
);

-- Insert Verb Groups (1: Godan / Group 1, 2: Ichidan / Group 2, 3: Irregular / Group 3)
INSERT INTO verb_groups (id, group_name) VALUES
(1, 'Godan (Group 1)'),
(2, 'Ichidan (Group 2)'),
(3, 'Irregular (Group 3)');

-- Insert Verbs
INSERT INTO verbs (id, group_id, english, dictionary_form, kanji_root, romaji_root, base_stem, romaji_base_stem, last_kana_char, jlpt_level) VALUES
(1, 2, 'eat', '食[た]べる', '食[た]', 'ta', '食[た]べ', 'tabe', 'る', 'N5'),
(2, 2, 'see / watch', '見[み]る', '見[み]', 'mi', '見[み]', 'mi', 'る', 'N5'),
(3, 1, 'drink', '飲[の]む', '飲[の]', 'no', '飲[の]', 'no', 'む', 'N5'),
(4, 1, 'write', '書[か]く', '書[か]', 'ka', '書[か]', 'ka', 'く', 'N5'),
(5, 1, 'read', '読[よ]む', '読[よ]', 'yo', '読[よ]', 'yo', 'む', 'N5'),
(6, 1, 'buy', '買[か]う', '買[か]', 'ka', '買[か]', 'ka', 'う', 'N5'),
(7, 3, 'do', 'する', 'する', 'suru', '', '', 'する', 'N5'),
(8, 3, 'come', '来[く]る', '来[く]', 'ku', '', '', 'くる', 'N5');

-- Insert Nouns
INSERT INTO nouns (id, english, japanese_form, romaji_form) VALUES
(1, 'I', '私[わたし]', 'watashi'),
(2, 'apple', '林檎[りんご]', 'ringo'),
(3, 'water', '水[みず]', 'mizu'),
(4, 'book', '本[ほん]', 'hon'),
(5, 'letter', '手紙[てがみ]', 'tegami'),
(6, 'tea', '茶[ちゃ]', 'cha'),
(7, 'sushi', '寿司[すし]', 'sushi'),
(8, 'movie', '映画[えいが]', 'eiga');

-- Insert Grammatical Forms
INSERT INTO grammatical_forms (id, form_name, jlpt_level) VALUES
(1, 'Polite Present Positive (-masu)', 'N5'),
(2, 'Polite Present Negative (-masen)', 'N5'),
(3, 'Polite Past Positive (-mashita)', 'N5'),
(4, 'Polite Past Negative (-masendeshita)', 'N5'),
(5, 'Plain Present Positive (Dictionary Form)', 'N5');

-- Insert Conjugation Rules
-- Group 1 (Godan) Rules
-- 1. Polite Present Positive (-masu)
INSERT INTO conjugation_rules (form_id, group_id, applies_to_ending, stem_mutation, romaji_stem_mutation, suffix, romaji_suffix) VALUES
(1, 1, 'む', 'み', 'mi', 'ます', 'masu'),
(1, 1, 'く', 'き', 'ki', 'ます', 'masu'),
(1, 1, 'う', 'い', 'i', 'ます', 'masu'),
-- 2. Polite Present Negative (-masen)
(2, 1, 'む', 'み', 'mi', 'ません', 'masen'),
(2, 1, 'く', 'き', 'ki', 'ません', 'masen'),
(2, 1, 'う', 'い', 'i', 'ません', 'masen'),
-- 3. Polite Past Positive (-mashita)
(3, 1, 'む', 'み', 'mi', 'ました', 'mashita'),
(3, 1, 'く', 'き', 'ki', 'ました', 'mashita'),
(3, 1, 'う', 'い', 'i', 'ました', 'mashita'),
-- 4. Polite Past Negative (-masendeshita)
(4, 1, 'む', 'み', 'mi', 'ませんでした', 'masendeshita'),
(4, 1, 'く', 'き', 'ki', 'ませんでした', 'masendeshita'),
(4, 1, 'う', 'い', 'i', 'ませんでした', 'masendeshita'),
-- 5. Plain Present Positive (Dictionary Form) - no change
(5, 1, 'む', 'む', 'mu', '', ''),
(5, 1, 'く', 'く', 'ku', '', ''),
(5, 1, 'う', 'う', 'u', '', '');

-- Group 2 (Ichidan) Rules
-- 1. Polite Present Positive (-masu)
INSERT INTO conjugation_rules (form_id, group_id, applies_to_ending, stem_mutation, romaji_stem_mutation, suffix, romaji_suffix) VALUES
(1, 2, 'る', '', '', 'ます', 'masu'),
-- 2. Polite Present Negative (-masen)
(2, 2, 'る', '', '', 'ません', 'masen'),
-- 3. Polite Past Positive (-mashita)
(3, 2, 'る', '', '', 'ました', 'mashita'),
-- 4. Polite Past Negative (-masendeshita)
(4, 2, 'る', '', '', 'ませんでした', 'masendeshita'),
-- 5. Plain Present Positive (Dictionary Form)
(5, 2, 'る', 'る', 'ru', '', '');

-- Group 3 (Irregular) Rules
-- For 'する' (do)
INSERT INTO conjugation_rules (form_id, group_id, applies_to_ending, stem_mutation, romaji_stem_mutation, suffix, romaji_suffix) VALUES
(1, 3, 'する', 'し', 'shi', 'ます', 'masu'),
(2, 3, 'する', 'し', 'shi', 'ません', 'masen'),
(3, 3, 'する', 'し', 'shi', 'ました', 'mashita'),
(4, 3, 'する', 'し', 'shi', 'ませんでした', 'masendeshita'),
(5, 3, 'する', 'する', 'suru', '', ''),
-- For 'くる' (come)
(1, 3, 'くる', '来[き]', 'ki', 'ます', 'masu'),
(2, 3, 'くる', '来[き]', 'ki', 'ません', 'masen'),
(3, 3, 'くる', '来[き]', 'ki', 'ました', 'mashita'),
(4, 3, 'くる', '来[き]', 'ki', 'ませんでした', 'masendeshita'),
(5, 3, 'くる', '来[く]る', 'kuru', '', '');

-- Insert Sentence Templates
-- The templates contain slots: {subject}, {object}, {verb}
INSERT INTO sentence_templates (id, template_name, intent_category, english_structure, japanese_structure, romaji_structure) VALUES
(1, 'Subject-Object-Verb (Standard Action)', 'transitive_action', '{subject} (Subject) does action to {object} (Object).', '{subject}は{object}を{verb}', '{subject} wa {object} o {verb}'),
(2, 'Subject-Object-Verb (Polite/Formal focus)', 'transitive_action', 'Focus: {subject} executes action regarding {object}.', '{subject}については、{object}を{verb}', '{subject} ni tsuite wa, {object} o {verb}'),
(3, 'Subject-Object-Verb (Emphasis on Object)', 'transitive_action', 'Emphasis: {object} is acted upon by {subject}.', '{object}は{subject}が{verb}', '{object} wa {subject} ga {verb}');

-- Insert Sample Phrases
INSERT INTO sample_phrases (input_pattern, template_id, subject_noun_id, object_noun_id, verb_id, grammatical_form_id) VALUES
('I eat an apple', 1, 1, 2, 1, 1),
('I watch a movie', 1, 1, 8, 2, 1),
('I drink water', 1, 1, 3, 3, 1),
('I write a letter', 1, 1, 5, 4, 1),
('I buy tea', 1, 1, 6, 6, 1),
('I read a book', 1, 1, 4, 5, 1);
