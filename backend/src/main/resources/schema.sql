-- Schema and Seed Data Initialization for H2 / PostgreSQL compatible mode

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

-- Insert Verbs (Expanded)
INSERT INTO verbs (id, group_id, english, dictionary_form, kanji_root, romaji_root, base_stem, romaji_base_stem, last_kana_char, jlpt_level) VALUES
(1, 2, 'eat', '食[た]べる', '食[た]', 'ta', '食[た]べ', 'tabe', 'る', 'N5'),
(2, 2, 'see / watch', '見[み]る', '見[み]', 'mi', '見[み]', 'mi', 'る', 'N5'),
(3, 1, 'drink', '飲[の]む', '飲[の]', 'no', '飲[の]', 'no', 'む', 'N5'),
(4, 1, 'write', '書[か]く', '書[か]', 'ka', '書[か]', 'ka', 'く', 'N5'),
(5, 1, 'read', '読[よ]む', '読[よ]', 'yo', '読[よ]', 'yo', 'む', 'N5'),
(6, 1, 'buy', '買[か]う', '買[か]', 'ka', '買[か]', 'ka', 'う', 'N5'),
(7, 3, 'do', 'する', 'する', 'suru', '', '', 'する', 'N5'),
(8, 3, 'come', '来[く]る', '来[く]', 'ku', '', '', 'くる', 'N5'),
(9, 1, 'speak / talk', '話[はな]す', '話[はな]', 'ha', '話[はな]', 'hana', 'す', 'N5'),
(10, 1, 'listen / ask', '聞[き]く', '聞[き]', 'ki', '聞[き]', 'ki', 'く', 'N5'),
(11, 1, 'meet', '会[あ]う', '会[あ]', 'a', '会[あ]', 'a', 'う', 'N5'),
(12, 1, 'wait', '待[ま]つ', '待[ま]', 'ma', '待[ま]', 'ma', 'つ', 'N5'),
(13, 1, 'return home', '帰[かえ]る', '帰[かえ]', 'kae', '帰[かえ]', 'kaere', 'る', 'N5');

-- Insert Nouns (Generalised Semantic Categories)
INSERT INTO nouns (id, english, japanese_form, romaji_form) VALUES
(1, 'I', '私[わたし]', 'watashi'),
(2, '[Food / Tabemono]', '食[た]べ物[もの]', 'tabemono'),
(3, '[Drink / Nomimono]', '飲[の]み物[もの]', 'nomimono'),
(4, '[Reading Material]', '読[よ]み物[もの]', 'yomimono'),
(5, '[Writing / Letter]', '手紙[てがみ]', 'tegami'),
(6, '[Language]', '言葉[ことば]', 'kotoba'),
(7, '[Person]', '人[ひと]', 'hito'),
(8, '[Media / Movie]', '映画[えいが]', 'eiga'),
(9, '[Place / Destination]', '場所[ばしょ]', 'basho'),
(10, '[Object / Item]', '物[もの]', 'mono');

-- Insert Grammatical Forms (N5/N4 Expanded)
INSERT INTO grammatical_forms (id, form_name, jlpt_level) VALUES
(1, 'Polite Present Positive (-masu)', 'N5'),
(2, 'Polite Present Negative (-masen)', 'N5'),
(3, 'Polite Past Positive (-mashita)', 'N5'),
(4, 'Polite Past Negative (-masendeshita)', 'N5'),
(5, 'Plain Present Positive (Dictionary Form)', 'N5'),
(6, 'Polite Request (-te kudasai)', 'N5'),
(7, 'Present Continuous (-te imasu)', 'N5'),
(8, 'Desire Form (-tai desu)', 'N5/N4'),
(9, 'Polite Potential Form (-emasu / -raremasu)', 'N4'),
(10, 'Polite Permission (-te mo ii desu)', 'N4');

-- Insert Conjugation Rules
-- Group 1 (Godan) Rules
-- 1. Polite Present Positive (-masu)
INSERT INTO conjugation_rules (form_id, group_id, applies_to_ending, stem_mutation, romaji_stem_mutation, suffix, romaji_suffix) VALUES
(1, 1, 'む', 'み', 'mi', 'ます', 'masu'),
(1, 1, 'く', 'き', 'ki', 'ます', 'masu'),
(1, 1, 'う', 'い', 'i', 'ます', 'masu'),
(1, 1, 'す', 'し', 'shi', 'ます', 'masu'),
(1, 1, 'つ', 'ち', 'chi', 'ます', 'masu'),
(1, 1, 'る', 'り', 'ri', 'ます', 'masu'),
-- 2. Polite Present Negative (-masen)
(2, 1, 'む', 'み', 'mi', 'ません', 'masen'),
(2, 1, 'く', 'き', 'ki', 'ません', 'masen'),
(2, 1, 'う', 'い', 'i', 'ません', 'masen'),
(2, 1, 'す', 'し', 'shi', 'ません', 'masen'),
(2, 1, 'つ', 'ち', 'chi', 'ません', 'masen'),
(2, 1, 'る', 'り', 'ri', 'ません', 'masen'),
-- 3. Polite Past Positive (-mashita)
(3, 1, 'む', 'み', 'mi', 'ました', 'mashita'),
(3, 1, 'く', 'き', 'ki', 'ました', 'mashita'),
(3, 1, 'う', 'い', 'i', 'ました', 'mashita'),
(3, 1, 'す', 'し', 'shi', 'ました', 'mashita'),
(3, 1, 'つ', 'ち', 'chi', 'ました', 'mashita'),
(3, 1, 'る', 'り', 'ri', 'ました', 'mashita'),
-- 4. Polite Past Negative (-masendeshita)
(4, 1, 'む', 'み', 'mi', 'ませんでした', 'masendeshita'),
(4, 1, 'く', 'き', 'ki', 'ませんでした', 'masendeshita'),
(4, 1, 'う', 'い', 'i', 'ませんでした', 'masendeshita'),
(4, 1, 'す', 'し', 'shi', 'ませんでした', 'masendeshita'),
(4, 1, 'つ', 'ち', 'chi', 'ませんでした', 'masendeshita'),
(4, 1, 'る', 'り', 'ri', 'ませんでした', 'masendeshita'),
-- 5. Plain Present Positive (Dictionary Form)
(5, 1, 'む', 'む', 'mu', '', ''),
(5, 1, 'く', 'く', 'ku', '', ''),
(5, 1, 'う', 'う', 'u', '', ''),
(5, 1, 'す', 'す', 'su', '', ''),
(5, 1, 'つ', 'つ', 'tsu', '', ''),
(5, 1, 'る', 'る', 'ru', '', ''),
-- 6. Polite Request (-te kudasai)
(6, 1, 'む', 'ん', 'n', 'でください', 'de kudasai'),
(6, 1, 'く', 'い', 'i', 'てください', 'te kudasai'),
(6, 1, 'う', 'っ', 't', 'てください', 'te kudasai'),
(6, 1, 'す', 'し', 'shi', 'てください', 'te kudasai'),
(6, 1, 'つ', 'っ', 't', 'てください', 'te kudasai'),
(6, 1, 'る', 'っ', 't', 'てください', 'te kudasai'),
-- 7. Present Continuous (-te imasu)
(7, 1, 'む', 'ん', 'n', 'でいます', 'de imasu'),
(7, 1, 'く', 'い', 'i', 'ています', 'te imasu'),
(7, 1, 'う', 'っ', 't', 'ています', 'te imasu'),
(7, 1, 'す', 'し', 'shi', 'ています', 'te imasu'),
(7, 1, 'つ', 'っ', 't', 'ています', 'te imasu'),
(7, 1, 'る', 'っ', 't', 'ています', 'te imasu'),
-- 8. Desire Form (-tai desu)
(8, 1, 'む', 'み', 'mi', 'たいです', 'tai desu'),
(8, 1, 'く', 'き', 'ki', 'たいです', 'tai desu'),
(8, 1, 'う', 'い', 'i', 'たいです', 'tai desu'),
(8, 1, 'す', 'し', 'shi', 'たいです', 'tai desu'),
(8, 1, 'つ', 'ち', 'chi', 'たいです', 'tai desu'),
(8, 1, 'る', 'り', 'ri', 'たいです', 'tai desu'),
-- 9. Polite Potential Form (-emasu)
(9, 1, 'む', 'め', 'me', 'ます', 'masu'),
(9, 1, 'く', 'け', 'ke', 'ます', 'masu'),
(9, 1, 'う', 'え', 'e', 'ます', 'masu'),
(9, 1, 'す', 'せ', 'se', 'ます', 'masu'),
(9, 1, 'つ', 'て', 'te', 'ます', 'masu'),
(9, 1, 'る', 'れ', 're', 'ます', 'masu'),
-- 10. Polite Permission (-te mo ii desu)
(10, 1, 'む', 'ん', 'n', 'でもいいです', 'de mo ii desu'),
(10, 1, 'く', 'い', 'i', 'てもいいです', 'te mo ii desu'),
(10, 1, 'う', 'っ', 't', 'てもいいです', 'te mo ii desu'),
(10, 1, 'す', 'し', 'shi', 'てもいいです', 'te mo ii desu'),
(10, 1, 'つ', 'っ', 't', 'てもいいです', 'te mo ii desu'),
(10, 1, 'る', 'っ', 't', 'てもいいです', 'te mo ii desu');

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
(5, 2, 'る', 'る', 'ru', '', ''),
-- 6. Polite Request (-te kudasai)
(6, 2, 'る', '', '', 'てください', 'te kudasai'),
-- 7. Present Continuous (-te imasu)
(7, 2, 'る', '', '', 'ています', 'te imasu'),
-- 8. Desire Form (-tai desu)
(8, 2, 'る', '', '', 'たいです', 'tai desu'),
-- 9. Polite Potential Form (-raremasu)
(9, 2, 'る', 'られ', 'rare', 'ます', 'masu'),
-- 10. Polite Permission (-te mo ii desu)
(10, 2, 'る', '', '', 'てもいいです', 'te mo ii desu');

-- Group 3 (Irregular) Rules
INSERT INTO conjugation_rules (form_id, group_id, applies_to_ending, stem_mutation, romaji_stem_mutation, suffix, romaji_suffix) VALUES
(1, 3, 'する', 'し', 'shi', 'ます', 'masu'),
(2, 3, 'する', 'し', 'shi', 'ません', 'masen'),
(3, 3, 'する', 'し', 'shi', 'ました', 'mashita'),
(4, 3, 'する', 'し', 'shi', 'ませんでした', 'masendeshita'),
(5, 3, 'する', 'する', 'suru', '', ''),
(6, 3, 'する', 'し', 'shi', 'てください', 'te kudasai'),
(7, 3, 'する', 'し', 'shi', 'ています', 'te imasu'),
(8, 3, 'する', 'し', 'shi', 'たいです', 'tai desu'),
(9, 3, 'する', 'でき', 'deki', 'ます', 'masu'),
(10, 3, 'する', 'し', 'shi', 'てもいいです', 'te mo ii desu'),
-- For 'くる' (come)
(1, 3, 'くる', '来[き]', 'ki', 'ます', 'masu'),
(2, 3, 'くる', '来[き]', 'ki', 'ません', 'masen'),
(3, 3, 'くる', '来[き]', 'ki', 'ました', 'mashita'),
(4, 3, 'くる', '来[き]', 'ki', 'ませんでした', 'masendeshita'),
(5, 3, 'くる', '来[く]る', 'kuru', '', ''),
(6, 3, 'くる', '来[き]', 'ki', 'てください', 'te kudasai'),
(7, 3, 'くる', '来[き]', 'ki', 'ています', 'te imasu'),
(8, 3, 'くる', '来[き]', 'ki', 'たいです', 'tai desu'),
(9, 3, 'くる', '来[こ]られ', 'kora', 'ます', 'masu'),
(10, 3, 'くる', '来[き]', 'ki', 'てもいいです', 'te mo ii desu');

-- Insert Sentence Templates
INSERT INTO sentence_templates (id, template_name, intent_category, english_structure, japanese_structure, romaji_structure) VALUES
(1, 'Subject-Object-Verb (Standard Action)', 'transitive_action', '{subject} (Subject) does action to {object} (Object).', '{subject}は{object}を{verb}', '{subject} wa {object} o {verb}'),
(2, 'Subject-Object-Verb (Polite/Formal focus)', 'transitive_action', 'Focus: {subject} executes action regarding {object}.', '{subject}については、{object}を{verb}', '{subject} ni tsuite wa, {object} o {verb}'),
(3, 'Subject-Object-Verb (Emphasis on Object)', 'transitive_action', 'Emphasis: {object} is acted upon by {subject}.', '{object}は{subject}が{verb}', '{object} wa {subject} ga {verb}'),
(4, 'Polite Request (Please do...)', 'request', 'Please {verb} {object}.', '{object}を{verb}', '{object} o {verb}'),
(5, 'Present Continuous (Am/Is doing...)', 'continuous_action', '{subject} is {verb} {object}.', '{subject}は{object}を{verb}', '{subject} wa {object} o {verb}'),
(6, 'Desire Expression (Want to do...)', 'desire_action', '{subject} wants to {verb} {object}.', '{subject}は{object}を{verb}', '{subject} wa {object} o {verb}'),
(7, 'Potential Expression (Can do...)', 'potential_action', '{subject} can {verb} {object}.', '{subject}は{object}が{verb}', '{subject} wa {object} ga {verb}'),
(8, 'Permission Expression (May do...)', 'permission_action', '{subject} may {verb} {object}.', '{subject}は{object}を{verb}', '{subject} wa {object} o {verb}');

-- Insert Sample Phrases (Generalised)
INSERT INTO sample_phrases (input_pattern, template_id, subject_noun_id, object_noun_id, verb_id, grammatical_form_id) VALUES
('I eat food', 1, 1, 2, 1, 1),
('I watch a movie', 1, 1, 8, 2, 1),
('I drink a beverage', 1, 1, 3, 3, 1),
('I write a letter', 1, 1, 5, 4, 1),
('I buy an item', 1, 1, 10, 6, 1),
('I read a book', 1, 1, 4, 5, 1),
('I speak language', 1, 1, 6, 9, 1),
('I listen to a person', 1, 1, 7, 10, 1),
('I meet a person', 1, 1, 7, 11, 1),
('I wait for a person', 1, 1, 7, 12, 1),
('please eat food', 4, 1, 2, 1, 6),
('please write a letter', 4, 1, 5, 4, 6),
('I am drinking a beverage', 5, 1, 3, 3, 7),
('I want to read a book', 6, 1, 4, 5, 8),
('I can speak Japanese', 7, 1, 6, 9, 9),
('you may eat food', 8, 1, 2, 1, 10);


-- =========================================================
-- JLPT N5/N4 VOCABULARY & KANJI IMPORTED FROM CSV DATASETS
-- =========================================================

DROP TABLE IF EXISTS jlpt_vocab CASCADE;
DROP TABLE IF EXISTS jlpt_kanji CASCADE;

CREATE TABLE jlpt_vocab (
    id SERIAL PRIMARY KEY,
    kanji VARCHAR(100) NOT NULL,
    reading VARCHAR(100) NOT NULL,
    jlpt_level VARCHAR(10) NOT NULL
);

CREATE TABLE jlpt_kanji (
    id SERIAL PRIMARY KEY,
    kanji VARCHAR(10) NOT NULL UNIQUE,
    jlpt_level VARCHAR(10) NOT NULL
);

INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('あ', 'あ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ああ', 'ああ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('あいさつ', 'あいさつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('間', 'あいだ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('合う', 'あう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('あかちゃん', 'あかちゃん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('上る', 'あがる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('赤ん坊', 'あかんぼう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('空く', 'あく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('アクセサリー', 'アクセサリー', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('あげる', 'あげる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('浅い', 'あさい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('味', 'あじ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('アジア', 'アジア', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('明日', 'あす', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('遊び', 'あそび', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('集る', 'あつまる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('集める', 'あつめる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('アナウンサー', 'アナウンサー', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('アフリカ', 'アフリカ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('アメリカ', 'アメリカ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('謝る', 'あやまる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('アルコール', 'アルコール', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('アルバイト', 'アルバイト', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('安心', 'あんしん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('安全', 'あんぜん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('あんな', 'あんな', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('案内', 'あんない', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('以下', 'いか', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('以外', 'いがい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('医学', 'いがく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('生きる', 'いきる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('意見', 'いけん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('石', 'いし', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('いじめる', 'いじめる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('以上', 'いじょう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('急ぐ', 'いそぐ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('致す', 'いたす', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('いただく', 'いただく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('一度', 'いちど', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('一生懸命', 'いっしょうけんめい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('いっぱい', 'いっぱい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('糸', 'いと', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('以内', 'いない', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('田舎', 'いなか', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('祈る', 'いのる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('いらっしゃる', 'いらっしゃる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('植える', 'うえる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('うかがう', 'うかがう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('受付', 'うけつけ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('受ける', 'うける', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('動く', 'うごく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('うそ', 'うそ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('うち', 'うち', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('打つ', 'うつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('美しい', 'うつくしい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('写す', 'うつす', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('移る', 'うつる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('腕', 'うで', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('うまい', 'うまい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('裏', 'うら', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('売り場', 'うりば', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('うれしい', 'うれしい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('うん', 'うん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('運転', 'うんてん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('運転手', 'うんてんしゅ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('運動', 'うんどう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('エスカレーター', 'エスカレーター', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('枝', 'えだ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('選ぶ', 'えらぶ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('遠慮', 'えんりょ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('おいでになる', 'おいでになる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お祝い', 'おいわい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('オートバイ', 'オートバイ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('おかげ', 'おかげ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('おかしい', 'おかしい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('億', 'おく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('屋上', 'おくじょう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('贈り物', 'おくりもの', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('送る', 'おくる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('遅れる', 'おくれる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('起す', 'おこす', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('行う', 'おこなう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('怒る', 'おこる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('押し入れ', 'おしいれ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お嬢さん', 'おじょうさん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お宅', 'おたく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('落る', 'おちる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('おっしゃる', 'おっしゃる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('夫', 'おっと', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('おつり', 'おつり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('音', 'おと', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('落す', 'おとす', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('踊り', 'おどり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('踊る', 'おどる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('驚く', 'おどろく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お祭り', 'おまつり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お見舞い', 'おみまい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お土産', 'おみやげ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('思い出す', 'おもいだす', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('思う', 'おもう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('おもちゃ', 'おもちゃ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('表', 'おもて', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('親', 'おや', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('下りる', 'おりる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('折る', 'おる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お礼', 'おれい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('折れる', 'おれる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('終わり', 'おわり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('カーテン', 'カーテン', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('海岸', 'かいがん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('会議', 'かいぎ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('会議室', 'かいぎしつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('会場', 'かいじょう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('会話', 'かいわ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('帰り', 'かえり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('変える', 'かえる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('科学', 'かがく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('鏡', 'かがみ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('掛ける', 'かける', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('飾る', 'かざる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('火事', 'かじ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ガス', 'ガス', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ガソリン', 'ガソリン', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ガソリンスタンド', 'ガソリンスタンド', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('堅', 'かたい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('硬', 'かたい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('固い', 'かたい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('形', 'かたち', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('片付ける', 'かたづける', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('課長', 'かちょう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('勝つ', 'かつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('かっこう', 'かっこう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('家内', 'かない', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('悲しい', 'かなしい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('必ず', 'かならず', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お・金持ち', 'かねもち', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お・金持ち', 'おかねもち', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('彼女', 'かのじょ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('壁', 'かべ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('かまう', 'かまう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('髪', 'かみ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('噛む', 'かむ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('通う', 'かよう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ガラス', 'ガラス', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('彼', 'かれ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('彼ら', 'かれら', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('乾く', 'かわく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('代わり', 'かわり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('変わる', 'かわる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('考える', 'かんがえる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('関係', 'かんけい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('看護婦', 'かんごふ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('簡単', 'かんたん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('気', 'き', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('機会', 'きかい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('危険', 'きけん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('聞こえる', 'きこえる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('汽車', 'きしゃ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('技術', 'ぎじゅつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('季節', 'きせつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('規則', 'きそく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('きっと', 'きっと', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('絹', 'きぬ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('厳しい', 'きびしい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('気分', 'きぶん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('決る', 'きまる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('君', 'きみ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('決める', 'きめる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('気持ち', 'きもち', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('着物', 'きもの', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('客', 'きゃく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('急', 'きゅう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('急行', 'きゅうこう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('教育', 'きょういく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('教会', 'きょうかい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('競争', 'きょうそう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('興味', 'きょうみ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('近所', 'きんじょ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('具合', 'ぐあい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('空気', 'くうき', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('空港', 'くうこう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('草', 'くさ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('くださる', 'くださる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('首', 'くび', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('雲', 'くも', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('比べる', 'くらべる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('くれる', 'くれる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('暮れる', 'くれる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('君', 'くん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('毛', 'け', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('計画', 'けいかく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('経験', 'けいけん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('経済', 'けいざい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('警察', 'けいさつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ケーキ', 'ケーキ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('けが', 'けが', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('景色', 'けしき', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('消しゴム', 'けしゴム', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('下宿', 'げしゅく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('決して', 'けっして', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('けれど', 'けれど', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('けれど', 'けれども', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('けれども', 'けれど', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('けれども', 'けれども', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('原因', 'げんいん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('けんか', 'けんか', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('研究', 'けんきゅう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('研究室', 'けんきゅうしつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('見物', 'けんぶつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('子', 'こ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('こう', 'こう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('郊外', 'こうがい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('講義', 'こうぎ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('工業', 'こうぎょう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('高校', 'こうこう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('高校生', 'こうこうせい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('工場', 'こうじょう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('校長', 'こうちょう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('交通', 'こうつう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('講堂', 'こうどう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('高等学校', 'こうとうがっこう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('公務員', 'こうむいん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('国際', 'こくさい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('心', 'こころ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('御主人', 'ごしゅじん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('故障', 'こしょう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ご存じ', 'ごぞんじ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('答', 'こたえ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ごちそう', 'ごちそう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('こと', 'こと', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('小鳥', 'ことり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('このあいだ', 'このあいだ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('このごろ', 'このごろ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('細かい', 'こまかい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ごみ', 'ごみ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('込む', 'こむ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('米', 'こめ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ごらんになる', 'ごらんになる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('これから', 'これから', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('怖い', 'こわい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('壊す', 'こわす', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('壊れる', 'こわれる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('コンサート', 'コンサート', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('今度', 'こんど', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('コンピュータ', 'コンピュータ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('コンピュータ', 'コンピューター', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('コンピューター', 'コンピュータ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('コンピューター', 'コンピューター', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('今夜', 'こんや', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('最近', 'さいきん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('最後', 'さいご', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('最初', 'さいしょ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('坂', 'さか', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('探す', 'さがす', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('下る', 'さがる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('盛ん', 'さかん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('下げる', 'さげる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('差し上げる', 'さしあげる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('さっき', 'さっき', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('寂しい', 'さびしい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('さ来月', 'さらいげつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('さ来週', 'さらいしゅう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('サラダ', 'サラダ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('騒ぐ', 'さわぐ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('触る', 'さわる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('産業', 'さんぎょう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('サンダル', 'サンダル', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('サンドイッチ', 'サンドイッチ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('残念', 'ざんねん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('市', 'し', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('字', 'じ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('試合', 'しあい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('仕方', 'しかた', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('しかる', 'しかる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('試験', 'しけん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('事故', 'じこ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('地震', 'じしん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('時代', 'じだい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('下着', 'したぎ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('支度', 'したく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('しっかり', 'しっかり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('失敗', 'しっぱい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('辞典', 'じてん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('品物', 'しなもの', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('しばらく', 'しばらく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('島', 'しま', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('市民', 'しみん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('事務所', 'じむしょ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('社会', 'しゃかい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('社長', 'しゃちょう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('じゃま', 'じゃま', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ジャム', 'ジャム', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('自由', 'じゆう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('習慣', 'しゅうかん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('住所', 'じゅうしょ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('柔道', 'じゅうどう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('十分', 'じゅうぶん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('出席', 'しゅっせき', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('出発', 'しゅっぱつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('趣味', 'しゅみ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('準備', 'じゅんび', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('紹介', 'しょうかい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('小学校', 'しょうがっこう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('小説', 'しょうせつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('招待', 'しょうたい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('承知', 'しょうち', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('将来', 'しょうらい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('食事', 'しょくじ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('食料品', 'しょくりょうひん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('女性', 'じょせい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('知らせる', 'しらせる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('調べる', 'しらべる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('人口', 'じんこう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('神社', 'じんじゃ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('親切', 'しんせつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('心配', 'しんぱい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('新聞社', 'しんぶんしゃ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('水泳', 'すいえい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('水道', 'すいどう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ずいぶん', 'ずいぶん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('数学', 'すうがく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('スーツ', 'スーツ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('スーツケース', 'スーツケース', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('過ぎる', 'すぎる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('すく', 'すく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('スクリーン', 'スクリーン', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('凄い', 'すごい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('進む', 'すすむ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('すっかり', 'すっかり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('すっと', 'すっと', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ステーキ', 'ステーキ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('捨てる', 'すてる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ステレオ', 'ステレオ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('砂', 'すな', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('すばらしい', 'すばらしい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('滑る', 'すべる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('隅', 'すみ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('済む', 'すむ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('すり', 'すり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('すると', 'すると', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('生活', 'せいかつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('生産', 'せいさん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('政治', 'せいじ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('西洋', 'せいよう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('世界', 'せかい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('席', 'せき', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('説明', 'せつめい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('背中', 'せなか', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ぜひ', 'ぜひ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('世話', 'せわ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('線', 'せん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ぜんぜん', 'ぜんぜん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('戦争', 'せんそう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('先輩', 'せんぱい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('そう', 'そう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('相談', 'そうだん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('育てる', 'そだてる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('卒業', 'そつぎょう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('祖父', 'そふ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ソフト', 'ソフト', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('祖母', 'そぼ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('それで', 'それで', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('それに', 'それに', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('それほど', 'それほど', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('そろそろ', 'そろそろ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('そんな', 'そんな', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('そんなに', 'そんなに', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('退院', 'たいいん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('大学生', 'だいがくせい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('大事', 'だいじ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('大体', 'だいたい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('たいてい', 'たいてい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('タイプ', 'タイプ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('大分', 'だいぶ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('台風', 'たいふう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('倒れる', 'たおれる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('だから', 'だから', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('確か', 'たしか', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('足す', 'たす', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('訪ねる', 'たずねる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('尋ねる', 'たずねる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('正しい', 'ただしい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('畳', 'たたみ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('立てる', 'たてる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('建てる', 'たてる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('例えば', 'たとえば', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('棚', 'たな', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('楽しみ', 'たのしみ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('楽む', 'たのしむ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('たまに', 'たまに', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('為', 'ため', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('だめ', 'だめ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('足りる', 'たりる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('男性', 'だんせい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('暖房', 'だんぼう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('血', 'ち', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('チェック', 'チェック', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('力', 'ちから', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ちっとも', 'ちっとも', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ちゃん', 'ちゃん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('注意', 'ちゅうい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('中学校', 'ちゅうがっこう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('注射', 'ちゅうしゃ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('駐車場', 'ちゅうしゃじょう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('地理', 'ちり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('捕まえる', 'つかまえる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('つき', 'つき', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('付く', 'つく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('漬ける', 'つける', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('都合', 'つごう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('伝える', 'つたえる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('続く', 'つづく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('続ける', 'つづける', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('包む', 'つつむ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('妻', 'つま', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('つもり', 'つもり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('釣る', 'つる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('連れる', 'つれる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('丁寧', 'ていねい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('テキスト', 'テキスト', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('適当', 'てきとう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('できるだけ', 'できるだけ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('手伝う', 'てつだう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('テニス', 'テニス', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('手袋', 'てぶくろ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('寺', 'てら', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('点', 'てん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('店員', 'てんいん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('天気予報', 'てんきよほう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('電灯', 'でんとう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('電報', 'でんぽう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('展覧会', 'てんらんかい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('都', 'と', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('道具', 'どうぐ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('とうとう', 'とうとう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('動物園', 'どうぶつえん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('遠く', 'とおく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('通る', 'とおる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('特に', 'とくに', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('特別', 'とくべつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('とこや', 'とこや', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('途中', 'とちゅう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('特急', 'とっきゅう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('届ける', 'とどける', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('泊まる', 'とまる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('止める', 'とめる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('取り替える', 'とりかえる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('泥棒', 'どろぼう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('どんどん', 'どんどん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('直す', 'なおす', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('直る', 'なおる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('治る', 'なおる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('中々', 'なかなか', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('泣く', 'なく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('無くなる', 'なくなる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('亡くなる', 'なくなる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('投げる', 'なげる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('なさる', 'なさる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('鳴る', 'なる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('なるべく', 'なるべく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('なるほど', 'なるほど', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('慣れる', 'なれる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('におい', 'におい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('苦い', 'にがい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('二階建て', 'にかいだて', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('逃げる', 'にげる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('日記', 'にっき', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('入院', 'にゅういん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('入学', 'にゅうがく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('似る', 'にる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('人形', 'にんぎょう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('盗む', 'ぬすむ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('塗る', 'ぬる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ぬれる', 'ぬれる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ねだん', 'ねだん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('熱', 'ねつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ねっしん', 'ねっしん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('寝坊', 'ねぼう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('眠い', 'ねむい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('眠る', 'ねむる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('残る', 'のこる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('のど', 'のど', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('乗り換える', 'のりかえる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('乗り物', 'のりもの', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('葉', 'は', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('場合', 'ばあい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('パート', 'パート', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('倍', 'ばい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('拝見', 'はいけん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('歯医者', 'はいしゃ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('運ぶ', 'はこぶ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('始める', 'はじめる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('場所', 'ばしょ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('はず', 'はず', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('恥ずかしい', 'はずかしい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('パソコン', 'パソコン', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('発音', 'はつおん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('はっきり', 'はっきり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('花見', 'はなみ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('林', 'はやし', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('払う', 'はらう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('番組', 'ばんぐみ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('反対', 'はんたい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ハンドバッグ', 'ハンドバッグ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('日', 'ひ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('火', 'ひ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ピアノ', 'ピアノ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('冷える', 'ひえる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('光', 'ひかり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('光る', 'ひかる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('引き出し', 'ひきだし', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('引き出す', 'ひきだす', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ひげ', 'ひげ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('飛行場', 'ひこうじょう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('久しぶり', 'ひさしぶり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('美術館', 'びじゅつかん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('非常に', 'ひじょうに', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('びっくり', 'びっくり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('引っ越す', 'ひっこす', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('必要', 'ひつよう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ひどい', 'ひどい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('開く', 'ひらく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ビル', 'ビル', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('昼間', 'ひるま', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('昼休み', 'ひるやすみ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('拾う', 'ひろう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ファックス', 'ファックス', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('増える', 'ふえる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('深い', 'ふかい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('複雑', 'ふくざつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('復習', 'ふくしゅう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('部長', 'ぶちょう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('普通', 'ふつう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ぶどう', 'ぶどう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('太る', 'ふとる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('布団', 'ふとん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('舟', 'ふね', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('不便', 'ふべん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('踏む', 'ふむ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('降り出す', 'ふりだす', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('プレゼント', 'プレゼント', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('文化', 'ぶんか', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('文学', 'ぶんがく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('文法', 'ぶんぽう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('別', 'べつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ベル', 'ベル', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('変', 'へん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('返事', 'へんじ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('貿易', 'ぼうえき', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('放送', 'ほうそう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('法律', 'ほうりつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('僕', 'ぼく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('星', 'ほし', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ほど', 'ほど', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ほとんど', 'ほとんど', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ほめる', 'ほめる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('翻訳', 'ほんやく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('参る', 'まいる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('負ける', 'まける', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('まじめ', 'まじめ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('まず', 'まず', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('または', 'または', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('間違える', 'まちがえる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('間に合う', 'まにあう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('周り', 'まわり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('回る', 'まわる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('漫画', 'まんが', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('真中', 'まんなか', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('見える', 'みえる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('湖', 'みずうみ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('味噌', 'みそ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('見つかる', 'みつかる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('見つける', 'みつける', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('皆', 'みな', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('港', 'みなと', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('向かう', 'むかう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('迎える', 'むかえる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('昔', 'むかし', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('虫', 'むし', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('息子', 'むすこ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('娘', 'むすめ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('無理', 'むり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('召し上がる', 'めしあがる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('珍しい', 'めずらしい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('申し上げる', 'もうしあげる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('申す', 'もうす', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('もうすぐ', 'もうすぐ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('もし', 'もし', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('もちろん', 'もちろん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('もっとも', 'もっとも', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('戻る', 'もどる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('木綿', 'もめん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('もらう', 'もらう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('森', 'もり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('焼く', 'やく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('約束', 'やくそく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('役に立つ', 'やくにたつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('焼ける', 'やける', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('優しい', 'やさしい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('痩せる', 'やせる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('やっと', 'やっと', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('やはり', 'やはり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('やはり', 'やっぱり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('やっぱり', 'やはり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('やっぱり', 'やっぱり', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('止む', 'やむ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('止める', 'やめる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('柔らかい', 'やわらかい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('湯', 'ゆ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('輸出', 'ゆしゅつ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('輸入', 'ゆにゅう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('指', 'ゆび', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('指輪', 'ゆびわ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('夢', 'ゆめ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('揺れる', 'ゆれる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('用', 'よう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('用意', 'ようい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('用事', 'ようじ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('汚れる', 'よごれる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('予習', 'よしゅう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('予定', 'よてい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('予約', 'よやく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('寄る', 'よる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('喜ぶ', 'よろこぶ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('よろしい', 'よろしい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('理由', 'りゆう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('利用', 'りよう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('両方', 'りょうほう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('旅館', 'りょかん', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('留守', 'るす', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('冷房', 'れいぼう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('歴史', 'れきし', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('レジ', 'レジ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('レポート', 'レポート', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('レポート', 'リポート', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('リポート', 'レポート', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('リポート', 'リポート', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('連絡', 'れんらく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ワープロ', 'ワープロ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('沸かす', 'わかす', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('別れる', 'わかれる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('沸く', 'わく', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('訳', 'わけ', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('忘れ物', 'わすれもの', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('笑う', 'わらう', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('割合', 'わりあい', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('割れる', 'われる', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('泳ぎ方', 'およぎかた', 'N4');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('会う', 'あう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('青', 'あお', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('青い', 'あおい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('赤', 'あか', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('赤い', 'あかい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('明い', 'あかるい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('秋', 'あき', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('開く', 'あく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('開ける', 'あける', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('上げる', 'あげる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('朝', 'あさ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('朝御飯', 'あさごはん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('あさって', 'あさって', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('足', 'あし', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('明日', 'あした', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('あそこ', 'あそこ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('遊ぶ', 'あそぶ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('暖かい', 'あたたかい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('頭', 'あたま', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('新しい', 'あたらしい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('あちら', 'あちら', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('暑い', 'あつい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('熱い', 'あつい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('厚い', 'あつい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('あっち', 'あっち', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('後', 'あと', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('あなた', 'あなた', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('兄', 'あに', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('姉', 'あね', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('あの', 'あの', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('あの', 'あの', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('アパート', 'アパート', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('あびる', 'あびる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('危ない', 'あぶない', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('甘い', 'あまい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('あまり', 'あまり', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('雨', 'あめ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('飴', 'あめ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('洗う', 'あらう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ある', 'ある', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('歩く', 'あるく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('あれ', 'あれ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('いい', 'いい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('いい', 'よい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('よい', 'いい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('よい', 'よい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('いいえ', 'いいえ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('言う', 'いう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('家', 'いえ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('いかが', 'いかが', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('行く', 'いく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('いくつ', 'いくつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('いくら', 'いくら', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('池', 'いけ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('医者', 'いしゃ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('いす', 'いす', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('忙しい', 'いそがしい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('痛い', 'いたい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('一', 'いち', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('一日', 'いちにち', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('いちばん', 'いちばん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('いつ', 'いつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('五日', 'いつか', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('一緒', 'いっしょ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('五つ', 'いつつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('いつも', 'いつも', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('犬', 'いぬ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('今', 'いま', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('意味', 'いみ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('妹', 'いもうと', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('嫌', 'いや', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('入口', 'いりぐち', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('居る', 'いる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('要る', 'いる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('入れる', 'いれる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('色', 'いろ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('いろいろ', 'いろいろ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('上', 'うえ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('後ろ', 'うしろ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('薄い', 'うすい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('歌', 'うた', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('歌う', 'うたう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('生まれる', 'うまれる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('海', 'うみ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('売る', 'うる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('煩い', 'うるさい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('上着', 'うわぎ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('絵', 'え', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('映画', 'えいが', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('映画館', 'えいがかん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('英語', 'えいご', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ええ', 'ええ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('駅', 'えき', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('エレベーター', 'エレベーター', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('鉛筆', 'えんぴつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('おいしい', 'おいしい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('多い', 'おおい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('大きい', 'おおきい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('大きな', 'おおきな', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('大勢', 'おおぜい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お母さん', 'おかあさん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お菓子', 'おかし', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お金', 'おかね', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('起きる', 'おきる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('置く', 'おく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('奥さん', 'おくさん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お酒', 'おさけ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お皿', 'おさら', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('伯父', 'おじいさん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('叔父', 'おじいさん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('教える', 'おしえる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('伯父', 'おじさん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('叔父', 'おじさん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('押す', 'おす', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('遅い', 'おそい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お茶', 'おちゃ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お手洗い', 'おてあらい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お父さん', 'おとうさん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('弟', 'おとうと', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('男', 'おとこ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('男の子', 'おとこのこ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('一昨日', 'おととい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('一昨年', 'おととし', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('大人', 'おとな', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('おなか', 'おなか', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('同じ', 'おなじ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お兄さん', 'おにいさん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お姉さん', 'おねえさん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('おばあさん', 'おばあさん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('伯母さん', 'おばさん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('叔母さん', 'おばさん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お風呂', 'おふろ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('お弁当', 'おべんとう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('覚える', 'おぼえる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('おまわりさん', 'おまわりさん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('重い', 'おもい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('おもしろい', 'おもしろい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('泳ぐ', 'およぐ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('降りる', 'おりる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('終る', 'おわる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('音楽', 'おんがく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('女', 'おんな', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('女の子', 'おんなのこ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('外国', 'がいこく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('外国人', 'がいこくじん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('会社', 'かいしゃ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('階段', 'かいだん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('買い物', 'かいもの', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('買う', 'かう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('返す', 'かえす', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('帰る', 'かえる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('かかる', 'かかる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('かぎ', 'かぎ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('書く', 'かく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('学生', 'がくせい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('かける', 'かける', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('傘', 'かさ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('貸す', 'かす', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('風', 'かぜ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('風邪', 'かぜ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('家族', 'かぞく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('方', 'かた', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('学校', 'がっこう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('カップ', 'カップ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('家庭', 'かてい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('角', 'かど', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('かばん', 'かばん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('花瓶', 'かびん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('紙', 'かみ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('カメラ', 'カメラ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('火曜日', 'かようび', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('辛い', 'からい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('体', 'からだ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('借りる', 'かりる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('軽い', 'かるい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('カレー', 'カレー', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('カレンダー', 'カレンダー', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('川', 'かわ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('河', 'かわ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('かわいい', 'かわいい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('漢字', 'かんじ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('木', 'き', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('黄色', 'きいろ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('黄色い', 'きいろい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('消える', 'きえる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('聞く', 'きく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('北', 'きた', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ギター', 'ギター', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('汚い', 'きたない', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('喫茶店', 'きっさてん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('切手', 'きって', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('切符', 'きっぷ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('昨日', 'きのう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('九', 'きゅう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('九', 'く', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('牛肉', 'ぎゅうにく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('牛乳', 'ぎゅうにゅう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('今日', 'きょう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('教室', 'きょうしつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('兄弟', 'きょうだい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('去年', 'きょねん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('嫌い', 'きらい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('切る', 'きる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('着る', 'きる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('きれい', 'きれい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('キロ', 'キロ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('キロ', 'キログラム', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('キログラム', 'キロ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('キログラム', 'キログラム', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('キロ', 'キロ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('キロ', 'キロメートル', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('キロメートル', 'キロ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('キロメートル', 'キロメートル', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('銀行', 'ぎんこう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('金曜日', 'きんようび', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('薬', 'くすり', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ください', 'ください', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('果物', 'くだもの', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('口', 'くち', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('靴', 'くつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('靴下', 'くつした', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('国', 'くに', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('曇り', 'くもり', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('曇る', 'くもる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('暗い', 'くらい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('クラス', 'クラス', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('グラム', 'グラム', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('来る', 'くる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('車', 'くるま', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('黒', 'くろ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('黒い', 'くろい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('警官', 'けいかん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('今朝', 'けさ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('消す', 'けす', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('結構', 'けっこう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('結婚', 'けっこん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('月曜日', 'げつようび', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('玄関', 'げんかん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('元気', 'げんき', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('五', 'ご', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('公園', 'こうえん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('交差点', 'こうさてん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('紅茶', 'こうちゃ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('交番', 'こうばん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('声', 'こえ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('コート', 'コート', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('コーヒー', 'コーヒー', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ここ', 'ここ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('午後', 'ごご', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('九日', 'ここのか', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('九つ', 'ここのつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('午前', 'ごぜん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('答える', 'こたえる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('こちら', 'こちら', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('こっち', 'こっち', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('コップ', 'コップ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('今年', 'ことし', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('言葉', 'ことば', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('子供', 'こども', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('この', 'この', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('御飯', 'ごはん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('コピーする', 'コピーする', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('困る', 'こまる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('これ', 'これ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('今月', 'こんげつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('今週', 'こんしゅう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('こんな', 'こんな', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('今晩', 'こんばん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('さあ', 'さあ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('財布', 'さいふ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('魚', 'さかな', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('先', 'さき', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('咲く', 'さく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('作文', 'さくぶん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('差す', 'さす', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('雑誌', 'ざっし', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('砂糖', 'さとう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('寒い', 'さむい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('さ来年', 'さらいねん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('三', 'さん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('散歩', 'さんぽする', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('四', 'し', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('四', 'よん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('塩', 'しお', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('しかし', 'しかし', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('時間', 'じかん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('仕事', 'しごと', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('辞書', 'じしょ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('静か', 'しずか', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('下', 'した', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('七', 'しち', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('七', 'なな', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('質問', 'しつもん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('自転車', 'じてんしゃ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('自動車', 'じどうしゃ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('死ぬ', 'しぬ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('字引', 'じびき', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('自分', 'じぶん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('閉まる', 'しまる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('閉める', 'しめる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('締める', 'しめる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('じゃ', 'じゃ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('じゃ', 'じゃあ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('じゃあ', 'じゃ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('じゃあ', 'じゃあ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('写真', 'しゃしん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('シャツ', 'シャツ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('シャワー', 'シャワー', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('十', 'じゅう とお', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('授業', 'じゅぎょう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('宿題', 'しゅくだい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('上手', 'じょうず', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('丈夫', 'じょうぶ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('しょうゆ', 'しょうゆ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('食堂', 'しょくどう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('知る', 'しる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('白', 'しろ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('白い', 'しろい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('新聞', 'しんぶん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('水曜日', 'すいようび', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('吸う', 'すう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('スカート', 'スカート', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('好き', 'すき', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('少ない', 'すくない', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('すぐに', 'すぐに', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('少し', 'すこし', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('涼しい', 'すずしい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ストーブ', 'ストーブ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('スプーン', 'スプーン', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('スポーツ', 'スポーツ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ズボン', 'ズボン', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('住む', 'すむ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('スリッパ', 'スリッパ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('する', 'する', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('座る', 'すわる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('背', 'せ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('生徒', 'せいと', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('セーター', 'セーター', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('せっけん', 'せっけん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('背広', 'せびろ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('狭い', 'せまい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ゼロ', 'ゼロ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('千', 'せん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('先月', 'せんげつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('先週', 'せんしゅう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('先生', 'せんせい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('洗濯', 'せんたく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('全部', 'ぜんぶ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('掃除', 'そうじする', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('そうして', 'そうして', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('そうして', 'そして', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('そして', 'そうして', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('そして', 'そして', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('そこ', 'そこ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('そちら', 'そちら', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('そっち', 'そっち', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('外', 'そと', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('その', 'その', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('そば', 'そば', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('空', 'そら', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('それ', 'それ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('それから', 'それから', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('それでは', 'それでは', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('大学', 'だいがく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('大使館', 'たいしかん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('大丈夫', 'だいじょうぶ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('大好き', 'だいすき', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('大切', 'たいせつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('台所', 'だいどころ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('たいへん', 'たいへん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('たいへん', 'たいへん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('高い', 'たかい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('たくさん', 'たくさん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('タクシー', 'タクシー', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('出す', 'だす', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('立つ', 'たつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('たて', 'たて', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('建物', 'たてもの', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('楽しい', 'たのしい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('頼む', 'たのむ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('たばこ', 'たばこ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('たぶん', 'たぶん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('食べ物', 'たべもの', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('食べる', 'たべる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('卵', 'たまご', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('誰', 'だれ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('誰', 'だれか', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('誕生日', 'たんじょうび', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('だんだん', 'だんだん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('小さい', 'ちいさい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('小さな', 'ちいさな', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('近い', 'ちかい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('違う', 'ちがう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('近く', 'ちかく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('地下鉄', 'ちかてつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('地図', 'ちず', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('茶色', 'ちゃいろ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ちゃわん', 'ちゃわん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ちょうど', 'ちょうど', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ちょっと', 'ちょっと', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('一日', 'ついたち', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('使う', 'つかう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('疲れる', 'つかれる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('次', 'つぎ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('着く', 'つく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('机', 'つくえ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('作る', 'つくる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('つける', 'つける', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('勤める', 'つとめる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('つまらない', 'つまらない', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('冷たい', 'つめたい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('強い', 'つよい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('手', 'て', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('テープ', 'テープ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('テーブル', 'テーブル', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('テープレコーダー', 'テープレコーダー', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('出かける', 'でかける', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('手紙', 'てがみ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('できる', 'できる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('出口', 'でぐち', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('テスト', 'テスト', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('では', 'では', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('デパート', 'デパート', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('でも', 'でも', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('出る', 'でる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('テレビ', 'テレビ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('天気', 'てんき', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('電気', 'でんき', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('電車', 'でんしゃ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('電話', 'でんわ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('戸', 'と', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ドア', 'ドア', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('トイレ', 'トイレ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('どう', 'どう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('どうして', 'どうして', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('どうぞ', 'どうぞ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('動物', 'どうぶつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('どうも', 'どうも', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('遠い', 'とおい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('十日', 'とおか', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('時々', 'ときどき', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('時計', 'とけい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('どこ', 'どこ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('所', 'ところ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('年', 'とし', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('図書館', 'としょかん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('どちら', 'どちら', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('どっち', 'どっち', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('とても', 'とても', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('どなた', 'どなた', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('隣', 'となり', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('どの', 'どの', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('飛ぶ', 'とぶ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('止まる', 'とまる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('友達', 'ともだち', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('土曜日', 'どようび', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('鳥', 'とり', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('とり肉', 'とりにく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('取る', 'とる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('撮る', 'とる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('どれ', 'どれ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ナイフ', 'ナイフ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('中', 'なか', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('長い', 'ながい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('鳴く', 'なく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('無くす', 'なくす', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('なぜ', 'なぜ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('夏', 'なつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('夏休み', 'なつやすみ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('など', 'など', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('七つ', 'ななつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('七日', 'なのか', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('名前', 'なまえ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('習う', 'ならう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('並ぶ', 'ならぶ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('並べる', 'ならべる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('なる', 'なる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('何', 'なん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('何', 'なに', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('二', 'に', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('賑やか', 'にぎやか', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('肉', 'にく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('西', 'にし', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('日曜日', 'にちようび', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('荷物', 'にもつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ニュース', 'ニュース', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('庭', 'にわ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('脱ぐ', 'ぬぐ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('温い', 'ぬるい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ネクタイ', 'ネクタイ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('猫', 'ねこ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('寝る', 'ねる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ノート', 'ノート', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('登る', 'のぼる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('飲み物', 'のみもの', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('飲む', 'のむ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('乗る', 'のる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('歯', 'は', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('パーティー', 'パーティー', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('はい', 'はい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('灰皿', 'はいざら', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('入る', 'はいる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('葉書', 'はがき', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('はく', 'はく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('箱', 'はこ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('橋', 'はし', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('はし', 'はし', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('始まる', 'はじまる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('初め', 'はじめ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('始め', 'はじめ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('初めて', 'はじめて', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('走る', 'はしる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('バス', 'バス', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('バター', 'バター', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('二十歳', 'はたち', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('働く', 'はたらく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('八', 'はち', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('二十日', 'はつか', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('花', 'はな', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('鼻', 'はな', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('話', 'はなし', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('話す', 'はなす', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('早い', 'はやい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('速い', 'はやい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('春', 'はる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('貼る', 'はる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('晴れ', 'はれ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('晴れる', 'はれる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('半', 'はん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('晩', 'ばん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('パン', 'パン', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ハンカチ', 'ハンカチ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('番号', 'ばんごう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('晩御飯', 'ばんごはん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('半分', 'はんぶん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('東', 'ひがし', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('引く', 'ひく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('弾く', 'ひく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('低い', 'ひくい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('飛行機', 'ひこうき', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('左', 'ひだり', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('人', 'ひと', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('一つ', 'ひとつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('一月', 'ひとつき', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('一人', 'ひとり', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('暇', 'ひま', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('百', 'ひゃく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('病院', 'びょういん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('病気', 'びょうき', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('昼', 'ひる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('昼御飯', 'ひるごはん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('広い', 'ひろい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('フィルム', 'フィルム', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('封筒', 'ふうとう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('プール', 'プール', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('フォーク', 'フォーク', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('吹く', 'ふく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('服', 'ふく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('二つ', 'ふたつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('豚肉', 'ぶたにく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('二人', 'ふたり', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('二日', 'ふつか', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('太い', 'ふとい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('冬', 'ふゆ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('降る', 'ふる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('古い', 'ふるい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ふろ', 'ふろ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('文章', 'ぶんしょう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ページ', 'ページ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('下手', 'へた', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ベッド', 'ベッド', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ペット', 'ペット', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('部屋', 'へや', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('辺', 'へん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ペン', 'ペン', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('勉強', 'べんきょうする', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('便利', 'べんり', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('帽子', 'ぼうし', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ボールペン', 'ボールペン', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ほか', 'ほか', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ポケット', 'ポケット', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('欲しい', 'ほしい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ポスト', 'ポスト', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('細い', 'ほそい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ボタン', 'ボタン', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ホテル', 'ホテル', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('本', 'ほん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('本棚', 'ほんだな', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ほんとう', 'ほんとう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('毎朝', 'まいあさ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('毎月', 'まいげつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('毎月', 'まいつき', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('毎週', 'まいしゅう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('毎日', 'まいにち', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('毎年', 'まいねん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('毎年', 'まいとし', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('毎晩', 'まいばん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('前', 'まえ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('曲る', 'まがる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('まずい', 'まずい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('また', 'また', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('まだ', 'まだ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('町', 'まち', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('待つ', 'まつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('まっすぐ', 'まっすぐ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('マッチ', 'マッチ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('窓', 'まど', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('丸い', 'まるい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('円い', 'まるい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('万', 'まん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('万年筆', 'まんねんひつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('磨く', 'みがく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('右', 'みぎ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('短い', 'みじかい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('水', 'みず', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('店', 'みせ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('見せる', 'みせる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('道', 'みち', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('三日', 'みっか', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('三つ', 'みっつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('緑', 'みどり', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('皆さん', 'みなさん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('南', 'みなみ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('耳', 'みみ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('見る 観る', 'みる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('みんな', 'みんな', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('六日', 'むいか', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('向こう', 'むこう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('難しい', 'むずかしい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('六つ', 'むっつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('村', 'むら', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('目', 'め', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('メートル', 'メートル', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('眼鏡', 'めがね', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('もう', 'もう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('もう一度', 'もういちど', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('木曜日', 'もくようび', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('持つ', 'もつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('もっと', 'もっと', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('物', 'もの', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('門', 'もん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('問題', 'もんだい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('八百屋', 'やおや', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('野菜', 'やさい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('易しい', 'やさしい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('安い', 'やすい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('休み', 'やすみ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('休む', 'やすむ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('八つ', 'やっつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('山', 'やま', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('やる', 'やる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('夕方', 'ゆうがた', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('夕飯', 'ゆうはん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('郵便局', 'ゆうびんきょく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('昨夜', 'ゆうべ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('有名', 'ゆうめい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('雪', 'ゆき', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('行く', 'ゆく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ゆっくりと', 'ゆっくりと', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('八日', 'ようか', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('洋服', 'ようふく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('よく', 'よく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('横', 'よこ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('四日', 'よっか', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('四つ', 'よっつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('呼ぶ', 'よぶ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('読む', 'よむ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('夜', 'よる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('弱い', 'よわい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('来月', 'らいげつ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('来週', 'らいしゅう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('来年', 'らいねん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ラジオ', 'ラジオ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ラジカセ', 'ラジカセ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ラジオカセット', 'ラジオカセット', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('りっぱ', 'りっぱ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('留学生', 'りゅうがくせい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('両親', 'りょうしん', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('料理', 'りょうり', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('旅行', 'りょこう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('零', 'れい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('冷蔵庫', 'れいぞうこ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('レコード', 'レコード', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('レストラン', 'レストラン', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('練習', 'れんしゅうする', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('廊下', 'ろうか', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('六', 'ろく', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ワイシャツ', 'ワイシャツ', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('若い', 'わかい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('分かる', 'わかる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('忘れる', 'わすれる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('私', 'わたくし', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('私', 'わたし', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('渡す', 'わたす', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('渡る', 'わたる', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('悪い', 'わるい', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('より', 'より', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('より', 'ほう', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ほう', 'より', 'N5');
INSERT INTO jlpt_vocab (kanji, reading, jlpt_level) VALUES ('ほう', 'ほう', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('会', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('同', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('事', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('自', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('社', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('発', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('者', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('地', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('業', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('方', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('新', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('場', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('員', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('立', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('開', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('手', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('力', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('問', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('代', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('明', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('動', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('京', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('目', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('通', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('言', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('理', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('体', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('田', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('主', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('題', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('意', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('不', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('作', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('用', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('度', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('強', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('公', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('持', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('野', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('以', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('思', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('家', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('世', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('多', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('正', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('安', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('院', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('心', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('界', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('教', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('文', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('元', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('重', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('近', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('考', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('画', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('海', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('売', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('知', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('道', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('集', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('別', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('物', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('使', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('品', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('計', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('死', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('特', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('私', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('始', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('朝', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('運', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('終', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('台', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('広', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('住', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('真', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('有', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('口', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('少', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('町', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('料', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('工', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('建', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('空', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('急', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('止', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('送', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('切', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('転', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('研', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('足', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('究', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('楽', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('起', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('着', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('店', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('病', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('質', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('待', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('試', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('族', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('銀', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('早', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('映', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('親', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('験', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('英', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('医', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('仕', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('去', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('味', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('写', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('字', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('答', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('夜', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('音', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('注', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('帰', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('古', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('歌', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('買', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('悪', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('図', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('週', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('室', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('歩', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('風', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('紙', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('黒', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('花', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('春', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('赤', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('青', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('館', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('屋', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('色', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('走', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('秋', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('夏', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('習', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('駅', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('洋', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('旅', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('服', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('夕', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('借', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('曜', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('飲', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('肉', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('貸', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('堂', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('鳥', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('飯', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('勉', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('冬', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('昼', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('茶', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('弟', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('牛', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('魚', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('兄', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('犬', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('妹', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('姉', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('漢', 'N4');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('日', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('一', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('国', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('人', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('年', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('大', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('十', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('二', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('本', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('中', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('長', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('出', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('三', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('時', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('行', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('見', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('月', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('後', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('前', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('生', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('五', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('間', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('上', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('東', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('四', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('今', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('金', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('九', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('入', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('学', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('高', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('円', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('子', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('外', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('八', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('六', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('下', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('来', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('気', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('小', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('七', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('山', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('話', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('女', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('北', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('午', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('百', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('書', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('先', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('名', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('川', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('千', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('水', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('半', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('男', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('西', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('電', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('校', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('語', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('土', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('木', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('聞', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('食', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('車', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('何', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('南', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('万', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('毎', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('白', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('天', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('母', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('火', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('右', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('読', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('友', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('左', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('休', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('父', 'N5');
INSERT INTO jlpt_kanji (kanji, jlpt_level) VALUES ('雨', 'N5');
